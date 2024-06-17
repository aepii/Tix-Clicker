local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Tools = ReplicatedStorage:WaitForChild("Tools")

local upgrades = {
	U1 = {
		Name = "Tix";
		Cost =  {Rocash = 0};
		Reward = {MultPerClick = 1, MultStorage = 1};
		Tool = Tools.Tix;
		Image = "rbxassetid://17193515413",
		ID = "U1"
	};
	U2 = {
		Name = "Tix Wad";
		Cost = {Rocash = 20};
		Reward = {MultPerClick = 2, MultStorage = 2};
		Tool = Tools["Tix Wad"];
		Image = "rbxassetid://17206299335",
		ID = "U2"
	},
	U3 = {
		Name = "Tix Wallet";
		Cost = {Rocash = 100, Materials = {[1] = {"M1", 3}}};
		Reward = {MultPerClick = 4, MultStorage = 4};
		Tool = Tools["Tix Wallet"];
		Image = "rbxassetid://17206340267",
		ID = "U3"
	};
	U4 = {
		Name = "Tix Bag";
		Cost = {Rocash = 1750, Materials = {[1] = {"M1", 10}, [2] = {"M2", 5}, [3] = {"M3", 2}}};
		Reward = {MultPerClick = 8, MultStorage = 15};
		Tool = Tools["Tix Bag"];
		Image = "rbxassetid://17273972764",
		ID = "U4"
	};
	U5 = {
		Name = "Tix Sack";
		Cost = {Rocash = 25000, Materials = {[1] = {"M2", 12}, [2] = {"M3", 7}, [3] = {"M4", 3}}};
		Reward = {MultPerClick = 15, MultStorage = 40};
		Tool = Tools["Tix Sack"];
		Image = "rbxassetid://17273942251",
		ID = "U5"
	};
	U6 = {
		Name = "Tix Case";
		Cost = {Rocash = 100000, Materials = {[1] = {"M4", 20}, [2] = {"M5", 15}, [3] = {"M6", 7}}};
		Reward = {MultPerClick = 40, MultStorage = 120};
		Tool = Tools["Tix Case"];
		Image = "rbxassetid://17273942384",
		ID = "U6"
	};
	U7 = {
		Name = "Tix Duffle Bag";
		Cost = {Rocash = 500000, Materials = {[1] = {"M5", 30}, [2] = {"M6", 20}, [3] = {"M7", 10}}};
		Reward = {MultPerClick = 100, MultStorage = 350};
		Tool = Tools["Tix Duffle Bag"];
		Image = "rbxassetid://17765380295",
		ID = "U7"
	};

}
	
return upgrades
