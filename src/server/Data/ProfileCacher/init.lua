-- ProfileTemplate table is what empty profiles will default to.
-- Updating the template will not include missing template values
--   in existing player profiles!

---- Services ----

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

---- Data ----

local ProfileData = require(ReplicatedStorage.Data.ProfileData)
local ProfileTemplate = ProfileData.Data

---- Loaded Modules ----

local ProfileService = require(script.ProfileService)
local DataManager = require(ServerScriptService.Data.DataManager)

---- Private Variables ----

local GameProfileStore = ProfileService.GetProfileStore(
	"PlayerData1",
	ProfileTemplate
)

local PlayerProfiles = {} -- [player]

---- Private Functions ----

local function playerAdded(player)
	print(player)
	local profile = GameProfileStore:LoadProfileAsync("Player_" .. player.UserId)
	if profile ~= nil then
		profile:AddUserId(player.UserId) -- GDPR compliance
		profile:Reconcile() -- Fill in missing variables from ProfileTemplate (optional)
		profile:ListenToRelease(function()
			PlayerProfiles[player] = nil
			-- The profile could've been loaded on another Roblox server:
			player:Kick("Error loading data, please rejoin.") 
		end)
		if player:IsDescendantOf(Players) == true then
			-- Replica service
			PlayerProfiles[player] = profile
			-- A profile has been successfully loaded:
			DataManager:InitializeReplicatedData(player, profile) 
		else
			-- Player left before the profile loaded:
			profile:Release()
		end
	else
		-- The profile couldn't be loaded possibly due to other
		--   Roblox servers trying to load this profile at the same time:
		player:Kick("Error loading data, please rejoin.") 
	end
end

local function playerRemoved(player)
	local player_profile = PlayerProfiles[player]
	if player_profile ~= nil then
		player_profile.Profile:Release()
	end
end

---- Profile Manager ----

local ProfileManager = {}

function ProfileManager:Init()
	-- In case Players have joined the server earlier than this script ran:
	for _, player in Players:GetPlayers() do
		task.spawn(playerAdded, player)
	end

	Players.PlayerAdded:Connect(playerAdded)
	Players.PlayerRemoving:Connect(playerRemoved)

	game:BindToClose(function()
		table.foreach(Players:GetPlayers(),function(_,player)
			playerRemoved(player)
		end)
	end)
end

function ProfileManager:GetProfile(player)
	local count = 0

	while count < 3 do
		local profile = PlayerProfiles[player]
		if profile ~= nil then
			return profile
		end
		count += 1
		task.wait(count)
	end

	if player:IsDescendantOf(Players) == true then
		player:Kick("Error finding data, please rejoin.") 
	end
end

return ProfileManager

