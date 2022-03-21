--[[
    Gold coin component for instances that represent gold coins that reward the player
    when he touches them
]]

--# <|=============== Services ===============|>
local Players           = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")

--? <|=============== LIFE CYCLE METHODS ===============|>
local GoldCoinEntity = {}
GoldCoinEntity.__index = GoldCoinEntity

function GoldCoinEntity.new(instance: Model)
    local self = setmetatable({}, GoldCoinEntity)

    if instance.PrimaryPart == nil then
        warn("Component construction failed, Instance must have a primary part, or instance is not a model")
        return 
    end
    
    self.Instance = instance
    self.RootPart = self.Instance.PrimaryPart
    CollectionService:AddTag(self.Instance, "GoldCoin")
    return self
end

function GoldCoinEntity:Start()
    self.RootPart.Touched:Connect(function(theTouchedPart) 
        local player: Player = Players:GetPlayerFromCharacter(theTouchedPart.Parent)
        
        if player then
            self:Destroy()
        end
    end)
end

function GoldCoinEntity:Destroy()
    print("Destroying")
    self.Instance:Destroy()
end




return GoldCoinEntity
