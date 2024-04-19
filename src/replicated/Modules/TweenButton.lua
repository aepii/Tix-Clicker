local SCALE = 1.15
local TIME = 0.1

local TweenButton = {}

function TweenButton:Reset(button, originalSize)
    button:TweenSize(originalSize, Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, TIME, true)
end

function TweenButton:Grow(button, originalSize)
    local newScaledSize = UDim2.new(
        originalSize.X.Scale * SCALE,
        0,
        originalSize.Y.Scale * SCALE,
        0
    )
    button:TweenSize(newScaledSize, Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, TIME, true)
end

function TweenButton:Shrink(button, originalSize)
    local newScaledSize = UDim2.new(
        originalSize.X.Scale / SCALE,
        0,
        originalSize.Y.Scale / SCALE,
        0
    )
    button:TweenSize(newScaledSize, Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, TIME, true)
end

return TweenButton