---- Services ----

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")

---- Data ----

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local DataManager = require(ServerScriptService.Data.DataManager)

---- Exchange Tix ----

local function exchangeTix(player)
    local profile = ProfileCacher:GetProfile(player)
    local data = ProfileCacher:GetProfile(player).Data

    if data.Tix >= 20 then
        DataManager:SetValue(player, profile, {"Rocash"}, data.Rocash + math.floor(data.Tix / 20))
        DataManager:SetValue(player, profile, {"Lifetime Rocash"}, data.Rocash + math.floor(data.Tix / 20))
        DataManager:SetValue(player, profile, {"Tix"}, data.Tix - math.floor(data.Tix / 20) * 20)
        DataManager:UpdateLeaderstats(player, profile, "Tix")
        DataManager:UpdateLeaderstats(player, profile, "Rocash")
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