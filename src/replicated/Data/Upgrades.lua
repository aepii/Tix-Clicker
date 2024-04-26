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
		Name = "Upgrade3";
		Title = "Tix Wallet";
		Cost = {Rocash = 100, Basic = 3};
		Reward = {MultPerClick = 4, MultStorage = 4};
		Tool = Tools["Tix Wallet"];
		Image = "rbxassetid://17206340267"
	};
	["Upgrade4"] = {
		Name = "Upgrade4";
		Title = "Tix Bag";
		Cost = {Rocash = 1500, Common = 10, Uncommon = 5, Fine = 3};
		Reward = {MultPerClick = 8, MultStorage = 15};
		Tool = Tools["Tix Bag"];
		Image = "rbxassetid://17273972764"
	};
	["Upgrade5"] = {
		Name = "Upgrade5";
		Title = "Tix Sack";
		Cost = {Rocash = 30000, Fine = 20, Rare = 10};
		Reward = {MultPerClick = 15, MultStorage = 30};
		Tool = Tools["Tix Sack"];
		Image = "rbxassetid://17273942251"
	};
	["Upgrade6"] = {
		Name = "Upgrade6";
		Title = "Tix Case";
		Cost = {Rocash = 750000, Rare = 100};
		Reward = {MultPerClick = 30, MultStorage = 75};
		Tool = Tools["Tix Case"];
		Image = "rbxassetid://17273942384"
	};
}
	
return upgrades
