---- Services ----

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

---- Variables ----

local Portals = Workspace.Portals
local Shops = Workspace.Shops

local TeleportScript = script.Teleport

---- Setup ----

function initialize()
    for _, portal in Portals:GetChildren() do
        local TeleportClone = TeleportScript:Clone()
        TeleportClone.Parent = portal.Portal.TouchPart
        TeleportClone.Enabled = true
    end
    for _, shop in Shops:GetChildren() do
        local TeleportClone = TeleportScript:Clone()
        TeleportClone.Parent = shop.TeleportLeave
        TeleportClone.Enabled = true
    end
end
initialize()