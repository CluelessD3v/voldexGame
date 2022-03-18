--# <|=============== SERVICES ===============|>
local RunService = game:GetService("RunService")

local FireBreathing = {}
FireBreathing.__index = FireBreathing


function FireBreathing.new(context: table)
    local self = setmetatable({}, FireBreathing)

    self.Name    = "FireBreathing"
    self.Context = context
    self.Instance = self.Context.Instance
    self.Trove   = context.Trove:Extend()
    
    return self
end

function FireBreathing:Start()
    self.Instance.Humanoid.Died:Connect(function()
        self:Exit()
    end) 

    local startedFireBreathing = time()
    local stopFireBreathingAt = 3

    self.Context.AnimationTracks.FireBreath:Play()

    self.Trove:Add(RunService.Heartbeat:Connect(function()
        if (time() - startedFireBreathing) >=stopFireBreathingAt then
            self.Context:SwitchState(self.Context.States.PreparingAttack)
        end
    
    end))
end


function FireBreathing:Exit()
    self.Context.AnimationTracks.FireBreath:stop()
    self.Trove:Clean()
end


return FireBreathing
