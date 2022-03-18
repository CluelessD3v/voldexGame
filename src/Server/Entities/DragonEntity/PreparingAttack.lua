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

    print("entered attack")

    self.Context.AnimationTracks.Idle:Play()
    self.Context.AnimationTracks.Idle:AdjustSpeed(4)

    self.Instance.Humanoid:MoveTo(self.Instance.PrimaryPart:GetPivot().Position)

    task.wait(5)

    self.Context:SwitchState(self.Context.States.ChasingPlayer)
    
end

function PreparingAttack:Exit()
    self.Context.AnimationTracks.Idle:Stop()

    self.Trove:Clean()
    return
end


return PreparingAttack