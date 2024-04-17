-- ProfileTemplate table is what empty profiles will default to.
-- Updating the template will not include missing template values
--   in existing player profiles!

----- Services -----

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

----- Data -----

local ProfileData = require(ReplicatedStorage.Data.ProfileData)
local ProfileTemplate = ProfileData.Data
local Data = ProfileData.Data

----- Loaded Modules -----

local Modules = ReplicatedStorage:WaitForChild("Modules")
local ProfileService = require(script.ProfileService)
local SuffixHandler = require(Modules.SuffixHandler)
local Accessories = require(ReplicatedStorage.Data.Accessories)

----- Private Variables -----

local ProfileStore = ProfileService.GetProfileStore(
	"PlayerData",
	ProfileTemplate
)

local Profiles = {} -- [player] = profile
local ProfileManager = {}

----- Private Functions -----

local function updateReplicatedData(player, profile, createdValue, key)
	while task.wait() and player:IsDescendantOf(Players) do
		createdValue.Value = profile.Data[key]
	end
end

local function updateUpgrades(player, profile, holder)
	local upgrades = require(ReplicatedStorage.Data.Upgrades)
	while task.wait() and player:IsDescendantOf(Players) do
		for name, _ in upgrades do
			if table.find(profile.Data.Upgrades, name) then
				if not holder:FindFirstChild(name) then
					local createdValue = Instance.new("BoolValue")
					createdValue.Name = name
					createdValue.Parent = holder
				end
			end
		end
	end
end

local function updateValueUpgrades(player, profile, holder)
	local valueUpgrades = require(ReplicatedStorage.Data.ValueUpgrades)
	while task.wait() and player:IsDescendantOf(Players) do
		for name, _ in valueUpgrades do
			if profile.Data.ValueUpgrades[name] then
				if not holder:FindFirstChild(name) then
					local createdValue = Instance.new("NumberValue")
					createdValue.Name = name
					createdValue.Parent = holder
				end
				holder:WaitForChild(name).Value = profile.Data.ValueUpgrades[name]
			end
		end
	end
end

local function updateInventory(player, profile, holder)
	local cases = require(ReplicatedStorage.Data.Cases)
	while task.wait() and player:IsDescendantOf(Players) do
		for name, _ in cases do
			if profile.Data.Inventory[name] then
				if not holder:FindFirstChild(name) then
					local createdValue = Instance.new("NumberValue")
					createdValue.Name = name
					createdValue.Parent = holder
				end
				holder:WaitForChild(name).Value = profile.Data.Inventory[name]
			end
		end
	end
end

local function updateValue(player, profile, ID)
	local accessory = Accessories[ID]
	player.TemporaryData["Value"].Value += accessory.Value
end

local function updateAccessories(player, profile, holder)
	while task.wait() and player:IsDescendantOf(Players) do
		for GUID, ID in profile.Data.Accessories do
			if not holder:FindFirstChild(GUID) then
				local createdValue = Instance.new("StringValue")
				createdValue.Name = GUID
				createdValue.Parent = holder
				createdValue.Value = ID
				updateValue(player, profile, ID)
			end
		end
	end
end

local function updateEquippedAccessories(player, profile, holder)
	while task.wait() and player:IsDescendantOf(Players) do
		for ID, GUID in profile.Data.EquippedAccessories do
			if not holder:FindFirstChild(ID) then
				local createdValue = Instance.new("StringValue")
				createdValue.Name = ID
				createdValue.Parent = holder
				createdValue.Value = GUID
			end
		end
		for _, accessory in holder:GetChildren() do
			if not profile.Data.EquippedAccessories[accessory.Name] then
				accessory:Destroy()
			end
		end
	end
end

local function createReplicatedData(player, profile)
	local dataProfile = ProfileData.Data
	local replicatedData = Instance.new("Folder")
	replicatedData.Name = "ReplicatedData"
	replicatedData.Parent = player

	local typeMap = {
		number = "NumberValue",
		string = "StringValue",
		boolean = "BoolValue",
		table = "Folder"
	}

	for key, value in dataProfile do
		local valueType = type(value)
		local instanceClass = typeMap[valueType]
		local createdValue = Instance.new(instanceClass)

		createdValue.Name = key
		createdValue.Parent = replicatedData

		if valueType ~= "table" then
			task.spawn(updateReplicatedData, player, profile, createdValue, key)
		else
			if key == "Upgrades" then
				task.spawn(updateUpgrades, player, profile, createdValue)
			elseif key == "ValueUpgrades" then
				task.spawn(updateValueUpgrades, player, profile, createdValue)
			elseif key == "Inventory" then
				task.spawn(updateInventory, player, profile, createdValue)
			elseif key == "Accessories" then
				task.spawn(updateAccessories, player, profile, createdValue)
			elseif key == "EquippedAccessories" then
				task.spawn(updateEquippedAccessories, player, profile, createdValue)
			end
		end
	end
end

local function updateLeaderstats(player, profile, createdValue, key)
	while task.wait() and player:IsDescendantOf(Players) do
		if key == "Value" then
			createdValue.Value = SuffixHandler:Convert(player.TemporaryData["Value"].Value)
		else
			createdValue.Value = SuffixHandler:Convert(profile.Data[key])
		end
	end
end

local function createLeaderstats(player, profile)
	local leaderstatsProfile = ProfileData.leaderstats
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	for index, data in leaderstatsProfile do
		local createdValue = Instance.new("StringValue")
		createdValue.Name = data.DisplayName
		createdValue.Parent = leaderstats

		task.spawn(updateLeaderstats, player, profile, createdValue, data.ID)
	end
end

local function createTemporaryData(player)
	local temporaryProfile = ProfileData.TemporaryData
	local temporaryData = Instance.new("Folder")
	temporaryData.Name = "TemporaryData"
	temporaryData.Parent = player

	for key, data in temporaryProfile do
		local createdValue = Instance.new(data.Type.."Value")
		createdValue.Name = key
		createdValue.Value = data.Value
		createdValue.Parent = temporaryData
	end
end

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
			print(profile.Data)
			createReplicatedData(player, profile)
			createLeaderstats(player, profile)
			createTemporaryData(player)
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

----- Initialize -----

function ProfileManager:Init()
	-- In case Players have joined the server earlier than this script ran:
	for _, player in Players:GetPlayers() do
		task.spawn(playerAdded, player)
	end

	----- Connections -----

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