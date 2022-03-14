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
                local playerCharacter: Model = player.Character

                if playerCharacter then
                    local playerHumanoid: Humanoid = player.Character:FindFirstChild("Humanoid")

                    if playerHumanoid then
                        local playerRootPart: Part     = playerHumanoid.RootPart
                        local dragonRootPart: Part     = self.Context.Instance.PrimaryPart
                        local dragonHumanoid: Humanoid = self.Context.Instance.Humanoid

                        if (playerRootPart.Position - dragonRootPart.Position).Magnitude > self.Context.DetectionAgro then
                            print("He left")
                            self.Context:SwitchState(self.Context.States.Idle)
                        else
                            dragonHumanoid:MoveTo(playerRootPart.Position)
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
