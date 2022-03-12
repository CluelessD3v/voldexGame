local PlayerCombatClient = {}
PlayerCombatClient.__index = PlayerCombatClient


function PlayerCombatClient.new()
    local self = setmetatable({}, PlayerCombatClient)
    

    self.States = {

    }

    self.CurrentState = nil
    return self
end


function PlayerCombatClient:SwitchState(newState: ModuleScript)
    self.CurrentState:Exit()
    self.CurrentState = newState.new()
    self.CurrentState:Start()
end


return PlayerCombatClient.new()
