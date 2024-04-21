---- Services ----

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TweenButton = require(Modules.TweenButton)
local Cases = require(ReplicatedStorage.Data.Cases)
local RarityColors = require(Modules.RarityColors)

---- UI ----

local IconButton = script.Parent
local IconButtonImage = IconButton.IconImage
local InvHolder = IconButton.Parent
local InvFrame = InvHolder.Parent
local TixInventory = InvFrame.Parent
local OpenFrame = TixInventory.OpenFrame
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

local function populateCaseRarity(weights, rewardsFrame)
    local i;
    for index, data in weights do
        local gradient = RarityColors:GetGradient(data[1])
        rewardsFrame[index].ChanceText.Text = data[2] .. "%"
        rewardsFrame[index].RarityText.Text = data[1]
        rewardsFrame[index].Visible = true
        rewardsFrame[index].RarityText.UIGradient.Color = gradient
        rewardsFrame[index].ChanceText.UIGradient.Color = gradient
        i = index
    end
    for count = i+1, 5 do
        rewardsFrame[count].Visible = false
    end
end

local function updateEquipFrame()
    local caseName = script.Parent.Name
    local case = Cases[caseName]
    
    if InvFrame.Holder:FindFirstChild(CurrentCase.Value) then
        InvFrame.Holder[CurrentCase.Value].Shadow.BackgroundColor3 = Color3.fromRGB(0, 83, 125)
    end

    if CurrentCase.Value == caseName and UIVisible.Value == false then
        return
    end

    CurrentCase.Value = caseName
    populateCaseRarity(case.Weights, RewardsFrame)
    InvFrame.Holder[caseName].Shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    OpenFrame.ItemName.Title.Text = case.Title
    IconImage.Image = case.Image
    local ownedValue = Player.ReplicatedData.Cases:FindFirstChild(caseName) and Player.ReplicatedData.Cases[caseName].Value or 0
    OwnedFrame.Owned.Text = "Owned " .. ownedValue  

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
    if UIVisible.Value == false or CurrentCase.Value ~= IconButton.Name then
        OpenFrame:TweenPosition(UDim2.new(0,0,.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        InvFrame:TweenSizeAndPosition(UDim2.new(0.75,0,0.8,0), UDim2.new(0.575,0,0.56,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        UIVisible.Value = true
    else
        OpenFrame:TweenPosition(UDim2.new(0,0,2,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        InvFrame:TweenSizeAndPosition(UDim2.new(0.9,0,0.8,0), UDim2.new(0.5,0,0.56,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
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


