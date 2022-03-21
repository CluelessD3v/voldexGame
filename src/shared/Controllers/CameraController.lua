--# <|=============== SERVICES ===============|>
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")

--# <|=============== DEPENDENCIES ===============|>
local Trove = require(ReplicatedStorage.Packages.trove)

--? <|=============== CONSTRUCTOR ===============|>
local CameraController = {}
CameraController.__index = CameraController


function CameraController.new()
    local self = setmetatable({}, CameraController)
    
    
    self.Trove = Trove.new()
    self.Locked = false

    print(self)
    return self
end

function CameraController:Start(character, camera)

    self.Character = character
    self.Camera = camera

    self.Camera.CameraType = Enum.CameraType.Scriptable
    local gyro:BodyGyro = Instance.new("BodyGyro")
    gyro.MaxTorque = Vector3.new(0, 4e5, 0)
    gyro.P         = 4e5
    gyro.Parent    = character.Humanoid.RootPart

    self.Trove:Add(gyro)

    local sensibility = .2
    
    self.Trove:Add( UserInputService.InputChanged:Connect(function(io, busy)
        if io.UserInputType == Enum.UserInputType.MouseMovement and not busy then
            local x = io.Delta.X
            local changeX = math.rad(x * sensibility)
            gyro.CFrame = gyro.CFrame * CFrame.fromAxisAngle(Vector3.new(1, 1, 0), -changeX)
        end
    end))
    

    self.Trove:Add(RunService.RenderStepped:Connect(function()
        local at = (character.Humanoid.RootPart.CFrame * CFrame.new(4, 4, 8)).Position 
        local lookAt = (character.Humanoid.RootPart.CFrame * CFrame.new(0,2, -12)).Position


        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        self.Camera.CFrame = CFrame.lookAt(at, lookAt)
    end))
end


function CameraController:Exit()
    self.Character.Humanoid.AutoRotate = true
    self.Camera.CameraType = Enum.CameraType.Custom
    self.Trove:Clean()
end



return CameraController.new()
