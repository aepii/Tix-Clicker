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

---- Networking ----

local Networking = ReplicatedStorage.Networking
local ExchangeTixRemote = Networking.ExchangeTix

---- Private Functions ----

local function playerAdded(player)
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data
    local queuedTix = player.TemporaryData.QueuedTix

    coroutine.resume(coroutine.create(function()
        while task.wait() and player:IsDescendantOf(Players) do
            local tixStorage = TemporaryData:CalculateTixStorage(player, data)
            local convertPerSecond = TemporaryData:CalculateConvertPerSecond(player, data)
            queuedTix.Value += convertPerSecond

            if queuedTix.Value >= 20 and data.Tix >= queuedTix.Value then
                local tixExchanged = math.floor(queuedTix.Value / 20) * 20
                local rocashGained = math.floor(queuedTix.Value / 20)

                DataManager:SetValue(player, profile, {"Rocash"}, data.Rocash + rocashGained)
                DataManager:SetValue(player, profile, {"Lifetime Rocash"}, data.Rocash + rocashGained)
                DataManager:SetValue(player, profile, {"Tix"}, data.Tix - tixExchanged)
                DataManager:UpdateLeaderstats(player, profile, "Tix")
                DataManager:UpdateLeaderstats(player, profile, "Rocash")

                queuedTix.Value -= tixExchanged

                if player.TemporaryData.ActiveCaseOpening.Value == false then
                    ExchangeTixRemote:FireClient(player, tixExchanged, rocashGained)
                end
            elseif queuedTix.Value >= 20 and data.Tix >= 20 and data.Tix < queuedTix.Value then
                local tixExchanged = math.floor(data.Tix / 20) * 20
                local rocashGained = math.floor(data.Tix / 20)

                DataManager:SetValue(player, profile, {"Rocash"}, data.Rocash + rocashGained)
                DataManager:SetValue(player, profile, {"Lifetime Rocash"}, data.Rocash + rocashGained)
                DataManager:SetValue(player, profile, {"Tix"}, data.Tix - tixExchanged)
                DataManager:UpdateLeaderstats(player, profile, "Tix")
                DataManager:UpdateLeaderstats(player, profile, "Rocash")

                queuedTix.Value = math.min((queuedTix.Value - tixExchanged), convertPerSecond)

                if player.TemporaryData.ActiveCaseOpening.Value == false then
                    ExchangeTixRemote:FireClient(player, tixExchanged, rocashGained)
                end
            end
            task.wait(1)
        end
    end))
end

Players.PlayerAdded:Connect(playerAdded)