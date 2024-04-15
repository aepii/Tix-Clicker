local Workspace = game:GetService("Workspace")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local Cases = require(ReplicatedStorage.Data.Cases)

local part = Workspace.OpenCasePart

local CASE = "C1"

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
            
           break
        end
    end
    
end

local function openCase(player)
    print("Clicked!")

    local data = ProfileCacher:GetProfile(player).Data
    local owned = data.Inventory[CASE]

    if owned >= 1 then
        roll(CASE)
        data.Inventory[CASE] -= 1
    end
end

part.ClickDetector.MouseClick:Connect(openCase)
