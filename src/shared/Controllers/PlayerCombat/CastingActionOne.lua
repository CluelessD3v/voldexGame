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
    local debounce = false
    self.Trove:Add(self.Context.EquippedWeapon.Handle.Touched:Connect(function(touchedPart)
        if debounce then 
            return
        end

        debounce = true

        --*//TODO look for a way to damage multiple humanoids
        --* probably inserting touched ones to a table and checking if they are there?

        for _, validTag in ipairs(self.Context.ValidTargetTags) do
            if CollectionService:HasTag(touchedPart.Parent, validTag) then
                local humanoid = touchedPart.Parent:FindFirstChild("Humanoid")
                print(humanoid.Parent)
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
