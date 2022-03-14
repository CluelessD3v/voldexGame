--[[
    Concrete dragon entity module that handles a dragon mob state life cycle.
]]

--# <|=============== SERVICES ===============|>
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

--# <|=============== DEPENDENCIES ===============|>
local Trove = require(ReplicatedStorage.Packages.trove)

--? <|=============== CONSTRUCTOR ===============|>
local Dragon = {}
Dragon.__index = Dragon

function Dragon.new(instance: Model)
    local self = setmetatable({}, Dragon)
    
    self.Instance = instance
    self.Trove    = Trove.new()
    
    self.DetectionAgro = 60
    self.SpawnLocation = workspace.Part

    self.ValidTargetTags = {
        "DragonTarget"
    }

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
