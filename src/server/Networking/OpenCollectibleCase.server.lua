---- Services ----

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local HttpService = game:GetService("HttpService")

---- Data ----

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local DataManager = require(ServerScriptService.Data.DataManager)
local CollectibleCases = require(ReplicatedStorage.Data.CollectibleCases)
local CollectibleAccessories = require(ReplicatedStorage.Data.CollectibleAccessories)

---- Networking ----

local Networking = ReplicatedStorage.Networking
local OpenCollectibleCaseRemote = Networking.OpenCollectibleCase
local OpenCollectibleCaseAnimRemote = Networking.OpenCollectibleCaseAnim
local UpdateClientCollectibleCaseInventoryRemote = Networking.UpdateClientCollectibleCaseInventory
local UpdateClientCollectibleAccessoriesInventoryRemote = Networking.UpdateClientCollectibleAccessoriesInventory
local UpdateClientShopInfoRemote = Networking.UpdateClientShopInfo

---- Private Functions ----

local function roll(caseID)
    local weights = CollectibleCases[caseID].Weights

    local totalWeight = 0
    for _, entry in weights do
        totalWeight = totalWeight + entry[2]
    end

    local randomNumber = math.random() * totalWeight

    local currentWeight = 0
    for _, entry in weights do
        currentWeight = currentWeight + entry[2]
        if currentWeight >= randomNumber then
            print(currentWeight, randomNumber)
            print(entry[1])
            return CollectibleAccessories[entry[1]]
        end
    end
end

OpenCollectibleCaseRemote.OnServerInvoke = (function(player, caseID)
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data

    local temporaryData = player.TemporaryData

    local case = CollectibleCases[caseID]
    local owned = data.CollectibleCases[caseID]

    if temporaryData.ActiveCaseOpening.Value == false then
        if owned >= 1 then
            local GUID = HttpService:GenerateGUID(false)
            local item = roll(caseID)

            temporaryData.LastClickTime.Value = os.clock()

            DataManager:SetValue(player, profile, {"CollectibleCases", caseID}, data["CollectibleCases"][caseID] - 1)
            DataManager:SetValue(player, profile, {"CollectibleAccessories", GUID}, item.ID)
            
            UpdateClientCollectibleAccessoriesInventoryRemote:FireClient(player, item.ID, GUID, "ADD") 
            UpdateClientShopInfoRemote:FireClient(player, "Case")

            if data.CollectibleCases[caseID] then
                UpdateClientCollectibleCaseInventoryRemote:FireClient(player, case, "UPDATE") 
            end
            if data.CollectibleCases[caseID] == 0 then
                DataManager:SetValue(player, profile, {"CollectibleCases", caseID}, nil)
                UpdateClientCollectibleCaseInventoryRemote:FireClient(player, case, "DEL")
            end
            DataManager:SetValue(player, profile, {"Lifetime Cases"}, (profile.Data["Lifetime Cases"] or 0) + 1)
            temporaryData.ActiveCaseOpening.Value = true
            OpenCollectibleCaseAnimRemote:FireClient(player, caseID, item)
        end
    end
end)

OpenCollectibleCaseAnimRemote.OnServerEvent:Connect(function(player)
    local temporaryData = player.TemporaryData
    temporaryData.ActiveCaseOpening.Value = false
end)