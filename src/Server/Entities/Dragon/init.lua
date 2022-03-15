--[[
    Concrete dragon entity module that handles a dragon mob state life cycle.
    
    To avoid the dragon chasing a player infinitely, the detection is done from
    the spawn location instead of the dragon instance itself, this is simply to avoid
    doing 2 distance checking ops(How far from the player, how far from the  spawn)
    
    DragonEntity type interface:
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
local Dragon = {}
Dragon.__index = Dragon

function Dragon.new(instance: Model, config: table)
    local self = setmetatable({}, Dragon)

    if not config then 
        config = {}
        warn("No config table was passed to", instance.Name, "dragon entity, using default values") 
    end
    self.Trove    = Trove.new()

    self.Instance = instance
    self.StateChanged = Instance.new("BindableEvent")
    
    self.Instance.Humanoid.WalkSpeed = 8

    self.Trove:Add(self.Instance)
    self.Animations = instance.Animations --*//Look into moving this to handler level 
    

    --# Type Interface
    self.DetectionAgro   = config.DetectionAgro or 60
    self.SpawnLocation   = config.SpawnLocation or workspace.Baseplate
    self.ValidTargetTags = config.ValidTargetTags or {"DragonTarget"}

    --# States
    self.States = {
        Idle          = require(script.Idle),
        ChasingPlayer = require(script.ChasingPlayer),
        Homing        = require(script.Homing),
    }

    self.CurrentState = nil
    return self
end

function Dragon:Start()
    self:SwitchState(self.States.Idle)
end

function Dragon:Destroy()
    self.Trove:Clean()
end

--- <|=============== PRIVATE FUNCTIONS ===============|>


--+ <|=============== PUBLIC FUNCTIONS ===============|>
--* Checks if an instance with a valid target tag entered the spawn location detection radius
function Dragon:TaggedInstanceEnteredAgro()
    for _, validTag in ipairs(self.ValidTargetTags) do
        for _, taggedInstance in ipairs(CollectionService:GetTagged(validTag)) do
            local target: Part = taggedInstance

            if (target:GetPivot().Position - self.SpawnLocation.Position).Magnitude <= self.DetectionAgro then
                return true, taggedInstance
            else
                return false
            end
        end
    end
end

--* Switches Dragon concrete states
function Dragon:SwitchState(newState: table)
    --# Does the Current state object exist? Great
    --# transition out of said current state, set 
    --# new state as current & start it, else default to idle

    if self.CurrentState then
        self.CurrentState:Exit()
        self.CurrentState = newState.new(self)
        print(self.CurrentState.Name)
        self.CurrentState:Start()
        return
    end

    self.CurrentState = self.States.Idle.new(self)
    self.CurrentState:Start()

end

return Dragon
