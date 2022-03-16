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
local EventsNameSpace: Folder = ReplicatedStorage.Events.PlayerCombat

local PlayerCombatHandler = {}
PlayerCombatHandler.__index = PlayerCombatHandler

function PlayerCombatHandler.new()
    local self = setmetatable({}, PlayerCombatHandler)

    --# Adding remote events to namespace in Replicated Storage
    self.StartCombatMode        = Instance.new("RemoteEvent")
    self.StartCombatMode.Name   = "StartCombatMode"
    self.StartCombatMode.Parent = EventsNameSpace

    self.ExitCombatMode        = Instance.new("RemoteEvent")
    self.ExitCombatMode.Name   = "ExitCombatMode"
    self.ExitCombatMode.Parent = EventsNameSpace


    self.DamageMob        = Instance.new("RemoteEvent")
    self.DamageMob.Name   = "DamageMob"
    self.DamageMob.Parent = EventsNameSpace

    self.ValidTargetTags = {  
        "Dragon"
    }

    return self
end



return PlayerCombatHandler.new()
