
----- Services -----

local ReplicatedStorage = game:GetService("ReplicatedStorage")

----- Data -----

local ProfileData = require(ReplicatedStorage.Data.ProfileData)

----- Loaded Modules -----

local Modules = ReplicatedStorage:WaitForChild("Modules")
local SuffixHandler = require(Modules.SuffixHandler)
local Accessories = require(ReplicatedStorage.Data.Accessories)

----- Private Variables -----

local typeMap = {
	number = "NumberValue",
	string = "StringValue",
	boolean = "BoolValue",
	table = "Folder"
}

local tableMap = {
	["Upgrades"] = "boolean",
	["ValueUpgrades"] = "number",
	["Cases"] = "number",
	["Accessories"] = "string",
	["EquippedAccessories"] = "string"
}

local ReplicatedData = {}

----- Private Functions -----

local function initPlayerValue(player, ID)
	local accessory = Accessories[ID]
	player.TemporaryData["Value"].Value += accessory.Value
end

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
		if holder.Name == "Accessories" then
			initPlayerValue(player, value)
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

local function initLeaderstats(player, profile, createdValue, key)
	if key == "Value" then
		createdValue.Value = SuffixHandler:Convert(player.TemporaryData["Value"].Value)
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
		initLeaderstats(player, profile, createdValue, data.ID)
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

----- Replicated Data -----

function ReplicatedData:Create(player, profile)
    createTemporaryData(player)
    createReplicatedData(player, profile)
    createLeaderstats(player, profile)
end

return ReplicatedData