local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Networking = ReplicatedStorage.Networking
local EquipAccessoryFunction = Networking.EquipAccessory
local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local Accessories = require(ReplicatedStorage.Data.Accessories)

local function physicalEquip(ID, humanoid)
    local accessory = Accessories[ID]
    if accessory and accessory.Type == "Accessory" then
        local asset = game:GetService("InsertService"):LoadAsset(accessory.AssetID):GetChildren()[1]
        asset.Name = accessory.Name
        humanoid:AddAccessory(asset)
    elseif accessory and accessory.Type == "Face" then
        humanoid.parent.Head.face.Texture = "rbxassetid://"..accessory.AssetID
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
            humanoid.parent.Head.face.Texture = "rbxassetid://144075659"
        end
    end
end

local function getAccessoryToEquip(ID, accessoriesInventory)
    for GUID, _ID in accessoriesInventory do
        if _ID == ID then
            return GUID
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

    if count < player.TemporaryData.EquippedAccessoriesLimit.Value then
        if not equippedAccessories[ID] then
            local GUID = getAccessoryToEquip(ID, accessoriesInventory)
            print(equippedAccessories)
            equippedAccessories[ID] = GUID
            print(equippedAccessories)
            physicalEquip(ID, player.Character.Humanoid)
        else
            equippedAccessories[ID] = nil
            physicalUnequip(ID, player.Character.Humanoid)
        end
    end
end

EquipAccessoryFunction.OnServerInvoke = function(player, GUID)
    local data = ProfileCacher:GetProfile(player).Data

    if data.Accessories[GUID] then
        equipAccessory(player, GUID, data)
    end
end