---- Services ----

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

---- Modules ----

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local DataManager = require(ServerScriptService.Data.DataManager)
local CollectibleAccessories = require(ReplicatedStorage.Data.CollectibleAccessories)

---- Private Functions ----

local function physicalEquip(ID, humanoid)
    local accessory = CollectibleAccessories[ID]
    if accessory and accessory.Type == "Accessory" then
        local asset = game:GetService("InsertService"):LoadAsset(accessory.AssetID):GetChildren()[1]
        asset.Name = accessory.Name
        humanoid:AddAccessory(asset)
    elseif accessory and accessory.Type == "Face" then
        local asset = game:GetService("InsertService"):LoadAsset(accessory.AssetID).face.Texture
        humanoid.parent.Head.face.Texture = asset
    end
end

local function physicalUnequip(ID, humanoid)
    local accessory = CollectibleAccessories[ID]
    if accessory then
        if accessory.Type == "Accessory" then
            local asset = humanoid.parent:FindFirstChild(accessory.Name)
            if asset then
                asset:Destroy()
            end
        elseif accessory.Type == "Face" then
            humanoid.parent.Head.face.Texture = "rbxasset://textures/face.png"
        end
    end
end

---- Networking ----

local Networking = ReplicatedStorage.Networking
local EquipCollectibleAccessoryRemote = Networking.EquipCollectibleAccessory
local EquipCollectibleAccessoryBindableRemote = Networking.EquipCollectibleAccessoryBindable
local UpdateClientCollectibleAccessoriesInventoryRemote = Networking.UpdateClientCollectibleAccessoriesInventory

EquipCollectibleAccessoryRemote.OnServerInvoke = function(player, GUID)
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data

    local temporaryData = player.TemporaryData

    local equippedAccessories = data.EquippedCollectibleAccessories
    local accessoriesInventory = data.CollectibleAccessories
    local ID = accessoriesInventory[GUID]

    if temporaryData.ActiveCaseOpening.Value == false then
        if data.CollectibleAccessories[GUID] then
            local count = 0
            for _ in equippedAccessories do
                count += 1
            end

            if equippedAccessories[ID] == GUID then
                DataManager:SetValue(player, profile, {"EquippedCollectibleAccessories", ID}, nil)
                UpdateClientCollectibleAccessoriesInventoryRemote:FireClient(player, ID, GUID, "UNEQUIP") 
                physicalUnequip(ID, player.Character.Humanoid)
            elseif equippedAccessories[ID] then
                return
            elseif count < player.TemporaryData.EquippedCollectibleAccessoriesLimit.Value then
                UpdateClientCollectibleAccessoriesInventoryRemote:FireClient(player, ID, GUID, "EQUIP") 
                DataManager:SetValue(player, profile, {"EquippedCollectibleAccessories", ID}, GUID)
                physicalEquip(ID, player.Character.Humanoid)
            end

        end
    end
end

EquipCollectibleAccessoryBindableRemote.Event:Connect(physicalEquip)