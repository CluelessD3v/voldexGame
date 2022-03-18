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
    
    self.Context.AnimationTracks.WingBeat:Play()
    self.Context.AnimationTracks.WingBeat.Stopped:Wait()
    self.Context:SwitchState(self.Context.States.ChasingPlayer)
    
end

function Attacking:Exit()
    self.Context.AnimationTracks.WingBeat:Stop()
    self.Trove:Clean()
    return
end


return Attacking
