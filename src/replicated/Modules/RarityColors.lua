local RarityGradients = {
    Basic = ColorSequence.new(Color3.fromRGB(192, 192, 192), Color3.fromRGB(160, 160, 160)),
    Common = ColorSequence.new(Color3.fromRGB(0, 128, 255), Color3.fromRGB(0, 80, 160)),
    Uncommon = ColorSequence.new(Color3.fromRGB(111, 190, 151), Color3.fromRGB(63, 107, 85)),
    Fine = ColorSequence.new(Color3.fromRGB(253, 255, 136), Color3.fromRGB(224, 214, 124)),
    Rare = ColorSequence.new(Color3.fromRGB(255, 128, 0), Color3.fromRGB(243, 163, 131)),
    Exceptional = ColorSequence.new(Color3.fromRGB(120, 245, 245), Color3.fromRGB(120, 223, 248)),
    Epic = ColorSequence.new(Color3.fromRGB(128, 0, 255), Color3.fromRGB(131, 102, 160)),
    Heroic = ColorSequence.new(Color3.fromRGB(253, 121, 121), Color3.fromRGB(253, 83, 83)),
    Legendary = ColorSequence.new(Color3.fromRGB(190, 145, 190), Color3.fromRGB(225, 238, 202))
}

local RarityModule = {}

function RarityModule:GetGradient(rarity)
    return RarityGradients[rarity] or ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(200, 200, 200))
end

return RarityModule
