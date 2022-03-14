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
    print("inside")
    self.Trove:Add(RunService.Heartbeat:Connect(function()
        local didEnter, taggedInstance =  self.Context:TaggedInstanceEnteredAgro()
        if didEnter then
            local dragonHumanoid = self.Context.Instance.Humanoid
            dragonHumanoid:MoveTo(taggedInstance:GetPivot().Position)
        else
            print("He left")
            self.Context:SwitchState(self.Context.States.Homing)
        end
        
    end))
end

function ChasingPlayer:Exit()
    self.Trove:Clean()    
    return
end


return ChasingPlayer
