local CastingActionTwo = {}
CastingActionTwo.__index = CastingActionTwo


function CastingActionTwo.new(context)
    local self = setmetatable({}, CastingActionTwo)
    self.Name = "CastingActionTwo"
    self.Context = context
    return self
end

function CastingActionTwo:Start()
    self.Context:SwitchState(self.Context.States.Idle)
end



function CastingActionTwo:Exit()
    
end


return CastingActionTwo
