local ReplicatedStorage = game:GetService("ReplicatedStorage")
--# <|=============== DEPENDENCIES ===============|>
-- Controllers
local Controllers  = ReplicatedStorage.Controllers
local cPlayerCombat = require(Controllers:FindFirstChild("PlayerCombat", true))

--# <|=============== SERVICES ===============|>
local Players = game:GetService("Players")

Players.LocalPlayer.CharacterAdded:Connect(function()
    local newCombatController = cPlayerCombat.new()

    newCombatController.StartCombatMode.OnClientEvent:Connect(function(equippedWeapon)
        newCombatController:Start(equippedWeapon)
    end)    

    newCombatController.ExitCombatMode.OnClientEvent:Connect(function()
        newCombatController:Exit()
    end)
end)