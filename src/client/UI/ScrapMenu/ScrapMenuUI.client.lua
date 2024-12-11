---- Services ----

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TweenButton = require(Modules.TweenButton)
local Accessories = require(ReplicatedStorage.Data.Accessories)
local RarityColors = require(Modules.RarityColors)
local TemporaryData = require(Modules.TemporaryData)
local TixUIAnim = require(Modules.TixUIAnim)
local SuffixHandler = require(Modules.SuffixHandler)

---- Data ----

local ReplicatedData = Player:WaitForChild("ReplicatedData")
local ReplicatedAccessories = ReplicatedData:WaitForChild("Accessories")
local EquippedAccessories = ReplicatedData:WaitForChild("EquippedAccessories")

---- UI ----

local PlayerGui = Player.PlayerGui
local UI = PlayerGui:WaitForChild("UI")
local VFX = UI:WaitForChild("VFX")

local ScrapMenu = UI.ScrapMenu
local InvFrame = ScrapMenu.InvFrame
local InvHolder = InvFrame.Holder
local ScrapFrame = ScrapMenu.ScrapFrame
local MultiScrapFrame = ScrapMenu.MultiScrapFrame
local IconCopy = InvHolder.IconCopy
local SearchBar = ScrapMenu.SearchBar.TextBox
local MultiScrapButton = ScrapMenu.MultiScrapButton
local SelectAllButton = ScrapMenu.SelectAllButton

local IconScript = script.Parent.Icon
IconScript.Name = "IconScript"
IconScript.Parent = IconCopy

---- UI Values ----

local CurrentAccessory = ScrapFrame.CurrentAccessory
local UIVisible = UI.UIVisible
local UIVisibleScrap = ScrapFrame.UIVisible
local CurrentUI = UI.CurrentUI
local CurrentRarity = MultiScrapFrame.CurrentRarity
local MultiScrap = ScrapMenu.MultiScrap
local SelectAll = ScrapMenu.SelectAll
local SelectAllValid = ScrapMenu.SelectAllValid
local MultiSelected = ScrapMenu.MultiSelected

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
local BindableSelectAllAccessoriesRemote = Networking.BindableSelectAllAccessories

---- Private Functions ----

local function isEquipped(GUID)
    local ID = ReplicatedAccessories:FindFirstChild(GUID)
    if not ID then
        return false
    end
    local equippedAccessory = EquippedAccessories:FindFirstChild(ID.Value)
    if equippedAccessory and equippedAccessory.Value == GUID then
        return true
    else
       return false
    end
end

local function search(text)
    local text = string.lower(text)
    local elements = InvHolder:GetChildren()

    if MultiScrap.Value == false then
        for _, element in elements do
            if element:IsA("Frame") and element ~= IconCopy then
                if isEquipped(element.GUID.Value) then
                    element.Visible = false
                else
                    if string.find(string.lower(element.AccessoryName.Value), text) or string.find(string.lower(element.Rarity.Value), text)  then
                        element.Visible = true
                    else
                        element.Visible = false
                    end
                end
            end
        end
    end

end

SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
	local text = SearchBar.Text
	search(text)
end)


local function scrapAccessory(accessoryGUID)
    local amount, materialData = ScrapAccessoryRemote:InvokeServer(accessoryGUID)
    if amount then
        SoundService:PlayLocalSound(ScrapSound)
        ScrapFrame:TweenPosition(UDim2.new(.05,0,2,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        InvFrame:TweenSizeAndPosition(UDim2.new(0.95,0,0.8,0), UDim2.new(0.5,0,0.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        UIVisibleScrap.Value = false
        if VFX.ScrapVFX.Value == true then
            if amount > 0 then
                TixUIAnim:Animate(Player, "MaterialDetail", amount, materialData)
                SoundService:PlayLocalSound(PopSound)
            end
        end
    else
        SoundService:PlayLocalSound(ErrorSound)
    end
end

local function resetMultiScrapFrame()
    MultiScrap.Value = false
    SearchBar.PlaceholderText = "Search"
    MultiScrapButton.ScrapText.Text = "Multi Scrap"
    SelectAllButton.SelectText.Text = "Select All"
    SelectAllValid.Value = false
    SelectAll.Value = false
    SelectAllButton.Visible = false
    for index, icon in InvHolder:GetChildren() do
        if icon:IsA("Frame") and icon ~= IconCopy then
            icon.SelectedIcon.Visible = false
        end
    end
    CurrentRarity.Value = ""
    MultiScrapFrame.Message.Visible = true
    MultiScrapFrame.RewardsFrame.Visible = false
    MultiScrapFrame:TweenPosition(UDim2.new(.05,0,2,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
    InvFrame:TweenSizeAndPosition(UDim2.new(0.95,0,0.8,0), UDim2.new(0.5,0,0.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
    for _, item in MultiSelected:GetChildren() do
        item:Destroy()
    end
    search("")
end

local function multiScrapAccessory()
    for _, item in MultiSelected:GetChildren() do
        local accessoryGUID = item.Name
        local amount, materialData = ScrapAccessoryRemote:InvokeServer(accessoryGUID)
        if VFX.ScrapVFX.Value == true then
            if amount then
                coroutine.wrap(function()
                    SoundService:PlayLocalSound(ScrapSound)
                    if amount > 0 then
                        TixUIAnim:Animate(Player, "MaterialDetail", amount, materialData)
                        SoundService:PlayLocalSound(PopSound)
                    end
                end)()
            else
                SoundService:PlayLocalSound(ErrorSound)
            end
        end
    end
    
    resetMultiScrapFrame()
end

local function getIcon(GUID)
    for index, icon in InvHolder:GetChildren() do
        if icon:IsA("Frame") and icon.GUID.Value == GUID then
            return icon
        elseif icon:IsA("Frame") then
            print(icon.Name)
            print(icon.GUID.Value, GUID)
        end
    end
end

local function updateInventory(ID, GUID, method)
    if string.sub(ID, 1, 2) == "CA" then
        return
    end
    if method == "INIT" then
        ScrapFrame:TweenPosition(UDim2.new(.05,0,2,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
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
        if icon then
            icon:Destroy()
        end
        print(#ReplicatedAccessories:GetChildren())
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
            icon.Visible = false
        else
            icon.Visible = true
        end
        icon.IconScript.Enabled = true
    elseif method == "EQUIP" then
        local icon = getIcon(GUID)
        if GUID == icon.GUID.Value then
            CurrentAccessory.Value = ""
            if icon then
                icon.Shadow.BackgroundColor3 = Color3.fromRGB(234, 160, 19)
            end
            ScrapFrame:TweenPosition(UDim2.new(.05,0,2,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
            InvFrame:TweenSizeAndPosition(UDim2.new(0.95,0,0.8,0), UDim2.new(0.5,0,0.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        end
        if icon then
            icon.Name = TemporaryData:CalculateTag(Player, GUID)
            icon.Visible = false
        end
    elseif method == "UNEQUIP" then  
        local icon = getIcon(GUID)
        if GUID == icon.GUID.Value then
            CurrentAccessory.Value = ""
            if icon then
                icon.Shadow.BackgroundColor3 = Color3.fromRGB(234, 160, 19)
            end
            ScrapFrame:TweenPosition(UDim2.new(.05,0,2,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
            InvFrame:TweenSizeAndPosition(UDim2.new(0.95,0,0.8,0), UDim2.new(0.5,0,0.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        end
        if icon then
            icon.Name = TemporaryData:CalculateTag(Player, GUID)
            icon.Visible = true
        end
    end
    resetMultiScrapFrame()
end

function initInventory()
    local counter = 0
    print(#ReplicatedAccessories:GetChildren())
    for _, accessory in ReplicatedAccessories:GetChildren() do
        counter += 1
        updateInventory(accessory.Value, accessory.Name, "ADD")
    end
    print("SCRAP ACCESSORIES COUNTER:", counter)
end

initInventory()

UpdateClientAccessoriesInventoryRemote.OnClientEvent:Connect(function(ID, GUID, method)
    updateInventory(ID, GUID, method)
end)

---- Buttons ----

local ExitButton = ScrapMenu.ExitButton
local ScrapButton = ScrapFrame.ScrapButton
local ConfirmMultiScrapButton = MultiScrapFrame.ScrapButton

local EXITBUTTON_ORIGINALSIZE = ExitButton.Size
local SCRAPBUTTON_ORIGINALSIZE = ScrapButton.Size
local MULTISCRAPBUTTON_ORIGINALSIZE = MultiScrapButton.Size
local CONFIRMMULTISCRAPBUTTON_ORIGINALSIZE = ConfirmMultiScrapButton.Size
local SELECTALLBUTTON_ORIGINALSIZE = SelectAllButton.Size

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
        scrapAccessory(currentIcon.GUID.Value)
    end
end

local function scrapMouseUp()
    TweenButton:Reset(ScrapButton, SCRAPBUTTON_ORIGINALSIZE)
end

local function multiScrapHover()
    TweenButton:Grow(MultiScrapButton, MULTISCRAPBUTTON_ORIGINALSIZE)
end

local function multiScrapLeave()
    TweenButton:Reset(MultiScrapButton, MULTISCRAPBUTTON_ORIGINALSIZE)
end

local function multiScrapMouseDown()
    playClickSound()
    TweenButton:Shrink(MultiScrapButton, MULTISCRAPBUTTON_ORIGINALSIZE)
    if InvFrame.Holder:FindFirstChild(CurrentAccessory.Value) then
        InvFrame.Holder[CurrentAccessory.Value].Shadow.BackgroundColor3 = Color3.fromRGB(234, 160, 19)
        CurrentAccessory.Value = ""
    end
    ScrapFrame:TweenPosition(UDim2.new(.05,0,2,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
    if MultiScrap.Value == false then 
        SearchBar.PlaceholderText = "Unavailable"
        MultiScrap.Value = true
        MultiScrapButton.ScrapText.Text = "Cancel"
        MultiScrapFrame:TweenPosition(UDim2.new(.05,0,.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        InvFrame:TweenSizeAndPosition(UDim2.new(0.75,0,0.8,0), UDim2.new(0.575,0,0.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
    else
        resetMultiScrapFrame()
    end
    search("")
end

local function multiScrapMouseUp()
    TweenButton:Reset(MultiScrapButton, MULTISCRAPBUTTON_ORIGINALSIZE)
end

local function confirmMultiScrapHover()
    TweenButton:Grow(ConfirmMultiScrapButton, CONFIRMMULTISCRAPBUTTON_ORIGINALSIZE)
end

local function confirmMultiScrapLeave()
    TweenButton:Reset(ConfirmMultiScrapButton, CONFIRMMULTISCRAPBUTTON_ORIGINALSIZE)
end

local function confirmMultiScrapMouseDown()
    playClickSound()
    TweenButton:Shrink(ConfirmMultiScrapButton, CONFIRMMULTISCRAPBUTTON_ORIGINALSIZE)
    multiScrapAccessory()
end

local function confirmMultiScrapMouseUp()
    TweenButton:Reset(ConfirmMultiScrapButton, CONFIRMMULTISCRAPBUTTON_ORIGINALSIZE)
end

local function selectAllHover()
    TweenButton:Grow(SelectAllButton, SELECTALLBUTTON_ORIGINALSIZE)
end

local function selectAllLeave()
    TweenButton:Reset(SelectAllButton, SELECTALLBUTTON_ORIGINALSIZE)
end

local function selectAllMouseDown()
    playClickSound()
    TweenButton:Shrink(SelectAllButton, SELECTALLBUTTON_ORIGINALSIZE)
    if SelectAllValid.Value == true  then
        if SelectAll.Value == false then
            SelectAll.Value = true
            BindableSelectAllAccessoriesRemote:Fire(CurrentRarity.Value, "Select")
            SelectAllButton.SelectText.Text = "Deselect All"
        else
            SelectAll.Value = false
            BindableSelectAllAccessoriesRemote:Fire(CurrentRarity.Value, "Deselect")
            SelectAllButton.SelectText.Text = "Select All"
        end
    end
end

local function selectAllMouseUp()
    TweenButton:Reset(SelectAllButton, SELECTALLBUTTON_ORIGINALSIZE)
end

local function multiSelectedUpdated()
    if #MultiSelected:GetChildren() == 1 then
        SelectAllValid.Value = true
        SelectAllButton.SelectText.Text = "Select All"
        SelectAllButton.Visible = true
    elseif #MultiSelected:GetChildren() == 0 then
        SelectAllValid.Value = false
        SelectAllButton.SelectText.Text = "Select All"
        SelectAllButton.Visible = false
    end
end

MultiSelected.ChildAdded:Connect(multiSelectedUpdated)

MultiSelected.ChildRemoved:Connect(multiSelectedUpdated)

ExitButton.ClickDetector.MouseEnter:Connect(exitHover)
ExitButton.ClickDetector.MouseLeave:Connect(exitLeave)
ExitButton.ClickDetector.MouseButton1Down:Connect(exitMouseDown)
ExitButton.ClickDetector.MouseButton1Up:Connect(exitMouseUp)

ScrapButton.ClickDetector.MouseEnter:Connect(scrapHover)
ScrapButton.ClickDetector.MouseLeave:Connect(scrapLeave)
ScrapButton.ClickDetector.MouseButton1Down:Connect(scrapMouseDown)
ScrapButton.ClickDetector.MouseButton1Up:Connect(scrapMouseUp)

ConfirmMultiScrapButton.ClickDetector.MouseEnter:Connect(confirmMultiScrapHover)
ConfirmMultiScrapButton.ClickDetector.MouseLeave:Connect(confirmMultiScrapLeave)
ConfirmMultiScrapButton.ClickDetector.MouseButton1Down:Connect(confirmMultiScrapMouseDown)
ConfirmMultiScrapButton.ClickDetector.MouseButton1Up:Connect(confirmMultiScrapMouseUp)

MultiScrapButton.ClickDetector.MouseEnter:Connect(multiScrapHover)
MultiScrapButton.ClickDetector.MouseLeave:Connect(multiScrapLeave)
MultiScrapButton.ClickDetector.MouseButton1Down:Connect(multiScrapMouseDown)
MultiScrapButton.ClickDetector.MouseButton1Up:Connect(multiScrapMouseUp)

SelectAllButton.ClickDetector.MouseEnter:Connect(selectAllHover)
SelectAllButton.ClickDetector.MouseLeave:Connect(selectAllLeave)
SelectAllButton.ClickDetector.MouseButton1Down:Connect(selectAllMouseDown)
SelectAllButton.ClickDetector.MouseButton1Up:Connect(selectAllMouseUp)