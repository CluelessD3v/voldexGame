--# <|=============== DEPENDENCIES ===============|>
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService  = game:GetService("UserInputService")

--# <|=============== DEPENDENCIES ===============|>
-- Controllers
local Controllers  = ReplicatedStorage.Controllers
local cPlayerCombatController     = require(Controllers:FindFirstChild("PlayerCombatController", true))
local cCameraController = require(Controllers:FindFirstChild("CameraController", true))

--# <|=============== SERVICES ===============|>
local Players = game:GetService("Players")

--# Listen when a player equips an instance tagged with the weapon tag
--# If so, start the combat state machine and the camera controller
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

UserInputService.InputBegan:Connect(function(io, busy)
    if io.KeyCode == Enum.KeyCode.LeftShift and not busy then
        local player = Players.LocalPlayer
        local humanoid = player.Character.Humanoid
        humanoid.WalkSpeed = 32
    end
end)


UserInputService.InputEnded:Connect(function(io, busy)
    if io.KeyCode == Enum.KeyCode.LeftShift and not busy then
        local player = Players.LocalPlayer
        local humanoid = player.Character.Humanoid
        humanoid.WalkSpeed = 16
    end
end)