--# <|=============== SERVICES ===============|>
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--# <|=============== DEPENDENCIES ===============|>
local Trove = require(ReplicatedStorage.Packages.Trove)

--? <|=============== CONSTRUCTOR ===============|>
local Sword = {}
Sword.__index = Sword


function Sword.new(instance: Tool)
    local self = setmetatable({}, Sword)
    print("Constructed")
    self.Trove = Trove.new()

    self.Instance = instance
    self.Trove:Add(self.Instance)
    return self
end

function Sword:Init()
    print("Init")
end


function Sword:Destroy()

end


return Sword
