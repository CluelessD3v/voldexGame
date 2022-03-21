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

    --# Events (this exist so the instance does not has to reach outside of this script to a handler or system)
    self.TouchedByPlayer = Instance.new("BindableEvent")
    self.TouchedByPlayer.Name   = "TouchedByPlayer"
    self.TouchedByPlayer.Parent = self.Instance
    
    return self
end

function GoldCoinEntity:Start()
    self.RootPart.Touched:Connect(function(theTouchedPart) 
        local player: Player = Players:GetPlayerFromCharacter(theTouchedPart.Parent)        
        if player then
            self.Instance.Sounds.Coin:Play()
            self.TouchedByPlayer:Fire(player)
            self.Instance.PrimaryPart.Transparency = 1  --# Quick hack around the sound not beign able to play when the coin is destroyed
            self.Instance.Sounds.Coin.Ended:Wait()

            self:Destroy()
        end
    end)
end

function GoldCoinEntity:Destroy()
    self.Instance:Destroy()
end




return GoldCoinEntity
