--# <|=============== SERVICES ===============|>
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--# <|=============== DEPENDENCIES ===============|>
local Trove = require(ReplicatedStorage.Packages.trove)
local MapToInstance = require(ReplicatedStorage:FindFirstChild("MapToInstance", true))

--# <|=============== DEPENDENCIES ===============|>
local LootableItemEntity = {}
LootableItemEntity.__index = LootableItemEntity


function LootableItemEntity.new(instance, data: table)
    local self = setmetatable({}, LootableItemEntity)
    self.Trove = Trove.new()

    self.Instance = instance
    self.Trove:Add(self.Instance)


    self.ProximityPrompt        = Instance.new("ProximityPrompt")
    self.ProximityPrompt.Parent = self.Instance

    self.ProximityPrompt.ActionText = "Grab:"
    self.ProximityPrompt.ObjectText = data.Name



    MapToInstance(self.Instance, data)
    return self
end

function LootableItemEntity:Start()
    self.ProximityPrompt.Triggered:Connect(function(player)
        self.Instance:SetAttribute("Owner", player.Name)
        self:Destroy()
    end)

end

function LootableItemEntity:Destroy()
    self.Trove:Clean()
end


return LootableItemEntity
