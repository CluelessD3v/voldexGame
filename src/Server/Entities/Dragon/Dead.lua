local Dead = {}
Dead.__index = Dead


function Dead.new(context: table)
    local self = setmetatable({}, Dead)

    self.Name = "Dead"
    self.Context = context
    self.Trove = self.Context.Trove:Extend()
    
    return self
end

function Dead:Start()

end

function Dead:Exit()
    self.Trove:Clean()
end


return Dead
