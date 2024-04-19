game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
game.Players.LocalPlayer.PlayerGui:WaitForChild("UI").MainTheme:Play()

local Sounds = Instance.new("Folder")
Sounds.Name = "Sounds"
Sounds.Parent = game.Players.LocalPlayer

local ClickSound = Instance.new("Sound")
ClickSound.Name = "ClickSound"
ClickSound.SoundId = "rbxassetid://177266782"
ClickSound.Parent = Sounds