--[[
    Handler to automatically bind a component class to an instance when a collection service tag 
    that matches the component module name is present
]]
--# <|=============== Services ===============|>
local CollectionService = game:GetService("CollectionService")

local Components = {
    ComponentModules = {

    }
}

Components.LoadFrom = function(componentsFolder: Folder)
    for _, module in ipairs(componentsFolder:GetChildren()) do
        local compModule: ModuleScript = require(module)
        table.insert(Components.ComponentModules, compModule)
        print(Components.ComponentModules)
    end
end

Components.OnInstanceTaggedInitComponent = function()
    for _, componentModule in ipairs(Components.ComponentModules) do
        CollectionService:GetInstanceAddedSignal(componentModule.Tag):Connect(function(instance)
            local newComponentInstance = componentModule.new(instance)
            newComponentInstance:Init()
        end)
    end
end


return Components 