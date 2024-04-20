---- Services ----

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TemporaryData = require(Modules.TemporaryData)

---- Data ----

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local ValueUpgrades = require(ReplicatedStorage.Data.ValueUpgrades)
local ReplicatedProfile = require(ServerScriptService.Data.ReplicatedProfile)

---- Networking ----

local Networking = ReplicatedStorage.Networking
local PurchaseValueUpgradeRemote = Networking.PurchaseValueUpgrade
local UpdateClientShopInfoRemote = Networking.UpdateClientShopInfo

---- Private Functions ----

local function replicateData(player, profile, replicatedData, upgradeName)
    local data = profile.Data
    replicatedData.Rocash.Value = data.Rocash

    local replicatedUpgrade = replicatedData.ValueUpgrades:FindFirstChild(upgradeName)
    if replicatedUpgrade then
        replicatedUpgrade.Value += 1
    else
        replicatedUpgrade = Instance.new("NumberValue")
        replicatedUpgrade.Name = upgradeName
        replicatedUpgrade.Value = 1
        replicatedUpgrade.Parent = replicatedData["ValueUpgrades"]
    end

    ReplicatedProfile:UpdateLeaderstats(player, profile, "Rocash")
end

PurchaseValueUpgradeRemote.OnServerInvoke = (function(player, upgradeName)
    local cost;
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data

    local replicatedData = player.ReplicatedData
    local valueUpgrade = ValueUpgrades[upgradeName]
    local upgradeData = data.ValueUpgrades[upgradeName]

    if upgradeData then
        cost = TemporaryData:CalculateTixPerSecondCost(upgradeData, upgradeName, 1)
    else
        cost = valueUpgrade.Cost
    end

    if data.Rocash >= cost then
        data.ValueUpgrades[upgradeName] = (data.ValueUpgrades[upgradeName] or 0) + 1
        data.Rocash -= cost
        replicateData(player, profile, replicatedData, upgradeName)
        UpdateClientShopInfoRemote:FireClient(player)
    end
    
end)