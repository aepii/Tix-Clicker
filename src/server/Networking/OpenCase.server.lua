---- Services ----

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

---- Data ----

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local Cases = require(ReplicatedStorage.Data.Cases)
local Accessories = require(ReplicatedStorage.Data.Accessories)
local ReplicatedProfile = require(ServerScriptService.Data.ReplicatedProfile)
local HttpService = game:GetService("HttpService")

---- Networking ----

local Networking = ReplicatedStorage.Networking
local OpenCaseRemote = Networking.OpenCase

---- Private Functions ----

local function replicateData(player, profile, replicatedData, caseName, result, ID)
   
    local data = profile.Data

    local replicatedUpgrade = replicatedData.Cases[caseName]
    replicatedUpgrade.Value = data.Cases[caseName]
  
    local replicatedAccessory = replicatedData.Accessories:FindFirstChild(result)
    if not replicatedAccessory then
        replicatedAccessory = Instance.new("StringValue")
        replicatedAccessory.Name = result
        replicatedAccessory.Value = ID
        replicatedAccessory.Parent = replicatedData["Accessories"]
    end
end

local function addToAccessories(player, ID, GUID)
    local data = ProfileCacher:GetProfile(player).Data
    data.Accessories[GUID] = ID
    --UpdateAccessoriesEvent:FireClient(player, ID, result, "ADD")
end

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


OpenCaseRemote.OnServerInvoke = (function(player, caseName)
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data

    local replicatedData = player.ReplicatedData
    local temporaryData = player.TemporaryData

    local owned = data.Cases[caseName]
    if #replicatedData.Accessories:GetChildren() < temporaryData.AccessoriesLimit.Value then 
        if owned >= 1 then
            local GUID = HttpService:GenerateGUID(false)

            data.Cases[caseName] -= 1
            local item = roll(caseName)
            addToAccessories(player, item.ID, GUID)
            replicateData(player, profile, replicatedData, caseName, GUID, item.ID)
        end
    end
end)