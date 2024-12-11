---- Services ----

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TweenButton = require(Modules.TweenButton)

---- UI ----

local PlayerGui = Player.PlayerGui
local UI = PlayerGui:WaitForChild("UI")

local VFX = UI:WaitForChild("VFX")
local TixClickVFX = VFX:WaitForChild("TixClickVFX")
local ExchangeVFX = VFX:WaitForChild("ExchangeVFX")
local ScrapVFX = VFX:WaitForChild("ScrapVFX")
local OtherVFX = VFX:WaitForChild("OtherVFX")

local Buttons = UI.Buttons
local SettingsMenu = UI.SettingsMenu
local Holder = SettingsMenu.OptionsFrame.Holder

---- UI Values ----

local UIVisible = UI.UIVisible
local CurrentUI = UI.CurrentUI

local UIFrames = {
    TixInventory = UI.TixInventory,
    CaseInventory = UI.CaseInventory,
    AccessoryInventory = UI.AccessoryInventory,
    ProfileMenu = UI.ProfileMenu,
    SettingsMenu = UI.SettingsMenu,
    --RewardsMenu = UI.RewardsMenu,
    AchievementsMenu = UI.AchievementsMenu,
    ShopMenu = UI.ShopMenu,
}

---- Sound ----

local Sounds = Player:WaitForChild("Sounds")
local MainTheme = UI:WaitForChild("MainTheme")
local ClickSound = Sounds:WaitForChild("ClickSound")
local MoneySound = Sounds:WaitForChild("MoneySound")
local OtherSFX = Sounds:WaitForChild("OtherSFX")

---- Private Functions ----

local function toggleMusic(active)
    if active == true then
        MainTheme.Volume = 1
    else
        MainTheme.Volume = 0
    end
end

local function toggleClickSFX(active)
    if active == true then
        ClickSound.Volume = 0.5
    else
        ClickSound.Volume = 0
    end
end

local function toggleMoneySFX(active)
    if active == true then
        MoneySound.Volume = 0.5
    else
        MoneySound.Volume = 0
    end
end

local function toggleOtherSFX(active)
    if active == true then
        OtherSFX.Volume = 1
    else
        OtherSFX.Volume = 0
    end
end

local function toggleTixClickVFX(active)
    if active == true then
        TixClickVFX.Value = true
    else
        TixClickVFX.Value = false
    end
end

local function toggleExchangeVFX(active)
    if active == true then
        ExchangeVFX.Value = true
    else
        ExchangeVFX.Value = false
    end
end

local function toggleScrapVFX(active)
    if active == true then
        ScrapVFX.Value = true
    else
        ScrapVFX.Value = false
    end
end

local function toggleOtherVFX(active)
    if active == true then
        OtherVFX.Value = true
    else
        OtherVFX.Value = false
    end
end

local functionTable = {
    ["MusicToggle"] = toggleMusic,
    ["ClickSFX"] = toggleClickSFX,
    ["MoneySFX"] = toggleMoneySFX,
    ["OtherSFX"] = toggleOtherSFX,
    ["TixClickVFX"] = toggleTixClickVFX,
    ["ExchangeVFX"] = toggleExchangeVFX,
    ["ScrapVFX"] = toggleScrapVFX,
    ["OtherVFX"] = toggleOtherVFX,
}

local function playClickSound()
    SoundService:PlayLocalSound(ClickSound)
end

local function buttonBehavior(button, originalSize, inventory, uiValue)

    local active = true

    local function buttonHover()
        TweenButton:Grow(button, originalSize)
    end

    local function buttonLeave()
        TweenButton:Reset(button, originalSize)
    end

    local function buttonMouseDown()
        playClickSound()
        TweenButton:Shrink(button, originalSize)
        if active == true then
            button.BackgroundColor3 = Color3.fromRGB(236, 44, 75)
            button.UIGradient.Color = ColorSequence.new(Color3.fromRGB(255,255,255), Color3.fromRGB(255,0,0)) 
            button.Shadow.BackgroundColor3 = Color3.fromRGB(73, 30, 30)
            active = false
        else
            button.BackgroundColor3 = Color3.fromRGB(85, 170, 127)
            button.UIGradient.Color = ColorSequence.new(Color3.fromRGB(255,255,255), Color3.fromRGB(15,255,83)) 
            button.Shadow.BackgroundColor3 = Color3.fromRGB(34, 68, 50)
            active = true
        end
        functionTable[button.Parent.Name](active)
    end

    local function buttonMouseUp()
        TweenButton:Reset(button, originalSize)
    end

    button.ClickDetector.MouseEnter:Connect(buttonHover)
    button.ClickDetector.MouseLeave:Connect(buttonLeave)
    button.ClickDetector.MouseButton1Down:Connect(buttonMouseDown)
    button.ClickDetector.MouseButton1Up:Connect(buttonMouseUp)
end

local function setupButtonsInFrame()
    for _, frame in Holder:GetChildren() do
        if frame:IsA("Frame") then
            buttonBehavior(frame.ToggleButton, frame.ToggleButton.Size)  -- Assuming originalSize is the initial Size of the button
        end
    end
end
setupButtonsInFrame()

---- Buttons ----

local ExitButton = SettingsMenu.ExitButton
local SettingsButton = Buttons.SettingsButton

local EXITBUTTON_ORIGINALSIZE = ExitButton.Size
local SETTINGSBUTTON_ORIGINALSIZE = SettingsButton.UIScale.Scale

local function exitHover()
    TweenButton:Grow(ExitButton, EXITBUTTON_ORIGINALSIZE)
end

local function exitLeave()
    TweenButton:Reset(ExitButton, EXITBUTTON_ORIGINALSIZE)
end

local function exitMouseDown()
    playClickSound()
    TweenButton:Shrink(ExitButton, EXITBUTTON_ORIGINALSIZE)
    SettingsMenu:TweenPosition(UDim2.new(0.5, 0, 2, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
    CurrentUI.Value = ""
    UIVisible.Value = false
end

local function exitMouseUp()
    TweenButton:Reset(ExitButton, EXITBUTTON_ORIGINALSIZE)
end

local function settingsHover()
    TweenButton:Grow(SettingsButton.UIScale, SETTINGSBUTTON_ORIGINALSIZE)
end

local function settingsLeave()
    TweenButton:Reset(SettingsButton.UIScale, SETTINGSBUTTON_ORIGINALSIZE)
end

local function settingsMouseDown()
    playClickSound()
    TweenButton:Shrink(SettingsButton.UIScale, SETTINGSBUTTON_ORIGINALSIZE)

    if CurrentUI.Value ~= "SettingsMenu" then
        if CurrentUI.Value == "RebirthMenu" or CurrentUI.Value == "ScrapMenu" then
            return
        end
            SettingsMenu:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
            local currentFrame = UIFrames[CurrentUI.Value]
            if currentFrame then
                currentFrame:TweenPosition(UDim2.new(0.5, 0, 2, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
            end
            CurrentUI.Value = "SettingsMenu"
            UIVisible.Value = true
    else
        SettingsMenu:TweenPosition(UDim2.new(0.5, 0, 2, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
        CurrentUI.Value = ""
        UIVisible.Value = false
    end
end

local function settingsMouseUp()
    TweenButton:Reset(SettingsButton.UIScale, SETTINGSBUTTON_ORIGINALSIZE)
end


ExitButton.ClickDetector.MouseEnter:Connect(exitHover)
ExitButton.ClickDetector.MouseLeave:Connect(exitLeave)
ExitButton.ClickDetector.MouseButton1Down:Connect(exitMouseDown)
ExitButton.ClickDetector.MouseButton1Up:Connect(exitMouseUp)

SettingsButton.ClickDetector.MouseEnter:Connect(settingsHover)
SettingsButton.ClickDetector.MouseLeave:Connect(settingsLeave)
SettingsButton.ClickDetector.MouseButton1Down:Connect(settingsMouseDown)
SettingsButton.ClickDetector.MouseButton1Up:Connect(settingsMouseUp)


