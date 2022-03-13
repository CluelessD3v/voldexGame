
--# <|=============== SERVICES ===============|>
local UserInputService = game:GetService("UserInputService")

local Idle = {}
Idle.__index = Idle


function Idle.new(controller: table)
    local self = setmetatable({}, Idle)
    self.Controller = controller
    self.Name = "Idle"
    self.Connections = {}
    return self
end

function Idle:Start()
     table.insert(self.Connections, UserInputService.InputBegan:Connect(function(io: InputObject, busy: boolean )
        if io.UserInputType == Enum.UserInputType.MouseButton1 and not busy then
            self.Controller:SwitchState(self.Controller.States.CastingActionOne)
        end
    end))
end

function Idle:Exit()
    for _, conn: RBXScriptSignal in ipairs(self.Connections) do
        print("in")
        conn:Disconnect()
    end
end


return Idle
