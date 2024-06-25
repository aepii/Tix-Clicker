---- Services ----

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

---- Data ----

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local DataManager = require(ServerScriptService.Data.DataManager)
local Cases = require(ReplicatedStorage.Data.Cases)

---- Networking ----

local Networking = ReplicatedStorage.Networking
local PurchaseCaseRemote = Networking.PurchaseCase
local UpdateClientShopInfoRemote = Networking.UpdateClientShopInfo
local UpdateClientCaseInventoryRemote = Networking.UpdateClientCaseInventory
local UpdateClientMaterialsInventoryRemote = Networking.UpdateClientMaterialsInventory

---- Private Functions ----

local function canPurchase(playerData, case)
    
    local costs = {}

    if case.Cost["RebirthTix"] then
        local cost = case.Cost["RebirthTix"]
        if playerData["Rebirth Tix"] < cost then
            return false
        end
        costs["RebirthTix"] = 0
    end

    if case.Cost["Rocash"] then
        local cost = case.Cost["Rocash"]
        if playerData["Rocash"] < cost then
            return false
        end
        costs["Rocash"] = 0
    end
        
    if case.Cost["Materials"] then
        local cost = case.Cost["Materials"]

        for key, materialData in cost do
            local materialID = materialData[1]
            local materialCostVal = materialData[2]
            if not playerData.Materials[materialID] then
                return false
            end
            if playerData.Materials[materialID] < materialCostVal then
                return false
            end
        end
        costs["Materials"] = 0
    end

    return costs
end


PurchaseCaseRemote.OnServerInvoke = (function(player, caseID)
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data

    local temporaryData = player.TemporaryData
    
    local case = Cases[caseID]

    if temporaryData.ActiveCaseOpening.Value == false then
        local canPurchase = canPurchase(data, case)
        if canPurchase then
            if not data.Cases[caseID] then
                UpdateClientCaseInventoryRemote:FireClient(player, case, "ADD")
            end
            -- Remove Materials
            if canPurchase["Materials"] then
                local materialCost = case.Cost["Materials"] 
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

            -- Remove Rocash
            if canPurchase["Rocash"] then
                local rocashCost = case.Cost["Rocash"]
                DataManager:SetValue(player, profile, {"Rocash"}, data.Rocash - rocashCost)
                DataManager:UpdateLeaderstats(player, profile, "Rocash")
            end

             -- Remove Rebirth Tix
             if canPurchase["RebirthTix"] then
                local rebirthTixCost = case.Cost["RebirthTix"]
                DataManager:SetValue(player, profile, {"Rebirth Tix"}, data["Rebirth Tix"] - rebirthTixCost)
                DataManager:UpdateLeaderstats(player, profile, "Rebirth Tix")
            end

            DataManager:SetValue(player, profile, {"Cases", caseID}, (data.Cases[caseID] or 0) + 1)
            UpdateClientShopInfoRemote:FireClient(player, caseID)

            if data.Cases[caseID] then
                UpdateClientCaseInventoryRemote:FireClient(player, case, "UPDATE")
            end

            return canPurchase
        end
    end
end)