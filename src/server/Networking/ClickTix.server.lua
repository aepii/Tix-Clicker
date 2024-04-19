---- Services ----

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

---- Modules ----
local Modules = ReplicatedStorage.Modules
local TemporaryData = require(Modules.TemporaryData)

---- Data ----

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local Upgrades = require(ReplicatedStorage.Data.Upgrades)
local ReplicatedProfile = require(ServerScriptService.Data.ReplicatedProfile)

---- Networking ----

local Networking = ReplicatedStorage.Networking
local ClickTixRemote = Networking.ClickTix

ClickTixRemote.OnServerInvoke = (function(player)
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data

    local replicatedData = player.ReplicatedData

    local tixStorage = TemporaryData:CalculateTixStorage(data)
    local tixPerClick = TemporaryData:CalculateTixPerClick(data)
    
    if data.Tix < tixStorage.Value then
        data.Tix = math.min(data.Tix + tixPerClick.Value, tixStorage.Value)
        data["Lifetime Tix"] = math.min(data.Tix + tixPerClick.Value, tixStorage.Value)

        replicatedData.Tix.Value = data.Tix
        replicatedData["Lifetime Tix"].Value = data["Lifetime Tix"]

        ReplicatedProfile:UpdateLeaderstats(player, profile, "Tix")

        return true
    end
end)
