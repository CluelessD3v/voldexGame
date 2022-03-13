--[[
    Main script:
    This is were the core loop of the game is ran, all server handler functions are called from this script
]]

--# <|=============== Services ===============|>
local Players           = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")

--# <|=============== Dependencies ===============|>
-- Handlers
local Handlers   = game:GetService("ServerScriptService").Handlers

local PlayerDataHandler: ModuleScript   = require(Handlers.PlayerData)
local PlayerCombatHandler: ModuleScript = require(Handlers.PlayerCombat)
-- Components
local Components = game:GetService("ServerScriptService").Components

local GoldCoinComponent: ModuleScript = require(Components.GoldCoin)





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


    for _, savedItem in pairs(PlayerDataHandler:GetPlayerMetaValue(player, "Inventory")) do
        local itemTypeList: table = CollectionService:GetTagged(savedItem.ItemTypeTag)
        
        for _, item in ipairs(itemTypeList) do
            print(item)
            if item.Name == savedItem.Name then
                print(item, "is compat")
                local playerItem: Tool = item:Clone()
                playerItem.Parent = game.StarterPack
            end
        end
    end
end)



local gc = GoldCoinComponent.new(workspace.Coin)
gc:Init()
