--# <|=============== SERVICES ===============|>
local RunService = game:GetService("RunService")


local PreparingAttack = {}
PreparingAttack.__index = PreparingAttack


function PreparingAttack.new(context: table)
    local self = setmetatable({}, PreparingAttack)

    self.Name = "PreparingAttack"
    self.Context = context
    self.Instance = self.Context.Instance
    self.Trove = context.Trove:Extend()


    return self
end

function PreparingAttack:Start()
    self.Instance.Humanoid.Died:Connect(function()
        self:Exit()
    end)
    
    self.Context.AnimationTracks.WingBeat:Play()
    self.Context.AnimationTracks.WingBeat.Stopped:Wait()
    

    self.Context:SwitchState(self.Context.States.ChasingPlayer)
    
end

function PreparingAttack:Exit()
    self.Context.AnimationTracks.WingBeat:Stop()
    self.Trove:Clean()
    return
end


return PreparingAttack
