local PaintScene = {}

local canvas
local brush
local brushCanvas
local plate


local CURSOR_COLOR = { 0.6, 0, 0, 0.8 }
local DRAW_FACTOR = 20
local BRUSH_SCALE = 15

function PaintScene:load(config)
    config.title = 'paint'
    
    canvas = love.graphics.newCanvas()

    brush = love.graphics.newImage('assets/brush8.png')
    brushCanvas = love.graphics.newCanvas(WINDOW_WIDTH, WINDOW_HEIGHT)
    
    plate = love.graphics.newImage('assets/plate.png')
    
    love.mouse.setVisible(false)
    love.mouse.setGrabbed(true)
end

function PaintScene:update(dt)
    local x, y = love.mouse.getPosition()

    if love.mouse.isDown(1) then
        love.graphics.setCanvas(brushCanvas)
        love.graphics.setBlendMode('add')
        love.graphics.setColor(1, 1, 1, 1 * dt * DRAW_FACTOR)
        love.graphics.draw(
            brush,
            x - brush:getWidth() / 2,
            y - brush:getHeight() / 2,
            0,
            BRUSH_SCALE,
            BRUSH_SCALE
        )
        love.graphics.setCanvas()
    end
end

function PaintScene:keypressed(key)
    --
end

function PaintScene:draw()
    love.graphics.setColor(1, 1, 1)

    love.graphics.setBlendMode('alpha')
    love.graphics.draw(plate, 0, 0, 20, 20)
  
    love.graphics.setBlendMode('multiply', 'premultiplied')
    love.graphics.draw(brushCanvas)

    -- love.graphics.setCanvas(canvas)
    -- local x, y = love.mouse.getPosition()
    -- love.graphics.setColor(CURSOR_COLOR)
    -- love.graphics.circle('fill', x, y, 5)
    -- love.graphics.setCanvas()

    -- love.graphics.draw(canvas)
end

return PaintScene