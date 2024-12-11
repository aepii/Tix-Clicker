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
local SuffixHandler = require(Modules.SuffixHandler)

---- Data ----

local ReplicatedData = Player:WaitForChild("ReplicatedData")
local ReplicatedTemporaryData = Player:WaitForChild("TemporaryData")
local ReplicatedAccessories = ReplicatedData:WaitForChild("Accessories")
local EquippedAccessories = ReplicatedData:WaitForChild("EquippedAccessories")
local accessoriesLimit = ReplicatedTemporaryData:WaitForChild("AccessoriesLimit")
local equippedAccessoriesLimit = ReplicatedTemporaryData:WaitForChild("EquippedAccessoriesLimit")

---- UI ----

local PlayerGui = Player.PlayerGui
local UI = PlayerGui:WaitForChild("UI")

local AccessoryInventory = UI.AccessoryInventory
local InvFrame = AccessoryInventory.InvFrame
local EquipFrame = AccessoryInventory.EquipFrame
local InvHolder = InvFrame.Holder
local SearchBar = AccessoryInventory.SearchBar.TextBox
local AccessoriesLimitFrame = AccessoryInventory.AccessoriesLimit
local EquippedAccessoriesLimitFrame = AccessoryInventory.EquippedLimit

local IconCopy = InvHolder.IconCopy

local IconScript = script.Parent.Icon
IconScript.Parent = IconCopy
IconScript.Enabled = true

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


local function equipAccessory(accessoryName ) --standard/collectible
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
end


local function updateInventory(ID, GUID, method)
    if method == "INIT" then
        EquipFrame:TweenPosition(UDim2.new(0.05,0,2,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        InvFrame:TweenSizeAndPosition(UDim2.new(0.95,0,0.8,0), UDim2.new(0.5,0,0.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        UIVisible.Value = false
        for index, icon in InvHolder:GetChildren() do
            if icon:IsA("Frame") and icon ~= IconCopy then
                icon:Destroy()
            end
        end
        initInventory()
    elseif method == "DEL" then
        local icon = getIcon(GUID)
        if GUID == icon.GUID.Value then
            EquipFrame:TweenPosition(UDim2.new(.05,0,2,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
            InvFrame:TweenSizeAndPosition(UDim2.new(0.95,0,0.8,0), UDim2.new(0.5,0,0.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        end
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
        
        if string.sub(ID, 1, 2) == "CA" then
            icon.ValueFrame.Visible = false
            icon.MultiplierFrame.Visible = true
            icon.MultiplierFrame.MultiText.Text = "x"..Accessories[ID].Reward["Best"]
        else
            icon.ValueFrame.Visible = true
            icon.MultiplierFrame.Visible = false
            icon.ValueFrame.ValueText.Text = "$"..SuffixHandler:Convert(Accessories[ID].Value)
        end

        icon.IconImage.Image = "http://www.roblox.com/Thumbs/Asset.ashx?Width=256&Height=256&AssetID="..Accessories[ID].AssetID
        icon.UIGradient.Color = RarityColors:GetGradient(Accessories[ID].Rarity)
        icon.Parent = InvHolder
        if isEquipped(GUID) then
            icon.EquippedIcon.Visible = true
        else
            icon.EquippedIcon.Visible = false
        end
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
    for _, accessory in ReplicatedAccessories:GetChildren() do
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
local UnequipAllButton = AccessoryInventory.UnequipAllButton
local EquipBestButton = AccessoryInventory.EquipBestButton

local EXITBUTTON_ORIGINALSIZE = ExitButton.Size
local EQUIPBUTTON_ORIGINALSIZE = EquipButton.Size
local UNEQUIPALLBUTTON_ORIGINALSIZE = UnequipAllButton.Size
local EQUIPBESTBUTTON_ORIGINALSIZE = EquipBestButton.Size

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

local function unequipAllHover()
    TweenButton:Grow(UnequipAllButton, UNEQUIPALLBUTTON_ORIGINALSIZE)
end

local function unequipAllLeave()
    TweenButton:Reset(UnequipAllButton, UNEQUIPALLBUTTON_ORIGINALSIZE)
end

local function unequipAllMouseDown()
    playClickSound()
    TweenButton:Shrink(UnequipAllButton, UNEQUIPALLBUTTON_ORIGINALSIZE)
    unequipAll()
end

local function unequipAllMouseUp()
    TweenButton:Reset(UnequipAllButton, UNEQUIPALLBUTTON_ORIGINALSIZE)
end

local function equipBestHover()
    TweenButton:Grow(EquipBestButton, EQUIPBESTBUTTON_ORIGINALSIZE)
end

local function equipBestLeave()
    TweenButton:Reset(EquipBestButton, EQUIPBESTBUTTON_ORIGINALSIZE)
end

local function equipBestMouseDown()
    playClickSound()
    TweenButton:Shrink(EquipBestButton, EQUIPBESTBUTTON_ORIGINALSIZE)
    unequipAll()

    local currentIcon = InvHolder:FindFirstChild(CurrentAccessory.Value)
    local bestAccessories = TemporaryData:GetBestAccessories(Player)
    for _, data in bestAccessories do
        if currentIcon and CurrentAccessory.Value == TemporaryData:CalculateTag(Player, data["GUID"]) then
            equipAccessory(data["GUID"])
            ButtonStatus:AccessoryInventory(Player, currentIcon.GUID.Value, EquipButton)
            currentIcon.Name = TemporaryData:CalculateTag(Player, data["GUID"])
            CurrentAccessory.Value = currentIcon.Name
        else
            equipAccessory(data["GUID"])
        end
    end
    
end

local function equipBestMouseUp()
    TweenButton:Reset(EquipBestButton, EQUIPBESTBUTTON_ORIGINALSIZE)
end

function unequipAll()
    local currentIcon = InvHolder:FindFirstChild(CurrentAccessory.Value)
    for _, data in EquippedAccessories:GetChildren() do
        if currentIcon and CurrentAccessory.Value == TemporaryData:CalculateTag(Player, data.Value) then
            equipAccessory(data.Value)
            ButtonStatus:AccessoryInventory(Player, currentIcon.GUID.Value, EquipButton)
            currentIcon.Name = TemporaryData:CalculateTag(Player, data.Value)
            CurrentAccessory.Value = currentIcon.Name
        else
            equipAccessory(data.Value)
        end
    end
end

ExitButton.ClickDetector.MouseEnter:Connect(exitHover)
ExitButton.ClickDetector.MouseLeave:Connect(exitLeave)
ExitButton.ClickDetector.MouseButton1Down:Connect(exitMouseDown)
ExitButton.ClickDetector.MouseButton1Up:Connect(exitMouseUp)

EquipButton.ClickDetector.MouseEnter:Connect(equipHover)
EquipButton.ClickDetector.MouseLeave:Connect(equipLeave)
EquipButton.ClickDetector.MouseButton1Down:Connect(equipMouseDown)
EquipButton.ClickDetector.MouseButton1Up:Connect(equipMouseUp)

UnequipAllButton.ClickDetector.MouseEnter:Connect(unequipAllHover)
UnequipAllButton.ClickDetector.MouseLeave:Connect(unequipAllLeave)
UnequipAllButton.ClickDetector.MouseButton1Down:Connect(unequipAllMouseDown)
UnequipAllButton.ClickDetector.MouseButton1Up:Connect(unequipAllMouseUp)

EquipBestButton.ClickDetector.MouseEnter:Connect(equipBestHover)
EquipBestButton.ClickDetector.MouseLeave:Connect(equipBestLeave)
EquipBestButton.ClickDetector.MouseButton1Down:Connect(equipBestMouseDown)
EquipBestButton.ClickDetector.MouseButton1Up:Connect(equipBestMouseUp)