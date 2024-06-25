---- Services ----

local ReplicatedStorage = game:GetService("ReplicatedStorage")

---- Data ----

local Data = ReplicatedStorage:WaitForChild("Data")
local ProfileData = require(Data:WaitForChild("ProfileData"))

local Upgrades = require(ReplicatedStorage.Data.Upgrades)
local PerSecondUpgrades = require(ReplicatedStorage.Data.PerSecondUpgrades)
local Accessories = require(ReplicatedStorage.Data.Accessories)
local Materials = require(ReplicatedStorage.Data.Materials)
local RebirthUpgrades = require(ReplicatedStorage.Data.RebirthUpgrades)

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
    Legendary = "R",
    Mythical = "Q",
    Divine = "P",
    Celestial = "O",
    Ascended = "N",
    Transcendent = "M",
    Cosmic = "L",
    
    Tixclusive = "A",
    Exclusive = "B",
    Exotic = "C",
    Event = "D",
    Godly = "E",
}

---- Temporary Data ----

local TemporaryData = {}

function TemporaryData:CalculateAccessories(player, data)
    local addPerClick, addStorage = TemporaryProfileData.AddPerClick.Value, TemporaryProfileData.AddStorage.Value
    local multPerClick, multStorage = TemporaryProfileData.MultPerClick.Value, TemporaryProfileData.MultStorage.Value
    for ID, GUID in data.EquippedAccessories do
        local accessory = Accessories[ID]
        local rewards = accessory.Reward
        
        if rewards.Best then
            local bestAccessory = TemporaryData:GetBestAccessory(player)
            local bestRewards = bestAccessory.Reward
        
            addPerClick += (bestRewards["AddPerClick"] or 0) * accessory.Reward["Best"]
            addStorage += (bestRewards["AddStorage"] or 0) * accessory.Reward["Best"] 
            multPerClick += (bestRewards["MultPerClick"] or 0) * accessory.Reward["Best"] 
            multStorage += (bestRewards["MultStorage"] or 0) * accessory.Reward["Best"] 
        else
            addPerClick += rewards.AddPerClick or 0
            addStorage += rewards.AddStorage or 0
            multPerClick += rewards.MultPerClick or 0
            multStorage += rewards.MultStorage or 0
        end

    end
    multPerClick = math.max(1, multPerClick)
    multStorage = math.max(1, multStorage)
    player.TemporaryData.AddPerClick.Value = addPerClick
    player.TemporaryData.AddStorage.Value = addStorage
    player.TemporaryData.MultPerClick.Value = multPerClick
    player.TemporaryData.MultStorage.Value = multStorage
end

function TemporaryData:GetBestAccessories(player)

    local ReplicatedData = player.ReplicatedData
    local ReplicatedTemporaryData = player.TemporaryData
    local ReplicatedAccessories = ReplicatedData.Accessories

    local EquippedAccessoriesLimit = ReplicatedTemporaryData.EquippedAccessoriesLimit

    local validID = {}
    local UnsortedAccessories = {}

    for _, data in ReplicatedAccessories:GetChildren() do
        local GUID = data.Name
        local ID = data.Value
        local accessory = Accessories[ID]
        local rewards = accessory.Reward   
        local valueIndicator;

        if not validID[ID] then

            if rewards.Best then
                local bestAccessory = TemporaryData:GetBestAccessory(player)
                local bestRewards = bestAccessory.Reward

                valueIndicator = bestRewards["AddPerClick"] * accessory.Reward["Best"]
            else
                valueIndicator = rewards["AddPerClick"] 
            end

            table.insert(UnsortedAccessories, {GUID = GUID, Value = valueIndicator})
            validID[ID] = true
        end
    end

    table.sort(UnsortedAccessories, function(a, b)
        return a.Value > b.Value
    end)

    local bestAccessories = {}
    for i = 1, math.min(#UnsortedAccessories, EquippedAccessoriesLimit.Value) do
        table.insert(bestAccessories, UnsortedAccessories[i])
    end

    return bestAccessories
end

function TemporaryData:CalculateRebirthUpgrades(player, data)
    for upgrade, value in data.RebirthUpgrades do
        if RebirthUpgrades[upgrade] then
            local upgradeData = RebirthUpgrades[upgrade]
            if upgradeData.Type == "Multiply" then
                player.TemporaryData[upgradeData.RewardType].Value = ((1 + upgradeData.Reward / 100) ^ value)
            else
                player.TemporaryData[upgradeData.RewardType].Value = (upgradeData.Reward * value)
            end
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

    local tixPerClick = (player.TemporaryData.RebirthMultPerClick.Value) * (TemporaryProfileData.TixPerClick.Value + player.TemporaryData.AddPerClick.Value) * (toolReward * player.TemporaryData.MultPerClick.Value)

    player.TemporaryData.TixPerClick.Value = tixPerClick
    return tixPerClick
end

function TemporaryData:CalculateTixStorage(player, data)
    TemporaryData:CalculateAccessories(player, data)
    TemporaryData:CalculateRebirthUpgrades(player, data)
    local toolEquipped = data.ToolEquipped
    local toolReward = Upgrades[toolEquipped].Reward["MultStorage"]
    local tixStorage = (player.TemporaryData.RebirthMultStorage.Value) * (TemporaryProfileData.TixStorage.Value + player.TemporaryData.AddStorage.Value) * (toolReward * player.TemporaryData.MultStorage.Value)
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
        if material.Rarity and itemValue >= material.Value[1] and itemValue <= material.Value[2] then
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

function TemporaryData:CalculateMultipleMaterialInfo(player, multiSelected)

    local materialID;
    local totalQuantity = 0
    local chanceToReceive = player.TemporaryData.MaterialDropChance.Value / 100

    local items = multiSelected:GetChildren()
    local itemSelectedID = items[1].Value
    local itemSelectedValue = Accessories[itemSelectedID].Value

    for _, material in Materials do
        if material.Rarity and itemSelectedValue >= material.Value[1] and itemSelectedValue <= material.Value[2] then
            materialID = material.ID
            print(materialID)
            break
        end
    end

    for _, item in items do
        local ID = item.Value
        local itemValue = Accessories[ID].Value
        
        local minVal = Materials[materialID].Value[1]
        local maxVal = Materials[materialID].Value[2]
        local maxQuantity =  player.TemporaryData.MaterialMaxDrop.Value
        local minQuantity = 1
        local quantity = math.floor(minQuantity + (itemValue - minVal) * ((maxQuantity - minQuantity) / (maxVal - minVal)))

        totalQuantity += quantity
    end
    
    print(totalQuantity)
    return totalQuantity, chanceToReceive, materialID

end

function TemporaryData:CalculateRebirthInfo(rocash, value)
    local ROCASH_TO_REBIRTH_TIX = 1000
    local VALUE_TO_REBIRTH_TIX = 1000
    local rocashCost = math.floor(rocash / ROCASH_TO_REBIRTH_TIX) * ROCASH_TO_REBIRTH_TIX
    local valueCost = math.floor(value / VALUE_TO_REBIRTH_TIX) * VALUE_TO_REBIRTH_TIX

    local rebirthTixReward = math.min(math.floor(rocash / ROCASH_TO_REBIRTH_TIX), math.floor(value / VALUE_TO_REBIRTH_TIX))

    return rebirthTixReward, rocashCost, ROCASH_TO_REBIRTH_TIX, valueCost, VALUE_TO_REBIRTH_TIX
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

function TemporaryData:GetBestAccessory(player)

    local ReplicatedData = player.ReplicatedData
    local ReplicatedAccessories = ReplicatedData.Accessories

    local value = 0
    local bestAccessory = nil

    for _, data in ReplicatedAccessories:GetChildren() do
        local ID = data.Value
        local accessory = Accessories[ID]

        if accessory.Value >= value then
            value = accessory.Value
            bestAccessory = accessory
        end
    end

    return bestAccessory
end

return TemporaryData