local PlayerCombatClient = {}
PlayerCombatClient.__index = PlayerCombatClient


function PlayerCombatClient.new()
    local self = setmetatable({}, PlayerCombatClient)
    return self
end


function PlayerCombatClient:Destroy()
    
end


return PlayerCombatClient.new()
