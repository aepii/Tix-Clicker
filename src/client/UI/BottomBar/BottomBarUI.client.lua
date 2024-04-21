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
local CaseInventory = UI.CaseInventory
local AccessoryInventory = UI.AccessoryInventory
local BottomBar = UI.BottomBar
local Toolbar = BottomBar.Toolbar
local XPHolder = BottomBar.XPHolder
local XPBar = XPHolder.XPBar

---- UI Values ----

local UIVisible = UI.UIVisible
local CurrentUI = UI.CurrentUI

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

local CaseButton = BottomBar.CaseButton.Icon
local CASEBUTTON_ORIGINALSIZE = CaseButton.Size

local AccessoryButton = BottomBar.AccessoryButton.Icon
local ACCESSORYBUTTON_ORIGINALSIZE = AccessoryButton.Size

local UIFrames = {
    TixInventory = TixInventory,
    CaseInventory = CaseInventory,
    AccessoryInventory = AccessoryInventory
}

local function playClickSound()
    SoundService:PlayLocalSound(ClickSound)
end

local function buttonBehavior(button, originalSize, inventory, uiValue)
    local function buttonHover()
        TweenButton:Grow(button, originalSize)
    end

    local function buttonLeave()
        TweenButton:Reset(button, originalSize)
    end

    local function buttonMouseDown()
        playClickSound()
        TweenButton:Shrink(button, originalSize)
        
        if CurrentUI.Value ~= uiValue then
            inventory:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
            local currentFrame = UIFrames[CurrentUI.Value]
            if currentFrame then
                currentFrame:TweenPosition(UDim2.new(0.5, 0, 2, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
            end
            CurrentUI.Value = uiValue
            UIVisible.Value = true
        else
            inventory:TweenPosition(UDim2.new(0.5, 0, 2, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
            CurrentUI.Value = ""
            UIVisible.Value = false
        end
    end

    local function buttonMouseUp()
        TweenButton:Reset(button, originalSize)
    end

    button.MouseEnter:Connect(buttonHover)
    button.MouseLeave:Connect(buttonLeave)
    button.MouseButton1Down:Connect(buttonMouseDown)
    button.MouseButton1Up:Connect(buttonMouseUp)
end

buttonBehavior(ToolButton, TOOLBUTTON_ORIGINALSIZE, TixInventory, "TixInventory")
buttonBehavior(CaseButton, CASEBUTTON_ORIGINALSIZE, CaseInventory, "CaseInventory")
buttonBehavior(AccessoryButton, ACCESSORYBUTTON_ORIGINALSIZE, AccessoryInventory, "AccessoryInventory")



