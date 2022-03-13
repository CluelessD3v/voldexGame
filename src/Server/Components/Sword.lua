--# <|=============== Services ===============|>
local CollectionService = game:GetService("CollectionService")

--? <|=============== CONSTRUCTOR ===============|>
local Sword = {}
Sword.__index = Sword


function Sword.new(instance: Tool)
    local self = setmetatable({}, Sword)
    self.Instance = instance
    CollectionService:AddTag(self.Instance, "Sword")    
    return self
end


function Sword:Destroy()
    
end


return Sword
