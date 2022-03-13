local CastingActionOne = {}
CastingActionOne.__index = CastingActionOne


function CastingActionOne.new(controller)
    local self = setmetatable({}, CastingActionOne)
    self.Name = "CastingActionOne"
    self.Controller = controller
    return self
end

function CastingActionOne:Start()
    self.Controller:SwitchState(self.Controller.States.Idle)
end



function CastingActionOne:Exit()
    
end


return CastingActionOne
