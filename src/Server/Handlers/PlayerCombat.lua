--# <|=============== Services ===============|>

local PlayerCombat = {}
PlayerCombat.__index = PlayerCombat


function PlayerCombat.new()
    local self = setmetatable({}, PlayerCombat)
    return self
end


function PlayerCombat:Destroy()
    
end


return PlayerCombat.new()
