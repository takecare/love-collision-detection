local WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getMode()
local BOX_SIZE = 100
local SPEED = 150
local RED = { 1, 0, 0, 1 }
local GREEN = { 0, 1, 0, 1 }
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
    local distance = math.abs(math.sqrt(pow(other.x - self.x, 2) + pow(other.y - self.y, 2)))
    local d = self.w > self.h and self.w or self.h
    self.collision.top = other.y + other.h >= self.y and distance < d
    self.collision.left = other.x + other.w >= self.x and distance < d
    self.collision.bottom = other.y <= self.y + self.h and distance < d
    self.collision.right = other.x <= self.x + self.w and distance < d
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

    -- if boxA:collidesWith(boxB) then
    --     boxA.edgeColor = { 0, 0, 1, 1 }
    -- else 
    --     boxA.edgeColor = WHITE
    -- end
    boxA:collidesWith(boxB)

    boxA:update(dt)
    boxB:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        --
    end
end

function love.draw()
    love.graphics.clear(0.25, 0.25, 0.25)
    boxA:render()
    boxB:render()
end
