--# <|=============== SERVICES ===============|>
local UserInputService= game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Trove = require(ReplicatedStorage.Packages.trove)

--? <|=============== CONSTRUCTOR ===============|>
local CameraController = {}
CameraController.__index = CameraController


function CameraController.new()
    local self = setmetatable({}, CameraController)

    self.Locked = false
    return self
end


function CameraController:Destroy()
    
end


return CameraController.new()
