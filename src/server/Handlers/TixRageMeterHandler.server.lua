---- Services ----

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TemporaryData = require(Modules.TemporaryData)

---- Data ----

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local DataManager = require(ServerScriptService.Data.DataManager)

---- Private Functions ----

local function playerAdded(player)
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data

    coroutine.resume(coroutine.create(function()
        while task.wait(0.1) and player:IsDescendantOf(Players) do
            if player.TemporaryData.ActiveCaseOpening.Value == false then
                local lastClickTime = player.TemporaryData.LastClickTime
                local elapsedTime = os.time() - lastClickTime.Value 
                if elapsedTime > 15 and player.TemporaryData.XP.Value > 0 then
                    player.TemporaryData.XP.Value = math.max(0, player.TemporaryData.XP.Value - ((elapsedTime + 20)^1.25 * .02))
                end
            end
		end
    end))
end

Players.PlayerAdded:Connect(playerAdded)