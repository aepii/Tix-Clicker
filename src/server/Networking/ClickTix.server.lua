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

    local temporaryData = player.TemporaryData

    local tixStorage = TemporaryData:CalculateTixStorage(player, data)
    local tixPerClick = TemporaryData:CalculateTixPerClick(player, data)
    
    temporaryData.LastClickTime.Value = os.time()

    if temporaryData.ActiveCaseOpening.Value == false then
        if data.Tix < tixStorage then
            local tixValue = math.min(data.Tix + tixPerClick, tixStorage)

            DataManager:SetValue(player, profile, {"Tix"}, tixValue)
            DataManager:SetValue(player, profile, {"Lifetime Tix"}, tixValue)

            DataManager:UpdateLeaderstats(player, profile, "Tix")
            
            temporaryData.XP.Value += 1
            return tixPerClick
        end
    end
end)
