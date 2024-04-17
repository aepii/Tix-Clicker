local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networking = ReplicatedStorage.Networking
local UpdateAccessoriesEvent = Networking.UpdateAccessories

local Accessories = require(ReplicatedStorage.Data.Accessories)

local Player = game.Players.LocalPlayer
local PlayerGui = Player.PlayerGui
local UI = PlayerGui:WaitForChild("UI")
local Frame = UI:WaitForChild("Accessories")

local IconScript = script.Parent.Icon

script.Parent = Frame

local ClickSound = Instance.new("Sound")
ClickSound.Name = "ClickSound"
ClickSound.SoundId = "rbxassetid://8755719003"
ClickSound.Parent = Frame

local ExitButton = script.Parent.ExitButton
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

local EquipAccessoryFunction = Networking.EquipAccessory

local function exitMouseDown()
    ClickSound:Play()
    local newScaledSize = UDim2.new(
        ExitButton_OriginalSize.X.Scale / SCALE,
        0,
        ExitButton_OriginalSize.Y.Scale / SCALE,
        0
    )
    ExitButton:TweenSize(newScaledSize, Enum.EasingDirection.In, Enum.EasingStyle.Quad, TIME, true)
end

local function exitMouseUp()
    ExitButton:TweenSize(ExitButton_OriginalSize, Enum.EasingDirection.In, Enum.EasingStyle.Quad, TIME, true)
    Frame:TweenPosition(UDim2.new(0.5,0,2,0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, TIME, true)
end

local function exitHover()
    local newScaledSize = UDim2.new(
        ExitButton_OriginalSize.X.Scale * SCALE,
        0,
        ExitButton_OriginalSize.Y.Scale * SCALE,
        0
    )
    ExitButton:TweenSize(newScaledSize, Enum.EasingDirection.In, Enum.EasingStyle.Quad, TIME, true)
end

local function exitLeave()
    ExitButton:TweenSize(ExitButton_OriginalSize, Enum.EasingDirection.In, Enum.EasingStyle.Quad, TIME, true)
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
        icon.ImageLabel.Image = "http://www.roblox.com/Thumbs/Asset.ashx?Width=256&Height=256&AssetID="..Accessories[ID].AssetID
        icon.Parent = Holder
    elseif method == "DEL" then
        local icon = Holder:FindFirstChild(GUID)
        if icon then
            icon:Destroy()
        end
    end
end

local function initInventory()
    for _, accessory in Player.ReplicatedData.Accessories:GetChildren() do
        updateInventory(accessory.Value, accessory.Name, "ADD")
    end
end

UpdateAccessoriesEvent.OnClientEvent:Connect(updateInventory)
initInventory()

local function equipAccessory()
    EquipAccessoryFunction:InvokeServer(EquipFrame.CurrentGUID.Value)
end

local function equipMouseDown()
    ClickSound:Play()
    local newScaledSize = UDim2.new(
        EquipButton_OriginalSize.X.Scale / SCALE,
        0,
        EquipButton_OriginalSize.Y.Scale / SCALE,
        0
    )
    EquipButton:TweenSize(newScaledSize, Enum.EasingDirection.In, Enum.EasingStyle.Quad, TIME, true)
end

local function equipMouseUp()
    EquipButton:TweenSize(EquipButton_OriginalSize, Enum.EasingDirection.In, Enum.EasingStyle.Quad, TIME, true)
    equipAccessory()
end

local function equipHover()
    local newScaledSize = UDim2.new(
        EquipButton_OriginalSize.X.Scale * SCALE,
        0,
        EquipButton_OriginalSize.Y.Scale * SCALE,
        0
    )
    EquipButton:TweenSize(newScaledSize, Enum.EasingDirection.In, Enum.EasingStyle.Quad, TIME, true)
end

local function equipLeave()
    EquipButton:TweenSize(EquipButton_OriginalSize, Enum.EasingDirection.In, Enum.EasingStyle.Quad, TIME, true)
end

EquipButton.ClickDetector.MouseEnter:Connect(equipHover)
EquipButton.ClickDetector.MouseLeave:Connect(equipLeave)
EquipButton.ClickDetector.MouseButton1Down:Connect(equipMouseDown)
EquipButton.ClickDetector.MouseButton1Up:Connect(equipMouseUp)
