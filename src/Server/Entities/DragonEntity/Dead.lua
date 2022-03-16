--# <|=============== SERVICES ===============|>
local TweenService = game:GetService("TweenService")

--? <|=============== CONSTRUCTOR ===============|>
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
            local tweenInfo = TweenInfo.new(
                1.5,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.Out,
                0,
                false,
                0 
            )

            local transparencyTween: Tween = TweenService:Create(child, tweenInfo, {Transparency = 1})
            transparencyTween:Play()
            
            task.delay(3, function()
                self.Context:Destroy()
            end)
        end
    end

end

function Dead:Exit()
    self.Trove:Clean()
end


return Dead
