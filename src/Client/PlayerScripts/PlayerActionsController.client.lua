local ReplicatedStorage = game:GetService("ReplicatedStorage")
--# <|=============== DEPENDENCIES ===============|>
-- Controllers
local Controllers  = ReplicatedStorage.Controllers
local cPlayerCombat = require(Controllers:FindFirstChild("PlayerCombat", true))

--# <|=============== SERVICES ===============|>
local Players = game:GetService("Players")

Players.LocalPlayer.CharacterAdded:Connect(function()
    local newCombatController
    
    cPlayerCombat.StartCombatMode.OnClientEvent:Connect(function()
        newCombatController = cPlayerCombat.new()
        newCombatController:Start()
    end)    

    cPlayerCombat.ExitCombatMode.OnClientEvent:Connect(function()
        newCombatController:Exit()
    end)
end)