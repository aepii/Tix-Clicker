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
local AnimateCircleRemote = Networking.AnimateCircle

---- Teleport ----

local debounceTable = {}

script.Parent.Touched:Connect(function(hit)
    local portalID = script.Parent.Parent.Parent.Name

    local player = game.Players:GetPlayerFromCharacter(hit.Parent)
    if player and not debounceTable[player] then
		debounceTable[player] = player
        local torso = hit.Parent:FindFirstChild("HumanoidRootPart")
        if torso then
            local profile = ProfileCacher:GetProfile(player)
            local data = profile.Data
            local displayUI = player.Character.Head.DisplayNameUI
            if table.find(data["Zones"], portalID) then
                AnimateCircleRemote:FireClient(player)
                task.wait(1)
                if script.Parent.Name == "TouchPart" then
                    UpdateCameraRemote:FireClient(player, "Lock")
                    torso.CFrame = Shops[portalID].Shop.TeleportPart.CFrame

                    displayUI.Enabled = false
                else
                    UpdateCameraRemote:FireClient(player, "Reset")
                    if portalID == "Z0" then
                        torso.CFrame = Portals.RebirthTeleport.CFrame
                    else
                        torso.CFrame = Portals.Teleport.CFrame
                    end
                    displayUI.Enabled = true
                end
            end
        end
        task.wait(2)
        debounceTable[player] = nil
    end
end)