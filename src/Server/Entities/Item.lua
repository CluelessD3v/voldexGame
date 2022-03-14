local Item = {}
Item.__index = Item


function Item.new(instance: MeshPart | Part)
    local self = setmetatable({}, Item)
    return self
end


function Item:Destroy()
    
end


return Item
