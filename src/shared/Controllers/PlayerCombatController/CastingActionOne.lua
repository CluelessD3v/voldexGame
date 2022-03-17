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

    self.AnimationTrack = nil
    return self
end

--+ <|=============== PUBLIC FUNCTIONS ===============|>
function CastingActionOne:Start()
    local debounce = false
    self.Trove:Add(self.Context.EquippedWeapon.Handle.Touched:Connect(function(touchedPart)
        if debounce then 
            return
        end

        debounce = true



        for _, validTag in ipairs(self.Context.ValidTargetTags) do
            if CollectionService:HasTag(touchedPart.Parent, validTag) then
                local humanoid = touchedPart.Parent:FindFirstChild("Humanoid")
                if humanoid then
                    self.Context.DamageMob:FireServer(humanoid.Parent)
                end
            end
        end
    end))

    local humanoid = Players.LocalPlayer.Character.Humanoid
    local animator = humanoid.Animator
    local animationsList = self.Context.EquippedWeapon.Animations:GetChildren()

    self.Context.ComboCount += 1
    
    if self.Context.ComboCount > #animationsList then
        self.Context.ComboCount = 1
    end


    self.AnimationTrack = animator:LoadAnimation(animationsList[self.Context.ComboCount])
    self.AnimationTrack:Play()
    self.AnimationTrack:AdjustSpeed(1.8) 
    
    
    self.AnimationTrack.Stopped:Wait()
    self.Context:SwitchState(self.Context.States.Idle)
end


function CastingActionOne:Exit()
    print("exited")
    self.AnimationTrack:Stop()
    self.Trove:Clean()
    return
end


return CastingActionOne
