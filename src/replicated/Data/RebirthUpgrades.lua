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
	--[[R5 = {
		Name = "Increase Accessory Storage";
		Cost = 1;
		Modifier = 2;
		Limit = 50;
		RewardType = "RebirthAccessoryStorage";
		Initial = 20;
		Reward = 5;
		InitialMessage = "Current Accessory Storage : &";
		RewardMessage = "Increase Accessory Storage by 5";
		Image = "rbxassetid://";
		ID = "R5"
	};
	R6 = {
		Name = "Increase Equipped Accessories";
		Cost = 10;
		Modifier = 5;
		Limit = 7;
		RewardType = "RebirthEquippedAccessoriesLimit";
		Initial = 3;
		Reward = 1;
		InitialMessage = "Current Equipped Accessories Limit : &";
		RewardMessage = "Increase Equipped Accessories by 1";
		Image = "rbxassetid://";
		ID = "R6"
	};
	R7 = {
		Name = "Speed Up Case Animation";
		Cost = 5;
		Modifier = 2.5;
		Limit = 15;
		RewardType = "RebirthEquippedAccessoriesLimit";
		Initial = 10;
		Reward = 0.5;
		InitialMessage = "Current Time : &";
		RewardMessage = "Decrease Time by 0.5s";
		Image = "rbxassetid://";
		ID = "R7"
	};
	R8 = {
		Name = "Increase Click Rate";
		Cost = 1;
		Modifier = 2;
		Limit = 20;
		RewardType = "RebirthEquippedAccessoriesLimit";
		Initial = 7;
		Reward = 0.5;
		InitialMessage = "Current Click Rate : &/s";
		RewardMessage = "Increase Click Rate by 1/s";
		Image = "rbxassetid://";
		ID = "R8"
	};--]]
}

return rebirthUpgrades
