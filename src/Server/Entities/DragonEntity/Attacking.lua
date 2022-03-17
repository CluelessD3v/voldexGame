local Attacking = {}
Attacking.__index = Attacking


function Attacking.new(context: table)
    local self = setmetatable({}, Attacking)

    self.Name = "Attacking"
    self.Context = context
    self.Instance = self.Context.Instance
    self.Trove = context.Trove:Extend()


    return self
end

function Attacking:Start()
    print("entered attack")
    self.Instance.Humanoid:MoveTo(self.Instance.PrimaryPart.Position)
end

function Attacking:Exit()
    self.Trove:Clean()
    return
end


return Attacking
