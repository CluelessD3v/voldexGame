local FireBreathing = {}
FireBreathing.__index = FireBreathing


function FireBreathing.new(context: table)
    local self = setmetatable({}, FireBreathing)

    self.Name    = "FireBreathing"
    self.Context = context
    self.Instance = self.Context.Instance
    self.Trove   = context.Trove:Extend()
    
    return self
end

function FireBreathing:Start()
    self.Instance.Humanoid.Died:Connect(function()
        self:Exit()
    end)

end


function FireBreathing:Exit()
    self.Trove:Clean()
end


return FireBreathing
