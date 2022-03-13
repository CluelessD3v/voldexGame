--# <|=============== Services ===============|>
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--# <|=============== DEPENDENCIES ===============|>

--? <|=============== CONSTRUCTOR ===============|>
local Controllers = ReplicatedStorage.Controllers
local PlayerCombat = {}
PlayerCombat.__index = PlayerCombat

function PlayerCombat.new()
    local self = setmetatable({}, PlayerCombat)

    self.Events      = Instance.new("Folder")
    self.Events.Name = "Events"

    self.StartCombatMode        = Instance.new("RemoteEvent")
    self.StartCombatMode.Name   = "StartCombatMode"
    self.StartCombatMode.Parent = Controllers.PlayerCombatClient.Events
    return self
end


function PlayerCombat:Destroy()
    
end


return PlayerCombat.new()
