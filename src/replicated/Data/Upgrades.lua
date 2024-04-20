local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Tools = ReplicatedStorage:WaitForChild("Tools")

local upgrades = {
	["Upgrade1"] = {
		Name = "Upgrade1";
		Title = "Tix";
		Cost = 0;
		Reward = {MultPerClick = 1, MultStorage = 1};
		Tool = Tools.Tix;
		Image = "rbxassetid://17193515413"
	};
	["Upgrade2"] = {
		Name = "Upgrade2";
		Title = "Tix Wad";
		Cost = {Rocash = 10};
		Reward = {MultPerClick = 2, MultStorage = 2};
		Tool = Tools["Tix Wad"];
		Image = "rbxassetid://17206299335"
	};
	["Upgrade3"] = {
		Name = "Upgrade2";
		Title = "Tix Wallet";
		Cost = {Rocash = 100, Basic = 3};
		Reward = {MultPerClick = 4, MultStorage = 4};
		Tool = Tools["Tix Wallet"];
		Image = "rbxassetid://17206340267"
	};
}
	
return upgrades
