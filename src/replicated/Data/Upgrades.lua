local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Tools = ReplicatedStorage:WaitForChild("Tools")

local upgrades = {
	["Upgrade1"] = {
		Title = "Tix";
		Cost = 0;
		Reward = 1;
		Tool = Tools.Tix;
		Image = "rbxassetid://17193515413"
	};
}
	
return upgrades
