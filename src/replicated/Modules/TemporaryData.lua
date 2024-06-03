---- Services ----

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

---- Data ----

local Data = ReplicatedStorage:WaitForChild("Data")
local ProfileData = require(Data:WaitForChild("ProfileData"))

local Upgrades = require(ReplicatedStorage.Data.Upgrades)
local PerSecondUpgrades = require(ReplicatedStorage.Data.PerSecondUpgrades)
local Accessories = require(ReplicatedStorage.Data.Accessories)
local Materials = require(ReplicatedStorage.Data.Materials)

local leaderstatsProfileData = ProfileData.leaderstats
local TemporaryProfileData = ProfileData.TemporaryData

---- Temporary Data ----

local TemporaryData = {}

function TemporaryData:CalculateAccessories(player, data)
    local addPerClick, addStorage = 0, 0
    local multPerClick, multStorage = 1, 1
    local equippedAccessories = data.EquippedAccessories

    for ID, GUID in data.EquippedAccessories do
        local accessory = Accessories[ID]
        local rewards = accessory.Reward
        
        addPerClick += rewards.AddPerClick or 0
        addStorage += rewards.AddStorage or 0
        multStorage += rewards.MultPerClick or 0
        multPerClick += rewards.MultStorage or 0
    end
    player.TemporaryData.AddPerClick.Value = addPerClick
    player.TemporaryData.AddStorage.Value = addStorage
    player.TemporaryData.MultPerClick.Value = multPerClick
    player.TemporaryData.MultStorage.Value = multStorage
end


function TemporaryData:CalculateTixPerClick(player, data)
    TemporaryData:CalculateAccessories(player, data)
    local toolEquipped = data.ToolEquipped
    local toolReward = Upgrades[toolEquipped].Reward["MultPerClick"]
    print(TemporaryProfileData.TixPerClick.Value, player.TemporaryData.AddPerClick.Value,toolReward)

    local tixPerClick = (TemporaryProfileData.TixPerClick.Value + player.TemporaryData.AddPerClick.Value) * (toolReward * player.TemporaryData.MultPerClick.Value)

    player.TemporaryData.TixPerClick.Value = tixPerClick
    return tixPerClick
end

function TemporaryData:CalculateTixStorage(player, data)
    TemporaryData:CalculateAccessories(player, data)
    local toolEquipped = data.ToolEquipped
    local toolReward = Upgrades[toolEquipped].Reward["MultStorage"]
    local tixStorage = (TemporaryProfileData.TixStorage.Value + player.TemporaryData.AddStorage.Value) * (toolReward * player.TemporaryData.MultStorage.Value)
    player.TemporaryData.TixStorage.Value = tixStorage
    return tixStorage
end

function TemporaryData:CalculateTixPerSecondCost(owned, upgrade, amount)
	local cost = PerSecondUpgrades[upgrade].Cost
	local modifier = PerSecondUpgrades[upgrade].Modifier
	return math.ceil(cost * modifier^(owned + amount - 1))
end

function TemporaryData:CalculateTixPerSecond(player, data)
    TemporaryData:CalculateAccessories(player, data)
	local tixPerSecond = 0
    local ownedUpgrades = data.PerSecondUpgrades
	for upgrade, value in ownedUpgrades do
        if PerSecondUpgrades[upgrade] then
            local reward = PerSecondUpgrades[upgrade].Reward
            tixPerSecond += value * reward
        end
	end
    player.TemporaryData.TixPerSecond.Value = tixPerSecond
	return tixPerSecond
end
	

function TemporaryData:CalculateValue(data)
    return 0
end

function TemporaryData:CalculateRequiredXP(level)
    return math.floor((level * 10) * (((level - 1) * 0.1) + 1))
end

function TemporaryData:GetLeaderstatDisplayName(key)
	local leaderstatsProfile = ProfileData.leaderstats
	for index, data in leaderstatsProfile do
		if data.ID == key then
			return data.DisplayName
		end
	end
end

function TemporaryData:Setup(player, data)
    TemporaryData:CalculateTixStorage(player, data)
	TemporaryData:CalculateTixPerClick(player, data)
	TemporaryData:CalculateTixPerSecond(player, data)
end

function TemporaryData:CalculateMaterialInfo(itemValue)

    for _, material in Materials do
        if material.Value and itemValue >= material.Value[1] and itemValue <= material.Value[2] then
            local materialID = material.ID
            local minVal = material.Value[1]
            local maxVal = material.Value[2]
            local maxQuantity = 5  
            local minQuantity = 1
            local chanceToReceive = 0.25 
            local quantity = math.floor(minQuantity + (itemValue - minVal) * ((maxQuantity - minQuantity) / (maxVal - minVal)))

            return quantity, chanceToReceive, materialID
        end
    end
end

return TemporaryData