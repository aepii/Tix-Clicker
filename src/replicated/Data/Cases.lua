local cases = {
    C1 = {
        Name = "Noob Case",
        Cost = 10,
        Weights = {
            [1] = {"Basic", 64},
            [2] = {"Common", 30},
            [3] = {"Uncommon", 5.5},
            [4] = {"Fine", 0.5}
        },
        Image = "rbxassetid://17227170475",
        ID = "C1"
    },

    C2 = {
        Name = "Apprentice Case",
        Cost = 100,
        Weights = {
            [1] = {"Basic", 25},
            [2] = {"Common", 42},
            [3] = {"Uncommon", 25},
            [4] = {"Fine", 7.9},
            [5] = {"Rare", 0.1}
        },
        Image = "rbxassetid://17230178285",
        ID = "C2"
    }
}

return cases 
