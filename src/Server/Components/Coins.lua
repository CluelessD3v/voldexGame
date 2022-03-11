local Coins = {}
Coins.__index = Coins


function Coins.new()
    local self = setmetatable({}, Coins)

    return self
end


function Coins:Destroy()
    
end


return Coins
