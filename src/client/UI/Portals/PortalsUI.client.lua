---- Services ----

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer

---- Modules ----

local Zones = require(ReplicatedStorage.Data.Zones)

---- Data ----

local ReplicatedData = Player:WaitForChild("ReplicatedData")
local ReplicatedZones = ReplicatedData.Zones

---- Variables ----

local Portals = Workspace.Portals

local PlayerGui = Player:WaitForChild("PlayerGui")
local PortalUI = PlayerGui:WaitForChild("PortalUI")

local PortalScript = script.Parent.Portal
PortalScript.Name = "PortalScript"
PortalScript.Parent = PortalUI

---- Setup ----

function initPortals()
    for _, portal in Portals:GetChildren() do
        local portalID = portal.Name
        if Zones[portalID] and not ReplicatedZones:FindFirstChild(portalID) then
            local portalUI = PortalUI:Clone()
            local Holder = portalUI.Holder
            local PurchaseButton = Holder.PurchaseButton
            local ZoneName = Holder.ZoneName
            local CostText = PurchaseButton.Cost.IconImage.Amount
            portalUI.Adornee = portal.Portal.TouchPart
            portalUI.Name = portalID
            portalUI.Parent = PlayerGui
            CostText.Text = Zones[portalID].Cost.RebirthTix
            ZoneName.Text = Zones[portalID].Name
            portalUI.PortalScript.Enabled = true
        end
    end
end
initPortals()