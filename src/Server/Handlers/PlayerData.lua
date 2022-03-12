--[[
    Singleton class to handle the player data Creation, Reading, Writing operations
]]
local PlayerData = {}
PlayerData.__index = PlayerData


function PlayerData.new()
    local self = setmetatable({}, PlayerData)
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
    local ov: objectValue = parent:FindFirstChild(name, true)
    ov.Value = newValue
end

--+ <|=============== PUBLIC FUNCTIONS ===============|>

--# Builds a data object for a player from the given metadata and object value types.
--# Also Instances object values under the given parent for the system to track as player owned.
function PlayerData:BuildPlayerDataObject(player, fromTable)
    
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

    Metadata Type Interface:
    None, given by the coder
--]]

--# Sets to PlayerDataObject ObjectValue value... Overwrites old value, so be mindful when using!
function PlayerData:SetPlayerDataValue(player: Player, name: string, newValue: any )
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

        warn("Object Value not found!")
    end


    warn("Player Data Object Not found")
end

function PlayerData:GetPlayerDataValue(player: Player, name: string)
    local playerDataObject = self.PlayerDataObjects[player.Name]

    --# The PlayerDataObject Exists? Great!
    --# Now look if the objectvalue type exist... It does!? Great!
    --# Then return the interal data value
    
    if playerDataObject then
        for key, objectValue in pairs(playerDataObject.ObjectValues) do
            if name == objectValue.Name or name == key then
                return objectValue.Value
            end
        end

        warn("Object Value not found!")
    end

    warn("Player Data Object Not found")
end


return PlayerData.new()
