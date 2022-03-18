local WingBeating = {}
WingBeating.__index = WingBeating

function WingBeating.new(context: table)
    local self = setmetatable({}, WingBeating)

    self.Name    = "WingBeating"
    self.Context = context
    self.Instance = self.Context.Instance
    self.Trove   = context.Trove:Extend()

    return self
end

function WingBeating:Start()

end



function WingBeating:Exit()
    self.Trove:Clean()
end


return WingBeating
