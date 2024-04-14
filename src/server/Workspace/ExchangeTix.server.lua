local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local ReplicatedUpgrades = require(ReplicatedStorage.Data.Upgrades)
local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)

local part = Workspace.ExchangeTixPart

local function exchangeTix(player)
    print("Exchange!")
    local data = ProfileCacher:GetProfile(player).Data

    if data.Tix >= 20 then
        data.Rocash += math.floor(data.Tix / 20)
        data.Tix -= math.floor(data.Tix / 20) * 20
    end
end

part.ClickDetector.MouseClick:Connect(exchangeTix)
