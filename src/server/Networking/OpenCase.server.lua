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

---- Networking ----

local Networking = ReplicatedStorage.Networking
local OpenCaseRemote = Networking.OpenCase
local UpdateClientCaseInventoryRemote = Networking.UpdateClientCaseInventory

---- Private Functions ----

local function pickWinner(rarity, caseName)
    local matchingAccessories = {}
    print(rarity,caseName)
    for _, accessory in Accessories do
        if accessory.Rarity == rarity and accessory.Cases[caseName] then
            print(_, accessory)
            table.insert(matchingAccessories, accessory)
        end
    end
    local randomIndex = math.random(1, #matchingAccessories)
    return matchingAccessories[randomIndex]
end

local function roll(caseName)
    local weights = Cases[caseName].Weights

    local totalWeight = 0
    for _, entry in weights do
        totalWeight = totalWeight + entry[2]
    end

    local randomNumber = math.random(1, totalWeight)

    local currentWeight = 0
    for _, entry in weights do
        currentWeight = currentWeight + entry[2]
        if currentWeight >= randomNumber then
            return pickWinner(entry[1], caseName)
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

    if #replicatedData.Accessories:GetChildren() < temporaryData.AccessoriesLimit.Value then 
        if owned >= 1 then
            local GUID = HttpService:GenerateGUID(false)
            local item = roll(caseID)

            DataManager:SetValue(player, profile, {"Cases", caseID}, data.caseID - 1)
            DataManager:SetValue(player, profile, {"Accessories", GUID}, item.ID)

            if data.Cases[caseID] then
                UpdateClientCaseInventoryRemote:FireClient(player, case, "UPDATE") 
            end
            if data.Cases[caseID] == 0 then
                UpdateClientCaseInventoryRemote:FireClient(player, case, "DEL")
                --replicatedData.Cases[caseID]:Destory()
                --data.Cases[caseID] = nil
            end
        end
    end
end)