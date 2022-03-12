--[[
    Main script:
    This is were the core loop of the game is ran, all server handler functions are called from this script
]]
local Handlers   = game:GetService("ServerScriptService").Handlers
local Components = game:GetService("ServerScriptService").Components
--# <|=============== Dependencies ===============|>
-- Handlers
local PlayerDataHandler: ModuleScript  = require(Handlers.PlayerData)
-- Components
local GoldCoinComponent: ModuleScript = require(Components.GoldCoin)

--# <|=============== Services ===============|>
local Players = game:GetService("Players")



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
                GhostSword = {
                    Name   = "Ghost Sword",
                    Damage = 25,
                    Speed  = 15,
                }
            }
        }
    })
                                    
    PlayerDataHandler:SetPlayerDataValue(player, "GoldCoins", 100)
    print(PlayerDataHandler:GetPlayerObjectValue(player, "GoldCoins"))

    PlayerDataHandler:SetPlayerMetaValue(player, "Inventory", {Name = "parapa"})
    local inventory = PlayerDataHandler:GetPlayerMetaValue(player, "Inventory")
    print(inventory)
    
end)



local gc = GoldCoinComponent.new(workspace.Coin)
gc:Init()