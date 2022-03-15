--# <|=============== SERVICES ===============|>
local Players = game:GetService("Players")


--? <|=============== CONSTRUCTOR ===============|>
local CastingActionOne = {}
CastingActionOne.__index = CastingActionOne


function CastingActionOne.new(context)
    local self = setmetatable({}, CastingActionOne)

    self.Name = "CastingActionOne"
    self.Context = context
    self.Trove = context.Trove:Extend()

    return self
end

--+ <|=============== PUBLIC FUNCTIONS ===============|>
function CastingActionOne:Start()
    self.Trove:Add(self.Context.EquippedWeapon.Handle.Touched:Connect(function(theTouchedPart)
        print(theTouchedPart)
    end))



    self.Context:SwitchState(self.Context.States.Idle)
end



function CastingActionOne:Exit()
    self.Trove:Clean()
    return
end


return CastingActionOne
