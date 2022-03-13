local ReplicatedStorage = game:GetService("ReplicatedStorage")
--# <|=============== DEPENDENCIES ===============|>
-- Controllers
local Controllers  = ReplicatedStorage.Controllers
local PlayerCombat = require(Controllers:FindFirstChild("PlayerCombatClient", true))

--# <|=============== Services ===============|>
local Players = game:GetService("Players")

Players.LocalPlayer.CharacterAdded:Connect(function()
    print(PlayerCombat)
end)