--# <|=============== SERVICES ===============|>

local ReplicatedStorage = game:GetService("ReplicatedStorage")



local WorldEvents               = ReplicatedStorage.Events.WorldRunner
local DragonDied                = WorldEvents.DragonDied
local PlayerEnteredCurrentLevel = WorldEvents.PlayerEnteredCurrentLevel


PlayerEnteredCurrentLevel.OnClientEvent:Connect(function()
    print("PlayerEnteredCurrentLevel")
end)

DragonDied.OnClientEvent:Connect(function()
    print("DragonDied")
end)