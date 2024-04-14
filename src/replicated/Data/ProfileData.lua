local ProfileData = {}

ProfileData.Data = {
	["Tix"] = 0;
	["Rocash"] = 100;
	["Rebirth Tix"] = 0;
	["Level"] = 1;
	["XP"] = 0;

	["Equipped"] = "Upgrade1";
	["AlphaTester"] = true;
	
	["Upgrades"] = {"Upgrade1"};
	
	["ValueUpgrades"] = {
	};
	
	["Inventory"] = {
	};
	
}

ProfileData.TemporaryData = {
	["TixPerClick"] = {
		Value = 1,
		Type = "Number"
	};
	["TixPerSecond"] = {
		Value = 0,
		Type = "Number"
	};
	["Value"] = {
		Value = 0,
		Type = "Number"
	};
	["TixStorage"] = {
		Value = 20,
		Type = "Number"
	};
}

ProfileData.leaderstats = {
	[1] = {
		ID = "Tix",
		DisplayName = "🎟️ Tix"
	};
	[2] = {
		ID = "Rocash",
		DisplayName = "💵 Rocash"
	};
	[3] = {
		ID = "Value",
		DisplayName = "📈 Value"
	};
	[4] = {
		ID = "Rebirth Tix",
		DisplayName = "🌟 Rb Tix"
	};
	[5] = {
		ID = "Level",
		DisplayName = "⭐ Level"
	};
}

return ProfileData
