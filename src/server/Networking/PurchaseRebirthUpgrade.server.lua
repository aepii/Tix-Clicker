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
local RebirthUpgrades = require(ReplicatedStorage.Data.RebirthUpgrades)

---- Networking ----

local Networking = ReplicatedStorage.Networking
local PurchaseRebirthUpgradeRemote = Networking.PurchaseRebirthUpgrade
local UpdateClientShopInfoRemote = Networking.UpdateClientShopInfo

---- Private Functions ----

PurchaseRebirthUpgradeRemote.OnServerInvoke = (function(player, upgradeID)
    local cost;
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data

    local rebirthUpgrade = RebirthUpgrades[upgradeID]
    local upgradeData = data.RebirthUpgrades[upgradeID]

    local limit = rebirthUpgrade.Limit

    if upgradeData then
        cost = TemporaryData:CalculateRebirthUpgradeCost(upgradeData, upgradeID, 1)
    else
        cost = rebirthUpgrade.Cost
    end

    local owned = (upgradeData or 0)

    if data["Rebirth Tix"] >= cost and owned < limit then
        DataManager:SetValue(player, profile, {"RebirthUpgrades", upgradeID}, owned + 1)
        DataManager:SetValue(player, profile, {"Rebirth Tix"}, data["Rebirth Tix"] - cost)
        DataManager:UpdateLeaderstats(player, profile, "Rebirth Tix")
        UpdateClientShopInfoRemote:FireClient(player, "RebirthUpgrade")
    end
    
end)