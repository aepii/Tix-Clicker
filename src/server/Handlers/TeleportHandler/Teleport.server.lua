---- Services ----

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

---- Variables ----

local Portals = Workspace.Portals
local Shops = Workspace.Shops

---- Networking ----

local Networking = ReplicatedStorage.Networking
local UpdateCameraRemote = Networking.UpdateCamera

---- Teleport ----

local debounce = false  -- Initialize debounce variable

script.Parent.Touched:Connect(function(hit)
    if not debounce then 
        local player = game.Players:GetPlayerFromCharacter(hit.Parent)
        if player then
            local torso = hit.Parent:FindFirstChild("HumanoidRootPart")
            if torso then
                debounce = true 
                if script.Parent.Name == "TouchPart" then
                    torso.Position = Shops[script.Parent.Parent.Parent.Name].TeleportPart.Position
                    UpdateCameraRemote:FireClient(player, "Lock")
                else
                    torso.Position = Workspace.SpawnLocation.Position
                    UpdateCameraRemote:FireClient(player, "Reset")
                end
            end
        end
        task.wait(1)  
        debounce = false
    end
end)