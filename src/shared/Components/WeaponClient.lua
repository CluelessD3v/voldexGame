local WeaponClient = {}
WeaponClient.__index = WeaponClient


function WeaponClient.new()
    local self = setmetatable({}, WeaponClient)
    return self
end


function WeaponClient:Destroy()
    
end


return WeaponClient
