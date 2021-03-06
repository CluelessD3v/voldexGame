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

    for key, objectValue in pairs(objectValues) do
        local newObjectValue        = Instance.new(objectValue.Type) or error("Object value must have a type field!")
              newObjectValue.Name   = objectValue.Name or key
              newObjectValue.Value  = objectValue.Value or nil
              newObjectValue.Parent = anInstance
    end

    return anInstance
end