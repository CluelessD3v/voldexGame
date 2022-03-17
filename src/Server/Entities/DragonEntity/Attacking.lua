local Attacking = {}
Attacking.__index = Attacking


function Attacking.new(context: table)
    local self = setmetatable({}, Attacking)

    self.Name = "Attacking"
    self.Context = context
    self.Instance = self.Context.Instance
    self.Trove = context.Trove:Extend()


    return self
end

function Attacking:Start()
    self.Instance.Humanoid.Died:Connect(function()
        self:Exit()
    end)

    print("entered attack from", self.Context.PreviousState.Name)

    local animator = self.Instance.Humanoid.Animator
    self.AnimationTrack = animator:LoadAnimation(self.Context.Animations.WingBeat)
    self.AnimationTrack:Play()

    self.AnimationTrack.Stopped:Wait()

    self.Context:SwitchState(self.Context.States.ChasingPlayer)
    
end

function Attacking:Exit()
    self.AnimationTrack:Stop()
    self.Trove:Clean()
    return
end


return Attacking
