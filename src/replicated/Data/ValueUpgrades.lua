local valueUpgrades = {
	["PerSecUpgrade1"] = {
		Title = "Tix Piggy Bank";
		Cost = 2;
		Modifier = 1.04;
		Reward = 1;
		Image = "rbxassetid://17206305363"
	};
	["PerSecUpgrade2"] = {
		Title = "Tix Dispenser";
		Cost = 10;
		Modifier = 1.039;
		Reward = 2;
		Image = "rbxassetid://17206348574"
	};
}

function valueUpgrades:TixPerSecondCost(upgrade, amount, owned)
	local cost = valueUpgrades[upgrade].Cost
	local modifier = valueUpgrades[upgrade].Modifier
	return math.ceil(cost * modifier^(owned + amount - 1))
end

function valueUpgrades:TixPerSecond(ownedUpgrades)
	local tixPerSecond = 0
	for upgrade, value in ownedUpgrades do
		local reward = valueUpgrades[upgrade].Reward
		tixPerSecond += value * reward
	end
	return tixPerSecond
end
	
return valueUpgrades
