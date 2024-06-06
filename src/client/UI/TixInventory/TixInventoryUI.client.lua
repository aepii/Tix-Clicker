---- Services ----

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TweenButton = require(Modules.TweenButton)
local ButtonStatus = require(Modules.ButtonStatus)
local Upgrades = require(ReplicatedStorage.Data.Upgrades)

---- Data ----

local ReplicatedData = Player:WaitForChild("ReplicatedData")

---- UI ----

local PlayerGui = Player.PlayerGui
local UI = PlayerGui:WaitForChild("UI")

local TixInventory = UI.TixInventory
local InvHolder = TixInventory.InvFrame.Holder
local EquipFrame = TixInventory.EquipFrame
local IconCopy = InvHolder.IconCopy

local IconScript = script.Parent.Icon
IconScript.Parent = IconCopy
IconScript.Enabled = true

---- UI Values ----

local CurrentUpgrade = EquipFrame.CurrentUpgrade
local UIVisible = UI.UIVisible
local CurrentUI = UI.CurrentUI

---- Sound ----

local Sounds = Player:WaitForChild("Sounds")
local ClickSound = Sounds:WaitForChild("ClickSound")

---- Networking ----

local Networking = ReplicatedStorage.Networking
local EquipTixRemote = Networking.EquipTix
local UpdateClientInventoryRemote = Networking.UpdateClientInventory

---- Private Functions ----

local function equipTix(upgradeID)
    EquipTixRemote:InvokeServer(upgradeID)
end

local function updateInventory(upgrade, method)
    if method == "INIT" then
        print("HELLO ITTNIT TIX")
        for index, icon in InvHolder:GetChildren() do
            if icon:IsA("Frame") and icon ~= IconCopy then
                icon:Destroy()
            end
        end
        print("HELLO INIT TIX")
        initInventory()
    elseif method == "ADD" then
        local icon = IconCopy:Clone()
        icon.Visible = true
        icon.Name = upgrade.ID
        icon.IconImage.Image = upgrade.Image
        icon.Parent = InvHolder
    elseif method == "DEL" then
        local icon = InvHolder:FindFirstChild(upgrade.ID)
        if icon then
            icon:Destroy()
        end
    end
end

function initInventory()
    for _, upgrade in ReplicatedData.Upgrades:GetChildren() do
        print(upgrade, "INITIALIZEEEE")
        updateInventory(Upgrades[upgrade.Name], "ADD")
    end
end

initInventory()

UpdateClientInventoryRemote.OnClientEvent:Connect(function(upgrade, method)
    updateInventory(upgrade, method)
end)

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
    TixInventory:TweenPosition(UDim2.new(0.5, 0, 2, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
    CurrentUI.Value = ""
    UIVisible.Value = false
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
    equipTix(CurrentUpgrade.Value)
    ButtonStatus:TixInventory(Player, CurrentUpgrade.Value, EquipButton)
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