--# <|=============== SERVICES ===============|>
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")

--? <|=============== CONSTRUCTOR ===============|>
local CastingActionOne = {}
CastingActionOne.__index = CastingActionOne


function CastingActionOne.new(context)
    local self = setmetatable({}, CastingActionOne)

    self.Name = "CastingActionOne"
    self.Context = context
    self.Trove = context.Trove:Extend() 
    self.CurrentAnimationTrack = nil
    return self
end

--+ <|=============== PUBLIC FUNCTIONS ===============|>
function CastingActionOne:Start()
    local debounce = false
    self.Context.Sounds.SwordSlash:Play()

    self.Trove:Add(self.Context.EquippedWeapon.Handle.Touched:Connect(function(touchedPart)
        if debounce then 
            return
        end

        debounce = true 

        --# If what we touched has a valid tag, then fire
        --# to the server and substract its health

        for _, validTag in ipairs(self.Context.ValidTargetTags) do
            if CollectionService:HasTag(touchedPart.Parent, validTag) then
                local humanoid = touchedPart.Parent:FindFirstChild("Humanoid")
                if humanoid then
                    self.Context.Sounds.SwordHit:Play()
                    self.Context.DamageMob:FireServer(humanoid.Parent)
                end
            end
        end
    end))

    --# Increase the "Combo Cound" so we can play a
    --# Different animation

    self.Context.ComboCount += 1
    
    if self.Context.ComboCount > #self.Context.AnimationTracks then
        self.Context.ComboCount = 1
    end


    --# Play the current animation track &
    --# wait for it to finish (adjust its speed cause some anims are hella slow)

    self.CurrentAnimationTrack = self.Context.AnimationTracks[self.Context.ComboCount]
    self.CurrentAnimationTrack:Play()
    self.CurrentAnimationTrack:AdjustSpeed(1.8) 
    
    self.CurrentAnimationTrack.Stopped:Wait()
    self.Context:SwitchState(self.Context.States.Idle)
end


function CastingActionOne:Exit()
    print("exited")
    if self.CurrentAnimationTrack then
        self.CurrentAnimationTrack:Stop()
    end
    self.Trove:Clean()
    return
end


return CastingActionOne
