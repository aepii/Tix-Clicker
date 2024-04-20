---- Services ----

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TemporaryData = require(Modules.TemporaryData)

---- Data ----

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local Cases = require(ReplicatedStorage.Data.Cases)
local ReplicatedProfile = require(ServerScriptService.Data.ReplicatedProfile)

---- Networking ----

local Networking = ReplicatedStorage.Networking
local PurchaseCaseRemote = Networking.PurchaseCase
local UpdateClientShopInfoRemote = Networking.UpdateClientShopInfo

---- Private Functions ----

local function replicateData(player, profile, replicatedData, caseName)
    local data = profile.Data
    replicatedData.Rocash.Value = data.Rocash

    local replicatedUpgrade = replicatedData.Cases:FindFirstChild(caseName)
    if replicatedUpgrade then
        replicatedUpgrade.Value += 1
    else
        replicatedUpgrade = Instance.new("NumberValue")
        replicatedUpgrade.Name = caseName
        replicatedUpgrade.Value = 1
        replicatedUpgrade.Parent = replicatedData["Cases"]
    end

    ReplicatedProfile:UpdateLeaderstats(player, profile, "Rocash")
end

PurchaseCaseRemote.OnServerInvoke = (function(player, caseName)
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data

    local replicatedData = player.ReplicatedData

    local case = Cases[caseName]
    local cost = case.Cost

    if data.Rocash >= cost then
        data.Cases[caseName] = (data.Cases[caseName] or 0) + 1
        data.Rocash -= cost
        replicateData(player, profile, replicatedData, caseName)
        UpdateClientShopInfoRemote:FireClient(player, "Case")
    end
    
end)