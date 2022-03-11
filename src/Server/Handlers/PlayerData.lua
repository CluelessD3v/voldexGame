--[[
    Module to handle the set up and tracking of player data
]]

local PlayerData = {}

PlayerData.SetObjectValuesFor = function(player: Player, fromTable: table, parentedTo: Instance?)
    local parent = if parentedTo then parentedTo else player 

    for key, object in pairs(fromTable) do 
        local objectVal: ObjectValue = Instance.new(object.Type)
        objectVal.Name   = key
        objectVal.Value  = objectVal.Value
        objectVal.Parent = parent
    end
end

return PlayerData 