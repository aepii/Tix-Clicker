local StarterGui = game:GetService("StarterGui")
local UIS = StarterGui.UI.ColorThemes

local function applyColorThemeToUI(ui)
    
    local attributes = ui:GetAttributes()

    local affectedUI = StarterGui.UI:FindFirstChild(ui.Name)

    print(affectedUI)
    for attribute, color in attributes do 
        local elements = game:GetService("CollectionService"):GetTagged(attribute)
        for _, element in elements do
            if element:IsDescendantOf(affectedUI) or element == affectedUI then
                if element.Name == "Shadow" then
                    element.UIStroke.Color = color
                end
                element.BackgroundColor3 = color
                print(element)
            end
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