local StencilScene = {}

function StencilScene:load(config)
    config.title = 'stencil'
    
    love.mouse.setVisible(false)
    love.mouse.setGrabbed(true)
end

function StencilScene:update(dt)
    --
end

function StencilScene:keypressed(key)
    --
end

local function myStencilFunction()
    love.graphics.rectangle('fill', 225, 200, 350, 300)
end

function StencilScene:draw()
    love.graphics.stencil(myStencilFunction, 'replace', 1)
 
    -- Only allow rendering on pixels which have a stencil value greater than 0.
     love.graphics.setStencilTest('greater', 0)
  
     love.graphics.setColor(1, 0, 0, 0.45)
     love.graphics.circle('fill', 300, 300, 150, 50)
  
     love.graphics.setColor(0, 1, 0, 0.45)
     love.graphics.circle('fill', 500, 300, 150, 50)
  
     love.graphics.setColor(0, 0, 1, 0.45)
     love.graphics.circle('fill', 400, 400, 150, 50)
  
     love.graphics.setStencilTest()
end

return StencilScene