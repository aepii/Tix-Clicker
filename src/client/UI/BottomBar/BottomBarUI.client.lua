---- Services ----

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TemporaryData = require(Modules.TemporaryData)
local TweenButton = require(Modules.TweenButton)

---- Data ----

local ReplicatedData = Player:WaitForChild("ReplicatedData")
local Level = ReplicatedData.Level
local XP = ReplicatedData.XP

---- UI ----

local PlayerGui = Player.PlayerGui
local UI = PlayerGui:WaitForChild("UI")

local TixInventory = UI.TixInventory
local BottomBar = UI.BottomBar
local Toolbar = BottomBar.Toolbar
local XPHolder = BottomBar.XPHolder
local XPBar = XPHolder.XPBar

---- Sound ----

local Sounds = Player:WaitForChild("Sounds")
local ClickSound = Sounds:WaitForChild("ClickSound")

---- Private Functions ----

local function animateXPBar()
    local requiredXP = TemporaryData:CalculateRequiredXP(Level.Value)
    XPHolder.Level.Text = "Level " .. Level.Value
	XPHolder.XPAmount.Text = XP.Value .. "/" .. requiredXP
    XPBar:TweenSize(UDim2.new((XP.Value/requiredXP)*0.95, 0, 0.7, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, 0.1, true)
end

XP.Changed:Connect(animateXPBar)
animateXPBar()

---- Buttons ----

local ToolButton = Toolbar.Tool
local TOOLBUTTON_ORIGINALSIZE = ToolButton.Size

local function playClickSound()
    SoundService:PlayLocalSound(ClickSound)
end

local function toolHover()
    TweenButton:Grow(ToolButton, TOOLBUTTON_ORIGINALSIZE)
end

local function toolLeave()
    TweenButton:Reset(ToolButton, TOOLBUTTON_ORIGINALSIZE)
end

local function toolMouseDown()
    playClickSound()
    TweenButton:Shrink(ToolButton, TOOLBUTTON_ORIGINALSIZE)
end

local function toolMouseUp()
    TweenButton:Reset(ToolButton, TOOLBUTTON_ORIGINALSIZE)
    TixInventory:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
end

ToolButton.MouseEnter:Connect(toolHover)
ToolButton.MouseLeave:Connect(toolLeave)
ToolButton.MouseButton1Down:Connect(toolMouseDown)
ToolButton.MouseButton1Up:Connect(toolMouseUp)

