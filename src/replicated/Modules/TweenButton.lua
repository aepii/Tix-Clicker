local TweenService = game:GetService("TweenService")

local SCALE = 1.1
local TIME = 0.1

local TweenButton = {}

function TweenButton:Reset(button, originalSize)
    if button:IsA("UIScale") then
        local tween = TweenService:Create(button, TweenInfo.new(TIME, Enum.EasingStyle.Bounce), {Scale = originalSize})
        tween:Play()
    else
        button:TweenSize(originalSize, Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, TIME, true)
    end
end

function TweenButton:Grow(button, originalSize)
    if button:IsA("UIScale") then
        local newScaledSize = originalSize * SCALE
        local tween = TweenService:Create(button, TweenInfo.new(TIME, Enum.EasingStyle.Bounce), {Scale = newScaledSize})
        tween:Play()
    else
        local newScaledSize = UDim2.new(
            originalSize.X.Scale * SCALE,
            0,
            originalSize.Y.Scale * SCALE,
            0
        )
        button:TweenSize(newScaledSize, Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, TIME, true)
    end
end

function TweenButton:Shrink(button, originalSize)
    if button:IsA("UIScale") then
        local newScaledSize = originalSize / SCALE
        local tween = TweenService:Create(button, TweenInfo.new(TIME, Enum.EasingStyle.Bounce), {Scale = newScaledSize})
        tween:Play()
    else
        local newScaledSize = UDim2.new(
            originalSize.X.Scale / SCALE,
            0,
            originalSize.Y.Scale / SCALE,
            0
        )
        button:TweenSize(newScaledSize, Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, TIME, true)
    end
end

return TweenButton
