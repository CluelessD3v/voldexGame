local ReplicatedStorage = game:GetService("ReplicatedStorage")
--# <|=============== DEPENDENCIES ===============|>
-- Controllers
local Controllers  = ReplicatedStorage.Controllers
local cPlayerCombatController     = require(Controllers:FindFirstChild("PlayerCombatController", true))
local cCameraController = require(Controllers:FindFirstChild("CameraController", true))

--# <|=============== SERVICES ===============|>
local Players = game:GetService("Players")

Players.LocalPlayer.CharacterAdded:Connect(function()
    local newPlayerCombatController = cPlayerCombatController.new()

    local player = Players.LocalPlayer
    newPlayerCombatController.StartCombatMode.OnClientEvent:Connect(function(equippedWeapon)
        local camera = workspace.CurrentCamera
        newPlayerCombatController:Start(player, equippedWeapon)
        cCameraController:Start(player.Character, camera)
    end)    
    

    newPlayerCombatController.ExitCombatMode.OnClientEvent:Connect(function()
        newPlayerCombatController:Exit()
        cCameraController:Exit()
    end)
end)