local ShopMenuUI = {}

function ShopMenuUI:Init()
    ---- Services ----

    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local SoundService = game:GetService("SoundService")

    ---- Modules ----

    local Modules = ReplicatedStorage.Modules
    local TweenButton = require(Modules.TweenButton)

    ---- UI ----

    local PlayerGui = Player.PlayerGui
    local UI = PlayerGui:WaitForChild("UI")

    local Buttons = UI.Buttons
    local ShopMenu = UI.ShopMenu

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
    local ClickSound = Sounds:WaitForChild("ClickSound")

    ---- Private Functions ----


    ---- Buttons ----

    local ExitButton = ShopMenu.ExitButton
    local ShopButton = Buttons.ShopButton

    local EXITBUTTON_ORIGINALSIZE = ExitButton.Size
    local SHOPBUTTON_ORIGINALSIZE = ShopButton.UIScale.Scale

    local function playClickSound()
        SoundService:PlayLocalSound(ClickSound)
    end

    local function exitHover()
        TweenButton:Grow(ExitButton, EXITBUTTON_ORIGINALSIZE)
    end

    local function exitLeave()
        TweenButton:Reset(ExitButton, EXITBUTTON_ORIGINALSIZE)
    end

    local function exitMouseDown()
        playClickSound()
        TweenButton:Shrink(ExitButton, EXITBUTTON_ORIGINALSIZE)
        ShopMenu:TweenPosition(UDim2.new(0.5, 0, 2, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        CurrentUI.Value = ""
        UIVisible.Value = false
    end

    local function exitMouseUp()
        TweenButton:Reset(ExitButton, EXITBUTTON_ORIGINALSIZE)
    end

    local function shopHover()
        TweenButton:Grow(ShopButton.UIScale, SHOPBUTTON_ORIGINALSIZE)
    end

    local function shopLeave()
        TweenButton:Reset(ShopButton.UIScale, SHOPBUTTON_ORIGINALSIZE)
    end

    local function shopMouseDown()
        playClickSound()
        TweenButton:Shrink(ShopButton.UIScale, SHOPBUTTON_ORIGINALSIZE)

        if CurrentUI.Value ~= "ShopMenu" then
            if CurrentUI.Value == "RebirthMenu" or CurrentUI.Value == "ScrapMenu" then
                return
            end
            ShopMenu:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
                local currentFrame = UIFrames[CurrentUI.Value]
                if currentFrame then
                    currentFrame:TweenPosition(UDim2.new(0.5, 0, 2, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
                end
                CurrentUI.Value = "ShopMenu"
                UIVisible.Value = true
        else
        ShopMenu:TweenPosition(UDim2.new(0.5, 0, 2, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
            CurrentUI.Value = ""
            UIVisible.Value = false
        end
    end

    local function shopMouseUp()
        TweenButton:Reset(ShopButton.UIScale, SHOPBUTTON_ORIGINALSIZE)
    end


    ExitButton.ClickDetector.MouseEnter:Connect(exitHover)
    ExitButton.ClickDetector.MouseLeave:Connect(exitLeave)
    ExitButton.ClickDetector.MouseButton1Down:Connect(exitMouseDown)
    ExitButton.ClickDetector.MouseButton1Up:Connect(exitMouseUp)

    ShopButton.ClickDetector.MouseEnter:Connect(shopHover)
    ShopButton.ClickDetector.MouseLeave:Connect(shopLeave)
    ShopButton.ClickDetector.MouseButton1Down:Connect(shopMouseDown)
    ShopButton.ClickDetector.MouseButton1Up:Connect(shopMouseUp)

end

return ShopMenuUI