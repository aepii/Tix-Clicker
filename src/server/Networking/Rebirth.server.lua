---- Services ----

local Workspace = game:GetService("Workspace")
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

local UpdateClientCaseInventoryRemote = Networking.UpdateClientCaseInventory
local UpdateClientInventoryRemote = Networking.UpdateClientInventory

local BindableEquipTix = Networking.BindableEquipTix

---- Private Functions ----

local function setData(player, profile, rebirthTixReward)
    DataManager:ArrayClear(player, profile, {"Upgrades"})
    DataManager:ArrayClear(player, profile, {"PerSecondUpgrades"})

    DataManager:SetValue(player, profile, {"Tix"}, 0)
    DataManager:SetValue(player, profile, {"Rocash"}, 0)
    DataManager:SetValue(player, profile, {"ToolEquipped"}, "U1")

    DataManager:ArrayInsert(player, profile, {"Upgrades"}, "U1")

    DataManager:SetValue(player, profile, {"Rebirth Tix"}, (profile.Data["Rebirth Tix"] or 0) + rebirthTixReward)
    DataManager:SetValue(player, profile, {"Lifetime Rebirth Tix"}, (profile.Data["Lifetime Rebirth Tix"] or 0) + rebirthTixReward)
end

local function setClientData(player, profile)
    DataManager:UpdateLeaderstats(player, profile, "Tix")
    DataManager:UpdateLeaderstats(player, profile, "Rocash")
    DataManager:UpdateLeaderstats(player, profile, "Value")
    DataManager:UpdateLeaderstats(player, profile, "Rebirth Tix")

    player.TemporaryData.XP.Value = 0
    player.TemporaryData.RageMode.Value = false
    player.TemporaryData.QueuedTix.Value = 0

    UpdateClientCaseInventoryRemote:FireClient(player, nil, "INIT")
    UpdateClientInventoryRemote:FireClient(player, nil, "INIT")
end

local function resetPhysicalStates(player, profile)
    BindableEquipTix:Fire(player, "U1")
    local character = player.Character or player.CharacterAdded:Wait()
    local torso = player.Character:FindFirstChild("HumanoidRootPart")

    torso.CFrame = Workspace.SpawnLocation.CFrame
end

RebirthRemote.OnServerInvoke = (function(player)
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data
    local rocash = data.Rocash
    local value = TemporaryData:CalculateValue(player, data)

    local temporaryData = player.TemporaryData

    local rebirthTixReward, rocashCost, ROCASH_TO_REBIRTH_TIX, valueCost, VALUE_TO_REBIRTH_TIX = TemporaryData:CalculateRebirthInfo(rocash, value)

    if temporaryData.ActiveCaseOpening.Value == false then
        if rocashCost >= ROCASH_TO_REBIRTH_TIX and valueCost >= VALUE_TO_REBIRTH_TIX then
            setData(player, profile, rebirthTixReward)
            setClientData(player, profile)
            resetPhysicalStates(player, profile)

            return rebirthTixReward, rocashCost
        end
    end
end)