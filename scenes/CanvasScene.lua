local CanvasScene = {}

local canvas
local brush
local plate
local size
local mode = 'paint'

local CURSOR_COLOR = { 0.6, 0, 0, 0.8 }
local CURSOR_SCALE = 3

local DecoratedCanvas = {}
function DecoratedCanvas:new(x, y, w, h)
    local canvas = {
        x = x,
        y = y,
        w = w,
        h = h,
        canvas = love.graphics.newCanvas(w, h)
    }
    self.__index = self
    return setmetatable(canvas, DecoratedCanvas)
end

function DecoratedCanvas:render()
    love.graphics.draw(self.canvas, self.x, self.y)
end

function CanvasScene:load(config)
    config.title = 'canvas'
    
    canvas = love.graphics.newCanvas()
    plate = love.graphics.newImage('assets/plate128.png')
    brush = love.graphics.newImage('assets/brush8.png')
    size = plate:getWidth()

    love.mouse.setVisible(false)
    love.mouse.setGrabbed(true)

    love.graphics.setCanvas(canvas)
        love.graphics.clear()
        love.graphics.setBlendMode('alpha')
        love.graphics.setColor(0, 1, 0, 0.5)
        -- love.graphics.rectangle('fill', 0, 0, 100, 100)
        love.graphics.draw(plate, 0, 0, 0, 1, 1)
    love.graphics.setCanvas()
end

function CanvasScene:update(dt)
    if love.mouse.isDown(1) then
        local mx, my = love.mouse.getPosition()
        local cx, cy = WINDOW_WIDTH / 2 - size / 2 - size, WINDOW_HEIGHT / 2 - size / 2
        local x, y = mx - cx, my - cy
        if mode == 'paint' then
            love.graphics.setCanvas(canvas)
            love.graphics.draw(brush, x, y, 0, CURSOR_SCALE, CURSOR_SCALE)
            love.graphics.setCanvas()
        elseif mode == 'clean' then
            love.graphics.setCanvas(canvas)
            love.graphics.setBlendMode('subtract')
            love.graphics.setColor(1,1,1,1)
            love.graphics.draw(brush, x, y, 0, CURSOR_SCALE, CURSOR_SCALE)
            love.graphics.setCanvas()
        end
    end
end

function CanvasScene:keypressed(key)
    if key == 'c' then
        mode = 'clean'
    elseif key == 'p' then
        mode = 'paint'
    end
end

function CanvasScene:draw()
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(canvas, WINDOW_WIDTH / 2 - size / 2 - size, WINDOW_HEIGHT / 2 - size / 2)
    
    love.graphics.setBlendMode('alpha')
    love.graphics.draw(canvas, WINDOW_WIDTH / 2 - size / 2, WINDOW_HEIGHT / 2 - size / 2)
 
    love.graphics.setBlendMode('alpha')
    love.graphics.setColor(1, 0, 0, 0.5)
    love.graphics.draw(canvas, WINDOW_WIDTH / 2 - size / 2 + size, WINDOW_HEIGHT / 2 - size / 2)

    -- render cursor
    local x, y = love.mouse.getPosition()
    love.graphics.setColor(CURSOR_COLOR)
    love.graphics.draw(brush, x, y, 0, CURSOR_SCALE, CURSOR_SCALE)
end

return CanvasScene