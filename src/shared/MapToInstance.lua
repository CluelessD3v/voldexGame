--[[
    This module serves as an utility to map data to an instance that would come from a config
    file or table object with the:
    - Properties
    - Attributes
    - Tags
    - ObjectValues
]]---

local CollectionService = game:GetService('CollectionService')

return function (anInstance: PVInstance, aFieldMap: table)
    aFieldMap = aFieldMap or {
        Properties = {},
        Attributes = {},
        Tags = {},
        ObjectValues = {}
    }

    -- Default to empty table if there is no field
    local properties   = aFieldMap.Properties or {}
    local attributes   = aFieldMap.Attributes or {}
    local tags         = aFieldMap.Tags or {}
    local objectValues = aFieldMap.ObjectValues or {}

    for property, value in pairs (properties) do 
        anInstance[property] = value
    end

 
    for attribute, value in pairs(attributes) do
        anInstance:SetAttribute(attribute, value)
    end

    for _, tag in pairs(tags) do
        CollectionService:AddTag(anInstance, tag)
    end

    for name, objectValue in pairs(objectValues) do
        objectValue.Name = name
        objectValue.Parent = Instance
    end

    return anInstance
end