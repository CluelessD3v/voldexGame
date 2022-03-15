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

    return self
end

--+ <|=============== PUBLIC FUNCTIONS ===============|>
function CastingActionOne:Start()
    self.Trove:Add(self.Context.EquippedWeapon.Handle.Touched:Connect(function(theTouchedPart)
        if CollectionService:HasTag(theTouchedPart.Parent, "Dragon") then
            local humanoid = theTouchedPart.Parent:FindFirstChild("Humanoid")

            if humanoid then
                print(humanoid)
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


    local animationTrack: AnimationTrack = animator:LoadAnimation(animationsList[self.Context.ComboCount])
    animationTrack:Play()
    --*//TODO do a speed adjustment to make animations more responsive, in fact, look into speeding them realtive to combo count
    
    
    animationTrack.Stopped:Wait()
    self.Context:SwitchState(self.Context.States.Idle)
end



function CastingActionOne:Exit()
    self.Trove:Clean()
    return
end


return CastingActionOne
