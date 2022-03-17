--# <|=============== SERVICES ===============|>
local CollectionService = game:GetService("CollectionService")

--? <|=============== CONSTRUCTOR ===============|>
local LootHandler = {}
LootHandler.__index = LootHandler

function LootHandler.new()
    local self = setmetatable({}, LootHandler)
    return self
end
--- <|=============== PRIVATE FUNCTIONS ===============|>
-- table should be a dictionary and each key must have a weight entry!
local function CalculateMaxWeight(aTable)
    local result = 0
    -- add all entries weights together, to get one big value 
    for _, data in pairs(aTable) do
        result = result + data.Weight
    end

    return result
end


--+ <|=============== PUBLIC FUNCTIONS ===============|>
function LootHandler:GetItemByWeight(itemList)
    -- Choose a random number between 0 and the max weight
    local MaxWeight = CalculateMaxWeight(itemList)
    local randI = math.random(MaxWeight)
    
    -- iterate the entries to see wich will be choosed based on their weight
    for _, object in pairs(itemList) do
        -- the random number is lower than the current entry weight? Tehn return me that entry IT WAS SELECTED
        if randI <= object.Weight then
            return object      
        else -- Substract and keep rolling 
            randI = randI - object.Weight   
        end
    end 
end

--[[
    function for lootable item data handling. Checks if the given item has either:     
    - Tag
    - Attribute

    that matches the "ItemType" key

    Then it will go on to check which item it is data wise, by checking if the item has a:
    - A tag
    - An Attribute
    - Even the Instance name

    that matches with the "ItemName" Key, 
    
    table fields:

    FooType = { -- Outer loop checks if it has an Att or Tag that matches the Type key
        FooObject1 = {},
        FooObject2 = {}, -- Nested Loop checks if the instance name 
        FooObject3 = {}     or iehter an attribute or tag or match the ItemConfigName Key
    },

    BazType = {
        BazObject1 = {},
        BazObject2 = {},
        BazObject3 = {},
    }

]]--

function LootHandler:GetLootableItemConfigFromTable(lootableItem, lootableItemTable)
    print(lootableItem, lootableItemTable, "")

    for itemTypeName, itemsTypeTable in pairs(lootableItemTable) do
        local hasItemTypeTag: boolean = CollectionService:HasTag(lootableItem, itemTypeName)
        local itemTypeAtt: string     = lootableItem:GetAttribute("ItemType")

        if hasItemTypeTag or itemTypeAtt == itemTypeName then  
            print("hasItemTypeTag", hasItemTypeTag)
            print("itemTypeAtt", itemTypeAtt)
            for itemName, itemData in pairs(itemsTypeTable) do
                
                local hasItemNameTag: boolean = CollectionService:HasTag(lootableItem, itemName)
                local itemNameAtt: string     = lootableItem:GetAttribute("ItemName")
                
                if lootableItem.Name == itemName or hasItemNameTag or itemNameAtt == itemName then
                    return itemData
                end
            end

            warn("Failed to get LootableItem:", lootableItem, "config data, could not verify ItemName!")
            warn("try either: Tagging, setting an attribute to, or renaming ", lootableItem, "with valid Item name")

        else
            warn("Failed to get LootableItem:", lootableItem, "config data, could not verify ItemType!")
            warn("try, Tagging or setting an Attribute to", lootableItem, "with valid ItemType name")
        end


    end
end

return LootHandler.new()
