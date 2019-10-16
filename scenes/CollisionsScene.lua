Collision = require 'Scenes/Collision'

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
        collision = {
            top = Collision:new(),
            left = Collision:new(),
            bottom = Collision:new(),
            right = Collision:new()
        },
        edgeColor = WHITE,
        edgeThickness = 3,
        title = ''
    }
    self.__index = self
    return setmetatable(box, Box)
end

function Box:render()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)

    love.graphics.setColor(self.collision.top.colliding and BLUE or self.edgeColor)
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.edgeThickness) -- top

    love.graphics.setColor(self.collision.left.colliding and BLUE or self.edgeColor)
    love.graphics.rectangle('fill', self.x, self.y, self.edgeThickness, self.h) -- left

    love.graphics.setColor(self.collision.bottom.colliding and BLUE or self.edgeColor)
    love.graphics.rectangle('fill', self.x, self.y + self.h - self.edgeThickness, self.w, self.edgeThickness) -- bottom

    love.graphics.setColor(self.collision.right.colliding and BLUE or self.edgeColor)
    love.graphics.rectangle('fill', self.x + self.w - self.edgeThickness, self.y, self.edgeThickness, self.h) -- right

    love.graphics.setColor(self.collision.top.colliding and YELLOW or self.edgeColor)
    if self.collision.top.colliding then
        love.graphics.rectangle(
            'fill',
            self.collision.top.xStart,
            self.collision.top.yStart,
            self.collision.top.xEnd - self.collision.top.xStart,
            self.edgeThickness
        )
    end
    if self.collision.left.colliding then
        love.graphics.rectangle(
            'fill',
            self.collision.left.xStart ,
            self.collision.left.yStart,
            self.edgeThickness,
            self.collision.left.yEnd - self.collision.left.yStart
    )
    end
    if self.collision.bottom.colliding then
        love.graphics.rectangle(
            'fill',
            self.collision.bottom.xStart,
            self.collision.bottom.yStart - self.edgeThickness,
            self.collision.bottom.xEnd - self.collision.bottom.xStart,
            self.edgeThickness
        )
    end
    if self.collision.right.colliding then
        love.graphics.rectangle(
            'fill',
            self.collision.right.xStart - self.edgeThickness,
            self.collision.right.yStart,
            self.edgeThickness,
            self.collision.right.yEnd - self.collision.right.yStart
        )
    end

    love.graphics.print(self.title,
    self.x + self.edgeThickness,
    self.y + self.edgeThickness)
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

    local collisionTop = 
        (minY > otherMinY and minY < otherMaxY)
        and (
            (minX > otherMinX and minX < otherMaxX) or -- other is colliding from the left side
            (maxX > otherMinX and maxX < otherMaxX) or -- other is colliding from the right side
            (minX < otherMinX and maxX > otherMaxX) -- other is colliding from the top and has smaller width
        )

    local collisionLeft = 
        (otherMinX < minX and minX < otherMaxX)
         and (
            (minY < otherMinY and maxY > otherMaxY) or -- other is colliding from the left and has smaller height
            (minY > otherMinY and minY < otherMaxY) or -- other is colliding from the top
            (maxY > otherMinY and maxY < otherMaxY) -- other is colliding from the bottom
        )
    
    local collisionBottom =
        (otherMinY < maxY and otherMaxY > maxY)
        and (
            (minX < otherMinX and maxX > otherMaxX) or -- other is colliding from the bottom and has smaller width
            (minX > otherMinX and minX < otherMaxX) or -- other is colliding from the right side
            (maxX > otherMinX and maxX < otherMaxX) -- other is colliding from the left side
        )

    local collisionRight =
        (otherMinX < maxX and otherMaxX > maxX)
        and (
            (minY < otherMinY and maxY > otherMaxY) or -- other is colliding from the right and has smaller height
            (minY > otherMinY and minY < otherMaxY) or -- other is colliding from the top
            (maxY > otherMinY and maxY < otherMaxY) -- other is colliding from the bottom
        )

    self.collision.top.colliding = collisionTop
    self.collision.right.colliding = collisionRight
    self.collision.bottom.colliding = collisionBottom
    self.collision.left.colliding = collisionLeft

    if collisionTop then
        self.collision.top.yStart = minY
        self.collision.top.yEnd = minY

        if minX < otherMinX and maxX > otherMaxX then  -- smaller width
            self.collision.top.xStart = otherMinX
            self.collision.top.xEnd = otherMaxX
            self.title = 'Tsw'
        elseif minX > otherMinX and maxX < otherMaxX then -- greater width
            self.collision.top.xStart = minX
            self.collision.top.xEnd = maxX
            self.title = 'Tgw'
        elseif minX < otherMaxX and minX > otherMinX then -- left
            self.collision.top.xStart = minX
            self.collision.top.xEnd = otherMaxX
            self.title = 'TL'
        elseif maxX < otherMaxX and maxX > otherMinX then -- right
            self.collision.top.xStart = otherMinX
            self.collision.top.xEnd = maxX
            self.title = 'TR'
        else
            self.title = ''
        end
    end

    if collisionLeft then
        self.collision.left.xStart = minX
        self.collision.left.xEnd = minX

        if minY < otherMinY and maxY > otherMaxY then -- smaller height
            self.collision.left.yStart = otherMinY
            self.collision.left.yEnd = otherMaxY
            self.title = 'Lsh'
        elseif minY > otherMinY and maxY < otherMaxY then -- greater height
            self.collision.left.yStart = minY
            self.collision.left.yEnd = maxY
            self.title = 'Lgh'
        elseif minY > otherMinY and minY < otherMaxY then -- top
            self.collision.left.yStart = minY
            self.collision.left.yEnd = otherMaxY
            self.title = 'LT'
        elseif maxY > otherMinY and maxY < otherMaxY then -- bottom
            self.collision.left.yStart = maxY
            self.collision.left.yEnd = otherMinY
            self.title = 'LB'
        else
            self.title = ''
        end
    end

    if collisionBottom then
        self.collision.bottom.yStart = maxY
        self.collision.bottom.yEnd = maxY

        if minX < otherMinX and maxX > otherMaxX then  -- smaller width
            self.collision.bottom.xStart = otherMinX
            self.collision.bottom.xEnd = otherMaxX
            self.title = 'Bsw'
        elseif minX > otherMinX and maxX < otherMaxX then -- greater width
            self.collision.bottom.xStart = minX
            self.collision.bottom.xEnd = maxX
            self.title = 'Bgw'
        elseif minX < otherMaxX and minX > otherMinX then -- left
            self.collision.bottom.xStart = minX
            self.collision.bottom.xEnd = otherMaxX
            self.title = 'BL'
        elseif maxX < otherMaxX and maxX > otherMinX then -- right
            self.collision.bottom.xStart = otherMinX
            self.collision.bottom.xEnd = maxX
            self.title = 'BR'
        else
            self.title = ''
        end
    end

    if collisionRight then
        self.collision.right.xStart = maxX
        self.collision.right.xEnd = maxX

        if minY < otherMinY and maxY > otherMaxY then -- smaller height
            self.collision.right.yStart = otherMinY
            self.collision.right.yEnd = otherMaxY
            self.title = 'Rsh'
        elseif minY > otherMinY and maxY < otherMaxY then -- greater height
            self.collision.right.yStart = minY
            self.collision.right.yEnd = maxY
            self.title = 'Rgh'
        elseif minY > otherMinY and minY < otherMaxY then -- top
            self.collision.right.yStart = minY
            self.collision.right.yEnd = otherMaxY
            self.title = 'RT'
        elseif maxY > otherMinY and maxY < otherMaxY then -- bottom
            self.collision.right.yStart = maxY
            self.collision.right.yEnd = otherMinY
            self.title = 'RB'
        else
            self.title = ''
        end
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

local CollisionsScene = {}

function CollisionsScene:load(config)
    config.title = 'collisions'
end

function CollisionsScene:update(dt)
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

function CollisionsScene:keypressed(key)
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

function CollisionsScene:draw()
    love.graphics.clear(0.25, 0.25, 0.25)
    boxA:render()
    boxB:render()
end

return CollisionsScene