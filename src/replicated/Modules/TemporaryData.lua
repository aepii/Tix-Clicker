---- Services ----

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

---- Data ----

local ProfileData = require(ReplicatedStorage.Data.ProfileData)
local Upgrades = require(ReplicatedStorage.Data.Upgrades)

local TemporaryProfileData = ProfileData.TemporaryData

local TemporaryData = {}

---- Temporary Data ----

function TemporaryData:CalculateTixPerClick(player, data)
    local toolEquipped = data.ToolEquipped
    local toolReward = Upgrades[toolEquipped].Reward["MultPerClick"]
    local value = TemporaryProfileData.TixPerClick.Value * toolReward

    player.TemporaryData.TixPerClick.Value = value
    return value
end

function TemporaryData:CalculateTixStorage(player, data)
    local toolEquipped = data.ToolEquipped
    local toolReward = Upgrades[toolEquipped].Reward["MultStorage"]
    local value = TemporaryProfileData.TixStorage.Value * toolReward

    player.TemporaryData.TixStorage.Value = value
    return value
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