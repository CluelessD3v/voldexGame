--[[
    Dragon Entity State, in this state the dragon will attempt to go back to its spawn location
    once it reaches the spawn location it will switch back to idle state.

    still, if an instance with a valid tag enters the spawn location detection radius, the dragon
    will start chasing it.

    Note: Even if the dragon does not reach the spawn location, moost likely due to something obstructing it
    it will go back to idle after the Humanoid MoveTo time out ends.

]]

--# <|=============== SERVICES ===============|>
local RunService = game:GetService("RunService")

--? <|=============== CONSTRUCTOR ===============|>s
local Homing = {}
Homing.__index = Homing


function Homing.new(context: table)
    local self = setmetatable({}, Homing)
    
    self.Name = "Homing"
    self.Context = context
    self.Instance = self.Context.Instance
    self.Trove = context.Trove:Extend()

    return self
end


function Homing:Start()
    self.Context.AnimationTrack:Stop()
    local animator = self.Context.Instance.Humanoid.Animator
    self.AnimationTrack = animator:LoadAnimation(self.Context.Animations.Walk)
    self.AnimationTrack:Play()

    --# Poll every frame to see if a valid instance
    --# entered the detection radius, did it entered?
    --# Great! start chasing it, it left? Too bad, go back to spawn.
    
    local dragonHumanoid: Humanoid = self.Context.Instance.Humanoid

    self.Trove:Add(RunService.Heartbeat:Connect(function()


        if self.Context:TaggedInstanceEnteredAgro() then
            self.Context:SwitchState(self.Context.States.ChasingPlayer)
        
        else

            dragonHumanoid:MoveTo(self.Context.SpawnLocation.Position, self.Context.SpawnLocation)

            self.Trove:Add(dragonHumanoid.MoveToFinished:Connect(function(reachedSpawn)
                if reachedSpawn or not reachedSpawn then
                    self.Context:SwitchState(self.Context.States.Idle)
                end
            end))
        end

    end))
end

function Homing:Exit()
    self.Context.AnimationTrack:Stop()
    self.Trove:Clean()
end


return Homing
