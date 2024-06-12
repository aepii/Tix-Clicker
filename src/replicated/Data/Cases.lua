local cases = {
    C1 = {
        Name = "Noob Case",
        Cost = 10,
        Weights = {
            [1] = {"Basic", 65},
            [2] = {"Common", 30.5},
            [3] = {"Uncommon", 4.5},
        },
        Image = "rbxassetid://17227170475",
        ID = "C1"
    },

    C2 = {
        Name = "Apprentice Case",
        Cost = 200,
        Weights = {
            [1] = {"Common", 20},
            [2] = {"Uncommon", 60},
            [3] = {"Fine", 19.5},
            [4] = {"Rare", 0.5},
        },
        Image = "rbxassetid://17230178285",
        ID = "C2"
    },

    C3 = {
        Name = "Intermediate Case",
        Cost = 5000,
        Weights = {
            [1] = {"Fine", 35},
            [2] = {"Rare", 45},
            [3] = {"Exceptional", 20},
        },
        Image = "rbxassetid://17812620985",
        ID = "C3"
    }
}

return cases 
