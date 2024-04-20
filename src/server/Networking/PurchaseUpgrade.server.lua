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
local PurchaseUpgradeRemote = Networking.PurchaseUpgrade
local UpdateClientInventoryRemote = Networking.UpdateClientInventory

---- Private Functions ----

local function replicateData(player, profile, replicatedData, upgradeName)
    local data = profile.Data
    replicatedData.Rocash.Value = data.Rocash

    local replicatedUpgrade = Instance.new("BoolValue")
    replicatedUpgrade.Name = upgradeName
    replicatedUpgrade.Parent = replicatedData["Upgrades"]

    ReplicatedProfile:UpdateLeaderstats(player, profile, "Rocash")
end

PurchaseUpgradeRemote.OnServerInvoke = (function(player, upgradeName)
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data

    local replicatedData = player.ReplicatedData

    local upgrade = Upgrades[upgradeName]
    local cost = upgrade.Cost["Rocash"]

    if data.Rocash >= cost then
        if not table.find(data["Upgrades"], upgradeName) then
            table.insert(data["Upgrades"], upgradeName)
            data.Rocash -= cost

            replicateData(player, profile, replicatedData, upgradeName)
            print(player, upgrade, "SERVER")
            UpdateClientInventoryRemote:FireClient(player, upgrade)
        end
    end
    
end)