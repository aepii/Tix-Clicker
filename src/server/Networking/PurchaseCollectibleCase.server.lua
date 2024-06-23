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
local CollectibleCases = require(ReplicatedStorage.Data.CollectibleCases)

---- Networking ----

local Networking = ReplicatedStorage.Networking
local PurchaseCollectibleCaseRemote = Networking.PurchaseCollectibleCase
local UpdateClientShopInfoRemote = Networking.UpdateClientShopInfo
local UpdateClientCollectibleCaseInventoryRemote = Networking.UpdateClientCollectibleCaseInventory
local UpdateClientMaterialsInventoryRemote = Networking.UpdateClientMaterialsInventory

---- Private Functions ----

local function canPurchase(playerData, case)
    local cost = case.Cost["RebirthTix"]

    if playerData["Rebirth Tix"] < cost then
        return false
    end

    if case.Cost["Materials"] then
        local materialCost = case.Cost["Materials"]

        for key, materialData in materialCost do
            local materialID = materialData[1]
            local materialCostVal = materialData[2]
            if not playerData.Materials[materialID] then
                return false
            end
            if playerData.Materials[materialID] < materialCostVal then
                return false
            end
        end
    end
    return true
end

PurchaseCollectibleCaseRemote.OnServerInvoke = (function(player, caseID)
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data

    local temporaryData = player.TemporaryData
    
    local case = CollectibleCases[caseID]
    local cost = case.Cost["RebirthTix"]

    if temporaryData.ActiveCaseOpening.Value == false then
        if canPurchase(data, case) then
            if case.Cost["Materials"] then
                materialCost = case.Cost["Materials"] 
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
            
            if not data.CollectibleCases[caseID] then
                UpdateClientCollectibleCaseInventoryRemote:FireClient(player, case, "ADD")
            end

            DataManager:SetValue(player, profile, {"CollectibleCases", caseID}, (data.CollectibleCases[caseID] or 0) + 1)
            DataManager:SetValue(player, profile, {"Rebirth Tix"}, data["Rebirth Tix"] - cost)
            DataManager:UpdateLeaderstats(player, profile, "Rebirth Tix")
            UpdateClientShopInfoRemote:FireClient(player, caseID.."Info")

            if data.CollectibleCases[caseID] then
                UpdateClientCollectibleCaseInventoryRemote:FireClient(player, case, "UPDATE")
            end
            return cost, materialCost
        end
    end
end)