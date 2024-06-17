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
local TemporaryData = require(Modules.TemporaryData)

---- Data ----

local ReplicatedData = Player:WaitForChild("ReplicatedData")
local ReplicatedTemporaryData = Player:WaitForChild("TemporaryData")
local ReplicatedAccessories = ReplicatedData.Accessories
local EquippedAccessories = ReplicatedData.EquippedAccessories
local accessoriesLimit = ReplicatedTemporaryData.AccessoriesLimit
local equippedAccessoriesLimit = ReplicatedTemporaryData.EquippedAccessoriesLimit

---- UI ----

local PlayerGui = Player.PlayerGui
local UI = PlayerGui:WaitForChild("UI")

local AccessoryInventory = UI.AccessoryInventory
local InvHolder = AccessoryInventory.InvFrame.Holder
local EquipFrame = AccessoryInventory.EquipFrame
local IconCopy = InvHolder.IconCopy

local SearchBar = AccessoryInventory.SearchBar.TextBox
local AccessoriesLimitFrame = AccessoryInventory.AccessoriesLimit
local EquippedAccessoriesLimitFrame = AccessoryInventory.EquippedLimit

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

local function search(text)
    local text = string.lower(text)
    local elements = InvHolder:GetChildren()

    for _, element in elements do
        if element:IsA("Frame") and element ~= IconCopy then
            if string.find(string.lower(element.AccessoryName.Value), text) or string.find(string.lower(element.Rarity.Value), text) then
                element.Visible = true
            else
                element.Visible = false
            end
        end
    end

end

SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
	local text = SearchBar.Text
	
	search(text)
end)


local function equipAccessory(accessoryName)
    EquipAccessoryRemote:InvokeServer(accessoryName)
end

local function isEquipped(GUID)
    local ID = ReplicatedAccessories[GUID].Value
    local equippedAccessory = EquippedAccessories:FindFirstChild(ID)
    if equippedAccessory and equippedAccessory.Value == GUID then
        return true
    else
       return false
    end
end

local function getIcon(GUID)
    for index, icon in InvHolder:GetChildren() do
        if icon:IsA("Frame") and icon.GUID.Value == GUID then
            return icon
        end
    end
    return false
end

local function updateInventory(ID, GUID, method)
    if method == "INIT" then
        for index, icon in InvHolder:GetChildren() do
            if icon:IsA("Frame") and icon ~= IconCopy then
                icon:Destroy()
            end
        end
        initInventory()
    elseif method == "DEL" then
        local icon = getIcon(GUID)
        if icon then
            icon:Destroy()
        end
    elseif method == "ADD" then
        local icon = IconCopy:Clone()
        icon.Visible = true
        icon.Name = TemporaryData:CalculateTag(Player, GUID)
        icon.ID.Value = ID
        icon.GUID.Value = GUID
        icon.Rarity.Value = Accessories[ID].Rarity
        icon.AccessoryName.Value = Accessories[ID].Name
        icon.IconImage.Image = "http://www.roblox.com/Thumbs/Asset.ashx?Width=256&Height=256&AssetID="..Accessories[ID].AssetID
        icon.UIGradient.Color = RarityColors:GetGradient(Accessories[ID].Rarity)
        icon.Parent = InvHolder
        if isEquipped(GUID) then
            icon.EquippedIcon.Visible = true
        else
            icon.EquippedIcon.Visible = false
        end
        icon.IconScript.Enabled = true
    elseif method == "EQUIP" then
        local icon = getIcon(GUID)
        if icon then
            icon.Name = TemporaryData:CalculateTag(Player, GUID)
            icon.EquippedIcon.Visible = true
        end
    elseif method == "UNEQUIP" then  
        local icon = getIcon(GUID)
        if icon then
            icon.Name = TemporaryData:CalculateTag(Player, GUID)
            icon.EquippedIcon.Visible = false
        end
    end
    AccessoriesLimitFrame.Text.Text = #ReplicatedAccessories:GetChildren() .. "/" .. accessoriesLimit.Value
    EquippedAccessoriesLimitFrame.Text.Text = #EquippedAccessories:GetChildren() .. "/" .. equippedAccessoriesLimit.Value
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
    local currentIcon = InvHolder:FindFirstChild(CurrentAccessory.Value)
    if currentIcon then
        equipAccessory(currentIcon.GUID.Value)
        ButtonStatus:AccessoryInventory(Player, currentIcon.GUID.Value, EquipButton)
        currentIcon.Name = TemporaryData:CalculateTag(Player, currentIcon.GUID.Value)
        CurrentAccessory.Value = currentIcon.Name
    end
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