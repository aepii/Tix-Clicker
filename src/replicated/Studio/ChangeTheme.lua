local StarterGui = game:GetService("StarterGui")
local UIS = StarterGui.UI.ColorThemes



local function applyColorThemeToUI(ui)
    
    local attributes = ui:GetAttributes()

    for attribute, color in attributes do 
        local elements = game:GetService("CollectionService"):GetTagged(attribute)
        for _, element in elements do
            if element.Name == "Shadow" then
                element.UIStroke.Color = color
            end
            element.BackgroundColor3 = color
        end
    end
end

local function apply(UIS)
    for _, ui in UIS:GetChildren() do
        print(_, ui)
        applyColorThemeToUI(ui)
    end
end

apply(UIS)