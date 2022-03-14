--# <|=============== SERVICES ===============|>
local RunService = game:GetService("RunService")

--? <|=============== CONSTRUCTOR ===============|>
local Idle = {}
Idle.__index = Idle

function Idle.new(context: table)
    local self = setmetatable({}, Idle)
    
    self.Name    = "Idle"
    self.Context = context
    self.Trove   = context.Trove:Extend()

    return self
end


--+ <|=============== PUBLIC FUNCTIONS ===============|>
function Idle:Start()
    self.Trove:Add(RunService.Heartbeat:Connect(function()
        if self.Context:TaggedInstanceEnteredAgro() then
            print("Close")
            self.Context:SwitchState(self.Context.States.ChasingPlayer)
        end
        
    end))
end

function Idle:Exit()
    self.Trove:Clean()
    return    
end


return Idle


