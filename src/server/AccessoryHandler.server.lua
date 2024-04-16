local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local Accessories = require(ReplicatedStorage.Data.Accessories)

local function playerAdded(player)
    local temporaryData = player:WaitForChild("TemporaryData")
    local data = ProfileCacher:GetProfile(player).Data
    coroutine.resume(coroutine.create(function()
        while task.wait() and player:IsDescendantOf(Players) do
            local addPerClick = 0
            local addStorage = 0 
            for ID, GUID in data.EquippedAccessories do
                local accessory = Accessories[ID]
                local rewards = accessory.Reward
                
                addPerClick += rewards.AddPerClick or 0
                addStorage += rewards.AddStorage or 0
            end
            temporaryData.AddPerClick.Value = addPerClick
            temporaryData.AddStorage.Value = addStorage
		end
    end))
end

Players.PlayerAdded:Connect(playerAdded)