---- Services ----

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService") 

---- Modules ----

local Modules = ReplicatedStorage.Modules
local Cases = require(ReplicatedStorage.Data.Cases)
local Accessories = require(ReplicatedStorage.Data.Accessories)
local RarityColors = require(Modules.RarityColors)

---- Data ----

local ReplicatedData = Player:WaitForChild("ReplicatedData")

---- UI ----

local PlayerGui = Player.PlayerGui
local OpenUI = PlayerGui:WaitForChild("CaseOpenUI")
local UI = PlayerGui:WaitForChild("UI")

local CaseInventory = UI.CaseInventory

local CaseWinningFrame = OpenUI.CaseWinningFrame
local CaseOpeningFrame = OpenUI.CaseOpeningFrame
local ItemHolder = CaseOpeningFrame.ItemFrame.Holder
local IconCopy = ItemHolder.IconCopy

local UIVisible = UI.UIVisible
local CurrentUI = UI.CurrentUI

---- Sound ----

local Sounds = Player:WaitForChild("Sounds")
local ClickSound = Sounds:WaitForChild("ClickSound")
local RewardSound = Sounds:WaitForChild("RewardSound")
local SpinSound = Sounds:WaitForChild("SpinSound")

---- Networking ----

local Networking = ReplicatedStorage.Networking
local OpenCaseAnimRemote = Networking.OpenCaseAnim

---- Private Functions ----

function confetti(rarity)
	local totalTime = 2 -- how many seconds it will run
	local confetti = Instance.new("Frame")
	confetti.Size = UDim2.new(0.08, 0, 0.125, 0)
	confetti.AnchorPoint = Vector2.new(0.5, 0.5)
	confetti.ZIndex = 100 -- change this to go over the black frame
	local rate = 30 -- how much confetti per second

	for _ = 1,rate*totalTime do
		local newConfetti = confetti:Clone()
		newConfetti.BackgroundColor3 = Color3.fromRGB(math.random(150,255), math.random(150,255), math.random(150,255)) -- random color that is not dark
		newConfetti.Position = UDim2.new(math.random(3,97)/100, 0, -0.1, 0)
		newConfetti.BorderSizePixel = 0
		newConfetti.Rotation = math.random(-360,360)
		newConfetti.Parent = CaseWinningFrame
		local randomLifetime = math.random(7,15)/10
		game:GetService("TweenService"):Create(newConfetti, TweenInfo.new(randomLifetime, Enum.EasingStyle.Linear), {Rotation = math.random(-360,360), Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(newConfetti.Position.X.Scale, 0, 1.1, 0)}):Play()
		game.Debris:AddItem(newConfetti, randomLifetime)
		wait(1/rate)
	end
end


local function pickItemHelper(rarity, caseID)
    local matchingAccessories = {}
    for _, accessory in Accessories do
        if accessory.Rarity == rarity and table.find(accessory.Cases, caseID) then
            table.insert(matchingAccessories, accessory)
        end
    end
    local randomIndex = math.random(1, #matchingAccessories)
    return matchingAccessories[randomIndex]
end

local function pickItem(caseID)
    local weights = Cases[caseID].Weights

    local totalWeight = 0
    for _, entry in weights do
        totalWeight = totalWeight + entry[2]
    end

    local randomNumber = math.random() * totalWeight

    local currentWeight = 0
    for _, entry in weights do
        currentWeight = currentWeight + entry[2]
        if currentWeight >= randomNumber then
            return pickItemHelper(entry[1], caseID)
        end
    end
end

local function showWinner(winner)
    SoundService:PlayLocalSound(RewardSound)
    CaseWinningFrame.Visible = true
    CaseWinningFrame:TweenSize(UDim2.new(0.5, 0, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.5, true)
    coroutine.wrap(function()
        while CaseWinningFrame.Visible == true do
            CaseWinningFrame.Icon.IconImage:TweenSize(UDim2.new(0.75, 0, 0.75, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 1, true)
            task.wait(0.5)
            CaseWinningFrame.Icon.IconImage:TweenSize(UDim2.new(1.25, 0, 1.25, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 1, true)
            task.wait(0.5)
        end
    end)()
    CaseWinningFrame.Icon.IconImage.Image = "http://www.roblox.com/Thumbs/Asset.ashx?Width=256&Height=256&AssetID="..winner.AssetID
    CaseWinningFrame.Icon.Title.Text = winner.Name 
    CaseWinningFrame.Icon.UIGradient.Color = RarityColors:GetGradient(winner.Rarity)
    confetti(winner.Rarity)
    task.wait(0.5)
    CaseWinningFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, 0.25, true)
    task.wait(0.25)
    CaseWinningFrame.Visible = false
    UI.Enabled = true
end

local function populateCase(caseID, winner)
    CaseOpeningFrame:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.5, true)

    UI.Enabled = false

    local case = Cases[caseID]

    CaseOpeningFrame.TitleFrame.Title.Text = case.Name
    ItemHolder.Position = UDim2.new(0.5, 0, 0.5, 0)

    local randomX = math.random(2001, 2024) / -100

    for i = 1, 90 do
        task.wait()
        local item;
        if i == 85 then
            item = winner
        else
            item = pickItem(caseID)
        end
        local icon = IconCopy:Clone()
        icon.Visible = true
        
        icon.Name = item.Name
        icon.IconImage.Image = "http://www.roblox.com/Thumbs/Asset.ashx?Width=256&Height=256&AssetID="..item.AssetID
        icon.UIGradient.Color = RarityColors:GetGradient(item.Rarity)
        icon.ValueText.Text = "$"..item.Value
        icon.Parent = ItemHolder
    end

    local tweenInfo = TweenInfo.new(
        5, Enum.EasingStyle.Circular, Enum.EasingDirection.Out
    )

    local finishTweenInfo = TweenInfo.new(
        0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out
    )

    local tween = TweenService:Create(ItemHolder, tweenInfo, {Position = UDim2.new(randomX, 0, 0.5, 0)})
    tween:Play()

    tween.Completed:Wait()
    task.wait(0.5)
    local finishTween = TweenService:Create(ItemHolder, finishTweenInfo, {Position = UDim2.new(-20.125, 0, 0.5, 0)})
    finishTween:Play()
    finishTween.Completed:Wait()
    task.wait(0.5)
    CaseOpeningFrame:TweenPosition(UDim2.new(0.5, 0, 2, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.5, true)

    for index, icon in ItemHolder:GetChildren() do
        if icon:IsA("Frame") and icon ~= IconCopy then
            icon:Destroy()
        end
    end

    showWinner(winner)
end

OpenCaseAnimRemote.OnClientEvent:Connect(function(caseID, winner)
    populateCase(caseID, winner)
end)
