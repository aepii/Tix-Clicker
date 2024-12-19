local LeaderboardsUI = {}

function LeaderboardsUI:Init()

    ---- Services ----

    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    ---- Modules ----

    local Modules = ReplicatedStorage.Modules
    local SuffixHandler = require(Modules.SuffixHandler)

    -- Define stats for the leaderboards
    local stats = {"Tix", "Rocash", "Rebirth Tix", "Value", "Cases", "Materials"}

    ---- UI ----

    local PlayerGui = Player.PlayerGui
    local LeaderboardHolder = PlayerGui:WaitForChild("Leaderboards")
    local LeaderboardUIs = {}

    for _, stat in stats do
        local leaderboardUI = LeaderboardHolder:WaitForChild(stat:gsub(" ","").."Leaderboard")
        local scoreClone = leaderboardUI:WaitForChild("Background"):WaitForChild("Main"):WaitForChild("Holder"):WaitForChild("Top4")
        for i = 4, 100 do
            local clone = scoreClone:Clone()
            clone.Name = "Top" .. i
            clone.Place.Text = i .. "."
            clone.Parent = leaderboardUI:WaitForChild("Background"):WaitForChild("Main"):WaitForChild("Holder")
        end
        LeaderboardUIs[stat] = leaderboardUI
    end
 
    ---- Networking ----
    local Networking = ReplicatedStorage.Networking
    local UpdateLeaderboard = Networking.UpdateLeaderboard

    UpdateLeaderboard:FireServer()

    UpdateLeaderboard.OnClientEvent:Connect(function(leaderboardData)
        for stat, entries in leaderboardData do
            local scores = LeaderboardUIs[stat]:WaitForChild("Background"):WaitForChild("Main"):WaitForChild("Holder")
            for rank, entry in entries do
                print("Rank:", rank, "UserId:", entry.userId, "Value:", entry.value)
                local frame = scores:WaitForChild("Top"..rank)
                frame.Place.Text = rank .. "."
                frame.PlayerName.Text = Players:GetNameFromUserIdAsync(entry.userId)
                frame.Value.Text = SuffixHandler:Convert(entry.value)
            end
        end
    end)

end

return LeaderboardsUI