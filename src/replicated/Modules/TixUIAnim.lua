---- Services ----

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService") 

---- Modules ----

local Modules = ReplicatedStorage.Modules
local SuffixHandler = require(Modules.SuffixHandler)
local RarityColors = require(Modules.RarityColors)

---- Tix Anim ----

local TixUIAnim = {}

function TixUIAnim:Animate(player, detail, value, valueData)
    
    local PlayerGui = player:WaitForChild("PlayerGui")
    local UI = PlayerGui:WaitForChild("UI")
    local details = UI:WaitForChild("EarningDetails")
    local detailClone = details:WaitForChild(detail)

    local detail = detailClone:Clone()
    detail.Parent = details

    detail.Visible = true
    detail.Size = UDim2.new(0, 0, 0, 0)
    
    if detail.Name == "TixDetail" then

        detail.Amount.Text = "+" .. SuffixHandler:Convert(value)
    
        local randomX = math.random(100, 900) / 1000
        local randomY = math.random(100, 900) / 1000
        
        detail.Rotation = math.random(270 - 50, 270 + 50)
        detail.Position = UDim2.new(randomX, 0, randomY, 0)
        
        detail:TweenSize(
            UDim2.new(0.04, 0, 0.1, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Elastic,
            0.5,
            true
        )
        
        wait(0.75)
        
        TweenService:Create(detail.Amount, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextSize = 0}):Play()
        detail:TweenSizeAndPosition(
            UDim2.new(0, 0, 0, 0),
            UDim2.new(0.965, 0, 0.35, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quint,
            1,
            true
        )
        
        wait(0.5)
        
        local statsDisplay = detail.Parent.Parent.Stats["1"]
        statsDisplay.Image:TweenSizeAndPosition(
            UDim2.new(0.5, 0, 1.5, 0),
            UDim2.new(0.7, 0, 0.5, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quint,
            0.05,
            true
        )
        
        wait(0.05)
        
        statsDisplay.Image:TweenSizeAndPosition(
            UDim2.new(0.5, 0, 1.25, 0),
            UDim2.new(0.7, 0, 0.5, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quint,
            0.05,
            true
        )
    elseif detail.Name == "TixCritDetail" then
        detail.Amount.Text = "+" .. SuffixHandler:Convert(value)
    
        local randomX = math.random(100, 900) / 1000
        local randomY = math.random(100, 900) / 1000
        
        detail.Rotation = math.random(270 - 50, 270 + 50)
        detail.Position = UDim2.new(randomX, 0, randomY, 0)
        
        detail:TweenSize(
            UDim2.new(0.06, 0, 0.15, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Elastic,
            0.5,
            true
        )
        
        wait(0.75)
        
        TweenService:Create(detail.Amount, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextSize = 0}):Play()
        detail:TweenSizeAndPosition(
            UDim2.new(0, 0, 0, 0),
            UDim2.new(0.965, 0, 0.35, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quint,
            1,
            true
        )
        
        wait(0.5)
        
        local statsDisplay = detail.Parent.Parent.Stats["1"]
        statsDisplay.Image:TweenSizeAndPosition(
            UDim2.new(0.5, 0, 1.5, 0),
            UDim2.new(0.7, 0, 0.5, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quint,
            0.05,
            true
        )
        
        wait(0.05)
        
        statsDisplay.Image:TweenSizeAndPosition(
            UDim2.new(0.5, 0, 1.25, 0),
            UDim2.new(0.7, 0, 0.5, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quint,
            0.05,
            true
        )
    elseif detail.Name == "NegateTixDetail" then
        detail.Amount.Text = "-" .. SuffixHandler:Convert(value)
    
        local randomX = math.random(400, 600) / 1000
        local randomY = math.random(400, 600) / 1000

        detail.Rotation = -45
        detail.Position = UDim2.new(0.965, 0, 0.35, 0)
        
        detail:TweenSize(
            UDim2.new(0.04, 0, 0.1, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Elastic,
            0.5,
            true
        )
        
        wait(0.75)
        
        TweenService:Create(detail.Amount, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextSize = 0}):Play()
        detail:TweenSizeAndPosition(
            UDim2.new(0, 0, 0, 0),
            UDim2.new(randomX, 0, randomY, 0), 
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quint,
            1,
            true
        )

        wait(0.5)
    elseif detail.Name == "RocashDetail" then
        detail.Amount.Text = "+" .. SuffixHandler:Convert(value)
        
        local randomX = math.random(400, 600) / 1000
        local randomY = math.random(400, 600) / 1000

        detail.Rotation = math.random(270 - 50, 270 + 50)
        detail.Position = UDim2.new(randomX, 0, randomY, 0)
        
        detail:TweenSizeAndPosition(
            UDim2.new(0.04, 0, 0.1, 0),
            UDim2.new(randomX, 0, randomX, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Elastic,
            0.5,
            true
        )
        
        wait(0.75)
        
        TweenService:Create(detail.Amount, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextSize = 0}):Play()
        detail:TweenSizeAndPosition(
            UDim2.new(0, 0, 0, 0),
            UDim2.new(0.965, 0, 0.45, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quint,
            1,
            true
        )
        
        wait(0.5)
        
        local statsDisplay = detail.Parent.Parent.Stats["2"]
        statsDisplay.Image:TweenSizeAndPosition(
            UDim2.new(0.5, 0, 1.5, 0),
            UDim2.new(0.7, 0, 0.5, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quint,
            0.05,
            true
        )
        
        wait(0.05)
        
        statsDisplay.Image:TweenSizeAndPosition(
            UDim2.new(0.5, 0, 1.25, 0),
            UDim2.new(0.7, 0, 0.5, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quint,
            0.05,
            true
        )
    elseif detail.Name == "NegateRocashDetail" then
        detail.Amount.Text = "-" .. SuffixHandler:Convert(value)
    
        local randomX = math.random(400, 600) / 1000
        local randomY = math.random(400, 600) / 1000

        detail.Rotation = -45
        detail.Position = UDim2.new(0.965, 0, 0.45, 0)
        
        detail:TweenSize(
            UDim2.new(0.04, 0, 0.1, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Elastic,
            0.5,
            true
        )
        
        wait(0.75)
        
        TweenService:Create(detail.Amount, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextSize = 0}):Play()
        detail:TweenSizeAndPosition(
            UDim2.new(0, 0, 0, 0),
            UDim2.new(randomX, 0, randomY, 0), 
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quint,
            1,
            true
        )

        wait(0.5)
    elseif detail.Name == "RebirthTixDetail" then
        detail.Amount.Text = "+" .. SuffixHandler:Convert(value)
        
        local randomX = math.random(400, 600) / 1000
        local randomY = math.random(400, 600) / 1000

        detail.Rotation = math.random(270 - 50, 270 + 50)
        detail.Position = UDim2.new(randomX, 0, randomY, 0)
        
        detail:TweenSizeAndPosition(
            UDim2.new(0.04, 0, 0.1, 0),
            UDim2.new(randomX, 0, randomX, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Elastic,
            0.5,
            true
        )
        
        wait(0.75)
        
        TweenService:Create(detail.Amount, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextSize = 0}):Play()
        detail:TweenSizeAndPosition(
            UDim2.new(0, 0, 0, 0),
            UDim2.new(0.965, 0, 0.55, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quint,
            1,
            true
        )
        
        wait(0.5)
        
        local statsDisplay = detail.Parent.Parent.Stats["3"]
        statsDisplay.Image:TweenSizeAndPosition(
            UDim2.new(0.5, 0, 1.5, 0),
            UDim2.new(0.7, 0, 0.5, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quint,
            0.05,
            true
        )
        
        wait(0.05)
        
        statsDisplay.Image:TweenSizeAndPosition(
            UDim2.new(0.5, 0, 1.25, 0),
            UDim2.new(0.7, 0, 0.5, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quint,
            0.05,
            true
        )
    elseif detail.Name == "NegateRebirthTixDetail" then
        detail.Amount.Text = "-" .. SuffixHandler:Convert(value)
    
        local randomX = math.random(400, 600) / 1000
        local randomY = math.random(400, 600) / 1000

        detail.Rotation = -45
        detail.Position = UDim2.new(0.965, 0, 0.55, 0)
        
        detail:TweenSize(
            UDim2.new(0.04, 0, 0.1, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Elastic,
            0.5,
            true
        )
        
        wait(0.75)
        
        TweenService:Create(detail.Amount, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextSize = 0}):Play()
        detail:TweenSizeAndPosition(
            UDim2.new(0, 0, 0, 0),
            UDim2.new(randomX, 0, randomY, 0), 
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quint,
            1,
            true
        )

        wait(0.5)
    elseif detail.Name == "ValueDetail" then
        detail.Amount.Text = "+" .. SuffixHandler:Convert(value)
        
        local randomX = math.random(400, 600) / 1000
        local randomY = math.random(400, 600) / 1000

        detail.Rotation = math.random(0 - 50, 0 + 50)
        detail.Position = UDim2.new(randomX, 0, randomY, 0)
        
        detail:TweenSizeAndPosition(
            UDim2.new(0.04, 0, 0.1, 0),
            UDim2.new(randomX, 0, randomX, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Elastic,
            0.5,
            true
        )
        
        wait(0.75)
        
        TweenService:Create(detail.Amount, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextSize = 0}):Play()
        detail:TweenSizeAndPosition(
            UDim2.new(0, 0, 0, 0),
            UDim2.new(0.965, 0, 0.65, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quint,
            1,
            true
        )
        
        wait(0.5)
        
        local statsDisplay = detail.Parent.Parent.Stats["4"]
        statsDisplay.Image:TweenSizeAndPosition(
            UDim2.new(0.5, 0, 1.25, 0),
            UDim2.new(0.7, 0, 0.5, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quint,
            0.05,
            true
        )
        
        wait(0.05)
        
        statsDisplay.Image:TweenSizeAndPosition(
            UDim2.new(0.5, 0, 1, 0),
            UDim2.new(0.7, 0, 0.5, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quint,
            0.05,
            true
        )
    elseif detail.Name == "NegateValueDetail" then
        detail.Amount.Text = "-" .. SuffixHandler:Convert(value)
    
        local randomX = math.random(400, 600) / 1000
        local randomY = math.random(400, 600) / 1000

        detail.Rotation = -45
        detail.Position = UDim2.new(0.965, 0, 0.65, 0)
        
        detail:TweenSize(
            UDim2.new(0.04, 0, 0.1, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Elastic,
            0.5,
            true
        )
        
        wait(0.75)
        
        TweenService:Create(detail.Amount, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextSize = 0}):Play()
        detail:TweenSizeAndPosition(
            UDim2.new(0, 0, 0, 0),
            UDim2.new(randomX, 0, randomY, 0), 
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quint,
            1,
            true
        )

        wait(0.5)
    elseif detail.Name == "MaterialDetail" then
        local tweenPosition;

        detail.Amount.Text = "+" .. SuffixHandler:Convert(value)
        detail.Image = valueData.Image
        detail.Amount.UIGradient.Color = RarityColors:GetGradient(valueData.Rarity)
        
        local randomX = math.random(400, 600) / 1000
        local randomY = math.random(400, 600) / 1000
        
        detail.Rotation = math.random(270 - 50, 270 + 50)
        detail.Position = UDim2.new(randomX, 0, randomY, 0)
        
        detail:TweenSize(
            UDim2.new(0.04, 0, 0.1, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Elastic,
            0.5,
            true
        )
        
        wait(0.75)
        
        local statsDisplay = detail.Parent.Parent.MaterialStats.MaterialsFrame.MaterialsHolder:FindFirstChild(valueData.ID)
        if statsDisplay then
            tweenPosition = UDim2.new(0, statsDisplay.AbsolutePosition.X, 0, statsDisplay.AbsolutePosition.Y)
        else
            tweenPosition = UDim2.new(0.965, 0, 0.965, 0)
        end

        TweenService:Create(detail.Amount, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextSize = 0}):Play()
        detail:TweenSizeAndPosition(
            UDim2.new(0, 0, 0, 0),
            tweenPosition,
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quint,
            1,
            true
        )
        
        wait(0.5)
        
        if statsDisplay then
            statsDisplay.IconImage:TweenSize(
                UDim2.new(1.25, 0, 1.25, 0),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quint,
                0.05,
                true
            )
            
            wait(0.05)

            statsDisplay.IconImage:TweenSize(
                UDim2.new(1, 0, 1, 0),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quint,
                0.05,
                true
            )
        end    
    elseif detail.Name == "NegateMaterialDetail" then
        detail.Amount.Text = "-" .. SuffixHandler:Convert(value)
        detail.Image = valueData.Image
        detail.Amount.UIGradient.Color = RarityColors:GetGradient(valueData.Rarity)
    
        local randomX = math.random(400, 600) / 1000
        local randomY = math.random(400, 600) / 1000

        local statsDisplay = detail.Parent.Parent.MaterialStats.MaterialsFrame.MaterialsHolder:FindFirstChild(valueData.ID)
        if statsDisplay then
            detail.Position = UDim2.new(0, statsDisplay.AbsolutePosition.X, 0, statsDisplay.AbsolutePosition.Y)
        else
            detail.Position = UDim2.new(0.965, 0, 0.965, 0)
        end
        
        detail:TweenSize(
            UDim2.new(0.04, 0, 0.1, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Elastic,
            0.5,
            true
        )
        
        wait(0.75)
        
        TweenService:Create(detail.Amount, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextSize = 0}):Play()
        detail:TweenSizeAndPosition(
            UDim2.new(0, 0, 0, 0),
            UDim2.new(randomX, 0, randomY, 0), 
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quint,
            1,
            true
        )

        wait(0.5)
    end
    
    detail.Amount.Visible = false    
    detail:Destroy()
end

return TixUIAnim