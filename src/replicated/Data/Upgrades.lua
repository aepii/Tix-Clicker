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
		Name = "Tix Piggy Bank";
		Cost = {Rocash = 100, Materials = {[1] = {"M1", 10}}};
		Reward = {MultPerClick = 4, MultStorage = 4};
		Tool = Tools["Tix Piggy Bank"];
		Image = "rbxassetid://17206305363",
		ID = "U3"
	};
	U4 = {
		Name = "Tix Wallet";
		Cost = {Rocash = 2500, Materials = {[1] = {"M1", 25}, [2] = {"M2", 15}, [3] = {"M3", 10}}};
		Reward = {MultPerClick = 9, MultStorage = 9};
		Tool = Tools["Tix Wallet"];
		Image = "rbxassetid://17206340267",
		ID = "U4"
	};
	U5 = {
		Name = "Tix Bag";
		Cost = {Rocash = 15000, Materials = {[1] = {"M2", 40}, [2] = {"M3", 30}, [3] = {"M4", 20}}};
		Reward = {MultPerClick = 20, MultStorage = 20};
		Tool = Tools["Tix Bag"];
		Image = "rbxassetid://17273972764",
		ID = "U5"
	};
	U6 = {
		Name = "Tix Sack";
		Cost = {Rocash = 200000, Materials = {[1] = {"M3", 70}, [2] = {"M4", 50}, [3] = {"M5", 30}}};
		Reward = {MultPerClick = 45, MultStorage = 45};
		Tool = Tools["Tix Sack"];
		Image = "rbxassetid://17273942251",
		ID = "U6"
	};
	U7 = {
		Name = "Tix Case";
		Cost = {Rocash = 1500000, Materials = {[1] = {"M4", 100}, [2] = {"M5", 75}, [3] = {"M6", 50}}};
		Reward = {MultPerClick = 100, MultStorage = 100};
		Tool = Tools["Tix Case"];
		Image = "rbxassetid://17273942384",
		ID = "U7"
	};
	--[[U8 = {
		Name = "Tix Duffle Bag";
		Cost = {Rocash = 1000000, Materials = {[1] = {"M5", 25}, [2] = {"M6", 15}, [3] = {"M7", 10}}};
		Reward = {MultPerClick = 150, MultStorage = 150};
		Tool = Tools["Tix Duffle Bag"];
		Image = "rbxassetid://17765380295",
		ID = "U8"
	};
	U9 = {
		Name = "Tix Chest";
		Cost = {Rocash = 5000000, Materials = {[1] = {"M6", 30}, [2] = {"M7", 20}, [3] = {"M8", 15}}};
		Reward = {MultPerClick = 300, MultStorage = 300};
		Tool = Tools["Tix Chest"];
		Image = "rbxassetid://18179409038",
		ID = "U9"
	};
	U10 = {
		Name = "Tix Safe";
		Cost = {Rocash = 75000000, Materials = {[1] = {"M7", 40}, [2] = {"M8", 30}, [3] = {"M9", 20}}};
		Reward = {MultPerClick = 750, MultStorage = 750};
		Tool = Tools["Tix Safe"];
		Image = "rbxassetid://18179409038",
		ID = "U10"
	};
	U11 = {
		Name = "Tix ATM";
		Cost = {Rocash = 500000000, Materials = {[1] = {"M8", 50}, [2] = {"M9", 40}, [3] = {"M10", 30}}};
		Reward = {MultPerClick = 1500, MultStorage = 1500};
		Tool = Tools["Tix ATM"];
		Image = "rbxassetid://18184564778",
		ID = "U11"
	};
	U12 = {
		Name = "Tix Dispenser";
		Cost = {Rocash = 500000000, Materials = {[1] = {"M8", 50}, [2] = {"M9", 40}, [3] = {"M10", 30}}};
		Reward = {MultPerClick = 1500, MultStorage = 1500};
		Tool = Tools["Tix Dispenser"];
		Image = "rbxassetid://18190698874",
		ID = "U12"
	};
	U13 = {
		Name = "Tix Printer";
		Cost = {Rocash = 500000000, Materials = {[1] = {"M8", 50}, [2] = {"M9", 40}, [3] = {"M10", 30}}};
		Reward = {MultPerClick = 1500, MultStorage = 1500};
		Tool = Tools["Tix Printer"];
		Image = "rbxassetid://18190698874",
		ID = "U13"
	};
	U14 = {
		Name = "Tix Generator";
		Cost = {Rocash = 500000000, Materials = {[1] = {"M8", 50}, [2] = {"M9", 40}, [3] = {"M10", 30}}};
		Reward = {MultPerClick = 1500, MultStorage = 1500};
		Tool = Tools["Tix Generator"];
		Image = "rbxassetid://18190698874",
		ID = "U14"
	};
	U15 = {
		Name = "Tix Gadget";
		Cost = {Rocash = 500000000, Materials = {[1] = {"M8", 50}, [2] = {"M9", 40}, [3] = {"M10", 30}}};
		Reward = {MultPerClick = 1500, MultStorage = 1500};
		Tool = Tools["Tix Gadget"];
		Image = "rbxassetid://18190698874",
		ID = "U15"
	};]]--
}
	
return upgrades
