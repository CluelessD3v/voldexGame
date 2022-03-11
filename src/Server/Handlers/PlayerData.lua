--[[
    Singleton calss to handle the player data Creation, Reading, Writing operations
]]
local PlayerData = {}
PlayerData.__index = PlayerData


function PlayerData.new()
    local self = setmetatable({}, PlayerData)
    self.Players = {}
    return self
end
--- <|=============== PRIVATE FUNCTIONS ===============|>


--+ <|=============== PUBLIC FUNCTIONS ===============|>
-- Builds a data object from the player for the class to modify and keep track of.
function PlayerData:BuildDataObjectFor(player, fromTable)
    table.insert(self.Players, player.Name)

    fromTable.ObjectValues = fromTable.ObjectValues or {}
    fromTable.MetaData     = fromTable.MetaData or {}


    self.Players[player.Name] = { --!//TODO change this to use the player id instead
        Instance     = player,
        ObjectValues = fromTable.ObjectValues,
        MetaData     = fromTable.MetaData,
    }

    print(self.Players)
end
--[[ 
    Player data object 
    - Instance     : Player instance reference
    - ObjectValues: This entry holds all data objects to be represented as object values 
    - Metadata   :  Player trackable metadata that does not need/can't be represented as object values

    ObjectValues Type Interace:
    - OfType    : any?      -> Mapped to the Instance Type if no type is given the operation will fail
    - Named     : string?   -> Mapped to the Name property if no name is given the key name will be used,
    - WithValue : any?     -> Mapped to the Value property if no value is given then it will default to nil,
    - ParentedTo: Instance? -> Mapped to the Parent property if no Parent is given it will default to the Player instance

    Metadata Type Interface:
    None, given by the coder
--]]







return PlayerData.new()
