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

---- UI ----

local IconButton = script.Parent
local IconButtonImage = IconButton.IconImage
local InvHolder = IconButton.Parent
local InvFrame = InvHolder.Parent
local ScrapMenu = InvFrame.Parent
local ScrapFrame = ScrapMenu.ScrapFrame
local IconImage = ScrapFrame.Icon.IconImage
local RewardsFrame = ScrapFrame.RewardsFrame
local RarityFrame = ScrapFrame.RarityFrame
local ScrapButton = ScrapFrame.ScrapButton

---- UI Values ----

local UIVisible = ScrapFrame.UIVisible
local CurrentAccessory = ScrapFrame.CurrentAccessory

---- Sound ----

local Sounds = Player:WaitForChild("Sounds")
local ClickSound = Sounds:WaitForChild("ClickSound")

---- Private Functions ----

local function updateScrapFrame()
    local GUID = script.Parent.Name
    local ID = Player.ReplicatedData.Accessories[GUID].Value
    local accessory = Accessories[ID]
    
    if InvFrame.Holder:FindFirstChild(CurrentAccessory.Value) then
        InvFrame.Holder[CurrentAccessory.Value].Shadow.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
    end

    if CurrentAccessory.Value == ID and UIVisible.Value == false then
        return
    end

    CurrentAccessory.Value = GUID

    local gradient = RarityColors:GetGradient(accessory.Rarity)

    for _, rewardFrame in RewardsFrame:GetChildren() do
        if rewardFrame:IsA("Frame") then
            local quantity, chanceToReceive, materialID = TemporaryData:CalculateMaterialInfo(Player, accessory.Value)
            local prefix = "x"
            rewardFrame.RewardText.UIGradient.Color = gradient
            rewardFrame.RewardText.Text = prefix  .. "0-" .. quantity
            rewardFrame.ChanceText.Text = chanceToReceive*100 .."%/drop"
            rewardFrame.RewardIcon.Image = Materials[materialID].Image
            rewardFrame.Visible = true
            rewardFrame.Parent = ScrapFrame.RewardsFrame
        end
    end

    RarityFrame.RarityText.UIGradient.Color = gradient
    RarityFrame.RarityText.Text = accessory.Rarity
    InvFrame.Holder[GUID].Shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ScrapFrame.ItemName.Title.Text = accessory.Name
    IconImage.Image = "http://www.roblox.com/Thumbs/Asset.ashx?Width=256&Height=256&AssetID="..accessory.AssetID

    --ButtonStatus:AccessoryInventory(Player, CurrentAccessory.Value, ScrapButton)
end

---- Buttons ----

local ICONIMAGE_ORIGINALSIZE = IconImage.Size

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
        ScrapFrame:TweenPosition(UDim2.new(0,0,.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        InvFrame:TweenSizeAndPosition(UDim2.new(0.75,0,0.8,0), UDim2.new(0.575,0,0.56,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        UIVisible.Value = true
    else
        ScrapFrame:TweenPosition(UDim2.new(0,0,2,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        InvFrame:TweenSizeAndPosition(UDim2.new(0.9,0,0.8,0), UDim2.new(0.5,0,0.56,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        UIVisible.Value = false
    end
    updateScrapFrame()
end

local function iconMouseUp()
    TweenButton:Reset(IconButtonImage, ICONIMAGE_ORIGINALSIZE)
end

IconButton.ClickDetector.MouseEnter:Connect(iconHover)
IconButton.ClickDetector.MouseLeave:Connect(iconLeave)
IconButton.ClickDetector.MouseButton1Down:Connect(iconMouseDown)
IconButton.ClickDetector.MouseButton1Up:Connect(iconMouseUp)


