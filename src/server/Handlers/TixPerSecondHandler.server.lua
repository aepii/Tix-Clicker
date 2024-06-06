---- Services ----

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TemporaryData = require(Modules.TemporaryData)

---- Networking ----

local Networking = ReplicatedStorage.Networking
local AnimateTixRemote = Networking.AnimateTix

---- Data ----

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local DataManager = require(ServerScriptService.Data.DataManager)

---- Private Functions ----

local function playerAdded(player)
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data

    coroutine.resume(coroutine.create(function()
        while task.wait() and player:IsDescendantOf(Players) do
            local tixStorage = TemporaryData:CalculateTixStorage(player, data)
            local tixPerSecond = TemporaryData:CalculateTixPerSecond(player, data)
            if data.Tix < tixStorage and tixPerSecond > 0 then
                DataManager:SetValue(player, profile, {"Tix"}, math.min(data.Tix + tixPerSecond, tixStorage))
                DataManager:UpdateLeaderstats(player, profile, "Tix")
                AnimateTixRemote:FireClient(player, tixPerSecond)
            end
            task.wait(1)
		end
    end))
end

Players.PlayerAdded:Connect(playerAdded)