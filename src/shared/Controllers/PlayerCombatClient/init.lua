local Players = game:GetService("Players")


local PlayerCombatClient = {}
PlayerCombatClient.__index = PlayerCombatClient


function PlayerCombatClient.new()
    local self = setmetatable({}, PlayerCombatClient)
    self.Host = Players.LocalPlayer

    self.States = {
        CastingActionOne = require(script.CastingActionOne),
        CastingActionTwo = require(script.CastingActionTwo),
        Idle             = require(script.Idle)
    }

    self.CurrentState = nil
    return self
end

function PlayerCombatClient:Start()
    self:SwitchState(self.States.Idle)
end

function PlayerCombatClient:Exit()
    self.CurrentState:Exit()
    self.CurrentState = nil
end


function PlayerCombatClient:SwitchState(newState: ModuleScript)
    if self.CurrentState then
        self.CurrentState:Exit()
        self.CurrentState = newState.new(self)
        print(self.CurrentState.Name)
        self.CurrentState:Start()
        
        return
    end

    self.CurrentState = self.States.Idle.new(self)
    self.CurrentState:Start()
end


return PlayerCombatClient.new()
