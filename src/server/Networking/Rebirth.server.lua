---- Services ----

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

---- Data ----

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local DataManager = require(ServerScriptService.Data.DataManager)

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TemporaryData = require(Modules.TemporaryData)

---- Networking ----

local Networking = ReplicatedStorage.Networking
local RebirthRemote = Networking.Rebirth

local UpdateClientAccessoriesInventoryRemote = Networking.UpdateClientAccessoriesInventory
local UpdateClientCaseInventoryRemote = Networking.UpdateClientCaseInventory
local UpdateClientInventoryRemote = Networking.UpdateClientInventory
local UpdateClientMaterialsInventoryRemote = Networking.UpdateClientMaterialsInventory

---- Private Functions ----

RebirthRemote.OnServerInvoke = (function(player)
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data

    local temporaryData = player.TemporaryData

    local value = temporaryData.Value

    local rebirthTixReward, valueCost, VALUE_TO_REBIRTH_TIX = TemporaryData:CalculateRebirthInfo(value.Value)

    if valueCost >= VALUE_TO_REBIRTH_TIX then
        DataManager:ArrayClear(player, profile, {"EquippedAccessories"})
        DataManager:ArrayClear(player, profile, {"Upgrades"})
        DataManager:ArrayClear(player, profile, {"PerSecondUpgrades"})
        DataManager:ArrayClear(player, profile, {"Accessories"})
        DataManager:ArrayClear(player, profile, {"Cases"})
        DataManager:ArrayClear(player, profile, {"Materials"})

        DataManager:SetValue(player, profile, {"Tix"}, 0)
        DataManager:SetValue(player, profile, {"Rocash"}, 0)
        DataManager:SetValue(player, profile, {"ToolEquipped"}, "U1")

        DataManager:ArrayInsert(player, profile, {"Upgrades"}, "U1")

        DataManager:SetValue(player, profile, {"Rebirth Tix"}, data["Rebirth Tix"] + rebirthTixReward)

        DataManager:UpdateLeaderstats(player, profile, "Tix")
        DataManager:UpdateLeaderstats(player, profile, "Rocash")
        DataManager:UpdateLeaderstats(player, profile, "Value")
        DataManager:UpdateLeaderstats(player, profile, "Rebirth Tix")
        DataManager:UpdateLeaderstats(player, profile, "Level")

        UpdateClientAccessoriesInventoryRemote:FireClient(player, nil, nil, "INIT")
        UpdateClientCaseInventoryRemote:FireClient(player, nil, "INIT")
        UpdateClientInventoryRemote:FireClient(player, nil, "INIT")
        UpdateClientMaterialsInventoryRemote:FireClient(player, nil, nil, "INIT")
        
    end
    print("FINISHED", tick())
end)