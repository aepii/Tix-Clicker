local SoundLoader = {}

function SoundLoader:Init()
  game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
  game.Players.LocalPlayer.PlayerGui:WaitForChild("UI"):WaitForChild("MainTheme"):Play()

  local Sounds = Instance.new("Folder")
  Sounds.Name = "Sounds"
  Sounds.Parent = game.Players.LocalPlayer

  local SoundGroup = Instance.new("SoundGroup")
  SoundGroup.Name = "OtherSFX"
  SoundGroup.Volume = 1
  SoundGroup.Parent = Sounds

  local ClickSound = Instance.new("Sound")
  ClickSound.Name = "ClickSound"
  ClickSound.SoundId = "rbxassetid://177266782"
  ClickSound.Parent = Sounds

  local PopSound = Instance.new("Sound")
  PopSound.Name = "PopSound"
  PopSound.SoundId = "rbxassetid://9113856564"
  PopSound.SoundGroup = SoundGroup
  PopSound.Parent = Sounds

  local MoneySound = Instance.new("Sound")
  MoneySound.Name = "MoneySound"
  MoneySound.SoundId = "rbxassetid://131886985"
  MoneySound.Parent = Sounds

  local ScrapSound = Instance.new("Sound")
  ScrapSound.Name = "ScrapSound"
  ScrapSound.SoundId = "rbxassetid://9117624735"
  ScrapSound.SoundGroup = SoundGroup
  ScrapSound.Parent = Sounds

  local ErrorSound = Instance.new("Sound")
  ErrorSound.Name = "ErrorSound"
  ErrorSound.SoundId = "rbxassetid://5148302439"
  ErrorSound.SoundGroup = SoundGroup
  ErrorSound.Parent = Sounds

  local RewardSound = Instance.new("Sound")
  RewardSound.Name = "RewardSound"
  RewardSound.SoundId = "rbxassetid://7933571710"
  RewardSound.SoundGroup = SoundGroup
  RewardSound.Parent = Sounds

  local RareRewardSound = Instance.new("Sound")
  RareRewardSound.Name = "RareRewardSound"
  RareRewardSound.SoundId = "rbxassetid://4612378086"
  RareRewardSound.SoundGroup = SoundGroup
  RareRewardSound.Parent = Sounds

  local CritSound = Instance.new("Sound")
  CritSound.Name = "CritSound"
  CritSound.SoundId = "rbxassetid://3125624765"
  CritSound.SoundGroup = SoundGroup
  CritSound.Parent = Sounds

  local PowerUpSound = Instance.new("Sound")
  PowerUpSound.Name = "PowerUpSound"
  PowerUpSound.SoundId = "rbxassetid://9058751039"
  PowerUpSound.SoundGroup = SoundGroup
  PowerUpSound.Parent = Sounds

  local RebirthSound = Instance.new("Sound")
  RebirthSound.Name = "RebirthSound"
  RebirthSound.SoundId = "rbxassetid://9125806414"
  RebirthSound.SoundGroup = SoundGroup
  RebirthSound.Parent = Sounds

  local ZipSound = Instance.new("Sound")
  ZipSound.Name = "ZipSound"
  ZipSound.SoundId = "rbxassetid://3479742892"
  ZipSound.SoundGroup = SoundGroup
  ZipSound.Parent = Sounds

end

return SoundLoader