---- Services ----

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local RarityColors = require(Modules.RarityColors)

---- Data ----

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)

---- Function ----

local Displays = {
    Z1 = "🐣 Noob",
    Z2 = "✏️ Apprentice",
    Z3 = "⭐ Intermediate",
    Z4 = "🦾 Advanced",
    Z5 = "🎯 Expert",
    Z6 = "🎓 Master",
}

local function getDisplayTag(data)
    local display = Displays["Z1"]
    local color = RarityColors.PortalColors["Z1"]

    for _, zone in data.Zones do
        display = Displays[zone]
        color = RarityColors.PortalColors[zone]
    end
    print(display, color)
    return display, color
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        local profile = ProfileCacher:GetProfile(player)
        local data = profile.Data
        local displayUI = ReplicatedStorage:WaitForChild("DisplayNameUI"):Clone()
        displayUI.Parent = character:WaitForChild("Head")
        
        displayUI.NameText.Text = "@"..player.Name

        local display, color = getDisplayTag(data)

        displayUI.TagText.Text = display
        displayUI.TagText.UIStroke.Color = color["Shadow"]
        displayUI.TagText.TextColor3 = color["Main"]
        displayUI.TagText.UIGradient.Color = ColorSequence.new(Color3.fromRGB(255,255,255), color["Shadow"])
    end)
end)