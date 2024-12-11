local CartoonCircleUI = {}

function CartoonCircleUI:Init()

    ---- Services ----

    local Player = game.Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    ---- UI ----

    local PlayerGui = Player:WaitForChild("PlayerGui")
    local UI = PlayerGui:WaitForChild("UI")
    local CartoonCircle = PlayerGui:WaitForChild("CartoonCircle")
    local Circle = CartoonCircle.Circle
    local Black = CartoonCircle.Black

    ---- Networking ----

    local Networking = ReplicatedStorage.Networking
    local AnimateCircleRemote = Networking.AnimateCircle
    local BindableAnimateCircleRemote = Networking.BindableAnimateCircle

    ---- Function ----

    local debounce = false

    local function animateCircle() 
        UI.Enabled = false
        Circle:TweenSize(UDim2.new(0.01,0,0.01,0), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, 0.5, true)
        task.wait(0.5)
        Black.Visible = true
        task.wait(0.5)
        Black.Visible = false
        Circle:TweenSize(UDim2.new(10,0,10,0), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, 1, true)
        if Player.TemporaryData.ActiveCaseOpening.Value == false then
            UI.Enabled = true
        end
    end

    BindableAnimateCircleRemote.Event:Connect(function()
        if debounce == false then
            debounce = true
            animateCircle()
            debounce = false
        end
    end)

    AnimateCircleRemote.OnClientEvent:Connect(function()
        if debounce == false then
            debounce = true
            animateCircle()
            debounce = false
        end
    end)
end

return CartoonCircleUI