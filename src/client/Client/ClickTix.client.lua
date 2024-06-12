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
local CritSound = Sounds:WaitForChild("CritSound")

---- Click Tix ----

UserInputService.InputBegan:Connect(function(input,_gameProcessed)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        if _gameProcessed == false then
            local value, crit = ClickTixRemote:InvokeServer()
            print(value, crit)
            if value then
                if crit then
                    coroutine.wrap(function()
                        SoundService:PlayLocalSound(CritSound)
                        SoundService:PlayLocalSound(ClickSound)
                        TixUIAnim:Animate(Player, "TixCritDetail", value, nil)
                        SoundService:PlayLocalSound(PopSound)
                    end)()
                else
                    coroutine.wrap(function()
                        SoundService:PlayLocalSound(ClickSound)
                        TixUIAnim:Animate(Player, "TixDetail", value, nil)
                        SoundService:PlayLocalSound(PopSound)
                    end)()
                end
            end
        end
    end
end)


