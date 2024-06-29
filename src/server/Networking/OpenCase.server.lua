---- Services ----

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local HttpService = game:GetService("HttpService")

---- Data ----

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local DataManager = require(ServerScriptService.Data.DataManager)
local GlobalData = require(ServerScriptService.Data.GlobalData)
local Cases = require(ReplicatedStorage.Data.Cases)
local Accessories = require(ReplicatedStorage.Data.Accessories)
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

local function roll(player, caseID)
    local totalWeight = TemporaryData:GetTotalWeight(player, caseID)
    local weights = Cases[caseID].Weights

    local randomNumber = math.random() * totalWeight

    local currentWeight = 0
    for index, entry in weights do
        local weight = TemporaryData:ApplyLuck(player, entry[2], index, #weights)
        currentWeight += weight
        print(randomNumber, currentWeight, totalWeight)
        print(entry[1],TemporaryData:WeightedPercent(weight, totalWeight).."% chance")
        if currentWeight >= randomNumber then
            if string.sub(caseID, 1, 2) == "CC" then
                return Accessories[entry[1]]
            else
                return pickWinner(entry[1], caseID)
            end
        end
    end
end

OpenCaseRemote.OnServerInvoke = (function(player, caseID, amount)
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data

    local replicatedData = player.ReplicatedData
    local temporaryData = player.TemporaryData

    local case = Cases[caseID]
    local owned = data.Cases[caseID]

    local items = {}
    local totalValue = 0

    if temporaryData.ActiveCaseOpening.Value == false then
        if temporaryData.MaxCaseOpenings.Value >= amount then
            if #replicatedData.Accessories:GetChildren() + amount <= temporaryData.AccessoriesLimit.Value then 
                if owned >= amount then
                    DataManager:SetValue(player, profile, {"Cases", caseID}, data["Cases"][caseID] - amount)

                    for i = 1, amount do
                        local GUID = HttpService:GenerateGUID(false)
                        local item = roll(player, caseID)
                        DataManager:SetValue(player, profile, {"Accessories", GUID}, item.ID)
                        UpdateClientAccessoriesInventoryRemote:FireClient(player, item.ID, GUID, "ADD") 
                        items[item.ID] = (items[item.ID] or 0) + 1
                        totalValue += item.Value
                    end
                    print(items)

                    for item, count in items do
                        print(item, count)
                        GlobalData:QueueAccessoryCountUpdate(item, count)
                    end
                    
                    temporaryData.LastClickTime.Value = os.clock()

                    UpdateClientShopInfoRemote:FireClient(player, "Case")
                    if data.Cases[caseID] then
                        UpdateClientCaseInventoryRemote:FireClient(player, case, "UPDATE") 
                    end
                    if data.Cases[caseID] == 0 then
                        DataManager:SetValue(player, profile, {"Cases", caseID}, nil)
                        UpdateClientCaseInventoryRemote:FireClient(player, case, "DEL")
                    end
                    
                    DataManager:SetValue(player, profile, {"Lifetime Value"}, (profile.Data["Lifetime Value"] or 0) + totalValue)
                    DataManager:SetValue(player, profile, {"Lifetime Cases"}, (profile.Data["Lifetime Cases"] or 0) + amount)
                    temporaryData.ActiveCaseOpening.Value = true
                    OpenCaseAnimRemote:FireClient(player, caseID, items)
                end
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