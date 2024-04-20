---- Services ----

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

---- Data ----

local ProfileData = require(ReplicatedStorage.Data.ProfileData)
local Upgrades = require(ReplicatedStorage.Data.Upgrades)
local ValueUpgrades = require(ReplicatedStorage.Data.ValueUpgrades)

local TemporaryProfileData = ProfileData.TemporaryData

local TemporaryData = {}

---- Temporary Data ----

function TemporaryData:CalculateTixPerClick(player, data)
    local toolEquipped = data.ToolEquipped
    local toolReward = Upgrades[toolEquipped].Reward["MultPerClick"]
    local tixPerClick = TemporaryProfileData.TixPerClick.Value * toolReward

    player.TemporaryData.TixPerClick.Value = tixPerClick
    return tixPerClick
end

function TemporaryData:CalculateTixStorage(player, data)
    local toolEquipped = data.ToolEquipped
    local toolReward = Upgrades[toolEquipped].Reward["MultStorage"]
    local tixStorage = TemporaryProfileData.TixStorage.Value * toolReward

    player.TemporaryData.TixStorage.Value = tixStorage
    return tixStorage
end

function TemporaryData:CalculateTixPerSecondCost(owned, upgrade, amount)
	local cost = ValueUpgrades[upgrade].Cost
	local modifier = ValueUpgrades[upgrade].Modifier
	return math.ceil(cost * modifier^(owned + amount - 1))
end

function TemporaryData:CalculateTixPerSecond(player, data)
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

return TemporaryData