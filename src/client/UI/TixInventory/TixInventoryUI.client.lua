---- Services ----

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TweenButton = require(Modules.TweenButton)
local Upgrades = require(ReplicatedStorage.Data.Upgrades)

---- UI ----

local PlayerGui = Player.PlayerGui
local UI = PlayerGui:WaitForChild("UI")

local TixInventory = UI.TixInventory
local InvHolder = TixInventory.InvFrame.Holder
local EquipFrame = TixInventory.EquipFrame
local IconCopy = InvHolder.IconCopy

---- Sound ----

local ClickSound = Instance.new("Sound")
ClickSound.SoundId = "rbxassetid://177266782"
ClickSound.Parent = TixInventory

---- Private Functions ----

local function updateInventory(upgrade, method)
    if method == "ADD" then
        local icon = IconCopy:Clone()
        icon.Visible = true
        icon.Name = upgrade.Title
        icon.ImageLabel.Image = upgrade.Image
        icon.Parent = InvHolder
    elseif method == "DEL" then
        local icon = InvHolder:FindFirstChild(upgrade.Title)
        if icon then
            icon:Destroy()
        end
    end
end

local function initInventory()
    for _, upgrade in Player.ReplicatedData.Upgrades:GetChildren() do
        updateInventory(Upgrades[upgrade.Name], "ADD")
    end
end

initInventory()

---- Buttons ----

local ExitButton = TixInventory.ExitButton
local EquipButton = EquipFrame.EquipButton

local EXITBUTTON_ORIGINALSIZE = ExitButton.Size
local EQUIPBUTTON_ORIGINALSIZE = EquipButton.Size

local function playClickSound()
    SoundService:PlayLocalSound(ClickSound)
end

local function exitHover()
    TweenButton:Grow(ExitButton, EXITBUTTON_ORIGINALSIZE)
end

local function exitLeave()
    TweenButton:Reset(ExitButton, EXITBUTTON_ORIGINALSIZE)
end

local function exitMouseDown()
    playClickSound()
    TweenButton:Shrink(ExitButton, EXITBUTTON_ORIGINALSIZE)
end

local function exitMouseUp()
    TweenButton:Reset(ExitButton, EXITBUTTON_ORIGINALSIZE)
end

local function equipHover()
    TweenButton:Grow(EquipButton, EQUIPBUTTON_ORIGINALSIZE)
end

local function equipLeave()
    TweenButton:Reset(EquipButton, EQUIPBUTTON_ORIGINALSIZE)
end

local function equipMouseDown()
    playClickSound()
    TweenButton:Shrink(EquipButton, EQUIPBUTTON_ORIGINALSIZE)
end

local function equipMouseUp()
    TweenButton:Reset(EquipButton, EQUIPBUTTON_ORIGINALSIZE)
end

ExitButton.ClickDetector.MouseEnter:Connect(exitHover)
ExitButton.ClickDetector.MouseLeave:Connect(exitLeave)
ExitButton.ClickDetector.MouseButton1Down:Connect(exitMouseDown)
ExitButton.ClickDetector.MouseButton1Up:Connect(exitMouseUp)

EquipButton.ClickDetector.MouseEnter:Connect(equipHover)
EquipButton.ClickDetector.MouseLeave:Connect(equipLeave)
EquipButton.ClickDetector.MouseButton1Down:Connect(equipMouseDown)
EquipButton.ClickDetector.MouseButton1Up:Connect(equipMouseUp)