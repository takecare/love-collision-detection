local WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getMode()
local BOX_SIZE = 100
local SPEED = 150
local RED = { 1, 0, 0, 0.5 }
local GREEN = { 0, 1, 0, 0.5 }
local BLUE = { 0, 0, 1, 1 }
local YELLOW = { 1, 1, 0, 1 }
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
        collision = { left = false, top = false, right = false, bottom = false, x = 0, y = 0 },
        edgeColor = WHITE,
        edgeThickness = 3
    }
    self.__index = self
    return setmetatable(box, Box)
end

function Box:render()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)

    love.graphics.setColor(self.collision.top and BLUE or self.edgeColor)
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.edgeThickness) -- top

    love.graphics.setColor(self.collision.left and BLUE or self.edgeColor)
    love.graphics.rectangle('fill', self.x, self.y, self.edgeThickness, self.h) -- left

    love.graphics.setColor(self.collision.bottom and BLUE or self.edgeColor)
    love.graphics.rectangle('fill', self.x, self.y + self.h - self.edgeThickness, self.w, self.edgeThickness) -- bottom

    love.graphics.setColor(self.collision.right and BLUE or self.edgeColor)
    love.graphics.rectangle('fill', self.x + self.w - self.edgeThickness, self.y, self.edgeThickness, self.h) -- right

    love.graphics.setColor(self.collision.top and YELLOW or self.edgeColor)
    if self.collision.top then
        love.graphics.rectangle('fill', self.collision.xStart, self.collision.yStart, self.collision.xEnd - self.collision.xStart, self.edgeThickness)
    elseif self.collision.left then
        love.graphics.rectangle('fill', self.collision.xStart , self.collision.yStart, self.edgeThickness, self.collision.yEnd - self.collision.yStart)
    elseif self.collision.bottom then
        --
    else
        --
    end
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
            (minX > otherMinX and minX < otherMaxX) or -- other is colliding from the left side
            (maxX > otherMinX and maxX < otherMaxX) or -- other is colliding from the right side
            (minX < otherMinX and maxX > otherMaxX) -- other is colliding from the top and has smaller width
        )

    self.collision.left = 
        (otherMinX < minX and minX < otherMaxX)
         and (
            (minY < otherMinY and maxY > otherMaxY) or -- other is colliding from the left and has smaller height
            (minY > otherMinY and minY < otherMaxY) or -- other is colliding from the top
            (maxY > otherMinY and maxY < otherMaxY) -- other is colliding from the bottom
        )
    
    self.collision.bottom =
        (otherMinY < maxY and otherMaxY > maxY)
        and (
            (minX < otherMinX and maxX > otherMaxX) or -- other is colliding from the bottom and has smaller width
            (minX > otherMinX and minX < otherMaxX) or -- other is colliding from the right side
            (maxX > otherMinX and maxX < otherMaxX) -- other is colliding from the left side
        )

    self.collision.right =
        (otherMinX < maxX and otherMaxX > maxX)
        and (
            (minY < otherMinY and maxY > otherMaxY) or -- other is colliding from the right and has smaller height
            (minY > otherMinY and minY < otherMaxY) or -- other is colliding from the top
            (maxY > otherMinY and maxY < otherMaxY) -- other is colliding from the bottom
        )

    if self.collision.top then
        self.collision.yStart = minY
        self.collision.yEnd = minY

        if minX > otherMinX and minX < otherMaxX then
            self.collision.xStart = minX
            self.collision.xEnd = otherMaxX
        elseif maxX > otherMinX and maxX < otherMaxX then -- right
            self.collision.xStart = otherMinX
            self.collision.xEnd = maxX
        else -- bottom
            self.collision.xStart = otherMinX
            self.collision.xEnd = otherMaxX
        end
    end

    -- problema: neste momento so' estou a suportar uma linha de colisao (edge) de cada vez

    if self.collision.left then
        self.collision.xStart = minX
        self.collision.xEnd = minX

        if minY < otherMinY and maxY > otherMaxY then
            self.collision.yStart = otherMinY
            self.collision.yEnd = otherMaxY
        elseif minY > otherMinY and minY < otherMaxY then -- top
            self.collision.yStart = minY
            self.collision.yEnd = otherMaxY
        else -- bottom
            self.collision.yStart = maxY
            self.collision.yEnd = otherMinY
        end
    end

    if self.collision.bottom then
        -- TODO
    end

    if self.collision.right then
        -- TODO
    end
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
