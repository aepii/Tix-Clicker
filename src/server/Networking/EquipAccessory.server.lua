--[[

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

local function replicateData(player, data, replicatedData, GUID, ID)
    local replicatedAccessory = replicatedData.EquippedAccessories:FindFirstChild(ID)

    if not replicatedAccessory then
        replicatedAccessory = Instance.new("StringValue")
        replicatedAccessory.Name = ID
        replicatedAccessory.Value = GUID
        replicatedAccessory.Parent = replicatedData["EquippedAccessories"]
    else
        replicatedAccessory:Destroy()
    end
end

local function equipAccessory(player, GUID, data)
    local replicatedData = player.ReplicatedData
    local equippedAccessories = data.EquippedAccessories
    local accessoriesInventory = data.Accessories
    local ID = accessoriesInventory[GUID]

    local count = 0
    for _ in equippedAccessories do
        count += 1
    end

    if equippedAccessories[ID] == GUID then
        print("UNEQUIPP")

        DataManager:SetValue(player, profile, {"EquippedAccessories"}, upgradeID)
        equippedAccessories[ID] = nil
        physicalUnequip(ID, player.Character.Humanoid)
        replicateData(player, data, replicatedData, GUID, ID)
    elseif equippedAccessories[ID] then
        return
    elseif count < player.TemporaryData.EquippedAccessoriesLimit.Value then
        print("EQUIPP")
        equippedAccessories[ID] = GUID
        physicalEquip(ID, player.Character.Humanoid)
        replicateData(player, data, replicatedData, GUID, ID)
    end

end

---- Networking ----

local Networking = ReplicatedStorage.Networking
local EquipAccessoryRemote = Networking.EquipAccessory
local EquipAccessoryBindableRemote = Networking.EquipAccessoryBindable

EquipAccessoryRemote.OnServerInvoke = function(player, GUID)
    local data = ProfileCacher:GetProfile(player).Data

    if data.Accessories[GUID] then
        equipAccessory(player, GUID, data)
    end
end

EquipAccessoryBindableRemote.Event:Connect(physicalEquip)--]]