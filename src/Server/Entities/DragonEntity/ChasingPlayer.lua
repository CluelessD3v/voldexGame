--[[
    Dragon Entity State. In this state the dragon attempts to chase an instance with a  valid target tag.

    if the instance leaves the dragon spawn location agro, then it will break chase, switch to homing state
    and attempt to go back to its spawn location.

]]
--# <|=============== SERVICES ===============|>
local RunService = game:GetService("RunService")

--? <|=============== CONSTRUCTOR ===============|>
local ChasingPlayer = {}
ChasingPlayer.__index = ChasingPlayer


function ChasingPlayer.new(context: table)
    local self = setmetatable({}, ChasingPlayer)

    self.Name    = "ChasingPlayer"
    self.Context = context
    self.Instance = self.Context.Instance
    self.Trove   = context.Trove:Extend()

    return self
end

function ChasingPlayer:Start()
    self.Instance.Humanoid.Died:Connect(function()
        self:Exit()
    end)

    self.Context.AnimationTracks.Walk:Play()


    --# Poll every frame to see if a valid instance
    --# is still in the detection radius, still inside agro?
    --# Great! chase it, it left? Too bad, go back to spawn.
    
    local dragonHumanoid = self.Instance.Humanoid

    self.Trove:Add(RunService.Heartbeat:Connect(function()

        if self.Context:TaggedInstanceEnteredAgro() then
            dragonHumanoid:MoveTo(self.Context.CurrentTarget:GetPivot().Position)
        else
            self.Context:SwitchState(self.Context.States.Homing)
        end

        if self.Context.CurrentTarget then
            print(self.Context.CurrentTarget)
            if (self.Instance:GetPivot().Position - self.Context.CurrentTarget:GetPivot().Position).Magnitude <= self.Context.AttackAgro then
                self.Context:SwitchState(self.Context.States.Attacking)
            end
        end
        
    end))
end

function ChasingPlayer:Exit()
    self.Context.AnimationTracks.Walk:Play()
    self.Trove:Clean()    
    return
end


return ChasingPlayer
