---- Services ----

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TweenButton = require(Modules.TweenButton)
local TixUIAnim = require(Modules.TixUIAnim)

---- UI ----

local PlayerGui = Player.PlayerGui
local UI = PlayerGui:WaitForChild("UI")
local VFX = UI:WaitForChild("VFX")

---- Sound ----

local Sounds = Player:WaitForChild("Sounds")
local ClickSound = Sounds:WaitForChild("ClickSound")
local MoneySound = Sounds:WaitForChild("MoneySound")
local PopSound = Sounds:WaitForChild("PopSound")
local ErrorSound = Sounds:WaitForChild("ErrorSound")

---- Networking ----

local Networking = ReplicatedStorage.Networking
local PurchaseZoneRemote = Networking.PurchaseZone

---- Buttons ----

local function purchaseZone(portalID)
    local response = PurchaseZoneRemote:InvokeServer(portalID)
    coroutine.wrap(function()
        if response then
            script.Parent:Destroy()   
            SoundService:PlayLocalSound(MoneySound)
            if VFX.OtherVFX.Value == true then
                TixUIAnim:Animate(Player, "NegateRebirthTixDetail", response, nil)
                SoundService:PlayLocalSound(PopSound)
            end
        else
            SoundService:PlayLocalSound(ErrorSound)
        end
    end)()
end

local PurchaseButton = script.Parent.Holder.PurchaseButton
local PURCHASEBUTTON_ORIGINALSIZE = PurchaseButton.Size

local function purchaseHover()
    TweenButton:Grow(PurchaseButton, PURCHASEBUTTON_ORIGINALSIZE)
end

local function purchaseLeave()
    TweenButton:Reset(PurchaseButton, PURCHASEBUTTON_ORIGINALSIZE)
end

local function purchaseMouseDown()
    SoundService:PlayLocalSound(ClickSound)
    purchaseZone(script.Parent.Name)
    TweenButton:Shrink(PurchaseButton, PURCHASEBUTTON_ORIGINALSIZE)
end

local function purchaseMouseUp()
    TweenButton:Reset(PurchaseButton, PURCHASEBUTTON_ORIGINALSIZE)
end

PurchaseButton.ClickDetector.MouseEnter:Connect(purchaseHover)
PurchaseButton.ClickDetector.MouseLeave:Connect(purchaseLeave)
PurchaseButton.ClickDetector.MouseButton1Down:Connect(purchaseMouseDown)
PurchaseButton.ClickDetector.MouseButton1Up:Connect(purchaseMouseUp)