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
local TemporaryData = require(Modules.TemporaryData)

---- UI ----

local IconButton = script.Parent
local IconButtonImage = IconButton.IconImage
local InvHolder = IconButton.Parent
local InvFrame = InvHolder.Parent
local AccessoryInventory = InvFrame.Parent
local EquipFrame = AccessoryInventory.EquipFrame
local IconImage = EquipFrame.Icon.IconImage
local RewardsFrame = EquipFrame.RewardsFrame
local RarityText = EquipFrame.Rarity
local EquipButton = EquipFrame.EquipButton

---- UI Values ----

local UIVisible = EquipFrame.UIVisible
local CurrentAccessory = EquipFrame.CurrentAccessory

local GUID = IconButton.GUID

---- Sound ----

local Sounds = Player:WaitForChild("Sounds")
local ClickSound = Sounds:WaitForChild("ClickSound")

---- Networking ----

local Networking = ReplicatedStorage.Networking

---- Private Functions ----

local function updateEquipFrame()
    local ID = Player.ReplicatedData.Accessories[GUID.Value].Value
    local accessory = Accessories[ID]
    
    local taggedName = TemporaryData:CalculateTag(Player, GUID.Value)

    if InvFrame.Holder:FindFirstChild(CurrentAccessory.Value) then
        InvFrame.Holder[CurrentAccessory.Value].Shadow.BackgroundColor3 = Color3.fromRGB(0, 83, 125)
    end

    if CurrentAccessory.Value == taggedName and UIVisible.Value == false then
        return
    end

    CurrentAccessory.Value = taggedName

    for _, rewardFrame in RewardsFrame:GetChildren() do
        if rewardFrame:IsA("Frame") then
            local reward = accessory.Reward[rewardFrame.Name]
            if reward then
                local prefix = string.find(rewardFrame.Name, "Add") and "+" or "x"
                rewardFrame.RewardText.Text = prefix .. SuffixHandler:Convert(reward)
                rewardFrame.Visible = true
                rewardFrame.Parent = EquipFrame.RewardsFrame
            else
                rewardFrame.Visible = false
            end
        end
    end

    RarityText.Text = accessory.Rarity
    RarityText.UIGradient.Color = RarityColors:GetGradient(accessory.Rarity)
    InvFrame.Holder[taggedName].Shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    EquipFrame.ItemName.Title.Text = accessory.Name
    EquipFrame.Icon.UIGradient.Color = RarityColors:GetGradient(accessory.Rarity)
    IconImage.Image = "http://www.roblox.com/Thumbs/Asset.ashx?Width=256&Height=256&AssetID="..accessory.AssetID

    ButtonStatus:AccessoryInventory(Player, GUID.Value, EquipButton)
end

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
    if UIVisible.Value == false or CurrentAccessory.Value ~= IconButton.Name then
        EquipFrame:TweenPosition(UDim2.new(0.05,0,.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        InvFrame:TweenSizeAndPosition(UDim2.new(0.75,0,0.8,0), UDim2.new(0.575,0,0.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        UIVisible.Value = true
    else
        EquipFrame:TweenPosition(UDim2.new(.05,0,2,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        InvFrame:TweenSizeAndPosition(UDim2.new(0.95,0,0.8,0), UDim2.new(0.5,0,0.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        UIVisible.Value = false
    end
    updateEquipFrame()
end

local function iconMouseUp()
    TweenButton:Reset(IconButtonImage, ICONIMAGE_ORIGINALSIZE)
end

IconButton.ClickDetector.MouseEnter:Connect(iconHover)
IconButton.ClickDetector.MouseLeave:Connect(iconLeave)
IconButton.ClickDetector.MouseButton1Down:Connect(iconMouseDown)
IconButton.ClickDetector.MouseButton1Up:Connect(iconMouseUp)


