local MainScene = require('scenes/MainScene')
local CanvasScene = require('scenes/CanvasScene')
local StencilScene = require('scenes/StencilScene')
local PaintScene = require('scenes/PaintScene')
local CollisionsScene = require('scenes/CollisionsScene')

WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getDesktopDimensions()
WINDOW_WIDTH, WINDOW_HEIGHT = 800, 800

local index = 1
local scenes = { 
    MainScene,
    CanvasScene,
    StencilScene,
    PaintScene,
    CollisionsScene
}

local nextScene = function ()
    if index == #scenes then
        index = 1
    else
        index = index + 1
    end
    loadScene()
end

local previousScene = function ()
    if index == 1 then
        index = #scenes
    else
        index = index - 1
    end
    loadScene()
end

local config = {
    title = 'playground'
}

function loadScene()
    love.graphics.reset()
    love.mouse.setVisible(true)
    love.mouse.setGrabbed(false)
    scenes[index]:load(config) -- bad: config param is both exit & return value
    love.window.setTitle(config.title)
end

function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    -- love.graphics.setDefaultFilter('nearest', 'nearest')
    loadScene()
end

function love.update(dt)
    scenes[index]:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == ']' then
        nextScene()
    elseif key == '[' then
        previousScene()
    else
        scenes[index]:keypressed(key)
    end
end

function love.draw()
    love.graphics.clear(0.25, 0.25, 0.25)
    scenes[index]:draw()
end
