--# <|=============== SERVICES ===============|>
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--# <|=============== DEPENDENCIES ===============|>
local Trove = require(ReplicatedStorage.Packages.trove)

--# <|=============== DEPENDENCIES ===============|>
local LootableItem = {}
LootableItem.__index = LootableItem


function LootableItem.new(instance: MeshPart | Part, config: table)
    print(config.Tags)
    local self = setmetatable({}, LootableItem)
    self.Trove = Trove.new()

    self.Instance = instance

    self.ProximityPrompt        = Instance.new("ProximityPrompt")
    self.ProximityPrompt.Parent = self.Instance

    self.Trove:Add(self.Instance)

    self.OwnerValue        = Instance.new("ObjectValue")
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

function LootableItem:Start()
    self.ProximityPrompt.Triggered:Connect(function(player)
        self.OwnerValue.Value = player
        self:Destroy()
    end)

end

function LootableItem:Destroy()
    self.Trove:Clean()
end


return LootableItem
