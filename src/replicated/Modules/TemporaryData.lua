---- Services ----

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

---- Data ----

local ProfileData = require(ReplicatedStorage.Data.ProfileData)
local Upgrades = require(ReplicatedStorage.Data.Upgrades)
local ValueUpgrades = require(ReplicatedStorage.Data.ValueUpgrades)
local Accessories = require(ReplicatedStorage.Data.Accessories)

local TemporaryProfileData = ProfileData.TemporaryData

local TemporaryData = {}

---- Temporary Data ----

function TemporaryData:CalculateAccessories(player, data)
    local addPerClick, addStorage = 0, 0
    local  multPerClick, multStorage = 1, 1
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
	local cost = ValueUpgrades[upgrade].Cost
	local modifier = ValueUpgrades[upgrade].Modifier
	return math.ceil(cost * modifier^(owned + amount - 1))
end

function TemporaryData:CalculateTixPerSecond(player, data)
    TemporaryData:CalculateAccessories(player, data)
	local tixPerSecond = 0
    local ownedUpgrades = data.ValueUpgrades
	for upgrade, value in ownedUpgrades do
        if ValueUpgrades[upgrade] then
            local reward = ValueUpgrades[upgrade].Reward
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

function TemporaryData:GetDisplayName(key)
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

return TemporaryData