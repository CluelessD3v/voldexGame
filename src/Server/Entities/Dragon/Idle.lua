--# <|=============== SERVICES ===============|>
local RunService = game:GetService("RunService")
local Players    = game:GetService("Players")


--? <|=============== CONSTRUCTOR ===============|>
local Idle = {}
Idle.__index = Idle

function Idle.new(context: table)
    local self = setmetatable({}, Idle)
    
    self.Name    = "Idle"
    self.Context = context
    self.Trove   = context.Trove:Extend()

    return self
end


--+ <|=============== PUBLIC FUNCTIONS ===============|>
function Idle:Start()
    self.Trove:Add(RunService.Heartbeat:Connect(function()
        for _, player in ipairs(Players:GetPlayers()) do
            if #Players:GetPlayers() > 0 then
                local character: Model = player.Character

                if character then
                    local humanoid: Humanoid = player.Character:FindFirstChild("Humanoid")

                    if humanoid then
                        local rootPart: Part       = humanoid.RootPart
                        local dragonRootPart: Part = self.Context.Instance.PrimaryPart

                        if (rootPart.Position - dragonRootPart.Position).Magnitude <= self.Context.DetectionAgro then
                            print("Close")
                            --self.Context:SwitchState(self.Context.States.ChasingPlayer)
                        end
                    end
                end
            end
             
        end
        
    end))
end

function Idle:Exit()
    self.Trove:Clean()    
end


return Idle


