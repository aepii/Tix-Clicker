---- Services ----

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

PurchasePerSecondUpgradeRemote.OnServerInvoke = (function(player, upgradeID, amount)
    if amount <= 0 then
        return
    end

    local cost;
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data

    local temporaryData = player.TemporaryData

    local perSecondUpgrade = PerSecondUpgrades[upgradeID]
    local upgradeData = data.PerSecondUpgrades[upgradeID] or 0

    cost = TemporaryData:CalculateTixPerSecondCost(upgradeData, upgradeID, amount)
 
    if temporaryData.ActiveCaseOpening.Value == false then
        if data.Rocash >= cost then
            DataManager:SetValue(player, profile, {"PerSecondUpgrades", upgradeID}, (upgradeData or 0) + amount)
            DataManager:SetValue(player, profile, {"Rocash"}, data.Rocash - cost)
            DataManager:UpdateLeaderstats(player, profile, "Rocash")
            UpdateClientShopInfoRemote:FireClient(player, "PerSecondUpgrade")
            return cost
        end
    end
end)