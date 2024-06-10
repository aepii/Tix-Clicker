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

local BindableEquipTix = Networking.BindableEquipTix

---- Private Functions ----

local function setData(player, profile, rebirthTixReward)
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

    DataManager:SetValue(player, profile, {"Rebirth Tix"}, profile.Data["Rebirth Tix"] + rebirthTixReward)
end

local function setClientData(player, profile)
    DataManager:UpdateLeaderstats(player, profile, "Tix")
    DataManager:UpdateLeaderstats(player, profile, "Rocash")
    DataManager:UpdateLeaderstats(player, profile, "Value")
    DataManager:UpdateLeaderstats(player, profile, "Rebirth Tix")

    player.TemporaryData.XP.Value = 0
    player.TemporaryData.QueuedTix.Value = 0

    UpdateClientAccessoriesInventoryRemote:FireClient(player, nil, nil, "INIT")
    UpdateClientCaseInventoryRemote:FireClient(player, nil, "INIT")
    UpdateClientInventoryRemote:FireClient(player, nil, "INIT")
    UpdateClientMaterialsInventoryRemote:FireClient(player, nil, nil, "INIT")
end

local function resetPhysicalStates(player)
    BindableEquipTix:Fire(player, "U1")
    local character = player.Character or player.CharacterAdded:Wait()

    character.Humanoid:RemoveAccessories()
    character.Head.face.Texture = "rbxasset://textures/face.png"
end

RebirthRemote.OnServerInvoke = (function(player)
    local profile = ProfileCacher:GetProfile(player)
    local temporaryData = player.TemporaryData
    local value = temporaryData.Value

    local rebirthTixReward, valueCost, VALUE_TO_REBIRTH_TIX = TemporaryData:CalculateRebirthInfo(value.Value)

    if temporaryData.ActiveCaseOpening.Value == false then
        if valueCost >= VALUE_TO_REBIRTH_TIX then
            setData(player, profile, rebirthTixReward)
            setClientData(player, profile)
            resetPhysicalStates(player)
        end
    end
    print("FINISHED", tick())
end)