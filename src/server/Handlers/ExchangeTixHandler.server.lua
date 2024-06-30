---- Services ----

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")

---- Data ----

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local DataManager = require(ServerScriptService.Data.DataManager)

---- Networking ----

local Networking = ReplicatedStorage.Networking
local ExchangeTixRemote = Networking.ExchangeTix

---- Exchange Tix ----

local debounceTable = {}

local function exchangeTix(player)
    local profile = ProfileCacher:GetProfile(player)
    local data = ProfileCacher:GetProfile(player).Data
    
    if player.TemporaryData.ActiveCaseOpening.Value == false then
        if data.Tix >= 20 then
            local tixExchanged = math.floor(data.Tix / 20) * 20
            local rocashGained = math.floor(data.Tix / 20)

            DataManager:SetValue(player, profile, {"Rocash"}, data.Rocash + rocashGained)
            DataManager:SetValue(player, profile, {"Lifetime Rocash"}, (data["Lifetime Rocash"] or 0) + rocashGained)
            DataManager:SetValue(player, profile, {"Tix"}, data.Tix - tixExchanged)
            DataManager:UpdateLeaderstats(player, profile, "Tix")
            DataManager:UpdateLeaderstats(player, profile, "Rocash")
            ExchangeTixRemote:FireClient(player, tixExchanged, rocashGained)
        end
    end
end

---- Setup ----

local ExchangeStation = Workspace.Exchange.ExchangeStation
local Hitbox = ExchangeStation.TouchPart.Hitbox

Hitbox.Touched:Connect(function(hit)
    if hit.Parent:FindFirstChild("Humanoid") then
		local player = Players:GetPlayerFromCharacter(hit.Parent)
        if not debounceTable[player] then
            debounceTable[player] = player
            exchangeTix(player)
            task.wait(1)
            debounceTable[player] = nil
        end
    end
end)