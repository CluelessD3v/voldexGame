--[[
    Main script:
    This is were the core loop of the game is ran, all server handler functions are called from this script
]]

--# <|=============== Services ===============|>
local Players             = game:GetService("Players")
local CollectionService   = game:GetService("CollectionService")
local ServerScriptService = game:GetService("ServerScriptService").Components

--# <|=============== Dependencies ===============|>
-- Handlers
local Handlers = ServerScriptService
local PlayerDataHandler: ModuleScript   = require(Handlers.PlayerData)
local PlayerCombatHandler: ModuleScript = require(Handlers.PlayerCombat)

-- Entities
local Entities = ServerScriptService.Entities
local GoldCoinEntity: ModuleScript = require(Entities.GoldCoin)

-- Configs
local Configs = ServerScriptService.Configs
local PlayerDataObjects =  require(Configs.PlayerDataObjects)



Players.PlayerAdded:Connect(function(player:Player)
    local stats: Folder = Instance.new("Folder")
    stats.Name = "stats"

    --* Mock data to test PlayerData Handler
    --* //TODO look into moving these data into a config module
    PlayerDataHandler:BuildPlayerDataObject(player,    {
        ObjectValues = {
            GoldCoins = {
                Type   = "NumberValue",
                Name   = "GoldCoins",
                Value  = 0,
                Parent = player
            }
        },

        MetaData = {
            Inventory = {
                ClassicSword = {
                    Name        = "ClassicSword",
                    ItemTypeTag = "Weapon"
                }
            }
        }
    })
    

    -- --* Mock calls to test PlayerCombatHander Handler
    -- PlayerDataHandler:SetPlayerDataValue(player, "GoldCoins", 100)
    -- print(PlayerDataHandler:GetPlayerObjectValue(player, "GoldCoins"))

    -- -- PlayerDataHandler:SetPlayerMetaValue(player, "Inventory", {Name = "parapa"})
    -- print(PlayerDataHandler:GetPlayerMetaValue(player, "Inventory"))
    
    
    -- PlayerCombatHandler.StartCombatMode:FireClient(player)
    -- PlayerCombatHandler.ExitCombatMode:FireClient(player)
end)



