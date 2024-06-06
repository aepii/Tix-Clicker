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
local PerSecondUpgrades = require(ReplicatedStorage.Data.PerSecondUpgrades)

---- Networking ----

local Networking = ReplicatedStorage.Networking
local PurchasePerSecondUpgradeRemote = Networking.PurchasePerSecondUpgrade
local UpdateClientShopInfoRemote = Networking.UpdateClientShopInfo

---- Private Functions ----

PurchasePerSecondUpgradeRemote.OnServerInvoke = (function(player, upgradeID)
    local cost;
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data

    local perSecondUpgrade = PerSecondUpgrades[upgradeID]
    local upgradeData = data.PerSecondUpgrades[upgradeID]

    if upgradeData then
        cost = TemporaryData:CalculateTixPerSecondCost(upgradeData, upgradeID, 1)
    else
        cost = perSecondUpgrade.Cost
    end

    if data.Rocash >= cost then
        DataManager:SetValue(player, profile, {"PerSecondUpgrades", upgradeID}, (upgradeData or 0) + 1)
        DataManager:SetValue(player, profile, {"Rocash"}, data.Rocash - cost)
        DataManager:UpdateLeaderstats(player, profile, "Rocash")
        UpdateClientShopInfoRemote:FireClient(player, "PerSecondUpgrade")
        return cost
    end
    
end)