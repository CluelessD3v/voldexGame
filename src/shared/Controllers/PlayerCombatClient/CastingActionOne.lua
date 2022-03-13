local CastingActionOne = {}
CastingActionOne.__index = CastingActionOne


function CastingActionOne.new()
    local self = setmetatable({}, CastingActionOne)
    self.Name = "CastingActionOne"

    return self
end

function CastingActionOne:Start()
    
end



function CastingActionOne:Exit()
    
end


return CastingActionOne
