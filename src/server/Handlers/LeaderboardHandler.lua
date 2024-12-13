local LeaderboardHandler = {}

function LeaderboardHandler:Init()

  ---- Services ----

  local Players = game:GetService("Players")
  local ServerScriptService = game:GetService("ServerScriptService")
  local ReplicatedStorage = game:GetService("ReplicatedStorage")
  local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)

  -- Define stats for the leaderboards
  local stats = {"Tix", "Rocash", "Rebirth Tix", "Value", "Cases", "Materials"}

  ---- Networking ----
  local Networking = ReplicatedStorage.Networking
  local UpdateLeaderboard = Networking.UpdateLeaderboard

  -- Create OrderedDataStores for stats
  local dataStores = {}
  for _, stat in stats do
    dataStores[stat.."Leaderboard"] = game:GetService("DataStoreService"):GetOrderedDataStore(stat)
  end

  -- Function to retrieve top leaderboard data
  local function getLeaderboardData(stat)
    local success, result = pcall(function()
      return dataStores[stat.."Leaderboard"]:GetSortedAsync(false, 100)
    end)
    if success and result then
      local leaderboardData = {}
      for _, entry in result:GetCurrentPage() do
        table.insert(leaderboardData, {
          userId = entry.key,
          value = entry.value
        })
      end
      return leaderboardData
    else
      warn("Failed to retrieve leaderboard data for "..stat..": "..(result or "Unknown error"))
      return {}
    end
  end

  -- Function to update player stats in the DataStore
  local function updatePlayerData()
    print("Updated")
    for _, player in Players:GetPlayers() do
      local profile = ProfileCacher:GetProfile(player)
      local data = profile.Data
      for _, stat in stats do
        local statValue = math.floor(data["Lifetime "..stat]) or 0
        local success, errorMessage = pcall(function()
          dataStores[stat.."Leaderboard"]:UpdateAsync(player.UserId, function(oldValue)
            return math.max(oldValue or 0, statValue)
          end)
        end)
        if not success then
          warn("Failed to update "..stat.." for "..player.Name..": "..errorMessage)
        end
      end
    end

    -- Notify all clients about leaderboard updates
    local leaderboardData = {}
    for _, stat in stats do
      leaderboardData[stat] = getLeaderboardData(stat)
    end
    UpdateLeaderboard:FireAllClients(leaderboardData)
  end

  -- Update player data every 60 seconds
  task.spawn(function()
    while true do
      updatePlayerData()
      task.wait(15) 
    end
  end)

end

return LeaderboardHandler
