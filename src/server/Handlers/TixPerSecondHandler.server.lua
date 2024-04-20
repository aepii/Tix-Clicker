---- Services ----

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TemporaryData = require(Modules.TemporaryData)

---- Data ----

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local ReplicatedProfile = require(ServerScriptService.Data.ReplicatedProfile)

---- Private Functions ----

local function replicateData(player, profile, replicatedData)
    local data = profile.Data

    replicatedData.Tix.Value = data.Tix
    replicatedData["Lifetime Tix"].Value = data["Lifetime Tix"]

    ReplicatedProfile:UpdateLeaderstats(player, profile, "Tix")
end


local function playerAdded(player)
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data
    local replicatedData = player.ReplicatedData

    coroutine.resume(coroutine.create(function()
        while task.wait() and player:IsDescendantOf(Players) do
            local tixStorage = TemporaryData:CalculateTixStorage(player, data)
            local tixPerSecond = TemporaryData:CalculateTixPerSecond(player, data)
            print(data.Tix)
            data.Tix = math.min(data.Tix + tixPerSecond, tixStorage)
            replicateData(player, profile, replicatedData)
            task.wait(1)
		end
    end))
end

Players.PlayerAdded:Connect(playerAdded)