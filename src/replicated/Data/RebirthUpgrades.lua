local rebirthUpgrades = {
	R1 = {
		Name = "Increase Material Drop Chance";
		Cost = 2;
		Modifier = 2.5;
		Limit = 20;
		RewardType = "RebirthMaterialDropChance";
		Initial = 25;
		Reward = 2.5;
		InitialMessage = "Current Material Drop Chance : &%";
		RewardMessage = "Increase Material Drop Chance by 2.5%!";
		Image = "rbxassetid://";
		ID = "R1"
	};
	R2 = {
		Name = "Increase Material Max Drop";
		Cost = 10;
		Modifier = 4;
		Limit = 10;
		RewardType = "RebirthMaterialMaxDrop";
		Initial = 5;
		Reward = 1;
		InitialMessage = "Current Max Material Drop : &";
		RewardMessage = "Increase Max Material Drop by 1!";
		Image = "rbxassetid://";
		ID = "R2"
	};
	R3 = {
		Name = "Increase Tix Per Click";
		Cost = 3;
		Modifier = 3;
		Limit = 50;
		RewardType = "RebirthMultPerClick";
		Initial = 0;
		Reward = 25;
		InitialMessage = "Current Rebirth Multiplier : &%";
		RewardMessage = "Increase Tix Per Click Multiplier by 25%";
		Image = "rbxassetid://";
		ID = "R3"
	};
	R4 = {
		Name = "Increase Tix Storage";
		Cost = 1;
		Modifier = 3;
		Limit = 50;
		RewardType = "RebirthMultStorage";
		Initial = 0;
		Reward = 25;
		InitialMessage = "Current Rebirth Multiplier : &%";
		RewardMessage = "Increase Tix Storage Multiplier by 25%";
		Image = "rbxassetid://";
		ID = "R4"
	};
}

return rebirthUpgrades
