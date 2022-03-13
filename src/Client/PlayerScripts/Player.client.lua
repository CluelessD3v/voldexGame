local ReplicatedStorage = game:GetService("ReplicatedStorage")
--# <|=============== DEPENDENCIES ===============|>
-- Controllers
local Controllers  = ReplicatedStorage.Controllers
local PlayerCombat = require(Controllers:FindFirstChild("PlayerCombatClient", true))

--# <|=============== SERVICES ===============|>
local Players = game:GetService("Players")

Players.LocalPlayer.CharacterAdded:Connect(function()
    PlayerCombat:Start()    
    task.wait(3)
    PlayerCombat:Exit()
    task.wait(3)
    PlayerCombat:Start()    
    task.wait(3)
    PlayerCombat:Exit()

end)