local ProfileData = {}

ProfileData.Data = {
	["Tix"] = 0;
	["Rocash"] = 0;
	["Rebirth Tix"] = 0;

	["Lifetime Tix"] = 0;
	["Lifetime Rocash"] = 0;
	["Lifetime Rebirth Tix"] = 0;

	["ToolEquipped"] = "U1";
	["EquippedAccessories"] = {};

	["EquippedAmulet"] = "";

	["AlphaTester"] = true;
	
	["Upgrades"] = {"U1"};
	
	["PerSecondUpgrades"] = {
	};

	["RebirthUpgrades"] = {
	};

	["Accessories"] = {
	};

	["Cases"] = {
	};

	["Materials"] = {	
	};

}

ProfileData.TemporaryData = {
	["LastClickTime"] = {
		Value = 0,
		Type = "Number"
	};
	["ActiveCaseOpening"] = {
		Value = false,
		Type = "Bool"
	};
	["XP"] = {
		Value = 0,
		Type = "Number"
	};
	["RequiredXP"] = {
		Value = 500,
		Type = "Number"
	};
	["TixPerClick"] = {
		Value = 1,
		Type = "Number"
	};
	["TixPerSecond"] = {
		Value = 0,
		Type = "Number"
	};
	["ConvertPerSecond"] = {
		Value = 0,
		Type = "Number"
	};
	["QueuedTix"] = {
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
	["EquippedAccessoriesLimit"] = {
		Value = 3,
		Type = "Number"
	};
	["AccessoriesLimit"] = {
		Value = 20,
		Type = "Number"
	};
	["AddPerClick"] = {
		Value = 0,
		Type = "Number"
	};
	["AddStorage"] = {
		Value = 0,
		Type = "Number"
	};
	["MultPerClick"] = {
		Value = 1,
		Type = "Number"
	};
	["MultStorage"] = {
		Value = 1,
		Type = "Number"
	};
	["RebirthMaterialDropChance"] = {
		Value = 25,
		Type = "Number"
	};
	["RebirthMaterialMaxDrop"] = {
		Value = 5,
		Type = "Number"
	};
	["RebirthMultPerClick"] = {
		Value = 0,
		Type = "Number"
	};
	["RebirthMultStorage"] = {
		Value = 0,
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
}

return ProfileData
