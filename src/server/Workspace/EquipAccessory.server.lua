local Workspace = game:GetService("Workspace")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InsertService = game:GetService("InsertService")

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local Accessories = require(ReplicatedStorage.Data.Accessories)

local part = Workspace.EquipAccessoryPart

local ID = "A1"
local LIMIT = 5

local function physicalEquip(ID, humanoid)
    local accessory = Accessories[ID]
    if accessory and accessory.Type == "Accessory" then
        local asset = game:GetService("InsertService"):LoadAsset(accessory.AssetID):GetChildren()[1]
        asset.Name = accessory.Name
        humanoid:AddAccessory(asset)
    elseif accessory and accessory.Type == "Face" then
        humanoid.parent.face.Texture = accessory.AssetID
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
            humanoid.parent.face.Texture = 144075659 
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

local function equipAccessory(player)
    print("EQUIP")
    local data = ProfileCacher:GetProfile(player).Data
    local equippedAccessories = data.EquippedAccessories
    local accessoriesInventory = data.Accessories

    local count = 0
    for _ in equippedAccessories do
        count += 1
    end

    if count < LIMIT then
        print("NO LIMIT REACH")
        if not equippedAccessories[ID] then
            print("NOT EQUIPPED YET")
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

part.ClickDetector.MouseClick:Connect(equipAccessory)


