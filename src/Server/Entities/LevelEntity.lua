local LevelEntity = {}
LevelEntity.__index = LevelEntity


function LevelEntity.new(Instance: Model)
    local self = setmetatable({}, LevelEntity)
    return self
end

function LevelEntity:Start()

end


function LevelEntity:Destroy()
    
end


return LevelEntity
