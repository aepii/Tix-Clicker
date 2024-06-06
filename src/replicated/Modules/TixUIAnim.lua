---- Services ----

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService") 

---- Modules ----

local Modules = ReplicatedStorage.Modules
local SuffixHandler = require(Modules.SuffixHandler)

---- Tix Anim ----

local TixUIAnim = {}

function TixUIAnim:Animate(player, detail, value)
    
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
            UDim2.new(0.965, 0, 0.4, 0),
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
        detail.Position = UDim2.new(0.965, 0, 0.4, 0)
        
        detail:TweenSize(
            UDim2.new(0.04, 0, 0.1, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Elastic,
            0.5,
            true
        )
        
        wait(0.75)
        
        TweenService:Create(detail.Amount, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextSize = 0}):Play()
        detail:TweenSize(
            UDim2.new(0, 0, 0, 0),
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
            UDim2.new(0.965, 0, 0.5, 0),
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
    end
    
    detail.Amount.Visible = false    
    detail:Destroy()
end

return TixUIAnim