local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Accessories = require(ReplicatedStorage.Data.Accessories)
local Player = game.Players.LocalPlayer

local Modules = ReplicatedStorage:WaitForChild("Modules")
local SuffixHandler = require(Modules.SuffixHandler)

local Button = script.Parent
local Icon = Button.ImageLabel
local Icon_OriginalSize = Icon.Size
local Icon_Scale = 1.25
local Icon_Time = 0.1

local ClickSound = Button.Parent.Parent.Parent.ClickSound

local Frame = Button.Parent.Parent.Parent.EquipFrame
local InvFrame = Button.Parent.Parent.Parent.InvFrame
local EquipButton = Frame.EquipButton

local function setEquipButtonStatus()
    local GUID = Frame.CurrentGUID.Value
    local ID = Player.ReplicatedData.Accessories[GUID].Value
    local accessory = Player.ReplicatedData.EquippedAccessories:FindFirstChild(ID)
    local equipText, backgroundColor, shadowColor, strokeColor

    if accessory then
        if accessory.Value == GUID then
            equipText = "Unequip"
            backgroundColor = Color3.fromRGB(170, 85, 89)
            shadowColor = Color3.fromRGB(102, 63, 64)
            strokeColor = Color3.fromRGB(102, 63, 64)
        else
            equipText = "Unavailable"
            backgroundColor = Color3.fromRGB(82, 81, 81)
            shadowColor = Color3.fromRGB(36, 35, 35)
            strokeColor = Color3.fromRGB(36, 35, 35)
        end
    else
        equipText = "Equip"
        backgroundColor = Color3.fromRGB(85, 170, 127)
        shadowColor = Color3.fromRGB(34, 68, 50)
        strokeColor = Color3.fromRGB(34, 68, 50)
    end

    Frame.EquipButton.EquipText.Text = equipText
    Frame.EquipButton.BackgroundColor3 = backgroundColor
    Frame.EquipButton.Shadow.BackgroundColor3 = shadowColor
    Frame.EquipButton.EquipText.UIStroke.Color = strokeColor
end

local function updateEquipFrame()
    local GUID = script.Parent.Name
    local ID = Player.ReplicatedData.Accessories[GUID].Value
    local accessory = Accessories[ID]
    
    if InvFrame.Holder:FindFirstChild(Frame.CurrentGUID.Value) then
        InvFrame.Holder[Frame.CurrentGUID.Value].Shadow.BackgroundColor3 = Color3.fromRGB(0, 83, 125)
    end

    for _, rewardFrame in ipairs(Frame.RewardsFrame:GetChildren()) do
        if rewardFrame:IsA("Frame") then
            local reward = accessory.Reward[rewardFrame.Name]
            if reward then
                local prefix = string.find(rewardFrame.Name, "Add") and "+" or "x"
                Frame.CurrentGUID.Value = GUID
                InvFrame.Holder[GUID].Shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                rewardFrame.RewardText.Text = prefix .. SuffixHandler:Convert(reward)
                rewardFrame.Visible = true
                rewardFrame.Parent = Frame.RewardsFrame
            else
                rewardFrame.Visible = false
            end
        end
    end

    setEquipButtonStatus()

    Frame.ItemName.Title.Text = accessory.Name
    Frame.Icon.ImageLabel.Image = "http://www.roblox.com/Thumbs/Asset.ashx?Width=256&Height=256&AssetID="..accessory.AssetID
end

local function iconTweenSize(scale)
    local newScaledSize = UDim2.new(
        Icon_OriginalSize.X.Scale * scale,
        0,
        Icon_OriginalSize.Y.Scale * scale,
        0
    )
    Icon:TweenSize(newScaledSize, Enum.EasingDirection.In, Enum.EasingStyle.Quad, Icon_Time, true)
end

local function iconMouseDown()
    ClickSound:Play()
    iconTweenSize(1 / Icon_Scale)
end

local function iconMouseUp()
    Icon:TweenSize(Icon_OriginalSize, Enum.EasingDirection.In, Enum.EasingStyle.Quad, Icon_Time, true)
    Frame:TweenPosition(UDim2.new(0,0,.5,0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, Icon_Time, true)
    InvFrame:TweenPosition(UDim2.new(0.6,0,0.56,0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, Icon_Time, true)
    updateEquipFrame()
end

Button.MouseEnter:Connect(function()
    iconTweenSize(Icon_Scale)
end)

Button.MouseLeave:Connect(function()
    Icon:TweenSize(Icon_OriginalSize, Enum.EasingDirection.In, Enum.EasingStyle.Quad, Icon_Time, true)
end)

Button.ClickDetector.MouseButton1Down:Connect(iconMouseDown)
Button.ClickDetector.MouseButton1Up:Connect(iconMouseUp)
