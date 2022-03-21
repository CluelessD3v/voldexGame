--# <|=============== SERVICES ===============|>
local UserInputService = game:GetService("UserInputService")

--? <|=============== CONSTRUCTOR ===============|>
local Idle = {}
Idle.__index = Idle


function Idle.new(context: table)
    local self = setmetatable({}, Idle)
    self.Context = context
    self.Name = "Idle"
    self.Trove = context.Trove:Extend() --# Constructs a new trove inside the context trove

    return self
end

function Idle:Start()

    --# ActionOne input listener
    self.Trove:Add(UserInputService.InputBegan:Connect(function(io: InputObject, busy: boolean )
        if io.UserInputType == Enum.UserInputType.MouseButton1 and not busy then
            self.Context:SwitchState(self.Context.States.CastingActionOne)
        end
    end))

end

function Idle:Exit()
    self.Trove:Clean()
end


return Idle
