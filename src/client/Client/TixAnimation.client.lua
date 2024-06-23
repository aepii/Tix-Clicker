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

---- Networking ----

local Networking = ReplicatedStorage.Networking
local AnimateTixRemote = Networking.AnimateTix

---- Private Functions ----

AnimateTixRemote.OnClientEvent:Connect(function(tixGained)
    if VFX.OtherVFX.Value == true then
        coroutine.wrap(function()
            TixUIAnim:Animate(Player, "TixDetail", tixGained, nil)
            SoundService:PlayLocalSound(PopSound)
        end)()
    end
end)
