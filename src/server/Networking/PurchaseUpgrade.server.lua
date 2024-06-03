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
local PurchaseUpgradeRemote = Networking.PurchaseUpgrade
local UpdateClientInventoryRemote = Networking.UpdateClientInventory

---- Private Functions ----

PurchaseUpgradeRemote.OnServerInvoke = (function(player, upgradeID)
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data

    local replicatedData = player.ReplicatedData

    local upgrade = Upgrades[upgradeID]
    local cost = upgrade.Cost["Rocash"]

    if data.Rocash >= cost then
        if not table.find(data["Upgrades"], upgradeID) then
            DataManager:ArrayInsert(player, profile, {"Upgrades"}, upgradeID)
            DataManager:SetValue(player, profile, {"Rocash"}, data.Rocash - cost)
            DataManager:UpdateLeaderstats(player, profile, "Rocash")
            print(player, upgrade, "SERVER")
            UpdateClientInventoryRemote:FireClient(player, upgrade)
        end
    end
    
end)