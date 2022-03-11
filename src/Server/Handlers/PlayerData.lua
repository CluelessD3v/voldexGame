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
-- Aux function to map data from PlayerData Object
-- ObjectValues field into object value instances

local function MapObjectValues(fromObjectValuesTable: table)
    
    for key, dataObject in pairs(fromObjectValuesTable) do
        local objectVal: ObjectValue = Instance.new(dataObject.OfType) or error("Value Type field missing")

        objectVal.Name   = dataObject.Named or key
        objectVal.Value  = dataObject.WithValue or error("Value field missing")
        objectVal.Parent = dataObject.ParentedTo or error("Parent field missing")
    end
end

--+ <|=============== PUBLIC FUNCTIONS ===============|>
-- Builds a data object for a player from the given metadata and object value types.
function PlayerData:BuildDataObjectForPlayer(player, fromTable)
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
    - OfType    : any      -> Mapped to the Instance Type if no type is given the operation will fail
    - Named     : string?   -> Mapped to the Name property if no name is given the key name will be used,
    - WithValue : any?     -> Mapped to the Value property if no value is given then it will default to nil,
    - ParentedTo: Instance? -> Mapped to the Parent property if no Parent is given it will default to the Player instance

    Metadata Type Interface:
    None, given by the coder
--]]


return PlayerData.new()
