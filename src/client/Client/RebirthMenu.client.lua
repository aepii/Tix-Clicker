---- Services ----

local Players = game:GetService("Players")
local LocalPlayer = game.Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService") 

---- Show Menu ----

local active = false

local function toggleMenu(show)
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local UI = playerGui.UI
    local rebirthMenu = UI.RebirthMenu

    if show and not active then
        active = true
        rebirthMenu:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
    elseif not show and active then
        rebirthMenu:TweenPosition(UDim2.new(0.5, 0, 2, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        task.wait(0.1)  
        active = false
    end
end

---- Setup ----

local RebirthStation = Workspace.Rebirth.RebirthStation
local Hitbox = RebirthStation:WaitForChild("TouchPart").Hitbox

local function checkDistance()
    local character = LocalPlayer.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    local connection

    if humanoidRootPart then
        connection = RunService.Heartbeat:Connect(function()
            if character and character.Parent then
                local distance = (humanoidRootPart.Position - RebirthStation.TouchPart.Position).magnitude
                if distance <= 9 then
                    toggleMenu(true)
                else
                    toggleMenu(false)
                    if connection then
                        connection:Disconnect()
                    end
                end
            else
                if connection then
                    connection:Disconnect()
                end
            end
        end)
    end
end

Hitbox.Touched:Connect(function(hit)
    if hit.Parent == LocalPlayer.Character then
        checkDistance()
    end
end)