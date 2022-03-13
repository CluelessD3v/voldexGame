local Weapon = {}
Weapon.__index = Weapon


function Weapon.new()
    local self = setmetatable({}, Weapon)
    return self
end


function Weapon:Destroy()
    
end


return Weapon
