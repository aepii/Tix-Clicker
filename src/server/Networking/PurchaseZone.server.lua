---- Services ----

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

---- Data ----

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local DataManager = require(ServerScriptService.Data.DataManager)
local Zones = require(ReplicatedStorage.Data.Zones)

---- Networking ----

local Networking = ReplicatedStorage.Networking
local PurchaseZoneRemote = Networking.PurchaseZone

---- Private Functions ----

PurchaseZoneRemote.OnServerInvoke = (function(player, portalID)
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data

    local temporaryData = player.TemporaryData

    local zone = Zones[portalID]
    local cost = zone.Cost["RebirthTix"]

    if temporaryData.ActiveCaseOpening.Value == false then 
        if not table.find(data["Zones"], portalID) then
            if data["Rebirth Tix"] >= cost then
                DataManager:SetValue(player, profile, {"Rebirth Tix"}, data["Rebirth Tix"] - cost)
                DataManager:ArrayInsert(player, profile, {"Zones"}, portalID)
                DataManager:UpdateLeaderstats(player, profile, "Rebirth Tix")
                return cost
            end
        end
    end
    return
end)