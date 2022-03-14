--[[
    Main script:
    This is were the core loop of the game is ran, all server handler functions are called from this script
]]

--# <|=============== Services ===============|>
local Players             = game:GetService("Players")
local CollectionService   = game:GetService("CollectionService")
local ServerScriptService = game:GetService("ServerScriptService")

--# <|=============== Dependencies ===============|>
-- Handlers
local Handlers = ServerScriptService.Handlers
local hPlayerData: ModuleScript   = require(Handlers.PlayerData)
local hPlayerCombat: ModuleScript = require(Handlers.PlayerCombat)

-- Entities
local Entities = ServerScriptService.Entities
local eGoldCoin: ModuleScript   = require(Entities.GoldCoin)
-- Configs
local Configs = ServerScriptService.Configs
local cPlayerDataSchema  = require(Configs.PlayerDataSchema)


Players.PlayerAdded:Connect(function(player:Player)
    local stats: Folder = Instance.new("Folder")
    stats.Name = "stats"
    
    cPlayerDataSchema.ObjectValues.GoldCoins.Parent = player
    

    hPlayerData:BuildPlayerDataObject(player, cPlayerDataSchema)

    print(hPlayerData.PlayerDataObjects)

    -- PlayerDataHandler:SetPlayerDataValue(player, "GoldCoins", 100)
    -- print(PlayerDataHandler:GetPlayerObjectValue(player, "GoldCoins"))

    -- -- PlayerDataHandler:SetPlayerMetaValue(player, "Inventory", {Name = "parapa"})
    -- print(PlayerDataHandler:GetPlayerMetaValue(player, "Inventory"))
    
    
    -- PlayerCombatHandler.StartCombatMode:FireClient(player)
    -- PlayerCombatHandler.ExitCombatMode:FireClient(player)
end)



