---- Services ----

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local CollectionService = game:GetService("CollectionService")

---- Data ----

local CollectibleAccessories = require(ReplicatedStorage.Data.CollectibleAccessories)

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TweenButton = require(Modules.TweenButton)
local ButtonStatus = require(Modules.ButtonStatus)
local CollectibleCases = require(ReplicatedStorage.Data.CollectibleCases)

---- UI ----

local IconButton = script.Parent
local IconButtonImage = IconButton.IconImage
local InvHolder = IconButton.Parent
local InvFrame = InvHolder.Parent
local CaseInventory = InvFrame.Parent
local OpenFrame = CaseInventory.CollectibleOpenFrame
local IconImage = OpenFrame.Icon.IconImage
local RewardsFrame = OpenFrame.RewardsFrame
local OpenButton = OpenFrame.OpenButton
local OwnedFrame = OpenFrame.OwnedFrame

---- UI Values ----

local UIVisible = OpenFrame.UIVisible
local CurrentCase = OpenFrame.CurrentCase

---- Sound ----

local Sounds = Player:WaitForChild("Sounds")
local ClickSound = Sounds:WaitForChild("ClickSound")

---- Private Functions ----

local function populateCaseItems(weights, rewardsFrame)

    local InvFrame = rewardsFrame.InvFrame
    local Holder = InvFrame.Holder
    local IconCopy = Holder.IconCopy

    for index, icon in Holder:GetChildren() do
        if icon:IsA("Frame") and icon ~= IconCopy then
            icon:Destroy()
        end
    end

    for index, data in weights do
        local icon = IconCopy:Clone()
        icon.Name = data[1]
        icon.ChanceFrame.ChanceText.Text = data[2] / 1000 .. "%"
        icon.IconImage.Image = "http://www.roblox.com/Thumbs/Asset.ashx?Width=256&Height=256&AssetID=" .. CollectibleAccessories[data[1]].AssetID
        icon.Visible = true
        CollectionService:RemoveTag(icon.Shadow.UIStroke, "Ignore")
        CollectionService:RemoveTag(icon.ChanceFrame.ChanceText.UIStroke, "Ignore")
        icon.Parent = Holder
    end
end
local function updateEquipFrame()
    local caseID = script.Parent.Name
    local case = CollectibleCases[caseID]
    
    if InvFrame.Holder:FindFirstChild(CurrentCase.Value) then
        InvFrame.Holder[CurrentCase.Value].Shadow.BackgroundColor3 = Color3.fromRGB(0, 83, 125)
    end

    if CurrentCase.Value == caseID and UIVisible.Value == false then
        return
    end

    CurrentCase.Value = caseID
    populateCaseItems(case.Weights, RewardsFrame)
    InvFrame.Holder[caseID].Shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    OpenFrame.ItemName.Title.Text = case.Name
    IconImage.Image = case.Image
    local ownedValue = Player.ReplicatedData.CollectibleCases:FindFirstChild(caseID) and Player.ReplicatedData.CollectibleCases[caseID].Value or 0
    OwnedFrame.Owned.Text = "Owned " .. ownedValue  

    ButtonStatus:CollectibleCaseInventory(Player, caseID, OpenButton)
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
    if UIVisible.Value == false or CurrentCase.Value ~= IconButton.Name then
        OpenFrame:TweenPosition(UDim2.new(.05,0,.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        InvFrame:TweenSizeAndPosition(UDim2.new(0.75,0,0.8,0), UDim2.new(0.575,0,0.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        UIVisible.Value = true
    else
        OpenFrame:TweenPosition(UDim2.new(.05,0,2,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
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


