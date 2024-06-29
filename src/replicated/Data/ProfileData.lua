local ProfileData = {}

ProfileData.Data = {
	["Tix"] = 0;
	["Rocash"] = 0;
	["Rebirth Tix"] = 0;

	["Join Time"] = os.time();
	["Lifetime Tix"] = 0;
	["Lifetime Rocash"] = 0;
	["Lifetime Rebirth Tix"] = 0;
	["Lifetime Value"] = 0;
	["Lifetime Cases"] = 0;
	["Lifetime Scrapped"] = 0;
	["Lifetime Materials"] = 0;
	["Lifetime Robux Spent"] = 0;
	["Lifetime Playtime"] = 0;

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

	["Zones"] = {"Z0", "Z1"};
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
		Value = 1000,
		Type = "Number"
	};
	["RageModeTime"] = {
		Value = 10,
		Type = "Number"
	};
	["RageMode"] = {
		Value = false,
		Type = "Bool"
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
	["CriticalChance"] = {
		Value = 1,
		Type = "Number"
	};
	["ClickRate"] = {
		Value = 20,
		Type = "Number"
	};
	["EquippedAccessoriesLimit"] = {
		Value = 3,
		Type = "Number"
	};
	["AccessoriesLimit"] = {
		Value = 50,
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
		Value = 0,
		Type = "Number"
	};
	["MultStorage"] = {
		Value = 0,
		Type = "Number"
	};
	["MaterialDropChance"] = {
		Value = 50,
		Type = "Number"
	};
	["MaterialMaxDrop"] = {
		Value = 5,
		Type = "Number"
	};
	["CaseTime"] = {
		Value = 5,
		Type = "Number"
	};
	["CriticalPower"] = {
		Value = 100,
		Type = "Number"
	};
	["Luck"] = {
		Value = 1,
		Type = "Number"
	};
	["MaxCaseOpenings"] = {
		Value = 1,
		Type = "Number"
	};
	["SpeedTixConvert"] = {
		Value = 1,
		Type = "Number"
	};
	["MultPerSecond"] = {
		Value = 0,
		Type = "Number"
	};
	["RageTime"] = {
		Value = 10,
		Type = "Number"
	};
	["RebirthMaterialDropChance"] = {
		Value = 0,
		Type = "Number"
	};
	["RebirthMaterialMaxDrop"] = {
		Value = 0,
		Type = "Number"
	};
	["RebirthMultPerClick"] = {
		Value = 1,
		Type = "Number"
	};
	["RebirthMultStorage"] = {
		Value = 1,
		Type = "Number"
	};
	["RebirthAccessoriesLimit"] = {
		Value = 0,
		Type = "Number"
	};
	["RebirthEquippedAccessoriesLimit"] = {
		Value = 0,
		Type = "Number"
	};
	["RebirthCaseTime"] = {
		Value = 0,
		Type = "Number"
	};
	["RebirthCriticalChance"] = {
		Value = 0,
		Type = "Number"
	};
	["RebirthCriticalPower"] = {
		Value = 0,
		Type = "Number"
	};
	["RebirthSpeedTixConvert"] = {
		Value = 0,
		Type = "Number"
	};
	["RebirthMultPerSecond"] = {
		Value = 0,
		Type = "Number"
	};
	["RebirthRequiredXP"] = {
		Value = 0,
		Type = "Number"
	};
	["RebirthRageTime"] = {
		Value = 0,
		Type = "Number"
	};
}

ProfileData.leaderstats = {
	[1] = {
		ID = "Rebirth Tix",
		DisplayName = "🌟 Rb Tix"
	};
	[2] = {
		ID = "Value",
		DisplayName = "📈 Value"
	};
	[3] = {
		ID = "Tix",
		DisplayName = "🎟️ Tix"
	};
	[4] = {
		ID = "Rocash",
		DisplayName = "💵 Rocash"
	};
}

return ProfileData
