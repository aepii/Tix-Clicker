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

---- Private ----

local RarityTags = {
    Basic = "Z",
    Common = "Y",
    Uncommon = "X",
    Fine = "W",
    Rare = "V",
    Exceptional = "U",
    Epic = "T",
    Heroic = "S",
    Legendary = "R"
}

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
            player.TemporaryData[upgradeData.RewardType].Value = (upgradeData.Reward * value)
        end
    end
    TemporaryData:CalculateAccessoriesLimit(player, data)
    TemporaryData:CalculateEquippedAccessoriesLimit(player, data)
    TemporaryData:CalculateMaterialMaxDrop(player, data)
    TemporaryData:CalculateMaterialDropChance(player, data)
    TemporaryData:CalculateCaseTime(player, data)
    TemporaryData:CalculateSpeedTixConvert(player, data)
    TemporaryData:CalculateCriticalChance(player, data)
    TemporaryData:CalculateCriticalPower(player, data)
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

function TemporaryData:CalculateAccessoriesLimit(player, data)
    local accessoriesLimit = TemporaryProfileData.AccessoriesLimit.Value + player.TemporaryData.RebirthAccessoriesLimit.Value
    player.TemporaryData.AccessoriesLimit.Value = accessoriesLimit
    return accessoriesLimit
end

function TemporaryData:CalculateEquippedAccessoriesLimit(player, data)
    local equippedAccessoriesLimit = TemporaryProfileData.EquippedAccessoriesLimit.Value + player.TemporaryData.RebirthEquippedAccessoriesLimit.Value
    player.TemporaryData.EquippedAccessoriesLimit.Value = equippedAccessoriesLimit
    return equippedAccessoriesLimit
end

function TemporaryData:CalculateMaterialMaxDrop(player, data)
    local materialMaxDrop = TemporaryProfileData.MaterialMaxDrop.Value + player.TemporaryData.RebirthMaterialMaxDrop.Value
    player.TemporaryData.MaterialMaxDrop.Value = materialMaxDrop
    return materialMaxDrop
end

function TemporaryData:CalculateMaterialDropChance(player, data)
    local materialDropChance = TemporaryProfileData.MaterialDropChance.Value + player.TemporaryData.RebirthMaterialDropChance.Value
    player.TemporaryData.MaterialDropChance.Value = materialDropChance
    return materialDropChance
end

function TemporaryData:CalculateCaseTime(player, data)
    local caseTime = TemporaryProfileData.CaseTime.Value - player.TemporaryData.RebirthCaseTime.Value
    player.TemporaryData.CaseTime.Value = caseTime
    return caseTime
end

function TemporaryData:CalculateCriticalChance(player, data)
    local criticalChance;
    if player.TemporaryData.RageMode.Value == true then
        criticalChance = 100
    else
        criticalChance = TemporaryProfileData.CriticalChance.Value + player.TemporaryData.RebirthCriticalChance.Value 
    end

    player.TemporaryData.CriticalChance.Value = criticalChance
    return criticalChance
end

function TemporaryData:CalculateCriticalPower(player, data)
    local criticalPower = TemporaryProfileData.CriticalPower.Value + player.TemporaryData.RebirthCriticalPower.Value
    player.TemporaryData.CriticalPower.Value = criticalPower
    return criticalPower
end

function TemporaryData:CalculateSpeedTixConvert(player, data)
    local speedTixConvert = TemporaryProfileData.SpeedTixConvert.Value - player.TemporaryData.RebirthSpeedTixConvert.Value
    player.TemporaryData.SpeedTixConvert.Value = speedTixConvert
    return speedTixConvert
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
            local reward = PerSecondUpgrades[upgrade].Reward.AddPerSecond
            tixPerSecond += value * reward
        end
	end
    player.TemporaryData.TixPerSecond.Value = tixPerSecond * (1 + player.TemporaryData.RebirthMultPerSecond.Value / 100)
	return tixPerSecond
end
	
function TemporaryData:CalculateConvertPerSecond(player, data)
    TemporaryData:CalculateAccessories(player, data)
    TemporaryData:CalculateRebirthUpgrades(player, data)
	local convertPerSecond = 0
	for upgrade, value in data.PerSecondUpgrades do
        if PerSecondUpgrades[upgrade] then
            local reward = PerSecondUpgrades[upgrade].Reward.AddConvert
            convertPerSecond += value * reward
        end
	end
    player.TemporaryData.ConvertPerSecond.Value = convertPerSecond
	return convertPerSecond
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
    TemporaryData:CalculateConvertPerSecond(player, data)
    TemporaryData:CalculateAccessoriesLimit(player, data)
    TemporaryData:CalculateEquippedAccessoriesLimit(player, data)
    TemporaryData:CalculateMaterialMaxDrop(player, data)
    TemporaryData:CalculateMaterialDropChance(player, data)
    TemporaryData:CalculateCaseTime(player, data)
    TemporaryData:CalculateSpeedTixConvert(player, data)
    TemporaryData:CalculateCriticalChance(player, data)
    TemporaryData:CalculateCriticalPower(player, data)
end

function TemporaryData:CalculateMaterialInfo(player, itemValue)

    for _, material in Materials do
        if material.Value and itemValue >= material.Value[1] and itemValue <= material.Value[2] then
            local materialID = material.ID
            local minVal = material.Value[1]
            local maxVal = material.Value[2]
            local maxQuantity =  player.TemporaryData.MaterialMaxDrop.Value
            local minQuantity = 1
            local chanceToReceive = player.TemporaryData.MaterialDropChance.Value / 100
            local quantity = math.floor(minQuantity + (itemValue - minVal) * ((maxQuantity - minQuantity) / (maxVal - minVal)))

            return quantity, chanceToReceive, materialID
        end
    end
end

function TemporaryData:CalculateRebirthInfo(value)
    local VALUE_TO_REBIRTH_TIX = 1000
    local rebirthTixReward = math.floor(value / VALUE_TO_REBIRTH_TIX)
    local valueCost = math.floor(value / VALUE_TO_REBIRTH_TIX) * VALUE_TO_REBIRTH_TIX

    return rebirthTixReward, valueCost, VALUE_TO_REBIRTH_TIX
end

function TemporaryData:CalculateTag(player, GUID)
    for index, data in player.ReplicatedData.Accessories:GetChildren() do
        if data.Name == GUID then
            local ID = data.Value
            local accessory = Accessories[ID]
            local equippedAccessory = player.ReplicatedData.EquippedAccessories:FindFirstChild(ID)
            local rarity = accessory.Rarity
            local value = accessory.Value
            if equippedAccessory then
                if equippedAccessory.Value == GUID then
                    return "@".. RarityTags[rarity] .. ID .. value .. GUID
                else
                    return RarityTags[rarity] .. ID .. value .. GUID
                end
            else
                return RarityTags[rarity] .. ID .. value .. GUID
            end
        end
    end
end

return TemporaryData