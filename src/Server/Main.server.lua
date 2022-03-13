--[[
    Main script:
    This is were the core loop of the game is ran, all server handler functions are called from this script
]]
local Handlers   = game:GetService("ServerScriptService").Handlers
local Components = game:GetService("ServerScriptService").Components
--# <|=============== Dependencies ===============|>
-- Handlers
local PlayerDataHandler: ModuleScript  = require(Handlers.PlayerData)
local PlayerCombatHandler: ModuleScript = require(Handlers.PlayerCombat)
-- Components
local GoldCoinComponent: ModuleScript = require(Components.GoldCoin)
local SwordComponent: ModuleScript = require(Components.Sword)

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
    

    --* Mock calls to test PlayerCombatHander Handler
    PlayerDataHandler:SetPlayerDataValue(player, "GoldCoins", 100)
    print(PlayerDataHandler:GetPlayerObjectValue(player, "GoldCoins"))

    PlayerDataHandler:SetPlayerMetaValue(player, "Inventory", {Name = "parapa"})
    print(PlayerDataHandler:GetPlayerMetaValue(player, "Inventory"))
    
    
    PlayerCombatHandler.StartCombatMode:FireClient(player)

    task.wait(3)

    PlayerCombatHandler.ExitCombatMode:FireClient(player)
end)



local gc = GoldCoinComponent.new(workspace.Coin)
gc:Init()
