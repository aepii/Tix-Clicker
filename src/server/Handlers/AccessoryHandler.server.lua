---- Services ----

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

---- Modules ----

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)

---- Networking ----

local Networking = ReplicatedStorage.Networking
local EquipAccessoryBindableRemote = Networking.EquipAccessoryBindable
local EquipCollectibleAccessoryBindableRemote = Networking.EquipCollectibleAccessoryBindable

local function playerAdded(player)
    local data = ProfileCacher:GetProfile(player).Data
    local character = player.Character or player.CharacterAdded:Wait()

    character.Humanoid:RemoveAccessories()
    character.Head.face.Texture = "rbxasset://textures/face.png"

    for ID, GUID in data.EquippedAccessories do
        EquipAccessoryBindableRemote:Fire(ID, player.Character.Humanoid)
    end

    for ID, GUID in data.EquippedCollectibleAccessories do
        EquipCollectibleAccessoryBindableRemote:Fire(ID, player.Character.Humanoid)
    end
    
end

Players.PlayerAdded:Connect(playerAdded)