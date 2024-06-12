local DynamicAccessories = {}

local accessories = {
    A1 = {
        Name = "Roblox Baseball Cap",
        Type = "Accessory",
        AssetID = 607702162,
        Reward = {AddPerClick = 0.5, AddStorage = 0.5},
        Value = 3,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A1"
    },
    A2 = {
        Name = "ROBLOX 'R' Baseball Cap",
        Type = "Accessory",
        AssetID = 417457461,
        Reward = {AddPerClick = 0.25, AddStorage = 0.75},
        Value = 3,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A2"
    },
    A3 = {
        Name = "Roblox Logo Visor",
        Type = "Accessory",
        AssetID = 607700713,
        Reward = {AddPerClick = 0.75},
        Value = 3,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A3"
    },
    A4 = {
        Name = "Adorable Puppy",
        Type = "Face",
        AssetID = 11389372,
        Reward = {AddPerClick = 0.5, AddStorage = 0.5},
        Value = 11,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A4"
    },
    A5 = {
        Name = "Lazy Eye",
        Type = "Face",
        AssetID = 7075502,
        Reward = {AddPerClick = 1.0},
        Value = 13,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A5"
    },
    A6 = {
        Name = "Cute Kitty",
        Type = "Face",
        AssetID = 11389441,
        Reward = {AddPerClick = 0.5, AddStorage = 0.5},
        Value = 15,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A6"
    },
    A10 = {
        Name = "Good Intentioned",
        Type = "Face",
        AssetID = 7317793,
        Reward = {AddPerClick = 1},
        Value = 20,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A10"
    },
    A11 = {
        Name = "Beautiful Hair for Beautiful People",
        Type = "Accessory",
        AssetID = 16630147,
        Reward = {AddPerClick = 1},
        Value = 60,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A11"
    },
    A12 = {
        Name = "John's Glasses",
        Type = "Accessory",
        AssetID = 12520031,
        Reward = {AddPerClick = 1},
        Value = 300,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A12"
    },
    A13 = {
        Name = "Brown Hair",
        Type = "Accessory",
        AssetID = 62234425,
        Reward = {AddPerClick = 1},
        Value = 1,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A13"
    },
    A14 = {
        Name = "Belle Of Belfast Long Red Hair",
        Type = "Accessory",
        AssetID = 2956239660,
        Reward = {AddPerClick = 1},
        Value = 1,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A14"
    },
    A15 = {
        Name = "Italian Ski Cap",
        Type = "Accessory",
        AssetID = 1038669,
        Reward = {AddStorage = 1},
        Value = 1900,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A15"
    },
    A16 = {
        Name = "Orange Shades",
        Type = "Accessory",
        AssetID = 376527500,
        Reward = {AddPerClick = 0.5, AddStorage = 0.5},
        Value = 5,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A16"
    },
    A17 = {
        Name = "Down to Earth Hair",
        Type = "Accessory",
        AssetID = 1772336109,
        Reward = {AddPerClick = 1.0},
        Value = 7,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A17"
    },
    A18 = {
        Name = "Knights of Redcliff: Paladin",
        Type = "Face",
        AssetID = 2493587489,
        Reward = {AddPerClick = 0.75, AddStorage = 0.25},
        Value = 9,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A18"
    },
    A19 = {
        Name = "Silly Fun",
        Type = "Face",
        AssetID = 7699174,
        Reward = {AddPerClick = 0.5, AddStorage = 0.5},
        Value = 10,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A19"
    },
    A20 = {
        Name = "Silver Ninja Star of the Brilliant Light",
        Type = "Accessory",
        AssetID = 11377306,
        Reward = {AddPerClick = 0.25, AddStorage = 0.75},
        Value = 25,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A20"
    },
    A21 = {
        Name = "Empyrean Reignment",
        Type = "Accessory",
        AssetID = 15967743,
        Reward = {AddPerClick = 0.75, AddStorage = 0.25},
        Value = 2000,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A21"
    },
    A22 = {
        Name = "Crimson Winter Scarf",
        Type = "Accessory",
        AssetID = 99860652,
        Reward = {AddPerClick = 0.5, AddStorage = 0.5},
        Value = 35,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A22"
    },
    A23 = {
        Name = "Ostrichsized Winter Scarf",
        Type = "99266546",
        AssetID = 99266546,
        Reward = {AddPerClick = 1.0},
        Value = 35,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A23"
    },
    A24 = {
        Name = "Rainbow Necktie",
        Type = "Accessory",
        AssetID = 151787596,
        Reward = {AddStorage = 1},
        Value = 40,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A24"
    },
    A25 = {
        Name = "Wild Neon Blue Scarf",
        Type = "Accessory",
        AssetID = 261830247,
        Reward = {AddPerClick = 0.5, AddStorage = 0.5},
        Value = 40,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A25"
    },
    A26 = {
        Name = "Mr. Chuckles",
        Type = "Face",
        AssetID = 10907541,
        Reward = {AddPerClick = 1.0},
        Value = 33,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A26"
    },
    A27 = {
        Name = "Wink-Blink",
        Type = "Face",
        AssetID = 22828351,
        Reward = {AddPerClick = 0.25, AddStorage = 0.75},
        Value = 37,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A27"
    },
    A28 = {
        Name = "Awkward....",
        Type = "Face",
        AssetID = 23932048,
        Reward = {AddStorage = 1.0},
        Value = 48,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A28"
    },
    A29 = {
        Name = "$.$",
        Type = "Face",
        AssetID = 10831558,
        Reward = {AddPerClick = 0.75, AddStorage = 0.25},
        Value = 36,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A29"
    },
    A30 = {
        Name = "Smug",
        Type = "Face",
        AssetID = 406001308,
        Reward = {AddPerClick = 1.0},
        Value = 47,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A30"
    },
    A31 = {
        Name = "Father's Tie",
        Type = "Accessory",
        AssetID = 161246700,
        Reward = {AddPerClick = 0.5, AddStorage = 0.5},
        Value = 50,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A31"
    },
    A32 = {
        Name = "Ninja Mask of Shadows",
        Type = "Accessory",
        AssetID = 1309911,
        Reward = {AddPerClick = 1.0},
        Value = 57,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A32"
    },
    A33 = {
        Name = "Holiday Crown",
        Type = "Accessory",
        AssetID = 139152472,
        Reward = {AddStorage = 1.0},
        Value = 55,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A33"
    },
    A34 = {
        Name = "Paper Hat",
        Type = "Accessory",
        AssetID = 10476359,
        Reward = {AddPerClick = 0.5, AddStorage = 0.5},
        Value = 61,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A34"
    },
    A35 = {
        Name = "Kitty Ears",
        Type = "Accessory",
        AssetID = 1374269,
        Reward = {AddPerClick = 0.25, AddStorage = 0.75},
        Value = 67,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A35"
    },
    A36 = {
        Name = "Bear Face Mask",
        Type = "Accessory",
        AssetID = 1192464705,
        Reward = {AddPerClick = 0.75, AddStorage = 0.25},
        Value = 75,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A36"
    },
    A37 = {
        Name = "Bandit",
        Type = "Accessory",
        AssetID = 20642008,
        Reward = {AddPerClick = 0.5, AddStorage = 0.5},
        Value = 81,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A37"
    },
    A38 = {
        Name = "Nerd Glasses",
        Type = "Accessory",
        AssetID = 11884330,
        Reward = {AddPerClick = 0.5, AddStorage = 0.5},
        Value = 90,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A38"
    },
    A39 = {
        Name = "Beautiful Hair for Beautiful People",
        Type = "Accessory",
        AssetID = 16630147,
        Reward = {AddPerClick = 1.0},
        Value = 200,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A39"
    },
    A40 = {
        Name = "Cinnamon Hair",
        Type = "Accessory",
        AssetID = 13745548,
        Reward = {AddStorage = 1.0},
        Value = 180,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A40"
    },
    A41 = {
        Name = "Black and Red",
        Type = "Accessory",
        AssetID = 14815761,
        Reward = {AddPerClick = 0.25, AddStorage = 0.75},
        Value = 160,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A41"
    },
    A42 = {
        Name = "Beautiful Brown Hair for Beautiful People",
        Type = "Accessory",
        AssetID = 17877340,
        Reward = {AddPerClick = 0.5, AddStorage = 0.5},
        Value = 150,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A42"
    },
    A43 = {
        Name = "Uh Oh",
        Type = "Face",
        AssetID = 7074944,
        Reward = {AddPerClick = 1.0},
        Value = 130,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A43"
    },
    A44 = {
        Name = "Tired Face",
        Type = "Face",
        AssetID = 141728790,
        Reward = {AddStorage = 1.0},
        Value = 120,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A44"
    },
    A45 = {
        Name = "Sick Day",
        Type = "Face",
        AssetID = 26619096,
        Reward = {AddPerClick = 0.5, AddStorage = 0.5},
        Value = 250,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A45"
    },
    A46 = {
        Name = "Just Trouble",
        Type = "Face",
        AssetID = 244160766,
        Reward = {AddPerClick = 0.25, AddStorage = 0.75},
        Value = 110,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A46"
    },
    A47 = {
        Name = "Tango",
        Type = "Face",
        AssetID = 16101765,
        Reward = {AddPerClick = 0.75, AddStorage = 0.25},
        Value = 220,
        Rarity = nil,
        Cases = {"C1", "C2"},
        ID = "A47"
    },
    A48 = {
        Name = "Beautiful Green Hair for Beautiful People",
        Type = "Accessory",
        AssetID = 226186871,
        Reward = {AddPerClick = 0.5, AddStorage = 0.5},
        Value = 270,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A48"
    },
    A49 = {
        Name = "Burning Hair for Fiery People",
        Type = "Accessory",
        AssetID = 2566043868,
        Reward = {AddPerClick = 0.5, AddStorage = 0.5},
        Value = 900,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A49"
    },
    A50 = {
        Name = "Ninja with the Cool Blonde Hair",
        Type = "Accessory",
        AssetID = 435111975,
        Reward = {AddPerClick = 0.25, AddStorage = 0.75},
        Value = 500,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A50"
    },
    A51 = {
        Name = "Monster Smile",
        Type = "Face",
        AssetID = 398675917,
        Reward = {AddPerClick = 0.75, AddStorage = 0.25},
        Value = 725,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A51"
    },
    A52 = {
        Name = "Anguished",
        Type = "Face",
        AssetID = 8560975,
        Reward = {AddPerClick = 0.5, AddStorage = 0.5},
        Value = 800,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A52"
    },
    A53 = {
        Name = "Doge",
        Type = "Accessory",
        AssetID = 151784320,
        Reward = {AddPerClick = 1.0},
        Value = 850,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A53"
    },
    A54 = {
        Name = "Wolf Tail",
        Type = "Accessory",
        AssetID = 791329052,
        Reward = {AddStorage = 1},
        Value = 325,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A54"
    },
    A55 = {
        Name = "Midnight Shades",
        Type = "Accessory",
        AssetID = 30331986,
        Reward = {AddStorage = 1},
        Value = 400,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A55"
    },
    A56 = {
        Name = "Skull",
        Type = "Accessory",
        AssetID = 36883367,
        Reward = {AddPerClick = 1},
        Value = 450,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A56"
    },
    A57 = {
        Name = "Man Bun Hair",
        Type = "Accessory",
        AssetID = 343584973,
        Reward = {AddPerClick = 0.5, AddStorage= 0.5},
        Value = 550,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A57"
    },
    A58 = {
        Name = "Beautiful Hair for Purple People",
        Type = "Accessory",
        AssetID = 17424092,
        Reward = {AddPerClick = 1.0},
        Value = 910,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A58"
    },
    A59 = {
        Name = "Red Whoosh with Headphones",
        Type = "Accessory",
        AssetID = 161246757,
        Reward = {AddPerClick = 0.5, AddStorage = 0.5},
        Value = 970,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A59"
    },
    A60 = {
        Name = "Green Whoosh and Headphones",
        Type = "Accessory",
        AssetID = 187845417,
        Reward = {AddPerClick = 0.75, AddStorage= 0.25},
        Value = 1050,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A60"
    },
    A61 = {
        Name = "Modern Pompadour",
        Type = "Accessory",
        AssetID = 161246595,
        Reward = {AddPerClick = .25, AddStorage= .75},
        Value = 1200,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A61"
    },
    A62 = {
        Name = "Serious Scar Face",
        Type = "Face",
        AssetID = 255827175,
        Reward = {AddPerClick = .5, AddStorage= .5},
        Value = 1350,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A62"
    },
    A63 = {
        Name = "Hmmm...",
        Type = "Face",
        AssetID = 7076076,
        Reward = {AddStorage= 1.0},
        Value = 1500,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A63"
    },
    A64 = {
        Name = "Tiger Chase Fear Face",
        Type = "Face",
        AssetID = 258198928,
        Reward = {AddPerClick = 1.0},
        Value = 1700,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A64"
    },
    A65 = {
        Name = "Woebegone",
        Type = "Face",
        AssetID = 21755022,
        Reward = {AddPerClick = .5, AddStorage= .5},
        Value = 1800,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A65"
    },
    A66 = {
        Name = "Bluesteel Warhelm of Rekt",
        Type = "Accessory",
        AssetID = 147144545,
        Reward = {AddPerClick = .25, AddStorage= .75},
        Value = 2150,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A66"
    },
    A67 = {
        Name = "Silver Aviators",
        Type = "Accessory",
        AssetID = 134823161,
        Reward = {AddPerClick = 0.25, AddStorage= .75},
        Value = 2400,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A67"
    },
    A68 = {
        Name = "Sonic Shades",
        Type = "Accessory",
        AssetID = 1743984961,
        Reward = {AddPerClick = 0.5, AddStorage= 0.5},
        Value = 2700,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A68"
    },
    A69 = {
        Name = "Steampunk Cyborg Face",
        Type = "Accessory",
        AssetID = 1380773045,
        Reward = {AddPerClick = 1.0},
        Value = 2900,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A69"
    },
    A70 = {
        Name = "Telamon's Other Chicken Suit",
        Type = "Accessory",
        AssetID = 121390996,
        Reward = {AddPerClick = .25, AddStorage= 0.75},
        Value = 2950,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A70"
    },
    A71 = {
        Name = "Telamon's Vampire Chicken Suit",
        Type = "Accessory",
        AssetID = 517267524,
        Reward = {AddPerClick = 0.75, AddStorage= 0.25},
        Value = 3000,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A71"
    },
    A72 = {
        Name = "Midnight Motor Magnifique",
        Type = "Accessory",
        AssetID = 456225312,
        Reward = {AddPerClick = 0.5, AddStorage= 0.5},
        Value = 3100,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A72"
    },
    A73 = {
        Name = "Adurite Hair for Beautiful People",
        Type = "Accessory",
        AssetID = 1191145114,
        Reward = {AddStorage= 1.0},
        Value = 3150,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A73"
    },
    A74 = {
        Name = "Flaming Mohawk",
        Type = "Accessory",
        AssetID = 191101707,
        Reward = {AddPerClick = .5, AddStorage= .5},
        Value = 2600,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A74"
    },
    A75 = {
        Name = "Don't Wake Me Up",
        Type = "Face",
        AssetID = 343619993,
        Reward = {AddPerClick = .25, AddStorage= .75},
        Value = 3250,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A75"
    },
    A76 = {
        Name = "Bored",
        Type = "Face",
        AssetID = 66330106,
        Reward = {AddPerClick = .75, AddStorage= .25},
        Value = 3400,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A76"
    },
    A77 = {
        Name = "Sadfaic",
        Type = "Face",
        AssetID = 117522793,
        Reward = {AddPerClick = 0.5, AddStorage= 0.5},
        Value = 1600,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A77"
    },
    A78 = {
        Name = "Dark Age Ninja Cape",
        Type = "Accessory",
        AssetID = 928853280,
        Reward = {AddPerClick = 1.0},
        Value = 3500,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A78"
    },
    A79 = {
        Name = "Sparkling Angel Wings",
        Type = "Accessory",
        AssetID = 192557913,
        Reward = {AddPerClick = 0.5, AddStorage= 0.5},
        Value = 5000,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A79"
    },
    A80 = {
        Name = "Sinister F",
        Type = "Accessory",
        AssetID = 4078588496,
        Reward = {AddPerClick = 0.25, AddStorage= 0.75},
        Value = 3600,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A80"
    },
    A81 = {
        Name = "Black 8-Bit Headphones",
        Type = "Accessory",
        AssetID = 1425126225,
        Reward = {AddPerClick = .75, AddStorage= 0.25},
        Value = 3800,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A81"
    },
    A82 = {
        Name = "Sad",
        Type = "Face",
        AssetID = 7699177,
        Reward = {AddPerClick = 0.5, AddStorage= 0.5},
        Value = 4000,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A82"
    },
    A83 = {
        Name = "Frightening Unibrow",
        Type = "Face",
        AssetID = 8560985,
        Reward = {AddStorage= 1.0},
        Value = 4250,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A83"
    },
    A84 = {
        Name = "Elvis Hair",
        Type = "Accessory",
        AssetID = 12314098,
        Reward = {AddPerClick = 0.25, AddStorage= 0.75},
        Value = 4700,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A84"
    },
    A85 = {
        Name = "Elton John - Classic Hair",
        Type = "Accessory",
        AssetID = 11452955059,
        Reward = {AddPerClick = .75, AddStorage= .25},
        Value = 5200,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A85"
    },
    A86 = {
        Name = "Classic Vampire",
        Type = "Face",
        AssetID = 7074836,
        Reward = {AddPerClick = .5, AddStorage= .5},
        Value = 5600,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A86"
    },
    A87 = {
        Name = "Sad Zombie",
        Type = "Face",
        AssetID = 7131361,
        Reward = {AddPerClick = .75, AddStorage= .25},
        Value = 6000,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A87"
    },
    A88 = {
        Name = "Black Wings",
        Type = "Accessory",
        AssetID = 215719598,
        Reward = {AddPerClick = .25, AddStorage= .75},
        Value = 6700,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A88"
    },
    A89 = {
        Name = "Crimson Wings",
        Type = "Accessory",
        AssetID = 409739014,
        Reward = {AddPerClick = 1.0},
        Value = 7100,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A89"
    },
    A90 = {
        Name = "Counterfeit Wizard’s Hat",
        Type = "Accessory",
        AssetID = 1743924583,
        Reward = {AddPerClick = .5, AddStorage= .5},
        Value = 7500,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A90"
    },
    A91 = {
        Name = "Shaggy",
        Type = "Accessory",
        AssetID = 20573078,
        Reward = {AddStorage= 1.0},
        Value = 8100,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A91"
    },
    A92 = {
        Name = "Bling Shades",
        Type = "Accessory",
        AssetID = 44114585,
        Reward = {AddPerClick = .5, AddStorage= .5},
        Value = 8500,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A92"
    },
    A93 = {
        Name = "Sleek Sunglasses",
        Type = "Accessory",
        AssetID = 51245241,
        Reward = {AddStorage= 1.0},
        Value = 9100,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A93"
    },
    A94 = {
        Name = "Blue Top Hat",
        Type = "Accessory",
        AssetID = 1016145591,
        Reward = {AddPerClick = 1.0},
        Value = 10000,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A94"
    },
    A95 = {
        Name = "Lucky Clover Necklace",
        Type = "Accessory",
        AssetID = 96680926,
        Reward = {AddPerClick = .5, AddStorage= .5},
        Value = 11000,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A95"
    },
    A96 = {
        Name = "Christmas Tie",
        Type = "Accessory",
        AssetID = 67318186,
        Reward = {AddPerClick = .75, AddStorage= .25},
        Value = 12000,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A96"
    },
    A97 = {
        Name = "Turkey Tie 2012",
        Type = "Accessory",
        AssetID = 98421766,
        Reward = {AddPerClick = .25, AddStorage= .75},
        Value = 11500,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A97"
    },
    A98 = {
        Name = "Gentleman Patriot",
        Type = "Accessory",
        AssetID = 29715001,
        Reward = {AddPerClick = 1.0},
        Value = 14000,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A98"
    },
    A99 = {
        Name = "Pirate Captain's Hat",
        Type = "Accessory",
        AssetID = 1028859,
        Reward = {AddStorage= 1.0},
        Value = 13500,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A99"
    },
    A100 = {
        Name = "Adurite Bucket",
        Type = "Accessory",
        AssetID = 928910453,
        Reward = {AddPerClick = .5, AddStorage= .5},
        Value = 13000,
        Rarity = nil,
        Cases = {"C1", "C2", "C3"},
        ID = "A100"
    }
}

local RarityRanges = {
    Basic = {Lower = 1, Upper = 10},
    Common = {Lower = 11, Upper = 50},
    Uncommon = {Lower = 51, Upper = 250},
    Fine = {Lower = 251, Upper = 900},
    Rare = {Lower = 901, Upper = 3500},
    Exceptional = {Lower = 3501, Upper = 14000},
    Epic = {Lower = 14001, Upper = 55000},
    Heroic = {Lower = 55001, Upper = 225000},
    Legendary = {Lower = 225001, Upper = 900000}
}

local RarityRewards = {
    Basic = {
        LowerAddPerClick = 1, UpperAddPerClick = 3,
        LowerAddStorage = 10, UpperAddStorage = 30
    },
    Common = {
        LowerAddPerClick = 3, UpperAddPerClick = 6,
        LowerAddStorage = 30, UpperAddStorage = 60
    },
    Uncommon = {
        LowerAddPerClick = 6, UpperAddPerClick = 12,
        LowerAddStorage = 60, UpperAddStorage = 120
    },
    Fine = {
        LowerAddPerClick = 12, UpperAddPerClick = 24,
        LowerAddStorage = 120, UpperAddStorage = 240
    },
    Rare = {
        LowerAddPerClick = 24, UpperAddPerClick = 48,
        LowerAddStorage = 240, UpperAddStorage = 480
    },
    Exceptional = {
        LowerAddPerClick = 48, UpperAddPerClick = 96,
        LowerAddStorage = 480, UpperAddStorage = 960
    },
    Epic = {
        LowerAddPerClick = 96, UpperAddPerClick = 192,
        LowerAddStorage = 960, UpperAddStorage = 1920
    },
    Heroic = {
        LowerAddPerClick = 192, UpperAddPerClick = 384,
        LowerAddStorage = 1920, UpperAddStorage = 3840
    },
    Legendary = {
        LowerAddPerClick = 384, UpperAddPerClick = 768,
        LowerAddStorage = 3840, UpperAddStorage = 7680
    },
}


function DynamicAccessories:CalculateDynamicRarity(ID)
    local accessory = accessories[ID]
    local value = accessory.Value

    local rarity = "Basic"

    for name, range in RarityRanges do
        if value >= range.Lower and value <= range.Upper then
            rarity = name
            break
        end
    end
    
    return rarity
end

function DynamicAccessories:CalculateDynamicRewards(ID)

    local accessory = accessories[ID]
    local value = accessory.Value
    local rarity = accessory.Rarity

    local minVal = RarityRanges[rarity].Lower
    local maxVal = RarityRanges[rarity].Upper

    local reward = accessory.Reward

    if RarityRewards[rarity] then
        local rewardRange = RarityRewards[rarity]
        if reward.AddPerClick then
            reward.AddPerClick = math.ceil(reward.AddPerClick * math.floor(rewardRange.LowerAddPerClick + (value - minVal) * ((rewardRange.UpperAddPerClick - rewardRange.LowerAddPerClick) / (maxVal - minVal))))
        end
        if reward.AddStorage then
            reward.AddStorage = math.ceil(reward.AddStorage * math.floor(rewardRange.LowerAddStorage + (value - minVal) * ((rewardRange.UpperAddStorage - rewardRange.LowerAddStorage) / (maxVal - minVal))))
        end
    end

    return reward
end

function DynamicAccessories:Init()
    print("INIT")
    for index, data in accessories do
        data.Rarity = DynamicAccessories:CalculateDynamicRarity(index)
        data.Reward = DynamicAccessories:CalculateDynamicRewards(index)
    end
end

DynamicAccessories:Init()

--[[
    RARITY:         VALUE                | ROBLOX RAP
    Basic :         0-10                 | FREE
    Common :        11-50                | 1-70
    Uncommon :      51-250               | 71-150
    Fine :          250-900              | 151-300
    Rare :          901-3,500            | 301-750
    Exceptional     3,501-14,000         | 751-2000
    Epic :          14,001-55,000        | 2001-6000
    Heroic :        55,001-225,000       | 6001-18,000
    Legendary :     225,001-900,000      | 18,001-55,000
 

]]

--[[
     A_ = {
        Name = "",
        Type = "Accessory/Face",
        AssetID = 0,
        Reward = {AddPerClick = 1, AddStorage = 1},
        Value = 0,
        Rarity = "Basic",
        Cases = {"C1", "C2"},
        ID = "_"
    }
]]

return accessories
