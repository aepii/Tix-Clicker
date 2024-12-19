local CaseOpeningUI = {}

function CaseOpeningUI:Init()
    ---- Services ----

    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local SoundService = game:GetService("SoundService")
    local TweenService = game:GetService("TweenService") 

    ---- Modules ----

    local Modules = ReplicatedStorage.Modules
    local TemporaryData = require(Modules.TemporaryData)
    local Cases = require(ReplicatedStorage.Data.Cases)
    local Accessories = require(ReplicatedStorage.Data.Accessories)
    local RarityColors = require(Modules.RarityColors)
    local TixUIAnim = require(Modules.TixUIAnim)
    local SuffixHandler = require(Modules.SuffixHandler)
    local TweenButton = require(Modules.TweenButton)

    ---- Data ----

    local ReplicatedTemporaryData = Player:WaitForChild("TemporaryData")
    local CaseTime = ReplicatedTemporaryData.CaseTime

    ---- UI ----

    local PlayerGui = Player.PlayerGui
    local OpenUI = PlayerGui:WaitForChild("CaseOpenUI")
    local UI = PlayerGui:WaitForChild("UI")
    local VFX = UI:WaitForChild("VFX")

    local CaseWinningFrame = OpenUI.CaseWinningFrame
    local CaseScroll = OpenUI.CaseScroll
    local Message = OpenUI.Message
    local CaseOpeningFrameCopy = CaseScroll.CaseOpeningFrameCopy
    local IconCopy = CaseWinningFrame.IconCopy

    local AutoOpen = UI.CaseInventory.AutoOpen

    ---- Sound ----

    local Sounds = Player:WaitForChild("Sounds")
    local ClickSound = Sounds:WaitForChild("ClickSound")
    local RewardSound = Sounds:WaitForChild("RewardSound")
    local PopSound = Sounds:WaitForChild("PopSound")

    ---- Networking ----

    local Networking = ReplicatedStorage.Networking
    local OpenCaseAnimRemote = Networking.OpenCaseAnim

    ---- Private Functions ----

    local function applyColorTheme(caseID, CaseOpeningFrame)
        
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
                    if element:IsA("UIStroke") then
                        element.Color = color
                        print(element.Thickness)
                    end
                end
            end
        end
    end

    function confetti(rarity, copy)
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
            newConfetti.Parent = copy
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
        local totalWeight = TemporaryData:GetTotalWeight(Player, caseID)
        local weights = Cases[caseID].Weights

        local randomNumber = math.random() * totalWeight

        local currentWeight = 0
        for index, entry in weights do
            currentWeight += TemporaryData:ApplyLuck(Player, entry[2], index, #weights)
            if currentWeight >= randomNumber then
                if string.sub(caseID, 1, 2) == "CC" then
                    return Accessories[entry[1]]
                else
                    return pickItemHelper(entry[1], caseID)
                end
            end
        end
    end

    local function showWinners(winners)
        SoundService:PlayLocalSound(RewardSound)
        CaseWinningFrame.Visible = true
        CaseWinningFrame:TweenSize(UDim2.new(0.5, 0, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.5, true)

        local totalValue = 0
        for item, count in winners do
            spawn(function()

                local item = Accessories[item]
                totalValue += item.Value
                local Icon = IconCopy:Clone()
                Icon.Name = item.ID
                Icon.Visible = true
                Icon.Parent = CaseWinningFrame 

                coroutine.wrap(function()
                    confetti(item.Rarity, Icon)
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
            
                    local Tween = TweenService:Create(Icon.Sunray, tweenInfo, {Rotation = 360}) 
                    Tween:Play() 
            
                    while CaseWinningFrame.Visible == true do
                        if not CaseWinningFrame:FindFirstChild(item.ID) then break end
                        Icon.Sunray:TweenSize(UDim2.new(1, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 1, true)
                        Icon.IconImage:TweenSize(UDim2.new(1, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 1, true)
                        Icon.Rarity:TweenPosition(UDim2.new(0.5, 0, 0.915, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .9, true)
                        Icon.Title:TweenPosition(UDim2.new(0.5, 0, 0.8, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .85, true)
                        task.wait(0.5)
                        if not CaseWinningFrame:FindFirstChild(item.ID) then break end
                        Icon.Sunray:TweenSize(UDim2.new(2, 0, 2, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 1, true)
                        Icon.IconImage:TweenSize(UDim2.new(1.5, 0, 1.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 1, true)
                        Icon.Rarity:TweenPosition(UDim2.new(0.5, 0, 0.885, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .9, true)
                        Icon.Title:TweenPosition(UDim2.new(0.5, 0, 0.770, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .85, true)
                        task.wait(0.5)
                    end
                    Tween:Cancel()
                end)()


                Icon.IconImage.Image = "http://www.roblox.com/Thumbs/Asset.ashx?Width=256&Height=256&AssetID="..item.AssetID
                Icon.Title.Text = item.Name 
                Icon.Rarity.Text = item.Rarity

                if count > 1 then
                    Icon.Copies.Visible = true
                    Icon.Copies.Text = "x"..count
                end
                
                local randomNum = math.random(1,2)

                local Color = RarityColors:GetGradient(item.Rarity)
            
                Icon.Rarity.UIGradient.Color = Color
                Icon.Sunray.ImageColor3 = Color.Keypoints[randomNum].Value 
            end)
        end

        if AutoOpen.Value == false then
            Message:TweenPosition(UDim2.new(0.5, 0, 0.925, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, .25, true)
            local Mouse = game.Players.LocalPlayer:GetMouse()
            Mouse.Button1Down:Wait()
            SoundService:PlayLocalSound(ClickSound)
        end
        Message:TweenPosition(UDim2.new(0.5, 0, 2, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, .25, true)
        CaseWinningFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, 0.25, true)
        task.wait(0.25)
        CaseWinningFrame.Visible = false
    
        UI.Enabled = true
        if VFX.OtherVFX.Value == true then
            coroutine.wrap(function()
                TixUIAnim:Animate(Player, "ValueDetail", totalValue, nil)
                SoundService:PlayLocalSound(PopSound)
            end)()
        end

        OpenUI.Enabled = false
    end

    local function populateCase(caseID, winner, copy)

        local CaseOpeningFrame = copy
        local ItemHolder = CaseOpeningFrame.ItemFrame.Holder
        local IconCopy = ItemHolder.IconCopy

        OpenUI.Enabled = true
        applyColorTheme(caseID, CaseOpeningFrame)

        CaseScroll:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.5, true)

        UI.Enabled = false

        local case = Cases[caseID]

        CaseOpeningFrame.TitleFrame.Title.Text = string.upper(case.Name)
        ItemHolder.Position = UDim2.new(0.5, 0, 0.5, 0)

        local randomX = math.random(2001, 2024) / -100

        for i = 1, 90 do
            task.wait()
            local item;
            if i == 85 then
                item = Accessories[winner]
            else
                item = pickItem(caseID)
            end
            local icon = IconCopy:Clone()
            icon.Visible = true
            
            icon.Name = item.Name
            icon.IconImage.Image = "http://www.roblox.com/Thumbs/Asset.ashx?Width=256&Height=256&AssetID="..item.AssetID
            icon.UIGradient.Color = RarityColors:GetGradient(item.Rarity)
            if string.sub(item.ID, 1, 2) == "CA" then
                icon.ValueText.Visible = false
                icon.MultiText.Visible = true
                icon.MultiText.Text = "x"..SuffixHandler:Convert(item.Reward["Best"])
            else
                icon.ValueText.Visible = true
                icon.MultiText.Visible = false
                icon.ValueText.Text = "$"..SuffixHandler:Convert(item.Value)
            end
            
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
        CaseScroll:TweenPosition(UDim2.new(0.5, 0, 2, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        task.wait(.1)
        CaseOpeningFrame:Destroy()
    end

    OpenCaseAnimRemote.OnClientEvent:Connect(function(caseID, items)
        local totalCopies = 0
        local completedCopies = 0
        local shouldComplete = false

        for item, count in pairs(items) do
            totalCopies = totalCopies + count
        end

        for item, count in pairs(items) do
            for i = 1, count do
                spawn(function()
                    local copy = CaseOpeningFrameCopy:Clone()
                    copy.Visible = true
                    copy.Parent = CaseScroll     
                    populateCase(caseID, item, copy)           
                    completedCopies = completedCopies + 1

                    if completedCopies == totalCopies then
                        shouldComplete = true
                    end
                end)
            end
        end

        if totalCopies <= 2 then
            -- Adjust CaseScroll settings for fewer copies
            CaseScroll.UIGridLayout.VerticalAlignment = "Center"
            CaseScroll.UIGridLayout.CellSize = UDim2.new(0.75, 0, 0.5, 0)
            CaseScroll.UIGridLayout.CellPadding = UDim2.new(0, 0, 0, 0)
        
            -- Adjust CaseWinningFrame settings based on totalCopies
            CaseWinningFrame.UIGridLayout.CellSize = UDim2.new(0.5, 0, 1, 0)
            CaseWinningFrame.UIGridLayout.CellPadding = UDim2.new(0.15, 0, 0, 0)
        elseif totalCopies == 3 then
            -- Adjust CaseScroll settings for medium number of copies
            CaseScroll.UIGridLayout.VerticalAlignment = "Top"
            CaseScroll.UIGridLayout.CellSize = UDim2.new(0.75, 0, 0.3, 0)
            CaseScroll.UIGridLayout.CellPadding = UDim2.new(0, 0, 0.075, 0)
        
            -- Adjust CaseWinningFrame settings
            CaseWinningFrame.UIGridLayout.CellSize = UDim2.new(0.5, 0, 1, 0)
            CaseWinningFrame.UIGridLayout.CellPadding = UDim2.new(0.15, 0, 0, 0)

        elseif totalCopies >= 4 and totalCopies <= 6 then
            -- Adjust CaseScroll settings for medium number of copies
            CaseScroll.UIGridLayout.VerticalAlignment = "Top"
            CaseScroll.UIGridLayout.CellSize = UDim2.new(0.75, 0, 0.3, 0)
            CaseScroll.UIGridLayout.CellPadding = UDim2.new(0, 0, 0.075, 0)
        
            -- Adjust CaseWinningFrame settings
            CaseWinningFrame.UIGridLayout.CellSize = UDim2.new(0.5, 0, 0.5, 0)
            CaseWinningFrame.UIGridLayout.CellPadding = UDim2.new(0.15, 0, 0, 0)
        
        elseif totalCopies >= 7 and totalCopies <= 8 then
            -- Adjust CaseScroll settings for higher number of copies
            CaseScroll.UIGridLayout.VerticalAlignment = "Top"
            CaseScroll.UIGridLayout.CellSize = UDim2.new(0.75, 0, 0.3, 0)
            CaseScroll.UIGridLayout.CellPadding = UDim2.new(0, 0, 0.075, 0)
        
            -- Adjust CaseWinningFrame settings
            CaseWinningFrame.UIGridLayout.CellSize = UDim2.new(0.35, 0, 0.35, 0)
            CaseWinningFrame.UIGridLayout.CellPadding = UDim2.new(0.15, 0, 0, 0)
        
        elseif totalCopies == 9 then
            -- Adjust CaseScroll settings for specific number of copies
            CaseScroll.UIGridLayout.VerticalAlignment = "Top"
            CaseScroll.UIGridLayout.CellSize = UDim2.new(0.75, 0, 0.3, 0)
            CaseScroll.UIGridLayout.CellPadding = UDim2.new(0, 0, 0.075, 0)
        
            -- Adjust CaseWinningFrame settings
            CaseWinningFrame.UIGridLayout.CellSize = UDim2.new(0.33, 0, 0.33, 0)
            CaseWinningFrame.UIGridLayout.CellPadding = UDim2.new(0.15, 0, 0, 0)
        
        elseif totalCopies == 10 then
            -- Adjust CaseScroll settings for specific number of copies
            CaseScroll.UIGridLayout.VerticalAlignment = "Top"
            CaseScroll.UIGridLayout.CellSize = UDim2.new(0.75, 0, 0.3, 0)
            CaseScroll.UIGridLayout.CellPadding = UDim2.new(0, 0, 0.075, 0)
        
            -- Adjust CaseWinningFrame settings
            CaseWinningFrame.UIGridLayout.CellSize = UDim2.new(0.25, 0, 0.35, 0)
            CaseWinningFrame.UIGridLayout.CellPadding = UDim2.new(0.15, 0, 0, 0)
        end
        

        spawn(function()
            while task.wait() and not shouldComplete do end
            RunService:UnbindFromRenderStep("SpinSound")
            showWinners(items)
            for _, icon in CaseWinningFrame:GetChildren() do
                if icon:IsA("Frame") and icon ~= IconCopy then
                    icon:Destroy()
                end
            end
            OpenCaseAnimRemote:FireServer()
        end)
    end)


    ---- Buttons ----

    local CancelAutoOpenButton = OpenUI.CancelAutoOpenButton
    local CANCELAUTOOPENBUTTON_ORIGINALSIZE = CancelAutoOpenButton.Size

    local function playClickSound()
        SoundService:PlayLocalSound(ClickSound)
    end

    local function cancelCancelAutoOpenHover()
        TweenButton:Grow(CancelAutoOpenButton, CANCELAUTOOPENBUTTON_ORIGINALSIZE)
    end

    local function cancelCancelAutoOpenLeave()
        TweenButton:Reset(CancelAutoOpenButton, CANCELAUTOOPENBUTTON_ORIGINALSIZE)
    end

    local function cancelCancelAutoOpenMouseDown()
        playClickSound()
        TweenButton:Shrink(CancelAutoOpenButton, CANCELAUTOOPENBUTTON_ORIGINALSIZE)
        CancelAutoOpenButton.Visible = false
        AutoOpen.Value = false
    end

    local function cancelCancelAutoOpenMouseUp()
        TweenButton:Reset(CancelAutoOpenButton, CANCELAUTOOPENBUTTON_ORIGINALSIZE)
    end

    CancelAutoOpenButton.ClickDetector.MouseEnter:Connect(cancelCancelAutoOpenHover)
    CancelAutoOpenButton.ClickDetector.MouseLeave:Connect(cancelCancelAutoOpenLeave)
    CancelAutoOpenButton.ClickDetector.MouseButton1Down:Connect(cancelCancelAutoOpenMouseDown)
    CancelAutoOpenButton.ClickDetector.MouseButton1Up:Connect(cancelCancelAutoOpenMouseUp)

end

return CaseOpeningUI