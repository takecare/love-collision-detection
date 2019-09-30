local Collision = {}

function Collision:new(obj)
    local newInstance = {
        colliding = false,
        xStart = nil,
        yStart = nil,
        xEnd = nil,
        yEnd = nil
    }
    setmetatable(newInstance, self)
    self.__index = self
    return newInstance
end

return Collision
