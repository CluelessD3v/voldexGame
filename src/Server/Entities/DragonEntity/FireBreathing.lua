--[[
    DragonEntity State: The dragon Instance will start breathing fire for
    N ammount of seconds, after he finishes he will go back to prepare for
    another attack
]]

--# <|=============== SERVICES ===============|>
local RunService   = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

--? <|=============== CONSTRUCTOR ===============|>
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

--+ <|=============== PUBLIC FUNCTIONS ===============|>
function FireBreathing:Start()
    self.Instance.Humanoid.Died:Connect(function()
        self:Exit()
    end) 
    
    local fhb = Instance.new("Part")
    self.Trove:Add(fhb)
    local head = self.Instance.Head
    fhb.Anchored = true
    fhb.Transparency = .75
    fhb.CFrame = head.CFrame:ToWorldSpace(CFrame.new(0, 0, fhb.Size.Z * -.5 +  head.Size.Z * -.5)) 
    fhb.Parent = head
    


    local startedFireBreathing = time()
    local stopFireBreathingAt  = 3



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
