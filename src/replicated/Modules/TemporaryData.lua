---- Services ----

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

---- Data ----

local TemporaryProfileData = require(ReplicatedStorage.Data.ProfileData).TemporaryData

local TemporaryData = {}

function TemporaryData:CalculateTixPerClick(data)
    return TemporaryProfileData.TixPerClick
end

function TemporaryData:CalculateTixStorage(data)
    return TemporaryProfileData.TixStorage
end


return TemporaryData