---- Services ----

local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

---- Networking ----

local Networking = ReplicatedStorage.Networking
local ClickTixRemote = Networking.ClickTix

---- Sound ----

local ClickSound = Instance.new("Sound")
ClickSound.SoundId = "rbxassetid://177266782"
ClickSound.Parent = game.Players.LocalPlayer

----  Click Tix ----

UserInputService.InputBegan:Connect(function(input,_gameProcessed)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        if _gameProcessed == false then
            local response = ClickTixRemote:InvokeServer()
            if response then
                SoundService:PlayLocalSound(ClickSound)
            end
        end
    end
end)


