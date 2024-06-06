---- Services ----

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TweenButton = require(Modules.TweenButton)
local ButtonStatus = require(Modules.ButtonStatus)
local Accessories = require(ReplicatedStorage.Data.Accessories)
local RarityColors = require(Modules.RarityColors)

---- Data ----

local ReplicatedData = Player:WaitForChild("ReplicatedData")
local TemporaryData = Player:WaitForChild("TemporaryData")
local ReplicatedAccessories = ReplicatedData.Accessories
local accessoriesLimit = TemporaryData.AccessoriesLimit

---- UI ----

local PlayerGui = Player.PlayerGui
local UI = PlayerGui:WaitForChild("UI")

local AccessoryInventory = UI.AccessoryInventory
local InvHolder = AccessoryInventory.InvFrame.Holder
local EquipFrame = AccessoryInventory.EquipFrame
local IconCopy = InvHolder.IconCopy

local AccessoriesLimitText = AccessoryInventory.AccessoriesLimit

local IconScript = script.Parent.Icon
IconScript.Name = "IconScript"
IconScript.Parent = IconCopy

---- UI Values ----

local CurrentAccessory = EquipFrame.CurrentAccessory
local UIVisible = UI.UIVisible
local CurrentUI = UI.CurrentUI

---- Sound ----

local Sounds = Player:WaitForChild("Sounds")
local ClickSound = Sounds:WaitForChild("ClickSound")

---- Networking ----

local Networking = ReplicatedStorage.Networking
local EquipAccessoryRemote = Networking.EquipAccessory
local UpdateClientAccessoriesInventoryRemote = Networking.UpdateClientAccessoriesInventory

---- Private Functions ----

local function equipAccessory(accessoryName)
    EquipAccessoryRemote:InvokeServer(accessoryName)
end

local function updateInventory(ID, GUID, method)
    if method == "INIT" then
        for index, icon in InvHolder:GetChildren() do
            print(icon.Name)
            if icon:IsA("Frame") and icon ~= IconCopy then
                icon:Destroy()
            end
        end
        initInventory()
    elseif method == "ADD" then
        local icon = IconCopy:Clone()
        icon.Visible = true
        icon.Name = GUID
        icon.IconImage.Image = "http://www.roblox.com/Thumbs/Asset.ashx?Width=256&Height=256&AssetID="..Accessories[ID].AssetID
        icon.UIGradient.Color = RarityColors:GetGradient(Accessories[ID].Rarity)
        icon.Parent = InvHolder
        icon.IconScript.Enabled = true
    elseif method == "DEL" then
        local icon = InvHolder:FindFirstChild(GUID)
        if icon then
            icon:Destroy()
        end
    end
    AccessoriesLimitText.Text = #ReplicatedAccessories:GetChildren() .. "/" .. accessoriesLimit.Value
end

function initInventory()
    for _, accessory in ReplicatedData.Accessories:GetChildren() do
        updateInventory(accessory.Value, accessory.Name, "ADD")
    end
end

initInventory()

UpdateClientAccessoriesInventoryRemote.OnClientEvent:Connect(function(ID, GUID, method)
    updateInventory(ID, GUID, method)
end)

---- Buttons ----

local ExitButton = AccessoryInventory.ExitButton
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
    AccessoryInventory:TweenPosition(UDim2.new(0.5, 0, 2, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
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
    equipAccessory(CurrentAccessory.Value)
    ButtonStatus:AccessoryInventory(Player, CurrentAccessory.Value, EquipButton)
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