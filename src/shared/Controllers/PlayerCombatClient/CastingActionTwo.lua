local CastingActionTwo = {}
CastingActionTwo.__index = CastingActionTwo


function CastingActionTwo.new()
    local self = setmetatable({}, CastingActionTwo)
    self.Name = "CastingActionTwo"
    return self
end

function CastingActionTwo:Start()
    
end



function CastingActionTwo:Exit()
    
end


return CastingActionTwo
