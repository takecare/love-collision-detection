local StencilScene = {}

local CURSOR_COLOR_PAINT = { 0.6, 0, 0, 0.8 }
local CURSOR_COLOR_CLEAN = { 0.2, 0.2, 0.5, 0.8 }
local CURSOR_SCALE = 3

local canvas
local brush
local plate
local size = 100
local mode = 'paint'

function StencilScene:load(config)
    config.title = 'stencil'
    
    love.mouse.setVisible(false)
    love.mouse.setGrabbed(true)

    canvas = love.graphics.newCanvas(size, size)

    brush = love.graphics.newImage('assets/brush8.png')
    plate = love.graphics.newImage('assets/plate128.png')
    size = plate:getWidth()
end

function StencilScene:update(dt)
    local mx, my = love.mouse.getPosition()
    local cx, cy = WINDOW_WIDTH / 2 - size / 2 - size, WINDOW_HEIGHT / 2 - size / 2
    local x, y = mx - cx, my - cy

    if love.mouse.isDown(1) then
        love.graphics.setCanvas(canvas)
        love.graphics.setBlendMode('add')
        -- love.graphics.setColor(1, 0, 0, 1)
        love.graphics.draw(brush, x, y, 0, CURSOR_SCALE, CURSOR_SCALE)
        love.graphics.setCanvas()
    end
end

function StencilScene:keypressed(key)
    --
end

local function myStencilFunction()
    love.graphics.draw(
        plate,
        WINDOW_WIDTH / 2 - size / 2,
        WINDOW_HEIGHT / 2 - size / 2
    )
end

function StencilScene:draw()
    -- love.graphics.setBlendMode('alpha')
    love.graphics.setColor(0.25, 0.25, 0.25, 1)
    love.graphics.rectangle(
        'fill',
        WINDOW_WIDTH / 2 - size / 2,
        WINDOW_HEIGHT / 2 - size / 2,
        size,
        size
    )

    love.graphics.setColor(1, 0, 0, 1)

    -- love.graphics.stencil(myStencilFunction, 'replace', 1)
    -- love.graphics.setStencilTest('greater', 0)
    love.graphics.draw(
        canvas,
        WINDOW_WIDTH / 2 - size / 2,
        WINDOW_HEIGHT / 2 - size / 2
    )
    -- love.graphics.setStencilTest()

    local x, y = love.mouse.getPosition()
    love.graphics.setColor(mode == 'paint' and CURSOR_COLOR_PAINT or CURSOR_COLOR_CLEAN)
    love.graphics.draw(brush, x, y, 0, CURSOR_SCALE, CURSOR_SCALE)
end

return StencilScene