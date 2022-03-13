--[[
    This controller serves as the context class for the concrete combat states it requires.
    It allows combat states to transition between each other, and be a data repo for data they might 
    require to function.

    It also holds an internal reference to the player(Host) it is current operating in
]]
--# <|=============== SERVICES ===============|>
local Players = game:GetService("Players")

--? <|=============== CONSTRUCTOR ===============|>
local PlayerCombatClient = {}
PlayerCombatClient.__index = PlayerCombatClient


function PlayerCombatClient.new()
    local self = setmetatable({}, PlayerCombatClient)
    self.Host = Players.LocalPlayer

    --# Concrete states the context manages
    self.States = {
        CastingActionOne = require(script.CastingActionOne),
        CastingActionTwo = require(script.CastingActionTwo),
        Idle             = require(script.Idle)
    }

    self.CurrentState = nil
    return self
end

--+ <|=============== PUBLIC FUNCTIONS ===============|>

--* KickStarts PlayerCombat State machine & allows players to engage with the combat system
function PlayerCombatClient:Start()
    self:SwitchState(self.States.Idle)
end


--* Exits from the combat system
function PlayerCombatClient:Exit()
    self.CurrentState:Exit()
    self.CurrentState = nil
end

--* Context Interface function that allows Required Concrete states to transition Between each other 

function PlayerCombatClient:SwitchState(newState: ModuleScript)
    --# Does the Current state object exist? Great
    --# transition out of said current state, set 
    --# new state as current & start it, else default to idle

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
