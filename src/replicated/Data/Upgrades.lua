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
		Cost = {Rocash = 5};
		Reward = {MultPerClick = 2, MultStorage = 2};
		Tool = Tools["Tix Wad"];
		Image = "rbxassetid://17206299335",
		ID = "U2"
	},
	U3 = {
		Name = "Tix Wallet";
		Cost = {Rocash = 50, Materials = {[1] = {"M1", 3}}};
		Reward = {MultPerClick = 4, MultStorage = 4};
		Tool = Tools["Tix Wallet"];
		Image = "rbxassetid://17206340267",
		ID = "U3"
	};
	U4 = {
		Name = "Tix Bag";
		Cost = {Rocash = 1000, Materials = {[1] = {"M1", 10}, [2] = {"M2", 5}, [3] = {"M3", 2}}};
		Reward = {MultPerClick = 8, MultStorage = 15};
		Tool = Tools["Tix Bag"];
		Image = "rbxassetid://17273972764",
		ID = "U4"
	};
	U5 = {
		Name = "Tix Sack";
		Cost = {Rocash = 10000, Materials = {[1] = {"M2", 12}, [2] = {"M3", 7}, [3] = {"M4", 3}}};
		Reward = {MultPerClick = 20, MultStorage = 40};
		Tool = Tools["Tix Sack"];
		Image = "rbxassetid://17273942251",
		ID = "U5"
	};
	U6 = {
		Name = "Tix Case";
		Cost = {Rocash = 50000, Materials = {[1] = {"M4", 15}, [2] = {"M5", 10}, [3] = {"M6", 5}}};
		Reward = {MultPerClick = 50, MultStorage = 150};
		Tool = Tools["Tix Case"];
		Image = "rbxassetid://17273942384",
		ID = "U6"
	};
	U7 = {
		Name = "Tix Duffle Bag";
		Cost = {Rocash = 200000, Materials = {[1] = {"M6", 20}}};
		Reward = {MultPerClick = 150, MultStorage = 400};
		Tool = Tools["Tix Duffle Bag"];
		Image = "rbxassetid://17765380295",
		ID = "U7"
	};

}
	
return upgrades
