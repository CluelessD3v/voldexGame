local ReplicatedStorage = game:GetService("ReplicatedStorage")
--# <|=============== DEPENDENCIES ===============|>
-- Controllers
local Controllers  = ReplicatedStorage.Controllers
local cPlayerCombat     = require(Controllers:FindFirstChild("PlayerCombatController", true))
local cCameraController = require(Controllers:FindFirstChild("CameraController", true))

--# <|=============== SERVICES ===============|>
local Players = game:GetService("Players")

local player = Players.LocalPlayer

Players.LocalPlayer.CharacterAdded:Connect(function()

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