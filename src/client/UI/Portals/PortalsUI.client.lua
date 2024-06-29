---- Services ----

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer

---- Modules ----

local Modules = ReplicatedStorage.Modules
local Zones = require(ReplicatedStorage.Data.Zones)
local SuffixHandler = require(Modules.SuffixHandler)

---- Data ----

local ReplicatedData = Player:WaitForChild("ReplicatedData")
local ReplicatedZones = ReplicatedData.Zones

---- Variables ----

local Portals = Workspace:WaitForChild("Portals")

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
            local CostText = PurchaseButton.Cost.IconImage.Amount
            portalUI.Adornee = portal:WaitForChild("Portal").TouchPart
            portalUI.Name = portalID
            portalUI.Parent = PlayerGui
            CostText.Text = SuffixHandler:Convert(Zones[portalID].Cost.RebirthTix)
            portalUI.PortalScript.Enabled = true
        end
    end
end
initPortals()