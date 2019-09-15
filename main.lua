local WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getMode()
local BOX_SIZE = 100
local SPEED = 150
local RED = { 1, 0, 0, 0.5 }
local GREEN = { 0, 1, 0, 0.5 }
local BLUE = { 0, 0, 1, 1 }
local WHITE = { 1, 1, 1, 1 }

function pow(a, b)
    if b == 1 then
      return a
    else
      return a * pow(a, b - 1)
    end
end

local Box = {}
function Box:new(x, y, w, h, color)
    local box = { 
        x = x,
        y = y,
        w = w,
        h = h,
        dx = 0,
        dy = 0,
        color = color~= nil and color or { 0.5, 0.5, 0.5, 0.5 },
        collision = { left = false, top = false, right = false, bottom = false },
        edgeColor = WHITE,
        edgeWidth = 3
    }
    self.__index = self
    return setmetatable(box, Box)
end

function Box:render()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)

    love.graphics.setColor(self.collision.top and BLUE or self.edgeColor)
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.edgeWidth) -- top

    love.graphics.setColor(self.collision.left and BLUE or self.edgeColor)
    love.graphics.rectangle('fill', self.x, self.y, self.edgeWidth, self.h) -- left

    love.graphics.setColor(self.collision.bottom and BLUE or self.edgeColor)
    love.graphics.rectangle('fill', self.x, self.y + self.h - self.edgeWidth, self.w, self.edgeWidth) -- bottom

    love.graphics.setColor(self.collision.right and BLUE or self.edgeColor)
    love.graphics.rectangle('fill', self.x + self.w - self.edgeWidth, self.y, self.edgeWidth, self.h) -- right
end

function Box:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Box:stop()
    self.dx = 0
    self.dy = 0
end

function Box:collidesWith(other)
    local minX = self.x
    local maxX = self.x + self.w
    local minY = self.y
    local maxY = self.y + self.h
    
    local otherMinX = other.x
    local otherMaxX = other.x + other.w
    local otherMinY = other.y
    local otherMaxY = other.y + other.h

    self.collision.top = 
        (minY > otherMinY and minY < otherMaxY)
        and (
            (minX > otherMinX and minX < otherMaxX) or
            (maxX > otherMinX and maxX < otherMaxX) or
            (minX < otherMinX and maxX > otherMaxX)
        )

    self.collision.left = 
        (otherMinX < minX and minX < otherMaxX)
         and (
            (minY < otherMinY and maxY > otherMaxY) or
            (otherMinY < minY and minY < otherMaxY) or
            (otherMinY < maxY and maxY < otherMaxY)
        )
    
    self.collision.bottom =
        (otherMinY < maxY and otherMaxY > maxY)
        and (
            (otherMinX > minX and otherMaxX < maxX) or
            (otherMinX < minX and otherMaxX > minX) or
            (maxX > otherMinX and otherMaxX > maxX)
        )

    self.collision.right =
        (otherMinX < maxX and otherMaxX > maxX)
        and (
            (minY < otherMinY and maxY > otherMaxY) or
            (otherMinY < minY and minY < otherMaxY) or
            (otherMinY < maxY and maxY < otherMaxY)
        )
end

local boxA = Box:new(
    WINDOW_WIDTH / 2,
    WINDOW_HEIGHT / 2,
    BOX_SIZE,
    BOX_SIZE,
    RED
)
local boxB = Box:new(
    WINDOW_WIDTH / 2 - BOX_SIZE,
    WINDOW_HEIGHT / 2 - BOX_SIZE,
    BOX_SIZE,
    BOX_SIZE,
    GREEN
)

function love.load()
    love.window.setTitle('collisions')
    love.graphics.setDefaultFilter('nearest', 'nearest')
end

function love.update(dt)
    boxA:stop()
    boxB:stop()

    if love.keyboard.isDown('w') then
        boxA.dy = -SPEED
    end
    if love.keyboard.isDown('a') then
        boxA.dx = -SPEED
    end
    if love.keyboard.isDown('s') then
        boxA.dy = SPEED
    end
    if love.keyboard.isDown('d') then
        boxA.dx = SPEED
    end
    if love.keyboard.isDown('up') then
        boxB.dy = -SPEED
    end
    if love.keyboard.isDown('left') then
        boxB.dx = -SPEED
    end
    if love.keyboard.isDown('down') then
        boxB.dy = SPEED
    end
    if love.keyboard.isDown('right') then
        boxB.dx = SPEED
    end

    boxA:collidesWith(boxB)
    boxB:collidesWith(boxA)

    boxA:update(dt)
    boxB:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'r' then
        boxA.w = boxA.w + 10
        boxA.h = boxA.h + 10
    elseif key == 'f' then
        boxA.w = boxA.w - 10
        boxA.h = boxA.h - 10
    elseif key == 'o' then
        boxB.w = boxB.w + 10
        boxB.h = boxB.h + 10
    elseif key == 'l' then
        boxB.w = boxB.w - 10
        boxB.h = boxB.h - 10
    end
end

function love.draw()
    love.graphics.clear(0.25, 0.25, 0.25)
    boxA:render()
    boxB:render()
end
