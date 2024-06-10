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
local TixUIAnim = require(Modules.TixUIAnim)

---- Data ----

local ReplicatedData = Player:WaitForChild("ReplicatedData")
local ReplicatedTemporaryData = Player:WaitForChild("TemporaryData")
local ReplicatedAccessories = ReplicatedData.Accessories
local EquippedAccessories = ReplicatedData.EquippedAccessories
local accessoriesLimit = ReplicatedTemporaryData.AccessoriesLimit

---- UI ----

local PlayerGui = Player.PlayerGui
local UI = PlayerGui:WaitForChild("UI")

local ScrapMenu = UI.ScrapMenu
local InvFrame = ScrapMenu.InvFrame
local InvHolder = InvFrame.Holder
local ScrapFrame = ScrapMenu.ScrapFrame
local IconCopy = InvHolder.IconCopy

local AccessoriesLimitText = ScrapMenu.AccessoriesLimit

local IconScript = script.Parent.Icon
IconScript.Name = "IconScript"
IconScript.Parent = IconCopy

---- UI Values ----

local CurrentAccessory = ScrapFrame.CurrentAccessory
local UIVisible = UI.UIVisible
local UIVisibleScrap = ScrapFrame.UIVisible
local CurrentUI = UI.CurrentUI

---- Sound ----

local Sounds = Player:WaitForChild("Sounds")
local ClickSound = Sounds:WaitForChild("ClickSound")
local ScrapSound = Sounds:WaitForChild("ScrapSound")
local ErrorSound = Sounds:WaitForChild("ErrorSound")
local PopSound = Sounds:WaitForChild("PopSound")

---- Networking ----

local Networking = ReplicatedStorage.Networking
local ScrapAccessoryRemote = Networking.ScrapAccessory
local UpdateClientAccessoriesInventoryRemote = Networking.UpdateClientAccessoriesInventory

---- Private Functions ----

local function scrapAccessory(accessoryGUID)
    local amount, materialData = ScrapAccessoryRemote:InvokeServer(accessoryGUID)
    if amount then
        SoundService:PlayLocalSound(ScrapSound)
        ScrapFrame:TweenPosition(UDim2.new(0,0,2,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        InvFrame:TweenSizeAndPosition(UDim2.new(0.9,0,0.8,0), UDim2.new(0.5,0,0.56,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        UIVisibleScrap.Value = false
        if amount > 0 then
            TixUIAnim:Animate(Player, "MaterialDetail", amount, materialData)
            SoundService:PlayLocalSound(PopSound)
        end
    else
        SoundService:PlayLocalSound(ErrorSound)
    end
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
        print("ATTEMPT DELTED")
        local icon = getIcon(GUID)
        print(icon)
        if icon then
            print("DELTED")
            icon:Destroy()
        end
    elseif method == "ADD" then
        local icon = IconCopy:Clone()
        icon.Visible = true
        icon.Name = TemporaryData:CalculateTag(Player, GUID)
        icon.ID.Value = ID
        icon.GUID.Value = GUID
        icon.IconImage.Image = "http://www.roblox.com/Thumbs/Asset.ashx?Width=256&Height=256&AssetID="..Accessories[ID].AssetID
        icon.UIGradient.Color = RarityColors:GetGradient(Accessories[ID].Rarity)
        icon.Parent = InvHolder
        if isEquipped(GUID) then
            icon.EquippedIcon.Visible = true
        else
            print("NOT")
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

local ExitButton = ScrapMenu.ExitButton
local ScrapButton = ScrapFrame.ScrapButton

local EXITBUTTON_ORIGINALSIZE = ExitButton.Size
local SCRAPBUTTON_ORIGINALSIZE = ScrapButton.Size

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
    ScrapMenu:TweenPosition(UDim2.new(0.5, 0, 2, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
    CurrentUI.Value = ""
    UIVisible.Value = false
end

local function exitMouseUp()
    TweenButton:Reset(ExitButton, EXITBUTTON_ORIGINALSIZE)
end

local function scrapHover()
    TweenButton:Grow(ScrapButton, SCRAPBUTTON_ORIGINALSIZE)
end

local function scrapLeave()
    TweenButton:Reset(ScrapButton, SCRAPBUTTON_ORIGINALSIZE)
end

local function scrapMouseDown()
    playClickSound()
    TweenButton:Shrink(ScrapButton, SCRAPBUTTON_ORIGINALSIZE)
    local currentIcon = InvHolder:FindFirstChild(CurrentAccessory.Value)
    if currentIcon then
        scrapAccessory(currentIcon.GUID.Value, ScrapFrame, UIVisibleScrap)
    end
end

local function scrapMouseUp()
    TweenButton:Reset(ScrapButton, SCRAPBUTTON_ORIGINALSIZE)
end

ExitButton.ClickDetector.MouseEnter:Connect(exitHover)
ExitButton.ClickDetector.MouseLeave:Connect(exitLeave)
ExitButton.ClickDetector.MouseButton1Down:Connect(exitMouseDown)
ExitButton.ClickDetector.MouseButton1Up:Connect(exitMouseUp)

ScrapButton.ClickDetector.MouseEnter:Connect(scrapHover)
ScrapButton.ClickDetector.MouseLeave:Connect(scrapLeave)
ScrapButton.ClickDetector.MouseButton1Down:Connect(scrapMouseDown)
ScrapButton.ClickDetector.MouseButton1Up:Connect(scrapMouseUp)