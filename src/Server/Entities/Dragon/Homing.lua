--# <|=============== SERVICES ===============|>
local RunService = game:GetService("RunService")
local Players    = game:GetService("Players")


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

                        if (playerRootPart.Position - dragonRootPart.Position).Magnitude <= self.Context.DetectionAgro then
                            print("He entered again")
                            self.Context:SwitchState(self.Context.States.ChasingPlayer)
                        else

                            print("welp, guess i am going home")
                            dragonHumanoid:MoveTo(self.Context.SpawnLocation.Position, self.Context.SpawnLocation)
                            dragonHumanoid.MoveToFinished:Connect(function(reachedSpawn)
                                
                                if reachedSpawn or not reachedSpawn then
                                    self.Context:SwitchState(self.Context.States.Idle)
                                end
                                
                            end)
                        end
                    end
                end
            end
        end
        
    end))
end

function Homing:Exit()
    self.Trove:Clean()
end


return Homing
