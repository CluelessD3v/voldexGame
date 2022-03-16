--# <|=============== SERVICES ===============|>
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--# <|=============== DEPENDENCIES ===============|>
local Trove = require(ReplicatedStorage.Packages.trove)
local MapToInstance = require(ReplicatedStorage:FindFirstChild("MapToInstance", true))

--# <|=============== DEPENDENCIES ===============|>
local LootableItem = {}
LootableItem.__index = LootableItem


function LootableItem.new(data: table)
    print(data.Tags)
    local self = setmetatable({}, LootableItem)
    self.Trove = Trove.new()

    self.Instance = data.Instance
    self.Trove:Add(self.Instance)

    self.ProximityPrompt        = Instance.new("ProximityPrompt")
    self.ProximityPrompt.Parent = self.Instance

    MapToInstance(self.Instance, data)
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
