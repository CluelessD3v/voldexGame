--# <|=============== SERVICES ===============|>

--# <|=============== DEPENDENCIES ===============|>

--? <|=============== CONSTRUCTOR ===============|>
local Sword = {}
Sword.__index = Sword


function Sword.new(instance: Tool)
    local self = setmetatable({}, Sword)
    print("Constructed")
    self.Instance = instance
    return self
end

function Sword:Init()
    print("Init")
end


function Sword:Destroy()

end


return Sword
