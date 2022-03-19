--[[
    DragonEntity state: The dragon found a target within his attack agro
    he will take a momment to allow targets to react, and to "decide"
    which attack to use against the target.

    If the target leaves the attack agro the dragon will attempt to give chase

]]
--# <|=============== SERVICES ===============|>
local RunService = game:GetService("RunService")

--? <|=============== CONSTRUCTOR ===============|>
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

--+ <|=============== PUBLIC FUNCTIONS ===============|>
function PreparingAttack:Start()
    self.Instance.Humanoid.Died:Connect(function()
        self:Exit()
    end)

    print("entered attack")

    self.Context.AnimationTracks.Idle:Play()
    self.Context.AnimationTracks.Idle:AdjustSpeed(2.5)

    self.Instance.Humanoid:MoveTo(self.Instance.PrimaryPart:GetPivot().Position)
    
    local n = math.random(1, 2)
    local prepareTime = 2.5
    local startedPreparing = time()


    self.Trove:Add(RunService.Heartbeat:Connect(function()
        if (time() - startedPreparing) >= prepareTime then
            if not self.Context:TaggedInstanceEnteredAttackAgro() then
                self.Context:SwitchState(self.Context.States.ChasingPlayer)
            else
                if n == 1 then
                    self.Context:SwitchState(self.Context.States.WingBeating)
                else
                    self.Context:SwitchState(self.Context.States.FireBreathing)
                end
            end
        end
    end))
end

function PreparingAttack:Exit()
    self.Context.AnimationTracks.Idle:Stop()

    self.Trove:Clean()
    return
end


return PreparingAttack
