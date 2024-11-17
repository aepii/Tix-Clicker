---- Services ----

local Player = game.Players.LocalPlayer
local SoundService = game:GetService("SoundService")

---- UI ----

local PlayerGui = Player.PlayerGui
local LoadingUI = PlayerGui:WaitForChild("Loading")
local Logo = LoadingUI.Logo

---- Sound ----

local Sounds = Player:WaitForChild("Sounds")
local ClickSound = Sounds:WaitForChild("ClickSound")
local PopSound = Sounds:WaitForChild("PopSound")
local RewardSound = Sounds:WaitForChild("RewardSound")

---- Private Functions ----

local function animate()
    local size = 1
    local animTime = 0.125
    local decrement = 0.01
    local timeDecrement = 0.0025  -- Amount to decrease the animation time each loop
    local decrementGrowth = 0.001  -- Amount to increase the decrement each loop

    while size >= 0 do
        SoundService:PlayLocalSound(ClickSound)
        Logo:TweenSize(UDim2.new(size - decrement, 0, size - decrement, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Elastic, animTime, true)
        task.wait(animTime)
        Logo:TweenSize(UDim2.new(size, 0, size, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Elastic, animTime, true)
        SoundService:PlayLocalSound(PopSound)
        task.wait(animTime)
        
        size = size - decrement
        animTime = animTime - timeDecrement
        decrement = decrement + decrementGrowth
        
        if animTime <= 0 then
            animTime = 0.01 -- Prevent animTime from becoming zero or negative
        end
    end

    Logo:Destroy()
    SoundService:PlayLocalSound(RewardSound)
end
