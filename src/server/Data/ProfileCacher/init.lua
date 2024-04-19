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
local ReplicatedProfile = require(script.Parent.ReplicatedProfile)

---- Private Variables ----

local ProfileStore = ProfileService.GetProfileStore(
	"PlayerData",
	ProfileTemplate
)

local Profiles = {} -- [player] = profile
local ProfileManager = {}

---- Private Functions ----

local function playerAdded(player)
	local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)
	if profile ~= nil then
		profile:AddUserId(player.UserId) -- GDPR compliance
		profile:Reconcile() -- Fill in missing variables from ProfileTemplate (optional)
		profile:ListenToRelease(function()
			Profiles[player] = nil
			-- The profile could've been loaded on another Roblox server:
			player:Kick("Error loading data, please rejoin.") 
		end)
		if player:IsDescendantOf(Players) == true then
			Profiles[player] = profile
			-- A profile has been successfully loaded:
			ReplicatedProfile:Create(player, profile)
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

---- Initialize ----

function ProfileManager:Init()
	-- In case Players have joined the server earlier than this script ran:
	for _, player in Players:GetPlayers() do
		task.spawn(playerAdded, player)
	end

	---- Connections ----

	Players.PlayerAdded:Connect(playerAdded)

	Players.PlayerRemoving:Connect(function(player)
		local profile = Profiles[player]
		if profile ~= nil then
			profile:Release()
		end
	end)
end

function ProfileManager:GetProfile(player)
	local count = 0

	while count < 3 do
		local profile = Profiles[player]
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