local PortalsUI = {}

function PortalsUI:Init()
    ---- Services ----

    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    ---- Modules ----

    local Modules = ReplicatedStorage.Modules
    local Zones = require(ReplicatedStorage.Data.Zones)
    local SuffixHandler = require(Modules.SuffixHandler)

    ---- Data ----

    local ReplicatedData = Player:WaitForChild("ReplicatedData")
    local ReplicatedZones = ReplicatedData:WaitForChild("Zones")

    ---- Variables ----

    local Portals = Workspace:WaitForChild("Portals")

    local PlayerGui = Player:WaitForChild("PlayerGui")
    local PortalUI = PlayerGui:WaitForChild("PortalUI")

    local PortalScript = script.Parent.Portal
    PortalScript.Name = "PortalScript"
    PortalScript.Parent = PortalUI

    ---- Setup ----

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

return PortalsUI