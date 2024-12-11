local RebirthMenuUI = {}

function RebirthMenuUI:Init()
   ---- Services ----

    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local SoundService = game:GetService("SoundService")

    ---- Modules ----

    local Modules = ReplicatedStorage.Modules
    local TweenButton = require(Modules.TweenButton)
    local TemporaryData = require(Modules:WaitForChild("TemporaryData"))
    local SuffixHandler = require(Modules.SuffixHandler)
    local TixUIAnim = require(Modules.TixUIAnim)

    ---- Data ----

    local ReplicatedData = Player:WaitForChild("ReplicatedData")
    local ReplicatedTemporaryData = Player:WaitForChild("TemporaryData")
    local Rocash = ReplicatedData:WaitForChild("Rocash")
    local Value = ReplicatedTemporaryData:WaitForChild("Value")

    ---- UI ----

    local PlayerGui = Player.PlayerGui
    local UI = PlayerGui:WaitForChild("UI")
    local VFX = UI:WaitForChild("VFX")

    local RebirthMenu = UI.RebirthMenu
    local InfoFrame = RebirthMenu.InfoFrame
    local RocashInfo = RebirthMenu.RocashInfo
    local ValueInfo = RebirthMenu.ValueInfo

    local RebirthButton = InfoFrame.RebirthButton

    ---- UI Values ----

    local UIVisible = UI.UIVisible
    local CurrentUI = UI.CurrentUI

    ---- Sound ----

    local Sounds = Player:WaitForChild("Sounds")
    local ClickSound = Sounds:WaitForChild("ClickSound")
    local PopSound = Sounds:WaitForChild("PopSound")
    local RebirthSound = Sounds:WaitForChild("RebirthSound")

    ---- Networking ----

    local Networking = ReplicatedStorage.Networking
    local RebirthRemote = Networking.Rebirth

    ---- Private Functions ----

    local function rebirth()
        local rebirthTixGain, rocashLost = RebirthRemote:InvokeServer()
        if rebirthTixGain then
            SoundService:PlayLocalSound(RebirthSound)
            if VFX.OtherVFX.Value == true then
                coroutine.wrap(function()
                    TixUIAnim:Animate(Player, "NegateRocashDetail", rocashLost, nil)
                    SoundService:PlayLocalSound(PopSound)
                end)()
                coroutine.wrap(function()
                    TixUIAnim:Animate(Player, "RebirthTixDetail", rebirthTixGain, nil)
                    SoundService:PlayLocalSound(PopSound)
                end)()
            end
        end
    end

    local function updateRebirthMenu()
        local rebirthTixReward, rocashCost, ROCASH_TO_REBIRTH_TIX, valueCost, VALUE_TO_REBIRTH_TIX = TemporaryData:CalculateRebirthInfo(Rocash.Value, Value.Value)
        RebirthButton.Reward.IconImage.Amount.Text = SuffixHandler:Convert(rebirthTixReward)
        RocashInfo.IconImage.Amount.Text = SuffixHandler:Convert(Rocash.Value) .. "/" .. SuffixHandler:Convert(ROCASH_TO_REBIRTH_TIX)
        ValueInfo.IconImage.Amount.Text = SuffixHandler:Convert(Value.Value) .. "/" .. SuffixHandler:Convert(VALUE_TO_REBIRTH_TIX)
    end

    local function initRebirthMenu()
        updateRebirthMenu()
    end

    initRebirthMenu()
    Rocash.Changed:Connect(updateRebirthMenu)
    Value.Changed:Connect(updateRebirthMenu)

    ---- Buttons ----

    local ExitButton = RebirthMenu.ExitButton

    local EXITBUTTON_ORIGINALSIZE = ExitButton.Size
    local REBIRTHBUTTON_ORIGINALSIZE = RebirthButton.Size

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
        RebirthMenu:TweenPosition(UDim2.new(0.5, 0, 2, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        CurrentUI.Value = ""
        UIVisible.Value = false
    end

    local function exitMouseUp()
        TweenButton:Reset(ExitButton, EXITBUTTON_ORIGINALSIZE)
    end

    local function rebirthHover()
        TweenButton:Grow(RebirthButton, REBIRTHBUTTON_ORIGINALSIZE)
    end

    local function rebirthLeave()
        TweenButton:Reset(RebirthButton, REBIRTHBUTTON_ORIGINALSIZE)
    end

    local function rebirthMouseDown()
        playClickSound()
        TweenButton:Shrink(RebirthButton, REBIRTHBUTTON_ORIGINALSIZE)
        rebirth()
    end

    local function rebirthMouseUp()
        TweenButton:Reset(RebirthButton, REBIRTHBUTTON_ORIGINALSIZE)
    end

    ExitButton.ClickDetector.MouseEnter:Connect(exitHover)
    ExitButton.ClickDetector.MouseLeave:Connect(exitLeave)
    ExitButton.ClickDetector.MouseButton1Down:Connect(exitMouseDown)
    ExitButton.ClickDetector.MouseButton1Up:Connect(exitMouseUp)

    RebirthButton.ClickDetector.MouseEnter:Connect(rebirthHover)
    RebirthButton.ClickDetector.MouseLeave:Connect(rebirthLeave)
    RebirthButton.ClickDetector.MouseButton1Down:Connect(rebirthMouseDown)
    RebirthButton.ClickDetector.MouseButton1Up:Connect(rebirthMouseUp)
end

return RebirthMenuUI