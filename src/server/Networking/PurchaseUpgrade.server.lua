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
local UpdateClientMaterialsInventoryRemote = Networking.UpdateClientMaterialsInventory

---- Private Functions ----

local function canPurchase(upgradeData, upgrade)
    print("CHECKING")
    local cost = upgrade.Cost["Rocash"]

    if upgradeData.Rocash < cost then
        print("NOT ENOUGH ROCASH")
        return false
    end

    if upgrade.Cost["Materials"] then
        local materialCost = upgrade.Cost["Materials"]

        for key, materialData in materialCost do
            print(key, materialData)
            local materialID = materialData[1]
            local materialCost = materialData[2]
            if not upgradeData.Materials[materialID] then
                print("MAT DOESNT EVEN EXIST")
                return false
            end
            if upgradeData.Materials[materialID] < materialCost then
                print("NOT ENOUGH MATS")
                return false
            end
        end
    end
    print("CAN AFFORD")
    return true
end

PurchaseUpgradeRemote.OnServerInvoke = (function(player, upgradeID)
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data

    local replicatedData = player.ReplicatedData

    local upgrade = Upgrades[upgradeID]
    local cost = upgrade.Cost["Rocash"]

    if not table.find(data["Upgrades"], upgradeID) then
        if canPurchase(data, upgrade) then
            if upgrade.Cost["Materials"] then
                local materialCost = upgrade.Cost["Materials"] 
                for key, materialData in materialCost do
                    local materialID = materialData[1]
                    local materialCost = materialData[2]
                    local newMaterialValue = (data.Materials[materialID] or 0) - materialCost
                    DataManager:SetValue(player, profile, {"Materials", materialID}, newMaterialValue)
                    if newMaterialValue ~= 0 then
                        UpdateClientMaterialsInventoryRemote:FireClient(player, newMaterialValue, materialID, "UPDATE")
                    else
                        UpdateClientMaterialsInventoryRemote:FireClient(player, newMaterialValue, materialID, "DEL")
                    end
                end
            end
            
            DataManager:SetValue(player, profile, {"Rocash"}, data.Rocash - cost)
            DataManager:ArrayInsert(player, profile, {"Upgrades"}, upgradeID)
            print(data.Upgrades)
            DataManager:UpdateLeaderstats(player, profile, "Rocash")
            print(player, upgrade, "SERVER")
            UpdateClientInventoryRemote:FireClient(player, upgrade, "ADD")
        end
    end
    
end)