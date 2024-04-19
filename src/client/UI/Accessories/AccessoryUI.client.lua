local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networking = ReplicatedStorage.Networking
local UpdateAccessoriesEvent = Networking.UpdateAccessories
local EquipAccessoryFunction = Networking.EquipAccessory

local Accessories = require(ReplicatedStorage.Data.Accessories)

local Player = game.Players.LocalPlayer
local PlayerGui = Player.PlayerGui
local UI = PlayerGui:WaitForChild("UI")
local Frame = UI:WaitForChild("Accessories")

local IconScript = script.Parent.Icon
IconScript.Parent = Frame

local ClickSound = Instance.new("Sound")
ClickSound.Name = "ClickSound"
ClickSound.SoundId = "rbxassetid://8755719003"
ClickSound.Parent = Frame

local ExitButton = Frame.ExitButton
local ExitButton_OriginalSize = ExitButton.Size
local SCALE = 1.15
local TIME = 0.1

local InvFrame = Frame.InvFrame
local Holder = InvFrame.Holder
local IconCopy = Holder.IconCopy

IconScript.Parent = IconCopy
IconScript.Enabled = true

local EquipFrame = Frame.EquipFrame
local EquipButton = EquipFrame.EquipButton
local EquipButton_OriginalSize = EquipButton.Size

local function playClickSound()
    ClickSound:Play()
end

local function tweenButtonSize(button, originalSize)
    local newScaledSize = UDim2.new(
        originalSize.X.Scale / SCALE,
        0,
        originalSize.Y.Scale / SCALE,
        0
    )
    button:TweenSize(newScaledSize, Enum.EasingDirection.In, Enum.EasingStyle.Quad, TIME, true)
end

local function resetButtonSize(button, originalSize)
    button:TweenSize(originalSize, Enum.EasingDirection.In, Enum.EasingStyle.Quad, TIME, true)
end

local function exitHover()
    tweenButtonSize(ExitButton, ExitButton_OriginalSize)
end

local function exitLeave()
    resetButtonSize(ExitButton, ExitButton_OriginalSize)
end

local function exitMouseDown()
    playClickSound()
    tweenButtonSize(ExitButton, ExitButton_OriginalSize)
end

local function exitMouseUp()
    resetButtonSize(ExitButton, ExitButton_OriginalSize)
    Frame:TweenPosition(UDim2.new(0.5, 0, 2, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, TIME, true)
end

ExitButton.ClickDetector.MouseEnter:Connect(exitHover)
ExitButton.ClickDetector.MouseLeave:Connect(exitLeave)
ExitButton.ClickDetector.MouseButton1Down:Connect(exitMouseDown)
ExitButton.ClickDetector.MouseButton1Up:Connect(exitMouseUp)

local function updateInventory(ID, GUID, method)
    if method == "ADD" then
        local icon = IconCopy:Clone()
        icon.Visible = true
        icon.Name = GUID
        icon.ImageLabel.Image = "http://www.roblox.com/Thumbs/Asset.ashx?Width=256&Height=256&AssetID=" .. Accessories[ID].AssetID
        icon.Parent = Holder
    elseif method == "DEL" then
        local icon = Holder:FindFirstChild(GUID)
        if icon then
            icon:Destroy()
        end
    end
end

local function initInventory()
    for _, accessory in ipairs(Player.ReplicatedData.Accessories:GetChildren()) do
        updateInventory(accessory.Value, accessory.Name, "ADD")
    end
end

UpdateAccessoriesEvent.OnClientEvent:Connect(updateInventory)
initInventory()

local function equipAccessory()
    EquipAccessoryFunction:InvokeServer(EquipFrame.CurrentGUID.Value)
end

local function setEquipButtonStatus()
    local GUID = EquipFrame.CurrentGUID.Value
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

    EquipButton.EquipText.Text = equipText
    EquipButton.BackgroundColor3 = backgroundColor
    EquipButton.Shadow.BackgroundColor3 = shadowColor
    EquipButton.EquipText.UIStroke.Color = strokeColor
end

local function equipButtonInteraction(isMouseDown)
    playClickSound()
    if isMouseDown then
        tweenButtonSize(EquipButton, EquipButton_OriginalSize)
    else
        equipAccessory()
        setEquipButtonStatus()
        resetButtonSize(EquipButton, EquipButton_OriginalSize)
    end
end

EquipButton.ClickDetector.MouseEnter:Connect(function()
    tweenButtonSize(EquipButton, EquipButton_OriginalSize)
end)

EquipButton.ClickDetector.MouseLeave:Connect(function()
    resetButtonSize(EquipButton, EquipButton_OriginalSize)
end)

EquipButton.ClickDetector.MouseButton1Down:Connect(function()
    equipButtonInteraction(true)
end)

EquipButton.ClickDetector.MouseButton1Up:Connect(function()
    equipButtonInteraction(false)
end)
