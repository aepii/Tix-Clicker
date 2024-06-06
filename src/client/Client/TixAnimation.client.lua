---- Services ----

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TixUIAnim = require(Modules.TixUIAnim)

---- Sound ----

local Sounds = Player:WaitForChild("Sounds")
local ClickSound = Sounds:WaitForChild("ClickSound")
local PopSound = Sounds:WaitForChild("PopSound")

---- Networking ----

local Networking = ReplicatedStorage.Networking
local AnimateTixRemote = Networking.AnimateTix

---- Private Functions ----

AnimateTixRemote.OnClientEvent:Connect(function(tixGained)
    coroutine.wrap(function()
            TixUIAnim:Animate(Player, "TixDetail", tixGained)
            SoundService:PlayLocalSound(PopSound)
    end)()
end)
