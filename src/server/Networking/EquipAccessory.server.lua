local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Networking = ReplicatedStorage.Networking
local EquipAccessoryFunction = Networking.EquipAccessory
local EquipAccessoryBindableFunction = Networking.BindableEquipAccessory
local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local Accessories = require(ReplicatedStorage.Data.Accessories)

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

EquipAccessoryBindableFunction.Event:Connect(physicalEquip)

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

local function equipAccessory(player, GUID, data)
    local equippedAccessories = data.EquippedAccessories
    local accessoriesInventory = data.Accessories
    local ID = accessoriesInventory[GUID]

    local count = 0
    for _ in equippedAccessories do
        count += 1
    end

    if equippedAccessories[ID] == GUID then
        equippedAccessories[ID] = nil
        physicalUnequip(ID, player.Character.Humanoid)
    elseif equippedAccessories[ID] then
        return
    elseif count < player.TemporaryData.EquippedAccessoriesLimit.Value then
        equippedAccessories[ID] = GUID
        physicalEquip(ID, player.Character.Humanoid)
    end

end

EquipAccessoryFunction.OnServerInvoke = function(player, GUID)
    local data = ProfileCacher:GetProfile(player).Data

    if data.Accessories[GUID] then
        equipAccessory(player, GUID, data)
    end
end

