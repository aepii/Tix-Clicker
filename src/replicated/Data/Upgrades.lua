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
		Cost = {Rocash = 1250, Materials = {[1] = {"M1", 10}, [2] = {"M2", 5}, [3] = {"M3", 2}}};
		Reward = {MultPerClick = 8, MultStorage = 8};
		Tool = Tools["Tix Bag"];
		Image = "rbxassetid://17273972764",
		ID = "U4"
	};
	U5 = {
		Name = "Tix Sack";
		Cost = {Rocash = 7500, Materials = {[1] = {"M2", 12}, [2] = {"M3", 7}, [3] = {"M4", 3}}};
		Reward = {MultPerClick = 12, MultStorage = 12};
		Tool = Tools["Tix Sack"];
		Image = "rbxassetid://17273942251",
		ID = "U5"
	};
	U6 = {
		Name = "Tix Case";
		Cost = {Rocash = 30000, Materials = {[1] = {"M3", 15}, [2] = {"M4", 10}, [3] = {"M5", 5}}};
		Reward = {MultPerClick = 18, MultStorage = 18};
		Tool = Tools["Tix Case"];
		Image = "rbxassetid://17273942384",
		ID = "U6"
	};
	U7 = {
		Name = "Tix Duffle Bag";
		Cost = {Rocash = 150000, Materials = {[1] = {"M4", 20}, [2] = {"M5", 12}, [3] = {"M6", 7}}};
		Reward = {MultPerClick = 25, MultStorage = 25};
		Tool = Tools["Tix Duffle Bag"];
		Image = "rbxassetid://17765380295",
		ID = "U7"
	};
	U8 = {
		Name = "Tix Chest";
		Cost = {Rocash = 1000000, Materials = {[1] = {"M5", 25}, [2] = {"M6", 15}, [3] = {"M7", 10}}};
		Reward = {MultPerClick = 35, MultStorage = 35};
		Tool = Tools["Tix Chest"];
		Image = "rbxassetid://18179409038",
		ID = "U8"
	};
	U9 = {
		Name = "Tix Safe";
		Cost = {Rocash = 5000000, Materials = {[1] = {"M6", 30}, [2] = {"M7", 20}, [3] = {"M8", 15}}};
		Reward = {MultPerClick = 50, MultStorage = 50};
		Tool = Tools["Tix Safe"];
		Image = "rbxassetid://18182028931",
		ID = "U9"
	};
	U10 = {
		Name = "Tix ATM";
		Cost = {Rocash = 75000000, Materials = {[1] = {"M7", 40}, [2] = {"M8", 30}, [3] = {"M9", 20}}};
		Reward = {MultPerClick = 75, MultStorage = 75};
		Tool = Tools["Tix ATM"];
		Image = "rbxassetid://18184555822",
		ID = "U10"
	};
	U11 = {
		Name = "Tix Gadget";
		Cost = {Rocash = 500000000, Materials = {[1] = {"M8", 50}, [2] = {"M9", 40}, [3] = {"M10", 30}}};
		Reward = {MultPerClick = 100, MultStorage = 100};
		Tool = Tools["Tix Gadget"];
		Image = "rbxassetid://18190698874",
		ID = "U11"
	};
}
	
return upgrades
