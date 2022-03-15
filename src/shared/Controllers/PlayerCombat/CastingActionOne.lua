local CastingActionOne = {}
CastingActionOne.__index = CastingActionOne


function CastingActionOne.new(context)
    local self = setmetatable({}, CastingActionOne)
    self.Name = "CastingActionOne"
    self.Context = context
    return self
end

function CastingActionOne:Start()
    self.Context.EquippedWeapon.Handle.Touched:Connect(function(theTouchedPart)
        print(theTouchedPart)
    end)
    self.Context:SwitchState(self.Context.States.Idle)
end



function CastingActionOne:Exit()
    return
end


return CastingActionOne
