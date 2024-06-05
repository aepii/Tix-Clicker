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
local RebirthUpgrades = require(ReplicatedStorage.Data.RebirthUpgrades)

local leaderstatsProfileData = ProfileData.leaderstats
local TemporaryProfileData = ProfileData.TemporaryData

---- Temporary Data ----

local TemporaryData = {}

function TemporaryData:CalculateAccessories(player, data)
    local addPerClick, addStorage = TemporaryProfileData.AddPerClick.Value, TemporaryProfileData.AddStorage.Value
    local multPerClick, multStorage = TemporaryProfileData.MultPerClick.Value, TemporaryProfileData.MultStorage.Value
    for ID, GUID in data.EquippedAccessories do
        local accessory = Accessories[ID]
        local rewards = accessory.Reward
        
        addPerClick += rewards.AddPerClick or 0
        addStorage += rewards.AddStorage or 0
        multPerClick += rewards.MultPerClick or 0
        multStorage += rewards.MultStorage or 0
    end
    player.TemporaryData.AddPerClick.Value = addPerClick
    player.TemporaryData.AddStorage.Value = addStorage
    player.TemporaryData.MultPerClick.Value = multPerClick
    player.TemporaryData.MultStorage.Value = multStorage
end

function TemporaryData:CalculateRebirthUpgrades(player, data)
    for upgrade, value in data.RebirthUpgrades do
        if RebirthUpgrades[upgrade] then
            local upgradeData = RebirthUpgrades[upgrade]
            player.TemporaryData[upgradeData.RewardType].Value = upgradeData.Initial + (upgradeData.Reward * value)
        end
    end
end

function TemporaryData:CalculateTixPerClick(player, data)
    TemporaryData:CalculateAccessories(player, data)
    TemporaryData:CalculateRebirthUpgrades(player, data)
    local toolEquipped = data.ToolEquipped
    local toolReward = Upgrades[toolEquipped].Reward["MultPerClick"]

    local tixPerClick = (1 + player.TemporaryData.RebirthMultPerClick.Value / 100) * (TemporaryProfileData.TixPerClick.Value + player.TemporaryData.AddPerClick.Value) * (toolReward * player.TemporaryData.MultPerClick.Value)

    player.TemporaryData.TixPerClick.Value = tixPerClick
    return tixPerClick
end

function TemporaryData:CalculateTixStorage(player, data)
    TemporaryData:CalculateAccessories(player, data)
    TemporaryData:CalculateRebirthUpgrades(player, data)
    local toolEquipped = data.ToolEquipped
    local toolReward = Upgrades[toolEquipped].Reward["MultStorage"]
    local tixStorage = (1 + player.TemporaryData.RebirthMultStorage.Value / 100) * (TemporaryProfileData.TixStorage.Value + player.TemporaryData.AddStorage.Value) * (toolReward * player.TemporaryData.MultStorage.Value)
    player.TemporaryData.TixStorage.Value = tixStorage
    return tixStorage
end

function TemporaryData:CalculateTixPerSecondCost(owned, upgrade, amount)
	local cost = PerSecondUpgrades[upgrade].Cost
	local modifier = PerSecondUpgrades[upgrade].Modifier
	return math.ceil(cost * modifier^(owned + amount - 1))
end

function TemporaryData:CalculateRebirthUpgradeCost(owned, upgrade, amount)
	local cost = RebirthUpgrades[upgrade].Cost
	local modifier = RebirthUpgrades[upgrade].Modifier
	return math.ceil(cost * modifier^(owned + amount - 1))
end

function TemporaryData:CalculateTixPerSecond(player, data)
    TemporaryData:CalculateAccessories(player, data)
    TemporaryData:CalculateRebirthUpgrades(player, data)
	local tixPerSecond = 0
	for upgrade, value in data.PerSecondUpgrades do
        if PerSecondUpgrades[upgrade] then
            local reward = PerSecondUpgrades[upgrade].Reward
            tixPerSecond += value * reward
        end
	end
    player.TemporaryData.TixPerSecond.Value = tixPerSecond
	return tixPerSecond
end
	

function TemporaryData:CalculateValue(player, data)
    local value = 0
    for GUID, ID in data.Accessories do
        local accessory = Accessories[ID]
        value += accessory.Value
    end
    player.TemporaryData.Value.Value = value
    return value
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

function TemporaryData:CalculateMaterialInfo(player, itemValue)

    for _, material in Materials do
        if material.Value and itemValue >= material.Value[1] and itemValue <= material.Value[2] then
            local materialID = material.ID
            local minVal = material.Value[1]
            local maxVal = material.Value[2]
            local maxQuantity = player.TemporaryData.RebirthMaterialMaxDrop.Value
            local minQuantity = 1
            local chanceToReceive = player.TemporaryData.RebirthMaterialDropChance.Value / 100
            local quantity = math.floor(minQuantity + (itemValue - minVal) * ((maxQuantity - minQuantity) / (maxVal - minVal)))

            return quantity, chanceToReceive, materialID
        end
    end
end

function TemporaryData:CalculateRebirthInfo(value)
    local VALUE_TO_REBIRTH_TIX = 1000
    print(value)
    local rebirthTixReward = math.floor(value / VALUE_TO_REBIRTH_TIX)
    local valueCost = math.floor(value / VALUE_TO_REBIRTH_TIX) * VALUE_TO_REBIRTH_TIX

    return rebirthTixReward, valueCost, VALUE_TO_REBIRTH_TIX
end


return TemporaryData