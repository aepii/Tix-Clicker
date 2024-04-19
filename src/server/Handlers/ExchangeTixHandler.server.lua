---- Services ----

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")

---- Data ----

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local ReplicatedProfile = require(ServerScriptService.Data.ReplicatedProfile)

---- Exchange Tix ----

local function exchangeTix(player)
    local profile = ProfileCacher:GetProfile(player)
    local data = ProfileCacher:GetProfile(player).Data

    local replicatedData = player.ReplicatedData

    if data.Tix >= 20 then
        data.Rocash += math.floor(data.Tix / 20)
        data.Tix -= math.floor(data.Tix / 20) * 20

        replicatedData.Rocash.Value = data.Rocash
        replicatedData.Tix.Value = data.Tix

        ReplicatedProfile:UpdateLeaderstats(player, profile, "Tix")
        ReplicatedProfile:UpdateLeaderstats(player, profile, "Rocash")
    end
end

---- Setup ----

local ExchangeStation = Workspace.Exchange.ExchangeStation
local Hitbox = ExchangeStation.TouchPart.Hitbox

Hitbox.Touched:Connect(function(hit)
    if hit.Parent:FindFirstChild("Humanoid") then
		local player = Players:GetPlayerFromCharacter(hit.Parent)
        exchangeTix(player)
    end
end)