--[[
    DragonEntity State: The dragon Instance will start breathing fire for
    N ammount of seconds, after he finishes he will go back to prepare for
    another attack
]]

--# <|=============== SERVICES ===============|>
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")


--? <|=============== CONSTRUCTOR ===============|>
local FireBreathing = {}
FireBreathing.__index = FireBreathing


function FireBreathing.new(context: table)
    local self = setmetatable({}, FireBreathing)

    self.Name    = "FireBreathing"
    self.Context = context
    self.Instance = self.Context.Instance
    self.Trove   = context.Trove:Extend()

    self.ParticleEmmiter = self.Instance.Head.ParticleEmitter
    
    return self
end

--+ <|=============== PUBLIC FUNCTIONS ===============|>
function FireBreathing:Start()
    self.Instance.Humanoid.Died:Connect(function()
        self:Exit()
    end) 
    
    local fireHitbox = Instance.new("Part")
    self.Trove:Add(fireHitbox)

    --# The hitbox of the fire ability of the dragon
    fireHitbox.Anchored     = true
    fireHitbox.Transparency = .5
    fireHitbox.Size         = Vector3.new(5,5,5)
    fireHitbox.CanCollide   = false

    --# Slight rotatiom so the hitbox does not look upward, but rather straight 
    fireHitbox.CFrame       = self.Instance.Head.CFrame:ToWorldSpace(CFrame.new(0, 0, fireHitbox.Size.Z * -.5 +  self.Instance.Head.Size.Z * -.5) * CFrame.Angles(math.rad(7), 0, 0))
    fireHitbox.Parent       = self.Instance.Head

    --#  Listen if the Fire touched a valid dragon target
    --# Due to the nature of fire damage this is not debounced &
    self.Trove:Add(fireHitbox.Touched:Connect(function(theTouchedPart) 
        for _, validTag in ipairs(self.Context.ValidTargetTags) do
            
            if CollectionService:HasTag(theTouchedPart.Parent , validTag) then
            print(theTouchedPart)

                local humanoid: Humanoid = theTouchedPart.Parent:FindFirstChild("Humanoid")

                if humanoid then
                    humanoid:TakeDamage(.3)
                end
            end
        end
    end))


    local fireParticleEmmiterHolder = Instance.new("Part")
    self.Trove:Add(fireParticleEmmiterHolder)

    --# A part to hold the fire particle emmiter is being used because an attachment was not positioning itself correctly
    fireParticleEmmiterHolder.Anchored     = true
    fireParticleEmmiterHolder.Transparency = .5
    fireParticleEmmiterHolder.Size         = Vector3.new(1,1,1)
    fireParticleEmmiterHolder.CanCollide   = false
    fireParticleEmmiterHolder.CFrame       = self.Instance.Head.CFrame + self.Instance.Head.CFrame.LookVector * self.Instance.Head.Size.Z * 0.5
    fireParticleEmmiterHolder.Parent       = self.Instance.Head


    --# Parent the Particle emmiter to the holder
    --# so the rotation of the head does not affect
    --# particles direction

    self.ParticleEmmiter.Parent = fireParticleEmmiterHolder
    self.ParticleEmmiter.Enabled = true



    --# Tween to move and resize the fire hitbox
    --# This is done to simulate resizing so the 
    --# hitbox instead of going through the dragon the body
    --# it is always keeping itself in front of itself


    local maxSize = 30 --# Max size in studs the hitbox will resize infront of the dragon

    local info = TweenInfo.new(
	1.5,
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.Out,
	0,
	false,
	0)
    local goals = {
        CFrame = fireHitbox.CFrame * CFrame.new(0,0, maxSize/-2),
        Size = fireHitbox.Size + Vector3.new(0, 0, maxSize)
    }

    local tween = TweenService:Create(fireHitbox, info, goals)
    tween:Play()

    local startedFireBreathing = time()
    local stopFireBreathingAt  = 2.5

    
    self.Context.AnimationTracks.FireBreath:Play()

    self.Trove:Add(RunService.Heartbeat:Connect(function()
        if (time() - startedFireBreathing) >=stopFireBreathingAt then
            self.Context:SwitchState(self.Context.States.PreparingAttack)
        end
    
    end))
end


function FireBreathing:Exit()
    self.ParticleEmmiter.Enabled = false
    self.ParticleEmmiter.Parent = self.Instance.Head
    self.Context.AnimationTracks.FireBreath:stop()
    self.Trove:Clean()
end


return FireBreathing
