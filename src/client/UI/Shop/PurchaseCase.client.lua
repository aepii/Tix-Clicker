---- Services ----

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Player = Players.LocalPlayer

---- Shop ----

local Shop = Workspace.ShopUpgrades

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TweenButton = require(Modules.TweenButton)
local ButtonStatus = require(Modules.ButtonStatus)
local TixUIAnim = require(Modules.TixUIAnim)

---- UI ----

local InfoUI = Player.PlayerGui:WaitForChild("InfoUI")
local UpgradeInfo = InfoUI.CaseInfo
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

---- Private Functions ----

local function purchaseCase(caseName)
    local response = PurchaseCaseRemote:InvokeServer(caseName)
    coroutine.wrap(function()
        if response then
            SoundService:PlayLocalSound(MoneySound)
            TixUIAnim:Animate(Player, "NegateRocashDetail", response)
            SoundService:PlayLocalSound(PopSound)
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
