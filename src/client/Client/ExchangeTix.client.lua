---- Services ----

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TweenButton = require(Modules.TweenButton)
local TixUIAnim = require(Modules.TixUIAnim)
local SuffixHandler = require(Modules.SuffixHandler)

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
    coroutine.wrap(function()
        SoundService:PlayLocalSound(PopSound)
        TixUIAnim:Animate(Player, "NegateTixDetail", tixExchanged)
    end)()
    coroutine.wrap(function()
        TixUIAnim:Animate(Player, "RocashDetail", rocashGained)
        SoundService:PlayLocalSound(PopSound)
    end)()
end)
