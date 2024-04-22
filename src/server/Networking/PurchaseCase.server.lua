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
local UpdateClientCaseInventoryRemote = Networking.UpdateClientCaseInventory

---- Private Functions ----

local function replicateData(player, profile, replicatedData, caseName)
    local data = profile.Data
    replicatedData.Rocash.Value = data.Rocash

    local replicatedUpgrade = replicatedData.Cases:FindFirstChild(caseName)
    if not replicatedUpgrade then
        replicatedUpgrade = Instance.new("NumberValue")
        replicatedUpgrade.Name = caseName
        
        replicatedUpgrade.Parent = replicatedData["Cases"]
    end
    replicatedUpgrade.Value = data.Cases[caseName]

    ReplicatedProfile:UpdateLeaderstats(player, profile, "Rocash")
end

PurchaseCaseRemote.OnServerInvoke = (function(player, caseName)
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data

    local replicatedData = player.ReplicatedData

    local case = Cases[caseName]
    local cost = case.Cost

    if data.Rocash >= cost then
        if data.Cases[caseName] then
            UpdateClientCaseInventoryRemote:FireClient(player, case, "UPDATE")
        else
            UpdateClientCaseInventoryRemote:FireClient(player, case, "ADD")
        end
        data.Cases[caseName] = (data.Cases[caseName] or 0) + 1
        data.Rocash -= cost
        replicateData(player, profile, replicatedData, caseName)
        UpdateClientShopInfoRemote:FireClient(player, "Case")
    end
    
end)