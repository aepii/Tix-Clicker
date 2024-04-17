local Button = script.Parent
local Icon = Button.ImageLabel
local Icon_OriginalSize = Icon.Size
local Icon_Scale = 1.25
local Icon_Time = 0.1

local ClickSound = Button.Parent.Parent.Parent.ClickSound

local Frame = Button.Parent.Parent.Parent.EquipFrame
local InvFrame = Button.Parent.Parent.Parent.InvFrame

local function iconMouseDown()
    ClickSound:Play()
    local newScaledSize = UDim2.new(
        Icon_OriginalSize.X.Scale / Icon_Scale,
        0,
        Icon_OriginalSize.Y.Scale / Icon_Scale,
        0
    )
    Icon:TweenSize(newScaledSize, Enum.EasingDirection.In, Enum.EasingStyle.Quad, Icon_Time, true)
end

local function iconMouseUp()
    Icon:TweenSize(Icon_OriginalSize, Enum.EasingDirection.In, Enum.EasingStyle.Quad, Icon_Time, true)
    Frame:TweenPosition(UDim2.new(0,0,.5,0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, Icon_Time, true)
    InvFrame:TweenPosition(UDim2.new(0.6,0,0.56,0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, Icon_Time, true)
end

local function iconHover()
    local newScaledSize = UDim2.new(
        Icon_OriginalSize.X.Scale * Icon_Scale,
        0,
        Icon_OriginalSize.Y.Scale * Icon_Scale,
        0
    )
    print(newScaledSize)
    Icon:TweenSize(newScaledSize, Enum.EasingDirection.In, Enum.EasingStyle.Quad, Icon_Time, true)
end

local function iconLeave()
    Icon:TweenSize(Icon_OriginalSize, Enum.EasingDirection.In, Enum.EasingStyle.Quad, Icon_Time, true)
end

Button.ClickDetector.MouseEnter:Connect(iconHover)
Button.ClickDetector.MouseLeave:Connect(iconLeave)
Button.ClickDetector.MouseButton1Down:Connect(iconMouseDown)
Button.ClickDetector.MouseButton1Up:Connect(iconMouseUp)