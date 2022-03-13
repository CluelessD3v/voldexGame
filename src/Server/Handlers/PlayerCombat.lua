--[[
    This handler serves and the handler class for player combat, it sends signals to and validates
    request from its clients counter part PlayerCombatClient Controller.

    This handler will kickstart automatically when ** a player equipped a tool ** from his
    inventory.

]]
--# <|=============== Services ===============|>
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--# <|=============== DEPENDENCIES ===============|>

--? <|=============== CONSTRUCTOR ===============|>
local Controllers = ReplicatedStorage.Controllers
local PlayerCombat = {}
PlayerCombat.__index = PlayerCombat

function PlayerCombat.new()
    local self = setmetatable({}, PlayerCombat)

    --# Adding remote events folders to namespace in Replicated Storage
    self.Events      = Instance.new("Folder")
    self.Events.Name = "Events"

    --# Events
    self.StartCombatMode        = Instance.new("RemoteEvent")
    self.StartCombatMode.Name   = "StartCombatMode"
    self.StartCombatMode.Parent = Controllers.PlayerCombatClient.Events

    self.ExitCombatMode        = Instance.new("RemoteEvent")
    self.ExitCombatMode.Name   = "ExitCombatMode"
    self.ExitCombatMode.Parent = Controllers.PlayerCombatClient.Events
    return self
end


function PlayerCombat:Destroy()
    
end


return PlayerCombat.new()
