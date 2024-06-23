---- Services ----

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Player = Players.LocalPlayer

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TweenButton = require(Modules.TweenButton)
local Materials = require(ReplicatedStorage.Data.Materials)
local TixUIAnim = require(Modules.TixUIAnim)

---- UI ----

local PlayerGui = Player.PlayerGui
local UI = PlayerGui:WaitForChild("UI")
local VFX = UI:WaitForChild("VFX")

local InfoUI = PlayerGui:WaitForChild("InfoUI")
local UpgradeInfo = InfoUI.CC1Info
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
local PurchaseCollectibleCaseRemote = Networking.PurchaseCollectibleCase

---- Private Functions ----

local function purchaseCase(caseName)
    local rebirthTixCost, materialCost = PurchaseCollectibleCaseRemote:InvokeServer(caseName)
    coroutine.wrap(function()
        if rebirthTixCost then
            coroutine.wrap(function()
                SoundService:PlayLocalSound(MoneySound)
                if VFX.OtherVFX.Value == true then
                    TixUIAnim:Animate(Player, "NegateRebirthTixDetail", rebirthTixCost, nil)
                    SoundService:PlayLocalSound(PopSound)
                end
            end)()
            if materialCost then       
                if VFX.OtherVFX.Value == true then
                    for key, materialData in materialCost do
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
            coroutine.wrap(function()
                SoundService:PlayLocalSound(ErrorSound)
            end)()
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
