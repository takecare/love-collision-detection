local CanvasScene = {}

local plateCanvas
local dirtCanvas
local cleanCanvas
local brush
local plate
local size
local mode = 'paint'

local CURSOR_COLOR_PAINT = { 0.6, 0, 0, 0.8 }
local CURSOR_COLOR_CLEAN = { 0.2, 0.2, 0.5, 0.8 }
local CURSOR_SCALE = 3

function CanvasScene:load(config)
    config.title = 'canvas'
    
    love.graphics.setColor(1, 1, 1, 1)

    plate = love.graphics.newImage('assets/plate128.png')
    brush = love.graphics.newImage('assets/brush8.png')
    size = plate:getWidth()
    plateCanvas = love.graphics.newCanvas(size, size)
    dirtCanvas = love.graphics.newCanvas(size, size)
    cleanCanvas = love.graphics.newCanvas(size, size)

    love.mouse.setVisible(false)
    love.mouse.setGrabbed(true)

    love.graphics.setCanvas(plateCanvas)
    love.graphics.setBlendMode('alpha')
    love.graphics.draw(plate)
    love.graphics.setCanvas()
end

function CanvasScene:update(dt)
    if love.mouse.isDown(1) then
        local mx, my = love.mouse.getPosition()
        local cx, cy = WINDOW_WIDTH / 2 - size / 2 - size, WINDOW_HEIGHT / 2 - size / 2
        local x, y = mx - cx, my - cy

        -- love.graphics.setColor(1, 1, 1, 1)

        if mode == 'paint' then
            love.graphics.setCanvas(dirtCanvas)
            love.graphics.setBlendMode('add')
            love.graphics.draw(brush, x, y, 0, CURSOR_SCALE, CURSOR_SCALE)
            love.graphics.setCanvas()
        elseif mode == 'clean' then
            love.graphics.setCanvas(cleanCanvas)
            love.graphics.setBlendMode('subtract')
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

    love.graphics.draw(plateCanvas, WINDOW_WIDTH / 2 - size / 2 - size, WINDOW_HEIGHT / 2 - size / 2)
    love.graphics.draw(dirtCanvas, WINDOW_WIDTH / 2 - size / 2 - size, WINDOW_HEIGHT / 2 - size / 2)
    love.graphics.draw(cleanCanvas, WINDOW_WIDTH / 2 - size / 2 - size, WINDOW_HEIGHT / 2 - size / 2)

    love.graphics.draw(plateCanvas, WINDOW_WIDTH / 2 - size / 2, WINDOW_HEIGHT / 2 - size / 2)

    love.graphics.draw(plateCanvas, WINDOW_WIDTH / 2 - size / 2 + size, WINDOW_HEIGHT / 2 - size / 2)

    -- render cursor
    local x, y = love.mouse.getPosition()
    love.graphics.setColor(mode == 'paint' and CURSOR_COLOR_PAINT or CURSOR_COLOR_CLEAN)
    love.graphics.draw(brush, x, y, 0, CURSOR_SCALE, CURSOR_SCALE)
end

return CanvasScene