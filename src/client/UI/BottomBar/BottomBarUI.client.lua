---- Services ----

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TweenButton = require(Modules.TweenButton)
local Upgrades = require(ReplicatedStorage.Data.Upgrades)

---- Data ----

local ReplicatedData = Player:WaitForChild("ReplicatedData")
local TemporaryData = Player:WaitForChild("TemporaryData")
local ToolEquipped = ReplicatedData.ToolEquipped
local XP = TemporaryData.XP
local requiredXP = TemporaryData.RequiredXP

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
    XPBar:TweenSize(UDim2.new(math.min((XP.Value/requiredXP.Value)*0.95, 0.95), 0, 0.7, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, 0.1, true)
    
end

XP.Changed:Connect(animateXPBar)
animateXPBar()

local function changeToolButton()
    Toolbar.Tool.Image = Upgrades[ToolEquipped.Value].Image
end

ToolEquipped.Changed:Connect(changeToolButton)
changeToolButton()

local gradient = XPBar.UIGradient
local ts = game:GetService("TweenService") 
local ti = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
local offset1 = {Offset = Vector2.new(1, 0)}
local create = ts:Create(gradient, ti, offset1)
local startingPos = {Offset = Vector2.new(-1, 0)}
local create2 = ts:Create(gradient, ti, startingPos)

coroutine.resume(coroutine.create(function()
    local function animate()
        gradient.Offset = Vector2.new(-1, 0)
        create:Play()
        create.Completed:Wait() 
        gradient.Offset = Vector2.new(1, 0)
        create2:Play()
        create2.Completed:Wait() 
        animate()
    end
    animate()
end))

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
    AccessoryInventory = AccessoryInventory,
    ProfileMenu = UI.ProfileMenu,
    SettingsMenu = UI.SettingsMenu,
    --RewardsMenu = UI.RewardsMenu,
    --QuestsMenu = UI.QuestsMenu,
    --ShopMenu = UI.ShopMenu,
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
            if CurrentUI.Value == "RebirthMenu" or CurrentUI.Value == "ScrapMenu" then
                return
            end
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




