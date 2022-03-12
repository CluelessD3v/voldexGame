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

    PlayerDataHandler:BuildPlayerDataObject(player,    {
        ObjectValues = {
            GoldCoins = {
                Type     = "NumberValue",
                Name      = "GoldCoins",
                Value  = 0,
                Parent = player
            }
        }
    })
                                    
    PlayerDataHandler:SetPlayerDataValue(player, "GoldCoins", 100)
    print(PlayerDataHandler:GetPlayerDataValue(player, "GoldCoins"))
end)



local gc = GoldCoinComponent.new(workspace.Coin)
gc:Init()