---- Services ----

local Player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TixUIAnim = require(Modules.TixUIAnim)

---- Networking ----

local Networking = ReplicatedStorage.Networking
local ClickTixRemote = Networking.ClickTix

---- Sound ----

local Sounds = Player:WaitForChild("Sounds")
local ClickSound = Sounds:WaitForChild("ClickSound")
local PopSound = Sounds:WaitForChild("PopSound")

---- Click Tix ----

UserInputService.InputBegan:Connect(function(input,_gameProcessed)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        if _gameProcessed == false then
            local response = ClickTixRemote:InvokeServer()
            if response then
                coroutine.wrap(function()
                    SoundService:PlayLocalSound(ClickSound)
                    TixUIAnim:Animate(Player, "TixDetail", response)
                    SoundService:PlayLocalSound(PopSound)
                end)()
            end
        end
    end
end)


