---- Services ----

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

---- Data ----

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local DataManager = require(ServerScriptService.Data.DataManager)
local GlobalData = require(ServerScriptService.Data.GlobalData)
local Materials = require(ReplicatedStorage.Data.Materials)
local Accessories = require(ReplicatedStorage.Data.Accessories)

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TemporaryData = require(Modules.TemporaryData)

---- Networking ----

local Networking = ReplicatedStorage.Networking
local ScrapAccessoryRemote = Networking.ScrapAccessory
local UpdateClientMaterialsInventoryRemote = Networking.UpdateClientMaterialsInventory
local UpdateClientAccessoriesInventoryRemote = Networking.UpdateClientAccessoriesInventory

---- Private Functions ----

local function isEquipped(equippedAccessories, accessoryGUID)
    for ID, GUID in equippedAccessories do
        if accessoryGUID == GUID then
            return true
        end
    end
    return false
end

local function calculateRate(quantity, chanceToReceive, materialID)
    local amount = 0

    for i = 1, quantity do
        local chosen = math.random()
        if chosen < chanceToReceive then
            amount = amount + 1
        end
    end

    return amount, materialID
end

ScrapAccessoryRemote.OnServerInvoke = (function(player, accessoryGUID)
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data

    local accessoryID = data.Accessories[accessoryGUID]
    local accessory = Accessories[accessoryID]

    if accessoryID and not isEquipped(data.EquippedAccessories, accessoryGUID) then

        local amount, materialID = calculateRate(TemporaryData:CalculateMaterialInfo(player, accessory.Value))
        local newMaterialValue = (data.Materials[materialID] or 0) + amount

        if not data.Materials[materialID] and newMaterialValue > 0 then
            UpdateClientMaterialsInventoryRemote:FireClient(player, newMaterialValue, materialID, "ADD")
        end

        DataManager:SetValue(player, profile, {"Accessories", accessoryGUID}, nil)
        GlobalData:QueueAccessoryCountUpdate(accessoryID, -1)

        DataManager:UpdateLeaderstats(player, profile, "Value")

        UpdateClientAccessoriesInventoryRemote:FireClient(player, accessoryID, accessoryGUID, "DEL") 

        if amount > 0 then
            DataManager:SetValue(player, profile, {"Materials", materialID}, newMaterialValue)
            if data.Materials[materialID] then
                UpdateClientMaterialsInventoryRemote:FireClient(player, newMaterialValue, materialID, "UPDATE")
            end
        end

        DataManager:SetValue(player, profile, {"Lifetime Scrapped"}, (profile.Data["Lifetime Scrapped"] or 0) + 1)
        DataManager:SetValue(player, profile, {"Lifetime Materials"}, (profile.Data["Lifetime Materials"] or 0) + amount)
        return amount, Materials[materialID]
    end
end)