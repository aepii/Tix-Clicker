local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local ReplicatedValueUpgrades = require(ReplicatedStorage.Data.ValueUpgrades)

local function playerAdded(player)
    local temporaryData = player:WaitForChild("TemporaryData")
    local tixPerSecond = temporaryData.TixPerSecond
    local tixStorage = temporaryData.TixStorage
    local data = ProfileCacher:GetProfile(player).Data
    coroutine.resume(coroutine.create(function()
        while task.wait(1) and player:IsDescendantOf(Players) do
			tixPerSecond.Value = ReplicatedValueUpgrades:TixPerSecond(data.ValueUpgrades)
            if tixPerSecond.Value > 0 and data.Tix < tixStorage.Value then
                data.Tix = math.min(data.Tix + tixPerSecond.Value, tixStorage.Value) 
            end
		end
    end))
end

Players.PlayerAdded:Connect(playerAdded)