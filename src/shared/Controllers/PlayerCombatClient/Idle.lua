--# <|=============== SERVICES ===============|>
local UserInputService = game:GetService("UserInputService")

local Idle = {}
Idle.__index = Idle


function Idle.new(context: table)
    local self = setmetatable({}, Idle)
    self.Context = context
    self.Name = "Idle"

    self.ActionOneConn = nil
    return self
end

function Idle:Start()
    self.ActionOneConn = UserInputService.InputBegan:Connect(function(io: InputObject, busy: boolean )
        if io.UserInputType == Enum.UserInputType.MouseButton1 and not busy then
            self.Context:SwitchState(self.Context.States.CastingActionOne)
        end
    end)
end

function Idle:Exit()
    self.ActionOneConn:Disconnect()
end


return Idle
