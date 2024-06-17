---- Services ----

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

---- Modules ----

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)

---- Variables ----

local Shops = Workspace.Shops
local Portals = Workspace.Portals

---- Networking ----

local Networking = ReplicatedStorage.Networking
local UpdateCameraRemote = Networking.UpdateCamera

---- Teleport ----

local debounce = false  -- Initialize debounce variable

script.Parent.Touched:Connect(function(hit)
    local portalID = script.Parent.Parent.Parent.Name
    if not debounce then 
        debounce = true 
        local player = game.Players:GetPlayerFromCharacter(hit.Parent)
        if player then
            local torso = hit.Parent:FindFirstChild("HumanoidRootPart")
            if torso then
                local profile = ProfileCacher:GetProfile(player)
                local data = profile.Data
                if table.find(data["Zones"], portalID) then
                    if script.Parent.Name == "TouchPart" then
                        torso.CFrame = Shops[portalID].Shop.TeleportPart.CFrame
                        UpdateCameraRemote:FireClient(player, "Lock")
                    else
                        torso.CFrame = Portals.Teleport.CFrame
                        UpdateCameraRemote:FireClient(player, "Reset")
                    end
                end
            end
        end
    end
    debounce = false
end)