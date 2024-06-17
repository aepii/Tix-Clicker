---- Services ----

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

---- Data ----

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local DataManager = require(ServerScriptService.Data.DataManager)
local Upgrades = require(ReplicatedStorage.Data.Upgrades)

---- Networking ----

local Networking = ReplicatedStorage.Networking
local PurchaseUpgradeRemote = Networking.PurchaseUpgrade
local UpdateClientInventoryRemote = Networking.UpdateClientInventory
local UpdateClientMaterialsInventoryRemote = Networking.UpdateClientMaterialsInventory

local BindableEquipTix = Networking.BindableEquipTix

---- Private Functions ----

local function canPurchase(upgradeData, upgrade)
    local cost = upgrade.Cost["Rocash"]

    if upgradeData.Rocash < cost then
        return false
    end

    if upgrade.Cost["Materials"] then
        local materialCost = upgrade.Cost["Materials"]

        for key, materialData in materialCost do
            local materialID = materialData[1]
            local materialCostVal = materialData[2]
            if not upgradeData.Materials[materialID] then
                return false
            end
            if upgradeData.Materials[materialID] < materialCostVal then
                return false
            end
        end
    end
    return true
end

PurchaseUpgradeRemote.OnServerInvoke = (function(player, upgradeID)
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data

    local temporaryData = player.TemporaryData

    local upgrade = Upgrades[upgradeID]
    local cost = upgrade.Cost["Rocash"]

    local materialCost = nil;

    if temporaryData.ActiveCaseOpening.Value == false then 
        if not table.find(data["Upgrades"], upgradeID) then
            if canPurchase(data, upgrade) then
                if upgrade.Cost["Materials"] then
                    materialCost = upgrade.Cost["Materials"] 
                    for key, materialData in materialCost do
                        local materialID = materialData[1]
                        local materialCostVal = materialData[2]
                        local newMaterialValue = (data.Materials[materialID] or 0) - materialCostVal
                        DataManager:SetValue(player, profile, {"Materials", materialID}, newMaterialValue)
                        if newMaterialValue ~= 0 then
                            UpdateClientMaterialsInventoryRemote:FireClient(player, newMaterialValue, materialID, "UPDATE")
                        else
                            DataManager:SetValue(player, profile, {"Materials", materialID}, nil)
                            UpdateClientMaterialsInventoryRemote:FireClient(player, newMaterialValue, materialID, "DEL")
                        end
                    end
                end
                
                DataManager:SetValue(player, profile, {"Rocash"}, data.Rocash - cost)
                DataManager:ArrayInsert(player, profile, {"Upgrades"}, upgradeID)
                DataManager:UpdateLeaderstats(player, profile, "Rocash")
                UpdateClientInventoryRemote:FireClient(player, upgrade, "ADD")

                BindableEquipTix:Fire(player, upgradeID)
                DataManager:SetValue(player, profile, {"ToolEquipped"}, upgradeID)
                return cost, materialCost
            end
        end
    end
end)