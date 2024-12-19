---- Services ----

local ReplicatedStorage = game:GetService("ReplicatedStorage")

---- Data ----

local ProfileData = require(ReplicatedStorage.Data.ProfileData)

---- Loaded Modules ----

local Modules = ReplicatedStorage:WaitForChild("Modules")
local SuffixHandler = require(Modules:WaitForChild("SuffixHandler"))
local TemporaryData = require(Modules:WaitForChild("TemporaryData"))

---- Private Variables ----

local typeMap = {
	number = "NumberValue",
	string = "StringValue",
	boolean = "BoolValue",
	table = "Folder",
}

local tableMap = {
	["Upgrades"] = "boolean",
	["RebirthUpgrades"] = "number",
	["Accessories"] = "string",
	["Cases"] = "number",
	["EquippedAccessories"] = "string",
	["Materials"] = "number",
	["Zones"] = "boolean",
	["Achievements"] = "number",
}

---- Private Functions ----

local function initData(player, profile, holder, valueType)
	local dataHolder = profile.Data[holder.Name]
	for index, value in dataHolder do
		local instanceClass = typeMap[valueType]
		local createdValue = Instance.new(instanceClass)
		if instanceClass ~= "BoolValue" then
			createdValue.Value = value
			createdValue.Name = index
		else
			createdValue.Name = value
		end
		createdValue.Parent = holder
	end
end

local function createReplicatedData(player, profile)
	local dataProfile = ProfileData.Data
	local replicatedData = Instance.new("Folder")
	replicatedData.Name = "ReplicatedData"
	replicatedData.Parent = player

	for key, value in dataProfile do
		local valueType = type(value)
		local instanceClass = typeMap[valueType]
		local createdValue = Instance.new(instanceClass)

		createdValue.Name = key
		createdValue.Parent = replicatedData

		if valueType ~= "table" then
			createdValue.Value = profile.Data[key]
		else
			local tableClass = tableMap[key]
			initData(player, profile, createdValue, tableClass)
		end
	end
end

local function updateLeaderstats(player, profile, createdValue, key)
	if key == "Value" then
		local Value = TemporaryData:CalculateValue(player, profile.Data)
		createdValue.Value = SuffixHandler:Convert(Value)
	else
		createdValue.Value = SuffixHandler:Convert(profile.Data[key])
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
		updateLeaderstats(player, profile, createdValue, data.ID)
	end
end

local function createTemporaryData(player, profile)
	local temporaryProfile = ProfileData.TemporaryData
	local temporaryData = Instance.new("Folder")
	temporaryData.Name = "TemporaryData"
	temporaryData.Parent = player

	for index, data in temporaryProfile do
		local createdValue = Instance.new(data.Type .. "Value")
		createdValue.Name = index
		createdValue.Value = data.Value
		createdValue.Parent = temporaryData
	end
	TemporaryData:Setup(player, profile.Data)
end

---- Leaderstats ----

local DataManager = {}

function DataManager:Init(player, profile)
	createReplicatedData(player, profile)
	createTemporaryData(player, profile)
	createLeaderstats(player, profile)
end

function DataManager:UpdateLeaderstats(player, profile, key)
	local leaderstatsProfile = ProfileData.leaderstats
	for index, data in leaderstatsProfile do
		if data.ID == key then
			updateLeaderstats(player, profile, player.leaderstats[data.DisplayName], key)
		end
	end
end

function DataManager:SetValue(player, profile, path, key)
	local currentProfile = profile.Data
	local currentReplicated = player.ReplicatedData

	local response = "Exists"

	-- Iterate through the path except for the last element
	for i = 1, #path - 1 do
		local pointer = path[i]

		-- If the part does not exist in profile, create an empty table for it
		if currentProfile[pointer] == nil then
			currentProfile[pointer] = {}
		end

		-- Move to the next level in the path for profile
		currentProfile = currentProfile[pointer]
		-- Move to the next level in the path for player.ReplicatedData
		currentReplicated = currentReplicated[pointer]
	end

	local finalKey = path[#path]

	if key == nil then
		-- Handle deletion
		currentProfile[finalKey] = nil

		local finalValue = currentReplicated:FindFirstChild(finalKey)
		if finalValue then
			finalValue:Destroy()
		end

		response = "Deleted"
	else
		-- Set the value at the final path for profile
		currentProfile[finalKey] = key

		-- Handle setting the value in player.ReplicatedData
		local finalValue = currentReplicated:FindFirstChild(finalKey)

		-- Create the appropriate value instance if it doesn't exist
		if not finalValue then
			local valueType = type(key)
			local instanceClass = typeMap[valueType]

			finalValue = Instance.new(instanceClass)
			finalValue.Name = finalKey
			finalValue.Parent = currentReplicated
			response = "Created"
		end
		-- Set the value
		finalValue.Value = key
	end

	return response
end

function DataManager:ArrayInsert(player, profile, path, key)
	local currentProfile = profile.Data
	local currentReplicated = player.ReplicatedData

	local response = "Exists"

	-- Iterate through the path except for the last element
	for i = 1, #path - 1 do
		local pointer = path[i]

		-- If the part does not exist in profile, create an empty table for it
		if currentProfile[pointer] == nil then
			currentProfile[pointer] = {}
		end

		-- Move to the next level in the path for profile
		currentProfile = currentProfile[pointer]
		-- Move to the next level in the path for player.ReplicatedData
		currentReplicated = currentReplicated[pointer]
	end

	local finalKey = path[#path]

	-- Ensure the final path in profile is an array
	if currentProfile[finalKey] == nil then
		currentProfile[finalKey] = {}
	end

	-- Append the element to the array in profile
	table.insert(currentProfile[finalKey], key)

	-- Handle setting the value in player.ReplicatedData
	local finalValue = currentReplicated:FindFirstChild(finalKey)

	-- If the final value does not exist, create a Folder to hold the array elements
	if not finalValue then
		finalValue = Instance.new("Folder")
		finalValue.Name = finalKey
		finalValue.Parent = currentReplicated
		response = "Created"
	end

	-- Clear existing children in the final value
	for _, child in pairs(finalValue:GetChildren()) do
		child:Destroy()
	end

	-- Create the appropriate value instances for each element in the array
	for index, element in currentProfile[finalKey] do
		local valueInstance = Instance.new("BoolValue")
		valueInstance.Name = element
		valueInstance.Parent = finalValue
	end

	return response
end

function DataManager:ArrayClear(player, profile, path)
	local currentProfile = profile.Data
	local currentReplicated = player.ReplicatedData

	-- Iterate through the path except for the last element
	for i = 1, #path - 1 do
		local pointer = path[i]

		-- If the part does not exist in profile, exit the loop
		if currentProfile[pointer] == nil then
			return "Path not found"
		end

		-- Move to the next level in the path for profile
		currentProfile = currentProfile[pointer]
		-- Move to the next level in the path for player.ReplicatedData
		currentReplicated = currentReplicated[pointer]
	end

	local finalKey = path[#path]

	-- Ensure the final path in profile is an array
	if currentProfile[finalKey] == nil then
		return "Array not found"
	end

	-- Clear the array in profile
	currentProfile[finalKey] = {}

	-- Handle clearing the replicated data
	local finalValue = currentReplicated:FindFirstChild(finalKey)

	-- If the final value exists, clear its children
	if finalValue then
		for _, child in pairs(finalValue:GetChildren()) do
			child:Destroy()
		end
	end

	return "Cleared"
end

return DataManager
