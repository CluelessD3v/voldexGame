local PlayerCombatClient = {}
PlayerCombatClient.__index = PlayerCombatClient


function PlayerCombatClient.new(player: Player)
    local self = setmetatable({}, PlayerCombatClient)
    self.Host = player
    

    self.States = {
        CastingActionOne = require(script.CastingActionOne),
        CastingActionTwo = require(script.CastingActionTwo),
        Idle             = require(script.Idle)
    }

    self.CurrentState = self.States.Idle.new(self)
    self.CurrentState:Start()

    return self
end


function PlayerCombatClient:SwitchState(newState: ModuleScript)
    self.CurrentState:Exit()
    self.CurrentState = newState.new()
    self.CurrentState:Start()
end


return PlayerCombatClient.new()
