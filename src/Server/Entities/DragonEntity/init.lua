--[[
    Concrete dragon entity module that handles a dragon mob state life cycle.
    
    To avoid the dragon chasing a player infinitely, the detection is done from
    the spawn location instead of the dragon instance itself, this is simply to avoid
    doing 2 distance checking ops(How far from the player, how far from the  spawn)
    
    Concrecte Dragon interface:
    - Detection Agro: how far the dragon spawn location can detect a player
    - SpawnLocation: The place the dragon would spawn at
    - ValidTargetTags: Tags the dragon will actively look to determine if he should chase an instance
]]

--# <|=============== SERVICES ===============|>
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

--# <|=============== DEPENDENCIES ===============|>
local Trove = require(ReplicatedStorage.Packages.trove)

--? <|=============== CONSTRUCTOR ===============|>
local DragonEntity = {}
DragonEntity.__index = DragonEntity

function DragonEntity.new(instance: Model, dragonObject: table)
    local self = setmetatable({}, DragonEntity)

    if not dragonObject then 
        dragonObject = {}
        warn("No config table was passed to", instance.Name, "dragon entity, using default values") 
    end

    self.Trove    = Trove.new()
    self.Instance = instance

    self.Trove:Add(self.Instance)

    self.Instance.Humanoid.WalkSpeed = 8
    self.Instance.Humanoid.BreakJointsOnDeath = false
    self.Instance.Humanoid.HipHeight = 2.17

    --# DragonEntity class properties
    self.CurrentTarget  = nil
    self.AnimationTracks = nil
    self.AnimationTracks = {}

    local animsFolder = self.Instance.Animations
    local animator = self.Instance.Humanoid.Animator
    for _, animation in pairs (animsFolder:GetChildren()) do
        print(animation)
        self.AnimationTracks[animation.Name] = animator:LoadAnimation(animation)
    end

    print(self.AnimationTracks)
    -- self.Animations = self.Instance.Animations

    

    --# DragonEntity class events
    self.StateChanged        = Instance.new("BindableEvent")
    self.StateChanged.Name   = "StateChanged"
    self.StateChanged.Parent = self.Instance

    
    --# DragonEntity Class Attributes
    self.Instance:SetAttribute("CurrentState", "someState")
    
    --# Mapping Concrete Dragon Object fields to new entity
    self.DetectionAgro   = dragonObject.DetectionAgro or 60
    self.AttackAgro      = dragonObject.AttackAgro or 15
    self.SpawnLocation   = dragonObject.SpawnLocation or workspace.DragonSpawn
    self.ValidTargetTags = dragonObject.ValidTargetTags or {"DragonTarget"}

    --# States
    self.States = {
        Idle            = require(script.Idle),
        ChasingPlayer   = require(script.ChasingPlayer),
        Homing          = require(script.Homing),
        PreparingAttack = require(script.PreparingAttack),
        Dead            = require(script.Dead),
        FireBreathing   = require(script.FireBreathing),
        WingBeating     = require(script.WingBeating),
    }
    self.CurrentState = self.States.Idle.new(self)
    self.PreviousState = nil
    self.Instance.Humanoid.Died:Connect(function()
        self:SwitchState(self.States.Dead)
    end)

    return self
end

function DragonEntity:Start()
    self:SwitchState(self.States.Idle)
end

function DragonEntity:Destroy()
    if self.AnimationTrack then
        self.AnimationTrack:Stop()
    end
    
    self.Trove:Clean()
end

--- <|=============== PRIVATE FUNCTIONS ===============|>
local function CheckIfInstanceIsInsideRadius(origin:PVInstance, instance: PVInstance, radius: number)
    if (origin:GetPivot().Position - instance:GetPivot().Position).Magnitude <= radius then
        return true
    else
        return false
    end
end           

--+ <|=============== PUBLIC FUNCTIONS ===============|>

--* Checks if an instance with a valid target tag entered the spawn location detection radius
function DragonEntity:TaggedInstanceEnteredAgro()
    for _, validTag in ipairs(self.ValidTargetTags) do
        for _, taggedInstance in ipairs(CollectionService:GetTagged(validTag)) do
            print(taggedInstance)
            if CheckIfInstanceIsInsideRadius(self.SpawnLocation, taggedInstance, self.DetectionAgro) then
                self.CurrentTarget = taggedInstance
                return true
            else
                self.CurrentTarget = nil
            end
        end
    end
end

--* Checks if an instance with a valid target tag entered the Dragon attack detection radius
function DragonEntity:TaggedInstanceEnteredAttackAgro()
    for _, validTag in ipairs(self.ValidTargetTags) do
        for _, taggedInstance in ipairs(CollectionService:GetTagged(validTag)) do

            if CheckIfInstanceIsInsideRadius(self.Instance.PrimaryPart, taggedInstance, self.AttackAgro) then
                self.CurrentTarget = taggedInstance
                return true
            else
                self.CurrentTarget = nil
            end
        end
    end
end

--* Switches Dragon concrete states
function DragonEntity:SwitchState(newState: table)
    --# Does the Current state object exist? Great
    --# transition out of said current state, set 
    --# new state as current & start it, else default to idle

    self.CurrentState:Exit()
    self.PreviousState = self.CurrentState
    self.CurrentState = newState.new(self)

    print("Entered", self.CurrentState.Name, "from", self.PreviousState.Name )

    self.Instance:SetAttribute("CurrentState", self.CurrentState.Name)
    self.Instance.StateChanged:Fire(self.CurrentState.Name)

    self.CurrentState:Start()
    return
end

return DragonEntity
