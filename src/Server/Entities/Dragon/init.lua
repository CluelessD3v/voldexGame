--[[
    Concrete dragon entity module that handles a dragon mob state life cycle
]]

--# <|=============== SERVICES ===============|>
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")


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
    self.SpawnLocaltion = workspace.Part

    self.States = {
        Idle          = require(script.Idle),
        ChasingPlayer = require(script.ChasingPlayer)
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
