---- Services ----

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local ButtonStatus = require(Modules.ButtonStatus)
local TweenButton = require(Modules.TweenButton)
local Accessories = require(ReplicatedStorage.Data.Accessories)
local SuffixHandler = require(Modules.SuffixHandler)
local RarityColors = require(Modules.RarityColors)
local Materials = require(ReplicatedStorage.Data.Materials)
local TemporaryData = require(Modules.TemporaryData)

---- Data ----

local ReplicatedData = Player:WaitForChild("ReplicatedData")
local ReplicatedAccessories = ReplicatedData:WaitForChild("Accessories")
local EquippedAccessories = ReplicatedData:WaitForChild("EquippedAccessories")

---- UI ----

local IconButton = script.Parent
local IconButtonImage = IconButton.IconImage
local InvHolder = IconButton.Parent
local InvFrame = InvHolder.Parent
local ScrapMenu = InvFrame.Parent
local ScrapFrame = ScrapMenu.ScrapFrame
local MultiScrapFrame = ScrapMenu.MultiScrapFrame
local IconImage = ScrapFrame.Icon.IconImage
local RewardsFrame = ScrapFrame.RewardsFrame
local ValueFrame = ScrapFrame.ValueFrame
local ScrapButton = ScrapFrame.ScrapButton
local SelectedIcon = IconButton.SelectedIcon
local IconCopy = InvHolder.IconCopy

---- UI Values ----

local UIVisible = ScrapFrame.UIVisible
local CurrentAccessory = ScrapFrame.CurrentAccessory
local CurrentRarity = MultiScrapFrame.CurrentRarity
local MultiScrap = ScrapMenu.MultiScrap
local MultiSelected = ScrapMenu.MultiSelected

local GUID = IconButton.GUID

---- Sound ----

local Sounds = Player:WaitForChild("Sounds")
local ClickSound = Sounds:WaitForChild("ClickSound")

---- Networking ----

local Networking = ReplicatedStorage.Networking
local BindableSelectAllAccessoriesRemote = Networking.BindableSelectAllAccessories


---- Private Functions ----

local function isEquipped(GUID)
    local ID = ReplicatedAccessories[GUID].Value
    local equippedAccessory = EquippedAccessories:FindFirstChild(ID)
    if equippedAccessory and equippedAccessory.Value == GUID then
        return true
    else
       return false
    end
end

local function multiScrapSearch(text)
    local text = string.lower(text)
    local elements = InvHolder:GetChildren()

    for _, element in elements do
        if element:IsA("Frame") and element ~= IconCopy then
            if isEquipped(element.GUID.Value) then
                element.Visible = false
            else
                if string.lower(element.Rarity.Value) == text or text == "" then
                    element.Visible = true
                else
                    element.Visible = false
                end
            end
        end
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

local function updateScrapFrame()
    local ID = ReplicatedAccessories[GUID.Value].Value
    local accessory = Accessories[ID]
    
    local taggedName = TemporaryData:CalculateTag(Player, GUID.Value)
    
    if InvFrame.Holder:FindFirstChild(CurrentAccessory.Value) then
        InvFrame.Holder[CurrentAccessory.Value].Shadow.BackgroundColor3 = Color3.fromRGB(234, 160, 19)
    end

    if CurrentAccessory.Value == taggedName and UIVisible.Value == false then
        return
    end

    CurrentAccessory.Value = taggedName

    local gradient = RarityColors:GetGradient(accessory.Rarity)

    for _, rewardFrame in RewardsFrame:GetChildren() do
        if rewardFrame:IsA("Frame") then
            local quantity, chanceToReceive, materialID = TemporaryData:CalculateMaterialInfo(Player, accessory.Value)
            local prefix = "x"
            rewardFrame.RewardText.UIGradient.Color = gradient
            rewardFrame.RewardText.Text = prefix  .. "0-" .. quantity
            rewardFrame.ChanceText.Text = string.format("%.1f", chanceToReceive*100).."%/drop"
            rewardFrame.RewardIcon.Image = Materials[materialID].Image
            rewardFrame.Visible = true
        end
    end

    ValueFrame.ValueText.Text = "$"..SuffixHandler:Convert(accessory.Value)
    InvFrame.Holder[taggedName].Shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ScrapFrame.ItemName.Title.Text = accessory.Name
    ScrapFrame.Icon.UIGradient.Color = RarityColors:GetGradient(accessory.Rarity)
    IconImage.Image = "http://www.roblox.com/Thumbs/Asset.ashx?Width=256&Height=256&AssetID="..accessory.AssetID

    ButtonStatus:ScrapInventory(Player, GUID.Value, ScrapButton)
end


local function updateMultiScrapFrame()
    local ID = ReplicatedAccessories[GUID.Value].Value
    local accessory = Accessories[ID]
    
    if CurrentRarity.Value == "" then
        CurrentRarity.Value = accessory.Rarity
    end

    local selected = MultiSelected:FindFirstChild(GUID.Value)

    if selected then
        SelectedIcon.Visible = false
        selected:Destroy()
    else
        SelectedIcon.Visible = true
        local instance = Instance.new("StringValue")
        instance.Name = GUID.Value
        instance.Value = ID
        instance.Parent = MultiSelected
    end

    if #MultiSelected:GetChildren() == 0 then
        CurrentRarity.Value = ""
        MultiScrapFrame.Message.Visible = true
        MultiScrapFrame.RewardsFrame.Visible = false
    else
        local gradient = RarityColors:GetGradient(CurrentRarity.Value)
        local quantity, chanceToReceive, materialID = TemporaryData:CalculateMultipleMaterialInfo(Player, MultiSelected)
        local prefix = "x"
        MultiScrapFrame.RewardsFrame[1].RewardText.UIGradient.Color = gradient
        MultiScrapFrame.RewardsFrame[1].RewardText.Text = prefix  .. "0-" .. quantity
        MultiScrapFrame.RewardsFrame[1].ChanceText.Text = string.format("%.1f", chanceToReceive*100).."%/drop"
        MultiScrapFrame.RewardsFrame[1].RewardIcon.Image = Materials[materialID].Image
        MultiScrapFrame.RewardsFrame.Visible = true
        MultiScrapFrame.Message.Visible = false
       
    end
    multiScrapSearch(CurrentRarity.Value)
end

BindableSelectAllAccessoriesRemote.Event:Connect(function(rarity, method)
    if rarity == script.Parent.Rarity.Value then
        if method == "Select" then
            if not MultiSelected:FindFirstChild(script.Parent.GUID.Value) then
                updateMultiScrapFrame()
            end
        else
            print(method)
            if MultiSelected:FindFirstChild(script.Parent.GUID.Value) then
                updateMultiScrapFrame()
            end
        end
    end
end)

---- Buttons ----

local ICONIMAGE_ORIGINALSIZE = IconButton.IconImage.Size

local function playClickSound()
    SoundService:PlayLocalSound(ClickSound)
end

local function iconHover()
    TweenButton:Grow(IconButtonImage, ICONIMAGE_ORIGINALSIZE)
end

local function iconLeave()
    TweenButton:Reset(IconButtonImage, ICONIMAGE_ORIGINALSIZE)
end

local function iconMouseDown()
    playClickSound()
    TweenButton:Shrink(IconButtonImage, ICONIMAGE_ORIGINALSIZE)
    if MultiScrap.Value == false then
        if UIVisible.Value == false or CurrentAccessory.Value ~= IconButton.Name then
            ScrapFrame:TweenPosition(UDim2.new(.05,0,.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
            InvFrame:TweenSizeAndPosition(UDim2.new(0.75,0,0.8,0), UDim2.new(0.575,0,0.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
            UIVisible.Value = true
        else
            ScrapFrame:TweenPosition(UDim2.new(.05,0,2,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
            InvFrame:TweenSizeAndPosition(UDim2.new(0.95,0,0.8,0), UDim2.new(0.5,0,0.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
            UIVisible.Value = false
        end
        updateScrapFrame()
    else
        updateMultiScrapFrame()
    end
end

local function iconMouseUp()
    TweenButton:Reset(IconButtonImage, ICONIMAGE_ORIGINALSIZE)
end

IconButton.ClickDetector.MouseEnter:Connect(iconHover)
IconButton.ClickDetector.MouseLeave:Connect(iconLeave)
IconButton.ClickDetector.MouseButton1Down:Connect(iconMouseDown)
IconButton.ClickDetector.MouseButton1Up:Connect(iconMouseUp)


