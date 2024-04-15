local Workspace = game:GetService("Workspace")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local Cases = require(ReplicatedStorage.Data.Cases)

local part = Workspace.BuyCasePart

local CASE = "C1"

local function purchaseCase(player)
    print("Clicked!")

    local data = ProfileCacher:GetProfile(player).Data
    local cost = Cases[CASE].Cost
    if data.Rocash >= cost then
        data.Inventory[CASE] = (data.Inventory[CASE] or 0) + 1
        data.Rocash -= cost
    end
end

part.ClickDetector.MouseClick:Connect(purchaseCase)
