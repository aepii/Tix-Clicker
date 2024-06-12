---- Services ----

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")

---- Sound ----

local Sounds = Player:WaitForChild("Sounds")
local PowerUpSound = Sounds:WaitForChild("PowerUpSound")

---- Networking ----

local Networking = ReplicatedStorage.Networking
local AnimateRageRemote = Networking.AnimateRage

---- UI ----

local PlayerGui = Player.PlayerGui
local UI = PlayerGui:WaitForChild("UI")

local BottomBar = UI.BottomBar
local UIPosition = BottomBar.Position

---- Private Functions ----

function rageAnim()
	local BobbleX = (math.cos(os.clock() * 20) * 0.01) -- Increase 20 for an intense shake. Increase decimal number for how far it goes.
	local BobbleY = math.abs(math.sin(os.clock() * 30) * 0.01) -- Increase 30 for an intense shake. Increase decimal number for how it goes.
	BottomBar.Position = UIPosition + UDim2.new(BobbleX,0,BobbleY,0) -- Adding pos to the elements, so we can keep the UDIM2 relative to its original position.
end

AnimateRageRemote.OnClientEvent:Connect(function()
    coroutine.wrap(function()
        SoundService:PlayLocalSound(PowerUpSound)
        while Player.TemporaryData.RageMode.Value == true do
            rageAnim()
            task.wait()
        end
        BottomBar.Position = UIPosition
    end)()
end)
