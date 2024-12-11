local DisplayNameHandler = {}

function DisplayNameHandler:Init()
   
   ---- Services ----

    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local ServerScriptService = game:GetService("ServerScriptService")

    ---- Modules ----

    local Modules = ReplicatedStorage.Modules
    local RarityColors = require(Modules.RarityColors)

    ---- Data ----

    local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)

    ---- Networking ----

    local Networking = ReplicatedStorage.Networking
    local BindableUpdateDisplayNameRemote = Networking.BindableUpdateDisplayName

    ---- Function ----

    local Displays = {
        Z1 = "Noob",
        Z2 = "Apprentice",
        Z3 = "Intermediate",
        Z4 = "Advanced",
        Z5 = "Expert",
        Z6 = "Master",
    }

    local function getDisplayTag(data)
        local display = Displays["Z1"]
        local color = RarityColors.PortalColors["Z1"]

        for _, zone in data.Zones do
            display = Displays[zone]
            color = RarityColors.PortalColors[zone]
        end

        return display, color
    end

    local function updateDisplay(player, data)

        local displayUI = player.Character.Head.DisplayNameUI

        displayUI.NameText.Text = "@"..player.Name

        local display, color = getDisplayTag(data)

        displayUI.TagText.Text = display
        displayUI.TagText.UIStroke.Color = color["Shadow"]
        displayUI.TagText.TextColor3 = color["Main"]
        displayUI.TagText.UIGradient.Color = ColorSequence.new(Color3.fromRGB(255,255,255), color["Shadow"])
    end

    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            local profile = ProfileCacher:GetProfile(player)
            local data = profile.Data
            task.wait(1)
            local displayUI = ReplicatedStorage:WaitForChild("DisplayNameUI"):Clone()
            displayUI.Parent = character:WaitForChild("Head")
            updateDisplay(player, data)
        end)
    end)

    BindableUpdateDisplayNameRemote.Event:Connect(function(player, data)
        updateDisplay(player, data)
    end)
end

return DisplayNameHandler