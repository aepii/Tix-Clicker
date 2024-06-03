---- Services ----

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

---- Modules ----

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local DataManager = require(ServerScriptService.Data.DataManager)
local Accessories = require(ReplicatedStorage.Data.Accessories)

---- Private Functions ----

local function physicalEquip(ID, humanoid)
    local accessory = Accessories[ID]
    if accessory and accessory.Type == "Accessory" then
        local asset = game:GetService("InsertService"):LoadAsset(accessory.AssetID):GetChildren()[1]
        asset.Name = accessory.Name
        humanoid:AddAccessory(asset)
    elseif accessory and accessory.Type == "Face" then
        print(accessory.AssetID)
        local asset = game:GetService("InsertService"):LoadAsset(accessory.AssetID).face.Texture
        humanoid.parent.Head.face.Texture = asset
    end
end

local function physicalUnequip(ID, humanoid)
    local accessory = Accessories[ID]
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
local EquipAccessoryRemote = Networking.EquipAccessory
local EquipAccessoryBindableRemote = Networking.EquipAccessoryBindable

EquipAccessoryRemote.OnServerInvoke = function(player, GUID)
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data

    local equippedAccessories = data.EquippedAccessories
    local accessoriesInventory = data.Accessories
    local ID = accessoriesInventory[GUID]

    if data.Accessories[GUID] then
        local count = 0
        for _ in equippedAccessories do
            count += 1
        end

        if equippedAccessories[ID] == GUID then
            print("UNEQUIPP")
            DataManager:SetValue(player, profile, {"EquippedAccessories", ID}, nil)
            physicalUnequip(ID, player.Character.Humanoid)
        elseif equippedAccessories[ID] then
            return
        elseif count < player.TemporaryData.EquippedAccessoriesLimit.Value then
            print("EQUIPP")
            DataManager:SetValue(player, profile, {"EquippedAccessories", ID}, GUID)
            physicalEquip(ID, player.Character.Humanoid)
        end
    end
end

EquipAccessoryBindableRemote.Event:Connect(physicalEquip)