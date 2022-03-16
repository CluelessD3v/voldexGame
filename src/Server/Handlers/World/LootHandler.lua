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


return LootHandler.new()
