--# <|=============== SERVICES ===============|>
local RunService = game:GetService("RunService")

--? <|=============== CONSTRUCTOR ===============|>s
local Homing = {}
Homing.__index = Homing


function Homing.new(context: table)
    local self = setmetatable({}, Homing)
    
    self.Name = "Homing"
    self.Context = context
    self.Trove = context.Trove:Extend()

    return self
end


function Homing:Start()
    local dragonHumanoid: Humanoid = self.Context.Instance.Humanoid

    self.Trove:Add(RunService.Heartbeat:Connect(function()

        local didEnter, taggedInstance =  self.Context:TaggedInstanceEnteredAgro()

        if didEnter then
            print(taggedInstance, "Detected, chasing")
            self.Context:SwitchState(self.Context.States.ChasingPlayer)
            
        else
            dragonHumanoid:MoveTo(self.Context.SpawnLocation.Position, self.Context.SpawnLocation)
           
            dragonHumanoid.MoveToFinished:Connect(function(reachedSpawn)
                if reachedSpawn or not reachedSpawn then
                    self.Context:SwitchState(self.Context.States.Idle)
                end
            end)
        end

    end))
end

function Homing:Exit()
    self.Trove:Clean()
end


return Homing
