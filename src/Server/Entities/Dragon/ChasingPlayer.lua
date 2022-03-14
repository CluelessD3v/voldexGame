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
    self.Trove   = context.Trove:Extend()

    return self
end

function ChasingPlayer:Start()

    --# Poll every frame to see if a valid instance
    --# is still in the detection radius, still inside agro?
    --# Great! chase it, it left? Too bad, go back to spawn.
    
    local dragonHumanoid = self.Context.Instance.Humanoid

    self.Trove:Add(RunService.Heartbeat:Connect(function()
        local didEnter, taggedInstance =  self.Context:TaggedInstanceEnteredAgro()
        if didEnter then
            dragonHumanoid:MoveTo(taggedInstance:GetPivot().Position)
        else
            self.Context:SwitchState(self.Context.States.Homing)
        end
        
    end))
end

function ChasingPlayer:Exit()
    self.Trove:Clean()    
    return
end


return ChasingPlayer