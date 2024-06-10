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

local ScrapSound = Instance.new("Sound")
ScrapSound.Name = "ScrapSound"
ScrapSound.SoundId = "rbxassetid://9117624735"
ScrapSound.Volume = 0.25
ScrapSound.Parent = Sounds

local ErrorSound = Instance.new("Sound")
ErrorSound.Name = "ErrorSound"
ErrorSound.SoundId = "rbxassetid://5148302439"
ErrorSound.Volume = 0.25
ErrorSound.Parent = Sounds

local RewardSound = Instance.new("Sound")
RewardSound.Name = "RewardSound"
RewardSound.SoundId = "rbxassetid://7933571710"
RewardSound.Volume = 0.25
RewardSound.Parent = Sounds

local SpinSound = Instance.new("Sound")
SpinSound.Name = "SpinSound"
SpinSound.SoundId = "rbxassetid://7818374501"
SpinSound.Volume = 0.25
SpinSound.Parent = Sounds