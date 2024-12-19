

local RarityModule = {}

RarityModule.RarityGradients = {
    Basic = ColorSequence.new(Color3.fromRGB(140, 140, 140), Color3.fromRGB(192, 192, 192)),
    Common = ColorSequence.new(Color3.fromRGB(0, 80, 160), Color3.fromRGB(34, 174, 255)),
    Uncommon = ColorSequence.new(Color3.fromRGB(63, 107, 85), Color3.fromRGB(97, 190, 144)),
    Fine = ColorSequence.new(Color3.fromRGB(243, 235, 167), Color3.fromRGB(253, 255, 136)),
    Rare = ColorSequence.new(Color3.fromRGB(248, 184, 158), Color3.fromRGB(255, 128, 0)),
    Exceptional = ColorSequence.new(Color3.fromRGB(168, 247, 250), Color3.fromRGB(48, 228, 250)),
    Epic = ColorSequence.new(Color3.fromRGB(131, 102, 160), Color3.fromRGB(149, 69, 230)),
    Heroic = ColorSequence.new(Color3.fromRGB(247, 105, 105), Color3.fromRGB(150, 54, 54)),
    Legendary = ColorSequence.new(Color3.fromRGB(190, 145, 190), Color3.fromRGB(225, 238, 202)),
    Mythical = ColorSequence.new(Color3.fromRGB(96, 85, 166), Color3.fromRGB(180, 90, 180)),
    Divine = ColorSequence.new(Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 255, 255)),
    Tixclusive = ColorSequence.new(Color3.fromRGB(250, 195, 55), Color3.fromRGB(250, 222, 62))
}

RarityModule.CaseColors = {
    C1 = {Main = Color3.fromRGB(125, 84, 43), Background = Color3.fromRGB(50, 50, 50), Shadow = Color3.fromRGB(84, 56, 29)},
    C2 = {Main = Color3.fromRGB(65, 63, 61), Background = Color3.fromRGB(50, 50, 50), Shadow = Color3.fromRGB(32, 32, 31)},
    C3 = {Main = Color3.fromRGB(0, 174, 255), Background = Color3.fromRGB(50, 50, 50), Shadow = Color3.fromRGB(0, 115, 168)},
    C4 = {Main = Color3.fromRGB(250, 211, 14), Background = Color3.fromRGB(50, 50, 50), Shadow = Color3.fromRGB(250, 183, 13)}, 
    C5 = {Main = Color3.fromRGB(242, 14, 250), Background = Color3.fromRGB(50, 50, 50), Shadow = Color3.fromRGB(118, 71, 139)}, 
    C6 = {Main = Color3.fromRGB(0, 170, 170), Background = Color3.fromRGB(50, 50, 50), Shadow = Color3.fromRGB(0, 85, 85)},
    C7 = {Main = Color3.fromRGB(200, 0, 0), Background = Color3.fromRGB(50, 50, 50), Shadow = Color3.fromRGB(128, 0, 0)},
    CC1 = {Main = Color3.fromRGB(250,222,62), Background = Color3.fromRGB(50, 50, 50), Shadow = Color3.fromRGB(250, 194, 52)}, 
}

RarityModule.PortalColors = {
    Z1 = {Main = Color3.fromRGB(125, 84, 43), Shadow = Color3.fromRGB(84, 56, 29)},
    Z2 = {Main = Color3.fromRGB(0, 174, 255), Shadow = Color3.fromRGB(0, 115, 168)},
    Z3 = {Main = Color3.fromRGB(250, 211, 14), Shadow = Color3.fromRGB(250, 183, 13)},
    Z4 = {Main = Color3.fromRGB(242, 14, 250), Shadow = Color3.fromRGB(118, 71, 139)},
    Z5 = {Main = Color3.fromRGB(0, 170, 170), Shadow = Color3.fromRGB(0, 85, 85)},
    Z6 = {Main = Color3.fromRGB(200, 0, 0), Shadow = Color3.fromRGB(128, 0, 0)}
}

function RarityModule:GetGradient(rarity)
    return self.RarityGradients[rarity] or ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(200, 200, 200))
end

return RarityModule
