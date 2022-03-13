local Idle = {}
Idle.__index = Idle


function Idle.new(controller: table)
    local self = setmetatable({}, Idle)
    self.Controller = controller
    self.Name = "Idle"
    return self
end

function Idle:Start()

end



function Idle:Exit()
    
end


return Idle
