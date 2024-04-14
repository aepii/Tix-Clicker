local Workspace = game:GetService("Workspace")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local ValueUpgrades = require(ReplicatedStorage.Data.ValueUpgrades)

local part = Workspace.BuyTPSPart

local UPGRADE = "SecUpgrade1"

local function purchaseUpgrade(player)
    print("Clicked!")

    local data = ProfileCacher:GetProfile(player).Data
    local owned = data.ValueUpgrades[UPGRADE] or 0
    local cost = ValueUpgrades:TixPerSecondCost(UPGRADE, 1, owned)
    if data.Rocash >= cost then
        data.ValueUpgrades[UPGRADE] = (data.ValueUpgrades[UPGRADE] or 0) + 1
        data.Rocash -= cost
    end
end

part.ClickDetector.MouseClick:Connect(purchaseUpgrade)
