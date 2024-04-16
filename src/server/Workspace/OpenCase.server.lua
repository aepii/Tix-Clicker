local Workspace = game:GetService("Workspace")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local Cases = require(ReplicatedStorage.Data.Cases)
local Accessories = require(ReplicatedStorage.Data.Accessories)

local part = Workspace.OpenCasePart

local CASE = "C1"

local function addToAccessories(player, ID)
    print(player, ID)
    local data = ProfileCacher:GetProfile(player).Data
    local result = HttpService:GenerateGUID(false)
    data.Accessories[result] = ID
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

local function roll(case)
    local weights = Cases[CASE].Weights

    local totalWeight = 0
    for rarity, weight in weights do
        totalWeight += weight
    end

    local randomNumber = math.random(1, totalWeight)

    local currentWeight = 0
    for rarity, weight in weights do
        currentWeight += weight
        if currentWeight >= randomNumber then
            return pickWinner(rarity, CASE)
        end
    end
end

local function openCase(player)
    local data = ProfileCacher:GetProfile(player).Data
    local owned = data.Inventory[CASE]

    if owned >= 1 then
        local item = roll(CASE)
        data.Inventory[CASE] -= 1
        addToAccessories(player, item.ID)
    end
end

part.ClickDetector.MouseClick:Connect(openCase)
