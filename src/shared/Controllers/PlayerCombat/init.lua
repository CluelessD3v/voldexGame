--[[
    This controller serves as the context class for the concrete combat states it requires.
    It allows combat states to transition between each other, and be a data repo for data they might 
    require to function.

    It also holds an internal reference to the player(Host) it is current operating in

    It has a control dependency with its server counterpart PlayerCombat Handler and needs it
    to recieve data to process and to send requests to the server.  

    This controller will only start when the StartCombatMode event is fired
    This controller will only stop when the ExitCombatMode event is fired
]]

--# <|=============== SERVICES ===============|>
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--# <|=============== DEPENDENCIES ===============|>
local Trove = require(ReplicatedStorage.Packages.trove)

--? <|=============== CONSTRUCTOR ===============|>
local eventsNameSpace   = ReplicatedStorage.Events.PlayerCombat 

local PlayerCombatClient = {}
PlayerCombatClient.__index = PlayerCombatClient


function PlayerCombatClient.new()
    local self = setmetatable({}, PlayerCombatClient)
    
    self.EquippedWeapon = nil
    self.Trove = Trove.new()

    self.StartCombatMode = eventsNameSpace:WaitForChild("StartCombatMode")
    self.ExitCombatMode  = eventsNameSpace:WaitForChild("ExitCombatMode")

    self.ComboCount = 0

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
function PlayerCombatClient:Start(equippedWeapon)
    self.EquippedWeapon = equippedWeapon
    self:SwitchState(self.States.Idle)
end

--* Exits from the combat system
function PlayerCombatClient:Exit()
    self.CurrentState:Exit()
    self.Trove:Clean()
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
