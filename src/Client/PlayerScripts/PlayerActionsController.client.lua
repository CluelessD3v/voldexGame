local ReplicatedStorage = game:GetService("ReplicatedStorage")
--# <|=============== DEPENDENCIES ===============|>
-- Controllers
local Controllers  = ReplicatedStorage.Controllers
local cPlayerCombat = require(Controllers:FindFirstChild("PlayerCombat", true))

--# <|=============== SERVICES ===============|>
local Players = game:GetService("Players")

Players.LocalPlayer.CharacterAdded:Connect(function()

    cPlayerCombat.StartCombatMode.OnClientEvent:Connect(function(equippedWeapon)
        cPlayerCombat:Start(equippedWeapon)
    end)    

    cPlayerCombat.ExitCombatMode.OnClientEvent:Connect(function()
        cPlayerCombat:Exit()
    end)
end)