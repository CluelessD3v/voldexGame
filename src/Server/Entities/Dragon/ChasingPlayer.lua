--# <|=============== SERVICES ===============|>
local RunService = game:GetService("RunService")
local Players    = game:GetService("Players")

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
        for _, player in ipairs(Players:GetPlayers()) do
            if #Players:GetPlayers() > 0 then
                local character: Model = player.Character

                if character then
                    local humanoid: Humanoid = player.Character:FindFirstChild("Humanoid")

                    if humanoid then
                        local rootPart: Part       = humanoid.RootPart
                        local dragonRootPart: Part = self.Context.Instance.PrimaryPart

                        if (rootPart.Position - dragonRootPart.Position).Magnitude > self.Context.DetectionAgro then
                            print("He left")
                            self.Context:SwitchState(self.Context.States.Idle)
                        end
                    end
                end
            end
        end
        
    end))
end

function ChasingPlayer:Exit()
    self.Trove:Clean()    
    return
end


return ChasingPlayer
