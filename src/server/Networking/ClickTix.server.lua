---- Services ----

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TemporaryData = require(Modules.TemporaryData)

---- Data ----

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local DataManager = require(ServerScriptService.Data.DataManager)
local Upgrades = require(ReplicatedStorage.Data.Upgrades)

---- Networking ----

local Networking = ReplicatedStorage.Networking
local ClickTixRemote = Networking.ClickTix

---- Private Functions ----

ClickTixRemote.OnServerInvoke = (function(player)
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data

    local tixStorage = TemporaryData:CalculateTixStorage(player, data)
    local tixPerClick = TemporaryData:CalculateTixPerClick(player, data)
    
    if data.Tix < tixStorage then
        local tixValue = math.min(data.Tix + tixPerClick, tixStorage)

        DataManager:SetValue(player, profile, {"Tix"}, tixValue)
        DataManager:SetValue(player, profile, {"Lifetime Tix"}, tixValue)
        DataManager:SetValue(player, profile, {"XP"}, data.XP + 1)
     
        if data.XP >= TemporaryData:CalculateRequiredXP(data.Level) then
            DataManager:SetValue(player, profile, {"Level"}, data.Level + 1)
            DataManager:SetValue(player, profile, {"XP"}, 0)
        end

        DataManager:UpdateLeaderstats(player, profile, "Tix")
        DataManager:UpdateLeaderstats(player, profile, "Level")

        return true
    end
end)
