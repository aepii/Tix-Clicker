---- Services ----

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TweenButton = require(Modules.TweenButton)
local ButtonStatus = require(Modules.ButtonStatus)
local Accessories = require(ReplicatedStorage.Data.Accessories)
local CollectibleAccessories = require(ReplicatedStorage.Data.CollectibleAccessories)
local RarityColors = require(Modules.RarityColors)
local TemporaryData = require(Modules.TemporaryData)
local SuffixHandler = require(Modules.SuffixHandler)

---- Data ----

local ReplicatedData = Player:WaitForChild("ReplicatedData")
local ReplicatedTemporaryData = Player:WaitForChild("TemporaryData")
local ReplicatedAccessories = ReplicatedData.Accessories
local ReplicatedCollectibleAccessories = ReplicatedData.CollectibleAccessories
local EquippedAccessories = ReplicatedData.EquippedAccessories
local EquippedCollectibleAccessories = ReplicatedData.EquippedCollectibleAccessories
local accessoriesLimit = ReplicatedTemporaryData.AccessoriesLimit
local equippedAccessoriesLimit = ReplicatedTemporaryData.EquippedAccessoriesLimit
local equippedCollectibleAccessoriesLimit = ReplicatedTemporaryData.EquippedCollectibleAccessoriesLimit

---- UI ----

local PlayerGui = Player.PlayerGui
local UI = PlayerGui:WaitForChild("UI")

local AccessoryInventory = UI.AccessoryInventory
local InvFrame = AccessoryInventory.InvFrame
local CollectibleInvFrame = AccessoryInventory.CollectibleInvFrame
local EquipFrame = AccessoryInventory.EquipFrame
local InvHolder = InvFrame.Holder
local CollectibleInvHolder = CollectibleInvFrame.Holder
local CollectibleEquipFrame = AccessoryInventory.CollectibleEquipFrame
local SearchBar = AccessoryInventory.SearchBar.TextBox
local AccessoriesLimitFrame = AccessoryInventory.AccessoriesLimit
local EquippedAccessoriesLimitFrame = AccessoryInventory.EquippedLimit
local EquippedCollectibleAccessoriesLimitFrame = AccessoryInventory.CollectibleEquippedLimit

local IconCopy = InvHolder.IconCopy

local IconScript = script.Parent.Icon
IconScript.Parent = IconCopy
IconScript.Enabled = true

local CollectibleIconCopy = CollectibleInvHolder.IconCopy

local CollectibleIconScript = script.Parent.CollectibleIcon
CollectibleIconScript.Parent = CollectibleIconCopy
CollectibleIconScript.Enabled = true

---- UI Values ----

local CurrentAccessory = EquipFrame.CurrentAccessory
local CurrentCollectibleAccessory = CollectibleEquipFrame.CurrentAccessory
local UIVisible = UI.UIVisible
local CurrentUI = UI.CurrentUI
local Category = "Standard"

---- Sound ----

local Sounds = Player:WaitForChild("Sounds")
local ClickSound = Sounds:WaitForChild("ClickSound")

---- Networking ----

local Networking = ReplicatedStorage.Networking
local EquipAccessoryRemote = Networking.EquipAccessory
local EquipCollectibleAccessoryRemote = Networking.EquipCollectibleAccessory
local UpdateClientAccessoriesInventoryRemote = Networking.UpdateClientAccessoriesInventory
local UpdateClientCollectibleAccessoriesInventoryRemote = Networking.UpdateClientCollectibleAccessoriesInventory

---- Private Functions ----

local function search(text)
    local text = string.lower(text)

    if Category == "Standard" then
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
    else
        local elements = CollectibleInvHolder:GetChildren()

        for _, element in elements do
            if element:IsA("Frame") and element ~= CollectibleIconCopy then
                if string.find(string.lower(element.AccessoryName.Value), text) or string.find(string.lower(element.Rarity.Value), text) then
                    element.Visible = true
                else
                    element.Visible = false
                end
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

local function equipCollectibleAccessory(accessoryName)
    EquipCollectibleAccessoryRemote:InvokeServer(accessoryName)
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

local function isCollectibleEquipped(GUID)
    local ID = ReplicatedCollectibleAccessories[GUID].Value
    local equippedAccessory = EquippedCollectibleAccessories:FindFirstChild(ID)
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

local function getCollectibleIcon(GUID)
    for index, icon in CollectibleInvHolder:GetChildren() do
        if icon:IsA("Frame") and icon.GUID.Value == GUID then
            return icon
        end
    end
    return false
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
        icon.ValueFrame.ValueText.Text = "$"..SuffixHandler:Convert(Accessories[ID].Value)
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

local function updateCollectibleInventory(ID, GUID, method)
    if method == "INIT" then
        CollectibleEquipFrame:TweenPosition(UDim2.new(0.05,0,2,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        CollectibleInvFrame:TweenSizeAndPosition(UDim2.new(0.95,0,0.8,0), UDim2.new(0.5,0,0.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        UIVisible.Value = false
        for index, icon in CollectibleInvHolder:GetChildren() do
            if icon:IsA("Frame") and icon ~= CollectibleIconCopy then
                icon:Destroy()
            end
        end
        initCollectibleInventory()
    elseif method == "DEL" then
        local icon = getCollectibleIcon(GUID)
        if GUID == icon.GUID.Value then
            CollectibleEquipFrame:TweenPosition(UDim2.new(.05,0,2,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
            CollectibleInvFrame:TweenSizeAndPosition(UDim2.new(0.95,0,0.8,0), UDim2.new(0.5,0,0.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        end
        if icon then
            icon:Destroy()
        end
    elseif method == "ADD" then
        local icon = CollectibleIconCopy:Clone()
        icon.Visible = true
        icon.Name = TemporaryData:CalculateCollectibleTag(Player, GUID)
        icon.ID.Value = ID
        icon.GUID.Value = GUID
        icon.Rarity.Value = CollectibleAccessories[ID].Rarity
        icon.AccessoryName.Value = CollectibleAccessories[ID].Name
        icon.IconImage.Image = "http://www.roblox.com/Thumbs/Asset.ashx?Width=256&Height=256&AssetID="..CollectibleAccessories[ID].AssetID
        icon.UIGradient.Color = RarityColors:GetGradient(CollectibleAccessories[ID].Rarity)
        icon.Parent = CollectibleInvHolder
        if isCollectibleEquipped(GUID) then
            icon.EquippedIcon.Visible = true
        else
            icon.EquippedIcon.Visible = false
        end
    elseif method == "EQUIP" then
        local icon = getCollectibleIcon(GUID)
        print(icon)
        if icon then
            icon.Name = TemporaryData:CalculateCollectibleTag(Player, GUID)
            icon.EquippedIcon.Visible = true
        end
    elseif method == "UNEQUIP" then  
        local icon = getCollectibleIcon(GUID)
        print(icon)
        if icon then
            icon.Name = TemporaryData:CalculateCollectibleTag(Player, GUID)
            icon.EquippedIcon.Visible = false
        end
    end
    EquippedCollectibleAccessoriesLimitFrame.Text.Text = #EquippedCollectibleAccessories:GetChildren() .. "/" .. equippedCollectibleAccessoriesLimit.Value
end

function initInventory()
    for _, accessory in ReplicatedData.Accessories:GetChildren() do
        updateInventory(accessory.Value, accessory.Name, "ADD")
    end
end

initInventory()

function initCollectibleInventory()
    for _, accessory in ReplicatedData.CollectibleAccessories:GetChildren() do
        updateCollectibleInventory(accessory.Value, accessory.Name, "ADD")
    end
end

initCollectibleInventory()

UpdateClientAccessoriesInventoryRemote.OnClientEvent:Connect(function(ID, GUID, method)
    updateInventory(ID, GUID, method)
end)

UpdateClientCollectibleAccessoriesInventoryRemote.OnClientEvent:Connect(function(ID, GUID, method)
    print(method)
    updateCollectibleInventory(ID, GUID, method)
end)

---- Buttons ----

local ExitButton = AccessoryInventory.ExitButton
local EquipButton = EquipFrame.EquipButton
local UnequipAllButton = AccessoryInventory.UnequipAllButton
local EquipBestButton = AccessoryInventory.EquipBestButton
local StandardButton = AccessoryInventory.StandardButton
local CollectibleButton = AccessoryInventory.CollectibleButton
local CollectibleEquipButton = CollectibleEquipFrame.EquipButton

local EXITBUTTON_ORIGINALSIZE = ExitButton.Size
local EQUIPBUTTON_ORIGINALSIZE = EquipButton.Size
local UNEQUIPALLBUTTON_ORIGINALSIZE = UnequipAllButton.Size
local EQUIPBESTBUTTON_ORIGINALSIZE = EquipBestButton.Size
local STANDARDBUTTON_ORIGINALSIZE = StandardButton.Size
local COLLECTIBLEBUTTON_ORIGINALSIZE = CollectibleButton.Size
local COLLECTIBLEEQUIPBUTTON_ORIGINALSIZE = CollectibleEquipButton.Size


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

    if Category == "Standard" then
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
    else
        local currentIcon = CollectibleInvHolder:FindFirstChild(CurrentCollectibleAccessory.Value)
        local bestAccessories = TemporaryData:GetBestCollectibleAccessories(Player)
        for _, data in bestAccessories do
            if currentIcon and CurrentCollectibleAccessory.Value == TemporaryData:CalculateCollectibleTag(Player, data["GUID"]) then
                equipCollectibleAccessory(data["GUID"])
                ButtonStatus:CollectibleAccessoryInventory(Player, currentIcon.GUID.Value, CollectibleEquipButton)
                currentIcon.Name = TemporaryData:CalculateCollectibleTag(Player, data["GUID"])
                CurrentCollectibleAccessory.Value = currentIcon.Name
            else
                equipCollectibleAccessory(data["GUID"])
            end
        end
    end
end

local function equipBestMouseUp()
    TweenButton:Reset(EquipBestButton, EQUIPBESTBUTTON_ORIGINALSIZE)
end

function unequipAll()
    if Category == "Standard" then
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
    else
        for _, data in EquippedCollectibleAccessories:GetChildren() do
            local currentIcon = CollectibleInvHolder:FindFirstChild(CurrentAccessory.Value)
            if currentIcon and CurrentCollectibleAccessory.Value == TemporaryData:CalculateCollectibleTag(Player, data.Value) then
                equipAccessory(data.Value)
                ButtonStatus:CollectibleAccessoryInventory(Player, currentIcon.GUID.Value, CollectibleEquipButton)
                currentIcon.Name = TemporaryData:CalculateCollectibleTag(Player, data.Value)
                CurrentCollectibleAccessory.Value = currentIcon.Name
            else
                equipCollectibleAccessory(data.Value)
            end
        end
    end
end

local function standardHover()
    TweenButton:Grow(StandardButton, STANDARDBUTTON_ORIGINALSIZE)
end

local function standardLeave()
    TweenButton:Reset(StandardButton, STANDARDBUTTON_ORIGINALSIZE)
end

local function standardMouseDown()
    playClickSound()
    TweenButton:Shrink(StandardButton, STANDARDBUTTON_ORIGINALSIZE)

    if Category == "Collectible" then
        CollectibleInvFrame.Visible = false
        EquipFrame.Visible = true
        CollectibleEquipFrame.Visible = false
        InvFrame.Visible = true
        AccessoriesLimitFrame.Visible = true
        EquippedAccessoriesLimitFrame.Visible = true
        EquippedCollectibleAccessoriesLimitFrame.Visible = false
        Category = "Standard"
    end
end

local function standardMouseUp()
    TweenButton:Reset(StandardButton, STANDARDBUTTON_ORIGINALSIZE)
end


local function collectibleHover()
    TweenButton:Grow(CollectibleButton, COLLECTIBLEBUTTON_ORIGINALSIZE)
end

local function collectibleLeave()
    TweenButton:Reset(CollectibleButton, COLLECTIBLEBUTTON_ORIGINALSIZE)
end

local function collectibleMouseDown()
    playClickSound()
    TweenButton:Shrink(CollectibleButton, COLLECTIBLEBUTTON_ORIGINALSIZE)

    if Category == "Standard" then
        CollectibleInvFrame.Visible = true
        EquipFrame.Visible = false
        CollectibleEquipFrame.Visible = true
        InvFrame.Visible = false
        AccessoriesLimitFrame.Visible = false
        EquippedAccessoriesLimitFrame.Visible = false
        EquippedCollectibleAccessoriesLimitFrame.Visible = true
        Category = "Collectible"
    end
end

local function collectibleMouseUp()
    TweenButton:Reset(CollectibleButton, COLLECTIBLEBUTTON_ORIGINALSIZE)
end

local function collectibleEquipHover()
    TweenButton:Grow(CollectibleEquipButton, COLLECTIBLEEQUIPBUTTON_ORIGINALSIZE)
end

local function collectibleEquipLeave()
    TweenButton:Reset(CollectibleEquipButton, COLLECTIBLEEQUIPBUTTON_ORIGINALSIZE)
end

local function collectibleEquipMouseDown()
    playClickSound()
    TweenButton:Shrink(CollectibleEquipButton, COLLECTIBLEEQUIPBUTTON_ORIGINALSIZE)
    local currentIcon = CollectibleInvHolder:FindFirstChild(CurrentCollectibleAccessory.Value)
    if currentIcon then
        equipCollectibleAccessory(currentIcon.GUID.Value)
        ButtonStatus:CollectibleAccessoryInventory(Player, currentIcon.GUID.Value, CollectibleEquipButton)
        currentIcon.Name = TemporaryData:CalculateCollectibleTag(Player, currentIcon.GUID.Value)
        CurrentCollectibleAccessory.Value = currentIcon.Name
    end
end

local function collectibleEquipMouseUp()
    TweenButton:Reset(CollectibleEquipButton, COLLECTIBLEEQUIPBUTTON_ORIGINALSIZE)
end


ExitButton.ClickDetector.MouseEnter:Connect(exitHover)
ExitButton.ClickDetector.MouseLeave:Connect(exitLeave)
ExitButton.ClickDetector.MouseButton1Down:Connect(exitMouseDown)
ExitButton.ClickDetector.MouseButton1Up:Connect(exitMouseUp)

EquipButton.ClickDetector.MouseEnter:Connect(equipHover)
EquipButton.ClickDetector.MouseLeave:Connect(equipLeave)
EquipButton.ClickDetector.MouseButton1Down:Connect(equipMouseDown)
EquipButton.ClickDetector.MouseButton1Up:Connect(equipMouseUp)

CollectibleEquipButton.ClickDetector.MouseEnter:Connect(collectibleEquipHover)
CollectibleEquipButton.ClickDetector.MouseLeave:Connect(collectibleEquipLeave)
CollectibleEquipButton.ClickDetector.MouseButton1Down:Connect(collectibleEquipMouseDown)
CollectibleEquipButton.ClickDetector.MouseButton1Up:Connect(collectibleEquipMouseUp)


UnequipAllButton.ClickDetector.MouseEnter:Connect(unequipAllHover)
UnequipAllButton.ClickDetector.MouseLeave:Connect(unequipAllLeave)
UnequipAllButton.ClickDetector.MouseButton1Down:Connect(unequipAllMouseDown)
UnequipAllButton.ClickDetector.MouseButton1Up:Connect(unequipAllMouseUp)

EquipBestButton.ClickDetector.MouseEnter:Connect(equipBestHover)
EquipBestButton.ClickDetector.MouseLeave:Connect(equipBestLeave)
EquipBestButton.ClickDetector.MouseButton1Down:Connect(equipBestMouseDown)
EquipBestButton.ClickDetector.MouseButton1Up:Connect(equipBestMouseUp)

StandardButton.ClickDetector.MouseEnter:Connect(standardHover)
StandardButton.ClickDetector.MouseLeave:Connect(standardLeave)
StandardButton.ClickDetector.MouseButton1Down:Connect(standardMouseDown)
StandardButton.ClickDetector.MouseButton1Up:Connect(standardMouseUp)

CollectibleButton.ClickDetector.MouseEnter:Connect(collectibleHover)
CollectibleButton.ClickDetector.MouseLeave:Connect(collectibleLeave)
CollectibleButton.ClickDetector.MouseButton1Down:Connect(collectibleMouseDown)
CollectibleButton.ClickDetector.MouseButton1Up:Connect(collectibleMouseUp)