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


---- Private Functions ----

local function replicateData(player, profile, replicatedData)
    local data = profile.Data

    replicatedData.Tix.Value = data.Tix
    replicatedData["Lifetime Tix"].Value = data["Lifetime Tix"]
    replicatedData.XP.Value = data.XP
    replicatedData.Level.Value = data.Level

    ReplicatedProfile:UpdateLeaderstats(player, profile, "Tix")
    ReplicatedProfile:UpdateLeaderstats(player, profile, "Level")
end

ClickTixRemote.OnServerInvoke = (function(player)
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data

    local replicatedData = player.ReplicatedData

    local tixStorage = TemporaryData:CalculateTixStorage(player, data)
    local tixPerClick = TemporaryData:CalculateTixPerClick(player, data)
    
    if data.Tix < tixStorage then
        data.Tix = math.min(data.Tix + tixPerClick, tixStorage)
        data["Lifetime Tix"] = math.min(data.Tix + tixPerClick, tixStorage)
        data.XP += 1
        
        if data.XP >= TemporaryData:CalculateRequiredXP(data.Level) then
            data.Level += 1
            data.XP = 0
        end

        replicateData(player, profile, replicatedData)
        return true
    end
end)
