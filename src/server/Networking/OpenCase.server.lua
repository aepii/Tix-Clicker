---- Services ----

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local HttpService = game:GetService("HttpService")

---- Data ----

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local DataManager = require(ServerScriptService.Data.DataManager)
local Cases = require(ReplicatedStorage.Data.Cases)
local Accessories = require(ReplicatedStorage.Data.Accessories)

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TemporaryData = require(Modules.TemporaryData)

---- Networking ----

local Networking = ReplicatedStorage.Networking
local OpenCaseRemote = Networking.OpenCase
local OpenCaseAnimRemote = Networking.OpenCaseAnim
local UpdateClientCaseInventoryRemote = Networking.UpdateClientCaseInventory
local UpdateClientAccessoriesInventoryRemote = Networking.UpdateClientAccessoriesInventory
local UpdateClientShopInfoRemote = Networking.UpdateClientShopInfo

---- Private Functions ----

function findRarityIndex(rarity, caseWeights)

    for k, v in pairs(caseWeights) do
        if v[1] == rarity then
            return k
        end
    end
    return nil
end

local function pickWinner(rarity, caseID)
    local matchingAccessories = {}
    for _, accessory in Accessories do
        if accessory.Rarity == rarity and findRarityIndex(rarity, Cases[caseID].Weights) then
            table.insert(matchingAccessories, accessory)
        end
    end
    local randomIndex = math.random(1, #matchingAccessories)
    return matchingAccessories[randomIndex]
end

local function roll(caseID)
    local weights = Cases[caseID].Weights

    local totalWeight = 0
    for _, entry in weights do
        totalWeight = totalWeight + entry[2]
    end

    local randomNumber = math.random() * totalWeight

    local currentWeight = 0
    for _, entry in weights do
        currentWeight = currentWeight + entry[2]
        if currentWeight >= randomNumber then
            return pickWinner(entry[1], caseID)
        end
    end
end

OpenCaseRemote.OnServerInvoke = (function(player, caseID)
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data

    local replicatedData = player.ReplicatedData
    local temporaryData = player.TemporaryData

    local case = Cases[caseID]
    local owned = data.Cases[caseID]

    if temporaryData.ActiveCaseOpening.Value == false then
        if #replicatedData.Accessories:GetChildren() < temporaryData.AccessoriesLimit.Value then 
            if owned >= 1 then
                local GUID = HttpService:GenerateGUID(false)
                local item = roll(caseID)

                temporaryData.LastClickTime.Value = os.clock()

                DataManager:SetValue(player, profile, {"Cases", caseID}, data["Cases"][caseID] - 1)
                DataManager:SetValue(player, profile, {"Accessories", GUID}, item.ID)
                
                UpdateClientAccessoriesInventoryRemote:FireClient(player, item.ID, GUID, "ADD") 
                UpdateClientShopInfoRemote:FireClient(player, "Case")

                if data.Cases[caseID] then
                    UpdateClientCaseInventoryRemote:FireClient(player, case, "UPDATE") 
                end
                if data.Cases[caseID] == 0 then
                    DataManager:SetValue(player, profile, {"Cases", caseID}, nil)
                    UpdateClientCaseInventoryRemote:FireClient(player, case, "DEL")
                end
                DataManager:SetValue(player, profile, {"Lifetime Value"}, (profile.Data["Lifetime Value"] or 0) + item.Value)
                DataManager:SetValue(player, profile, {"Lifetime Cases"}, (profile.Data["Lifetime Cases"] or 0) + 1)
                temporaryData.ActiveCaseOpening.Value = true
                OpenCaseAnimRemote:FireClient(player, caseID, item)
            end
        end
    end
end)

OpenCaseAnimRemote.OnServerEvent:Connect(function(player)
    local profile = ProfileCacher:GetProfile(player)
    local temporaryData = player.TemporaryData

    DataManager:UpdateLeaderstats(player, profile, "Value")
    temporaryData.ActiveCaseOpening.Value = false
end)