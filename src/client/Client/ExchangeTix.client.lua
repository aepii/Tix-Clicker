---- Services ----

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TixUIAnim = require(Modules.TixUIAnim)

---- UI ----

local PlayerGui = Player.PlayerGui
local UI = PlayerGui:WaitForChild("UI")
local VFX = UI:WaitForChild("VFX")

---- Sound ----

local Sounds = Player:WaitForChild("Sounds")
local PopSound = Sounds:WaitForChild("PopSound")
local MoneySound = Sounds:WaitForChild("MoneySound")

---- Networking ----

local Networking = ReplicatedStorage.Networking
local ExchangeTixRemote = Networking.ExchangeTix

---- Private Functions ----

ExchangeTixRemote.OnClientEvent:Connect(function(tixExchanged, rocashGained)
    SoundService:PlayLocalSound(MoneySound)
    if VFX.ExchangeVFX.Value == true then
        coroutine.wrap(function()
            SoundService:PlayLocalSound(PopSound)
            TixUIAnim:Animate(Player, "NegateTixDetail", tixExchanged, nil)
        end)()
        coroutine.wrap(function()
            TixUIAnim:Animate(Player, "RocashDetail", rocashGained, nil)
            SoundService:PlayLocalSound(PopSound)
        end)()
    end
end)
