--[[
    Gold coin component for instances that represent gold coins that reward the player
    when he touches them
]]

local CollectionService = game:GetService("CollectionService")

local GoldCoin = {}
GoldCoin.__index = GoldCoin

function GoldCoin.new(instance: Model)
    local self = setmetatable({}, GoldCoin)

    if instance.PrimaryPart == nil then
        local newPrimaryPart: Part = Instance.new("Part")

        instance.PrimaryPart  = newPrimaryPart
        newPrimaryPart.Parent = instance
        
        warn("No primary part was found, A default one was created")
    end
    
    self.Instance = instance
    self.RootPart = self.Instance.PrimaryPart
    CollectionService:AddTag(self.Instance, "GoldCoin")
    return self
end

function GoldCoin:Init()
    self.RootPart.Touched:Connect(function(theTouchedPart) 
        self:Destroy()
    end)

end

function GoldCoin:Destroy()
    print("Destroying")
    self.Instance:Destroy()
    self = nil
end


return GoldCoin
