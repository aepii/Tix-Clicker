---- Services ----

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")

---- Data ----

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)

---- Exchange Tix ----

local function exchangeTix(player)
    local data = ProfileCacher:GetProfile(player).Data

    local replicatedData = player.ReplicatedData

    if data.Tix >= 20 then
        data.Rocash += math.floor(data.Tix / 20)
        data.Tix -= math.floor(data.Tix / 20) * 20

        replicatedData.Rocash.Value = data.Rocash
        replicatedData.Tix.Value = data.Tix
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