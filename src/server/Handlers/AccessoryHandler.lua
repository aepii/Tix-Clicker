local AccessoryHandler = {}

function AccessoryHandler:Init()
    ---- Services ----

    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local ServerScriptService = game:GetService("ServerScriptService")

    ---- Modules ----

    local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)

    ---- Networking ----

    local Networking = ReplicatedStorage.Networking
    local EquipAccessoryBindableRemote = Networking.EquipAccessoryBindable

    local function playerAdded(player)
        local data = ProfileCacher:GetProfile(player).Data
        local character = player.Character or player.CharacterAdded:Wait()

        character.Humanoid:RemoveAccessories()
        
        if not character.Head:FindFirstChild("face") then
            local Desc = game:GetService("Players"):GetHumanoidDescriptionFromUserId(player.UserId)
            Desc.Head = "7430070993"
            character.Humanoid:ApplyDescription(Desc)
        end
        character.Head.face.Texture = "rbxasset://textures/face.png"

        for ID, GUID in data.EquippedAccessories do
            EquipAccessoryBindableRemote:Fire(ID, player.Character.Humanoid)
        end
        
    end

    Players.PlayerAdded:Connect(playerAdded)
end

return AccessoryHandler