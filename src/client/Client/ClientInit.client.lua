game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
game.Players.LocalPlayer.PlayerGui:WaitForChild("UI"):WaitForChild("MainTheme"):Play()

local Sounds = Instance.new("Folder")
Sounds.Name = "Sounds"
Sounds.Parent = game.Players.LocalPlayer

local ClickSound = Instance.new("Sound")
ClickSound.Name = "ClickSound"
ClickSound.SoundId = "rbxassetid://177266782"
ClickSound.Parent = Sounds

local PopSound = Instance.new("Sound")
PopSound.Name = "PopSound"
PopSound.SoundId = "rbxassetid://9113856564"
PopSound.Parent = Sounds

local MoneySound = Instance.new("Sound")
MoneySound.Name = "MoneySound"
MoneySound.SoundId = "rbxassetid://131886985"
MoneySound.Volume = 0.25
MoneySound.Parent = Sounds