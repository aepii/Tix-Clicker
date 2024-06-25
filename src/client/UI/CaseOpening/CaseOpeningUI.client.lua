---- Services ----

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService") 

---- Modules ----

local Modules = ReplicatedStorage.Modules
local Cases = require(ReplicatedStorage.Data.Cases)
local Accessories = require(ReplicatedStorage.Data.Accessories)
local RarityColors = require(Modules.RarityColors)
local TixUIAnim = require(Modules.TixUIAnim)
local SuffixHandler = require(Modules.SuffixHandler)

---- Data ----

local TemporaryData = Player:WaitForChild("TemporaryData")
local CaseTime = TemporaryData.CaseTime

---- UI ----

local PlayerGui = Player.PlayerGui
local OpenUI = PlayerGui:WaitForChild("CaseOpenUI")
local UI = PlayerGui:WaitForChild("UI")
local VFX = UI:WaitForChild("VFX")

local CaseWinningFrame = OpenUI.CaseWinningFrame
local CaseOpeningFrame = OpenUI.CaseOpeningFrame
local ItemHolder = CaseOpeningFrame.ItemFrame.Holder
local IconCopy = ItemHolder.IconCopy

---- Sound ----

local Sounds = Player:WaitForChild("Sounds")
local ClickSound = Sounds:WaitForChild("ClickSound")
local RewardSound = Sounds:WaitForChild("RewardSound")
local PopSound = Sounds:WaitForChild("PopSound")

---- Networking ----

local Networking = ReplicatedStorage.Networking
local OpenCaseAnimRemote = Networking.OpenCaseAnim

---- Private Functions ----

local function applyColorTheme(caseID)
    
    local attributes = RarityColors.CaseColors[caseID]
    local affectedUI = CaseOpeningFrame

    for attribute, color in attributes do 
        local elements = game:GetService("CollectionService"):GetTagged(attribute)
        for _, element in elements do
            if element:IsDescendantOf(affectedUI) or element == affectedUI then
                if element:IsA("TextLabel") or element.Name == "Shadow" then
                    element.UIStroke.Color = color
                end
                if element:IsA("Frame") then
                    element.BackgroundColor3 = color
                end
            end
        end
    end
end

function confetti(rarity)
	local totalTime = 2 -- how many seconds it will run
	local confetti = Instance.new("Frame")
	confetti.Size = UDim2.new(0.08, 0, 0.125, 0)
	confetti.AnchorPoint = Vector2.new(0.5, 0.5)
	confetti.ZIndex = 100 -- change this to go over the black frame
	local rate = 30 -- how much confetti per second

	for _ = 1,rate*totalTime do
		local newConfetti = confetti:Clone()
        local randomNum = math.random(1,2)
		newConfetti.BackgroundColor3 = RarityColors:GetGradient(rarity).Keypoints[randomNum].Value 
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

function findRarityIndex(rarity, caseWeights)

    for k, v in pairs(caseWeights) do
        if v[1] == rarity then
            return k
        end
    end
    return nil
end

local function pickItemHelper(rarity, caseID)
    local matchingAccessories = {}
    for _, accessory in Accessories do
        if accessory.Rarity == rarity and findRarityIndex(rarity, Cases[caseID].Weights) then
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
            if string.sub(caseID, 1, 2) == "CC" then
                return Accessories[entry[1]]
            else
                return pickItemHelper(entry[1], caseID)
            end
        end
    end
end

local function showWinner(winner)
    SoundService:PlayLocalSound(RewardSound)
    CaseWinningFrame.Visible = true
    CaseWinningFrame:TweenSize(UDim2.new(0.5, 0, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.5, true)

    coroutine.wrap(function()
        confetti(winner.Rarity)
    end)()

    coroutine.wrap(function()
        local tweenInfo = TweenInfo.new(
                5, -- The time the tween takes to complete
                Enum.EasingStyle.Linear, -- The tween style.
                Enum.EasingDirection.Out, -- EasingDirection
                -1, -- How many times you want the tween to repeat. If you make it less than 0 it will repeat forever.
                false, -- Reverse?
                0 -- Delay
            )

        local Tween = TweenService:Create(CaseWinningFrame.Icon.Sunray, tweenInfo, {Rotation = 360}) 
        Tween:Play() 

        while CaseWinningFrame.Visible == true do

            CaseWinningFrame.Icon.Sunray:TweenSize(UDim2.new(1, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 1, true)
            CaseWinningFrame.Icon.IconImage:TweenSize(UDim2.new(1, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 1, true)
            CaseWinningFrame.Icon.Rarity:TweenPosition(UDim2.new(0.5, 0, 0.915, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .9, true)
            CaseWinningFrame.Icon.Title:TweenPosition(UDim2.new(0.5, 0, 0.8, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .85, true)
            CaseWinningFrame.Icon.Message:TweenPosition(UDim2.new(0.5, 0, 1.15, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .8, true)
            task.wait(0.5)
            CaseWinningFrame.Icon.Sunray:TweenSize(UDim2.new(2, 0, 2, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 1, true)
            CaseWinningFrame.Icon.IconImage:TweenSize(UDim2.new(1.5, 0, 1.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 1, true)
            CaseWinningFrame.Icon.Rarity:TweenPosition(UDim2.new(0.5, 0, 0.885, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .9, true)
            CaseWinningFrame.Icon.Title:TweenPosition(UDim2.new(0.5, 0, 0.770, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .85, true)
            CaseWinningFrame.Icon.Message:TweenPosition(UDim2.new(0.5, 0, 1.120, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .8, true)
            task.wait(0.5)
        end
        Tween:Cancel()
    end)()

    CaseWinningFrame.Icon.IconImage.Image = "http://www.roblox.com/Thumbs/Asset.ashx?Width=256&Height=256&AssetID="..winner.AssetID
    CaseWinningFrame.Icon.Title.Text = winner.Name 
    CaseWinningFrame.Icon.Rarity.Text = winner.Rarity

    local randomNum = math.random(1,2)

    CaseWinningFrame.Icon.Rarity.UIGradient.Color = RarityColors:GetGradient(winner.Rarity)
    CaseWinningFrame.Icon.Sunray.ImageColor3 = RarityColors:GetGradient(winner.Rarity).Keypoints[randomNum].Value 
    
    local Mouse = game.Players.LocalPlayer:GetMouse()
    Mouse.Button1Down:Wait()
    SoundService:PlayLocalSound(ClickSound)
    
    CaseWinningFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, 0.25, true)
    task.wait(0.25)
    CaseWinningFrame.Visible = false
    UI.Enabled = true
    if VFX.OtherVFX.Value == true then
        coroutine.wrap(function()
            TixUIAnim:Animate(Player, "ValueDetail", winner.Value, nil)
            SoundService:PlayLocalSound(PopSound)
        end)()
    end

    OpenCaseAnimRemote:FireServer()
end

local function populateCase(caseID, winner)
    applyColorTheme(caseID)
    CaseOpeningFrame:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.5, true)

    UI.Enabled = false

    local case = Cases[caseID]

    CaseOpeningFrame.TitleFrame.Title.Text = string.upper(case.Name)
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
        icon.ValueText.Text = "$"..SuffixHandler:Convert(item.Value)
        icon.Parent = ItemHolder
    end
    local tweenInfo = TweenInfo.new(
        CaseTime.Value, Enum.EasingStyle.Circular, Enum.EasingDirection.Out
    )

    local finishTweenInfo = TweenInfo.new(
        0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out
    )
    local lastPlayedElement = 0
    RunService:BindToRenderStep("SpinSound", 100, function()
        local currentElement = math.ceil((ItemHolder.Position.X.Scale) / 0.25)
        if lastPlayedElement ~= currentElement then
            lastPlayedElement = currentElement
            SoundService:PlayLocalSound(ClickSound)
        end
    end)

    local tween = TweenService:Create(ItemHolder, tweenInfo, {Position = UDim2.new(randomX, 0, 0.5, 0)})
    tween:Play()

    tween.Completed:Wait()
    local finishTween = TweenService:Create(ItemHolder, finishTweenInfo, {Position = UDim2.new(-20.125, 0, 0.5, 0)})
    task.wait(0.25)
    SoundService:PlayLocalSound(ClickSound)
    finishTween:Play()
    finishTween.Completed:Wait()
    task.wait(0.1)
    CaseOpeningFrame:TweenPosition(UDim2.new(0.5, 0, 2, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)

    for index, icon in ItemHolder:GetChildren() do
        if icon:IsA("Frame") and icon ~= IconCopy then
            icon:Destroy()
        end
    end
    RunService:UnbindFromRenderStep("SpinSound")
    showWinner(winner)
end

OpenCaseAnimRemote.OnClientEvent:Connect(function(caseID, winner)
    populateCase(caseID, winner)
end)
