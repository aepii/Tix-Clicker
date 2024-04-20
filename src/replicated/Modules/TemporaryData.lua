---- Services ----

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

---- Data ----

local ProfileData = require(ReplicatedStorage.Data.ProfileData)

local TemporaryProfileData = ProfileData.TemporaryData

local TemporaryData = {}

---- Temporary Data ----

function TemporaryData:CalculateTixPerClick(player, data)
    player.TemporaryData.TixPerClick.Value = TemporaryProfileData.TixPerClick.Value
    return TemporaryProfileData.TixPerClick
end

function TemporaryData:CalculateTixStorage(player, data)
    player.TemporaryData.TixStorage.Value = TemporaryProfileData.TixStorage.Value
    return TemporaryProfileData.TixStorage
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