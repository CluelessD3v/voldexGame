--[[
    Singleton class to handle the player data Creation, Reading, Writing operations
]]

--? <|=============== CONSTRUCTOR ===============|>
local PlayerDataHandler = {}
PlayerDataHandler.__index = PlayerDataHandler


function PlayerDataHandler.new()
    local self = setmetatable({}, PlayerDataHandler)
    self.PlayerDataObjects = {}
    return self
end

--- <|=============== PRIVATE FUNCTIONS ===============|>

--# Aux function to map data from PlayerData Object
--# ObjectValues field into object value instances

local function MapObjectValues(fromObjectValuesTable: table)
    
    for key, dataObject in pairs(fromObjectValuesTable) do
        local objectVal: ObjectValue = Instance.new(dataObject.Type) or error("Value Type field missing")

        objectVal.Name   = dataObject.Name or key
        objectVal.Value  = dataObject.Value or error("Value field missing")
        objectVal.Parent = dataObject.Parent or error("Parent field missing")
    end
end

--# Aux function called when doing a write operation on an object value type.
--# This function exist to keep both the internal DataObject value & the Instance
--# Value synced!

local function SetObjectValueInstanceValue(parent, name, newValue)
    local ov: ObjectValue = parent:FindFirstChild(name, true)
    ov.Value = newValue
end

--+ <|=============== PUBLIC FUNCTIONS ===============|>

--# Builds a data object for a player from the given MetaData and ObjectvVlue tables.
--# Also Instances object values under the given parent for the system to track as player owned.
function PlayerDataHandler:BuildPlayerDataObject(player, fromTable)
    
    table.insert(self.PlayerDataObjects, player.Name)

    fromTable.ObjectValues = fromTable.ObjectValues or {}
    fromTable.MetaData     = fromTable.MetaData or {}


    self.PlayerDataObjects[player.Name] = { --!//TODO change this to use the player id instead
        Instance     = player,
        ObjectValues = fromTable.ObjectValues,
        MetaData     = fromTable.MetaData,
    }

    MapObjectValues(self.PlayerDataObjects[player.Name].ObjectValues)
end

--[[ 
    Player data object 
    - Instance     : Player instance reference
    - ObjectValues: This entry holds all data objects to be represented as object values 
    - Metadata   :  Player trackable metadata that does not need/can't be represented as object values
            
    ObjectValues Type Interface:
    - Type  : any      -> Mapped to the Instance Type if no type is given the operation will fail
    - Name  : string?   -> Mapped to the Name property if no name is given the key name will be used,
    - Value : any?     -> Mapped to the Value property if no value is given then it will default to nil,
    - Parent: Instance? -> Mapped to the Parent property if no Parent is given it will default to the Player instance

    MetaData Type Interface:
    None, given by the coder
--]]

-- Object value functions
--* Overwrites value field from both PlayerDataObject ObjectValue and its physical instance in the game
function PlayerDataHandler:SetPlayerDataValue(player: Player, name: string, newValue: any )
    local playerDataObject = self.PlayerDataObjects[player.Name]

    --# The PlayerDataObject Exists? Great!
    --# Now look if the objectvalue type exist... It does!? Great!
    --# Then overwrite both the internal valueObject value and Instance value

    if playerDataObject then
        for key, objectValue in pairs(playerDataObject.ObjectValues) do
            if name == objectValue.Name or name == key then
                objectValue.Value = newValue
                SetObjectValueInstanceValue(objectValue.Parent, name or key, newValue)
                return
            end
        end

        warn("ObjectValue field not found!")
        return nil
    end

    warn("Given PlayerDataObject was not found")
    return nil
end

--* Returns ObjectValue table from PlayerDataObject, NOT THE PHYSICAL OBJECT VALUE INSTANCE
function PlayerDataHandler:GetPlayerObjectValue(player: Player, name: string)
    local playerDataObject = self.PlayerDataObjects[player.Name]

    --# Does the given PlayerDataObject Exists? Great!
    --# Now Does the given objectvalue field exist, It does!? Great!
    --# Then return the inter ObjectValue value field
    
    if playerDataObject then
        local objectValue: table = playerDataObject.ObjectValues[name]

        if objectValue then
            return playerDataObject.ObjectValues[name]
        end

        warn("Given ObjectValue field not found!")
        return nil
    end     

    warn("Given PlayerDataObject Not found")
    return nil
end



-- Metadata functions
--* Overwrites value  from the given PlayerDataObject MetaData field
function PlayerDataHandler:SetPlayerMetaValue(player: Player, name: string, newValue: any )
    local playerDataObject = self.PlayerDataObjects[player.Name]

    --# The given PlayerDataObject Exists? Great!
    --# Does the given MetaData field exist? Great!
    --# Then overwrite it with the new value

    if playerDataObject then
        local metaDataValue: any = playerDataObject.MetaData[name]

        if metaDataValue then
            playerDataObject.MetaData[name] = newValue
            return
        end            
        
        warn("Given MetaData field not found!")
        return nil
    end

    warn("Given PlayerDataObject Not found")
    return nil
end

--* Returns Value from the given PlayerDataObject MetaData field
function PlayerDataHandler:GetPlayerMetaValue(player: Player, name: string)
    local playerDataObject = self.PlayerDataObjects[player.Name]
    if playerDataObject then
        local metaDataValue: any = playerDataObject.MetaData[name]

        if metaDataValue then
            return playerDataObject.MetaData[name] 
        end            
        
        warn("Given MetaData field not found!")
        return nil
    end

    warn("Given PlayerDataObject was not found")
    return nil
end


return PlayerDataHandler.new()
