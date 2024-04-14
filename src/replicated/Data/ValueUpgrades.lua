local valueUpgrades = {
	["SecUpgrade1"] = {
		Title = "Tix Piggy Bank";
		Cost = 2;
		Modifier = 1.04;
		Reward = 1;
		Image = nil
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
