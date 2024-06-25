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
		Reward = {MultPerClick = 8, MultStorage = 15};
		Tool = Tools["Tix Bag"];
		Image = "rbxassetid://17273972764",
		ID = "U4"
	};
	U5 = {
		Name = "Tix Sack";
		Cost = {Rocash = 10000, Materials = {[1] = {"M2", 12}, [2] = {"M3", 7}, [3] = {"M4", 3}}};
		Reward = {MultPerClick = 15, MultStorage = 25};
		Tool = Tools["Tix Sack"];
		Image = "rbxassetid://17273942251",
		ID = "U5"
	};
	U6 = {
		Name = "Tix Case";
		Cost = {Rocash = 50000, Materials = {[1] = {"M3", 20}, [2] = {"M4", 15}, [3] = {"M5", 7}}};
		Reward = {MultPerClick = 25, MultStorage = 40};
		Tool = Tools["Tix Case"];
		Image = "rbxassetid://17273942384",
		ID = "U6"
	};
	U7 = {
		Name = "Tix Duffle Bag";
		Cost = {Rocash = 200000, Materials = {[1] = {"M4", 30}, [2] = {"M5", 20}, [3] = {"M6", 10}}};
		Reward = {MultPerClick = 40, MultStorage = 75};
		Tool = Tools["Tix Duffle Bag"];
		Image = "rbxassetid://17765380295",
		ID = "U7"
	};
	U8 = {
		Name = "Tix Chest";
		Cost = {Rocash = 1000000, Materials = {[1] = {"M5", 50}, [2] = {"M6", 30}, [3] = {"M7", 15}}};
		Reward = {MultPerClick = 75, MultStorage = 175};
		Tool = Tools["Tix Chest"];
		Image = "rbxassetid://18179409038",
		ID = "U8"
	};

	U9 = {
		Name = "Tix Safe";
		Cost = {Rocash = 10000000, Materials = {[1] = {"M6", 75}, [2] = {"M7", 45}, [3] = {"M8", 20}}};
		Reward = {MultPerClick = 175, MultStorage = 400};
		Tool = Tools["Tix Safe"];
		Image = "rbxassetid://18182028931",
		ID = "U9"
	};

	U10 = {
		Name = "Tix ATM";
		Cost = {Rocash = 120000000, Materials = {[1] = {"M7", 90}, [2] = {"M8", 60}, [3] = {"M9", 25}}};
		Reward = {MultPerClick = 400, MultStorage = 1000};
		Tool = Tools["Tix ATM"];
		Image = "rbxassetid://18184555822",
		ID = "U10"
	};

	U11 = {
		Name = "Tix Gadget";
		Cost = {Rocash = 2500000000, Materials = {[1] = {"M8", 120}, [2] = {"M9", 90}, [3] = {"M10", 40}}};
		Reward = {MultPerClick = 1000, MultStorage = 2500};
		Tool = Tools["Tix Gadget"];
		Image = "rbxassetid://18190698874",
		ID = "U11"
	};
}
	
return upgrades
