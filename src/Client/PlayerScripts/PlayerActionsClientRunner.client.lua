local ReplicatedStorage = game:GetService("ReplicatedStorage")
--# <|=============== DEPENDENCIES ===============|>
-- Controllers
local Controllers  = ReplicatedStorage.Controllers
local cPlayerCombat     = require(Controllers:FindFirstChild("PlayerCombatController", true))
local cCameraController = require(Controllers:FindFirstChild("CameraController", true))

--# <|=============== SERVICES ===============|>
local Players = game:GetService("Players")

Players.LocalPlayer.CharacterAdded:Connect(function()
    local player = Players.LocalPlayer
    cPlayerCombat.StartCombatMode.OnClientEvent:Connect(function(equippedWeapon)
        local camera = workspace.CurrentCamera
        cPlayerCombat:Start(player, equippedWeapon)
        cCameraController:Start(player.Character, camera)
    end)    

    cPlayerCombat.ExitCombatMode.OnClientEvent:Connect(function()
        cPlayerCombat:Exit()
        cCameraController:Exit()
    end)
end)