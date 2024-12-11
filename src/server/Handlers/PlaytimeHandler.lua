local PlaytimeHandler = {}

function PlaytimeHandler:Init()
   ---- Services ----

    local Players = game:GetService("Players")
    local ServerScriptService = game:GetService("ServerScriptService")

    ---- Data ----

    local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
    local DataManager = require(ServerScriptService.Data.DataManager)

    ---- Function ----

    Players.PlayerAdded:Connect(function(player)
        local profile = ProfileCacher:GetProfile(player)
        local data = profile.Data
        coroutine.resume(coroutine.create(function()
            while task.wait(1) and player:IsDescendantOf(Players) do
                DataManager:SetValue(player, profile, {"Lifetime Playtime"}, data["Lifetime Playtime"] + 1)
            end
        end))
    end)
end

return PlaytimeHandler