--[[
    Dragon entity base state, here the dragon will simply stay in his Spawn location and wait
    for an instance with a valid target tag to enter the detection radius.
]]--

--# <|=============== SERVICES ===============|>
local RunService = game:GetService("RunService")

--? <|=============== CONSTRUCTOR ===============|>
local Idle = {}
Idle.__index = Idle

function Idle.new(context: table)
    local self = setmetatable({}, Idle)
    
    self.Name    = "Idle"
    self.Context = context
    self.Trove   = context.Trove:Extend()

    return self
end


--+ <|=============== PUBLIC FUNCTIONS ===============|>

function Idle:Start()
    --# Poll every frame to see if a valid instance
    --# Entered the detection radius, did it entered?
    --# Great! Then start chasing it.

    self.Trove:Add(RunService.Heartbeat:Connect(function()
        if self.Context:TaggedInstanceEnteredAgro() then
            self.Context:SwitchState(self.Context.States.ChasingPlayer)
        end
        
    end))
end

function Idle:Exit()
    self.Trove:Clean()
    return    
end


return Idle


