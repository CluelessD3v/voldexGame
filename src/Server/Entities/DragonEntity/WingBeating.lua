--[[
    DragonEntity State: The dragon will beat his wings and attack his target
]]

--# <|=============== SERVICES ===============|>
local CollectionService = game:GetService("CollectionService")

--? <|=============== CONSTRUCTOR ===============|>
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

--+ <|=============== PUBLIC FUNCTIONS ===============|>
function WingBeating:Start()
    self.Instance.Humanoid.Died:Connect(function()
        self:Exit()
    end)
    
    local debounce = false
    
    for _, v in pairs(self.Context.WingBeatingHitboxes) do
        self.Trove:Add(v.Touched:Connect(function(theTouchedPart)
            
            for _, validTag in ipairs(self.Context.ValidTargetTags) do
                if CollectionService:HasTag(theTouchedPart.Parent , validTag) and not debounce  then
                    debounce = true
                    local humanoid: Humanoid = theTouchedPart.Parent:FindFirstChild("Humanoid")

                    if humanoid then
                        humanoid:TakeDamage(20)
                    end
                end
            end
        end))
    end


    self.Context.AnimationTracks.WingBeat:Play()
    self.Context.AnimationTracks.WingBeat.Stopped:Wait()

    self.Context:SwitchState(self.Context.States.PreparingAttack)
end

function WingBeating:Exit()
    self.Context.AnimationTracks.WingBeat:Stop()
    self.Trove:Clean()
end


return WingBeating
