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
    for _, child in ipairs(self.Context.Instance:GetChildren()) do
        if child:IsA("Part") or child:IsA("MeshPart") then
            child.Anchored = true
        end
    end

end

function Dead:Exit()
    self.Trove:Clean()
end


return Dead
