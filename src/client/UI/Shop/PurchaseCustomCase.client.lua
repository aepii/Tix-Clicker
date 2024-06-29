---- Services ----

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Player = Players.LocalPlayer

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TweenButton = require(Modules.TweenButton)
local TixUIAnim = require(Modules.TixUIAnim)
local Cases = require(ReplicatedStorage.Data.Cases)
local Materials = require(ReplicatedStorage.Data.Materials)
local TemporaryData = require(Modules.TemporaryData)

---- UI ----

local PlayerGui = Player.PlayerGui
local UI = PlayerGui:WaitForChild("UI")
local VFX = UI:WaitForChild("VFX")

local InfoUI = PlayerGui:WaitForChild("InfoUI")
local UpgradeInfo = InfoUI.CustomCaseInfo
local InfoFrame = UpgradeInfo.InfoFrame
local CurrentUI = InfoUI.CurrentUI

---- Sound ----

local Sounds = Player:WaitForChild("Sounds")
local ClickSound = Sounds:WaitForChild("ClickSound")
local MoneySound = Sounds:WaitForChild("MoneySound")
local PopSound = Sounds:WaitForChild("PopSound")
local ErrorSound = Sounds:WaitForChild("ErrorSound")

---- Networking ----

local Networking = ReplicatedStorage.Networking
local PurchaseCaseRemote = Networking.PurchaseCase
local BindableUpdateClientShopInfoRemote = Networking.BindableUpdateClientShopInfo

---- Amounts ----

local multiBuyButtons = InfoFrame.MultiBuy
local amountFrame = InfoFrame.AmountFrame

local amount = InfoFrame.Amount

local function playClickSound()
    SoundService:PlayLocalSound(ClickSound)
end

local function buttonBehavior(button, originalSize)

    local function buttonHover()
        TweenButton:Grow(button.UIScale, originalSize)
    end

    local function buttonLeave()
        TweenButton:Reset(button.UIScale, originalSize)
    end

    local function buttonMouseDown()
        playClickSound()
        TweenButton:Shrink(button.UIScale, originalSize)
        if button.Name == "Max" then
            amount.Value = math.max(1, TemporaryData:CalculateMaxCases(Player, InfoFrame.ID.Value))
        else
            amount.Value = button.Name
        end
        BindableUpdateClientShopInfoRemote:Fire("CC")
        amountFrame.AmountText.Text = "+"..amount.Value
    end

    local function buttonMouseUp()
        TweenButton:Reset(button.UIScale, originalSize)
    end

    button.ClickDetector.MouseEnter:Connect(buttonHover)
    button.ClickDetector.MouseLeave:Connect(buttonLeave)
    button.ClickDetector.MouseButton1Down:Connect(buttonMouseDown)
    button.ClickDetector.MouseButton1Up:Connect(buttonMouseUp)
end

local function setupButtonsInFrame()
    for _, frame in multiBuyButtons:GetChildren() do
        if frame:IsA("Frame") then
            buttonBehavior(frame, frame.UIScale.Scale)  -- Assuming originalSize is the initial Size of the button
        end
    end
end
setupButtonsInFrame()

---- Private Functions ----

local function purchaseCase(caseID)
    local costs = PurchaseCaseRemote:InvokeServer(caseID, amount.Value)
    coroutine.wrap(function()
        if costs then
            SoundService:PlayLocalSound(MoneySound)
            if VFX.OtherVFX.Value == true then
                local case = Cases[caseID]

                coroutine.wrap(function()
                if costs["Rocash"] then
                        TixUIAnim:Animate(Player, "NegateRocashDetail", case.Cost["Rocash"], nil)
                        SoundService:PlayLocalSound(PopSound)
                    end
                end)()

                coroutine.wrap(function()
                    if costs["RebirthTix"] then
                        TixUIAnim:Animate(Player, "NegateRebirthTixDetail", case.Cost["RebirthTix"], nil)
                        SoundService:PlayLocalSound(PopSound)
                    end
                end)()

                if costs["Materials"] then
                    for key, materialData in case.Cost["Materials"] do
                        coroutine.wrap(function()
                            local materialID = materialData[1]
                            local materialCostVal = materialData[2]
                            TixUIAnim:Animate(Player, "NegateMaterialDetail", materialCostVal, Materials[materialID])
                            SoundService:PlayLocalSound(PopSound)
                        end)()
                    end
                end

            end 
        else
            SoundService:PlayLocalSound(ErrorSound)
        end
    end)()
end

---- Buttons ----

local PurchaseButton = InfoFrame.PurchaseButton
local PURCHASEBUTTON_ORIGINALSIZE = PurchaseButton.Size

local function playClickSound()
    SoundService:PlayLocalSound(ClickSound)
end

local function purchaseHover()
    TweenButton:Grow(PurchaseButton, PURCHASEBUTTON_ORIGINALSIZE)
end

local function purchaseLeave()
    TweenButton:Reset(PurchaseButton, PURCHASEBUTTON_ORIGINALSIZE)
end

local function purchaseMouseDown()
    playClickSound()
    purchaseCase(CurrentUI.Value)
    TweenButton:Shrink(PurchaseButton, PURCHASEBUTTON_ORIGINALSIZE)
end

local function purchaseMouseUp()
    TweenButton:Reset(PurchaseButton, PURCHASEBUTTON_ORIGINALSIZE)
end

PurchaseButton.ClickDetector.MouseEnter:Connect(purchaseHover)
PurchaseButton.ClickDetector.MouseLeave:Connect(purchaseLeave)
PurchaseButton.ClickDetector.MouseButton1Down:Connect(purchaseMouseDown)
PurchaseButton.ClickDetector.MouseButton1Up:Connect(purchaseMouseUp)
