--# <|=============== Services ===============|>
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--# <|=============== Dependencies ===============|>
local Trove = require(ReplicatedStorage.Packages.trove)


local Item = {}
Item.__index = Item


function Item.new(instance: MeshPart | Part, config: table)
    local self = setmetatable({}, Item)
    self.Trove = Trove.new()

    self.Instance = instance
    self.Trove:Add(self.Instance)

    self.OwnerValue = Instance.new("ObjectValue")
    self.OwnerValue.Name   = "Owner"
    self.OwnerValue.Parent = self.Instance

    for attName, attVal in pairs(config.Attributes) do
        self.Instance:SetAttribute(attName, attVal)
    end

    for _, tag in pairs(config.Tags) do
        CollectionService:AddTag(self.Instance, tag)
    end

    return self
end


function Item:Destroy()
    
end


return Item
