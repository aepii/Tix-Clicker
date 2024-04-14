local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local ReplicatedUpgrades = require(ReplicatedStorage.Data.Upgrades)
local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)

local part = Workspace.EarnTixPart

local function earnTix(player)
    print("Clicked!")
    local temporaryData = player:WaitForChild("TemporaryData")
    local data = ProfileCacher:GetProfile(player).Data

    local tixStorage = temporaryData.TixStorage
    local tixPerClick = temporaryData.TixPerClick

    if data.Tix < tixStorage.Value then
        data.Tix = math.min(data.Tix + tixPerClick.Value, tixStorage.Value)
    end
end

part.ClickDetector.MouseClick:Connect(earnTix)
