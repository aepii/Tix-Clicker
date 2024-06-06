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
local Cases = require(ReplicatedStorage.Data.Cases)

---- Networking ----

local Networking = ReplicatedStorage.Networking
local PurchaseCaseRemote = Networking.PurchaseCase
local UpdateClientShopInfoRemote = Networking.UpdateClientShopInfo
local UpdateClientCaseInventoryRemote = Networking.UpdateClientCaseInventory

---- Private Functions ----

PurchaseCaseRemote.OnServerInvoke = (function(player, caseID)
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data

    local case = Cases[caseID]
    local cost = case.Cost

    if data.Rocash >= cost then
        if not data.Cases[caseID] then
            UpdateClientCaseInventoryRemote:FireClient(player, case, "ADD")
        end

        DataManager:SetValue(player, profile, {"Cases", caseID}, (data.Cases[caseID] or 0) + 1)
        DataManager:SetValue(player, profile, {"Rocash"}, data.Rocash - cost)
        DataManager:UpdateLeaderstats(player, profile, "Rocash")
        UpdateClientShopInfoRemote:FireClient(player, "Case")

        if data.Cases[caseID] then
            UpdateClientCaseInventoryRemote:FireClient(player, case, "UPDATE")
        end
        return cost
    end
    
end)