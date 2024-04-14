local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local Upgrades = require(ReplicatedStorage.Data.Upgrades)

local function playerAdded(player)
    local temporaryData = player:WaitForChild("TemporaryData")
    local data = ProfileCacher:GetProfile(player).Data
    coroutine.resume(coroutine.create(function()
        while task.wait() and player:IsDescendantOf(Players) do
			local upgrade = Upgrades[data.Equipped]
			temporaryData.TixPerClick.Value = 1 * upgrade.Reward
		end
    end))
end

Players.PlayerAdded:Connect(playerAdded)