local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

---- Services ----

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

---- Networking ----

local Networking = ReplicatedStorage.Networking
local UpdateCameraRemote = Networking.UpdateCamera

---- Camera ----

local function onUpdate()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        camera.CFrame = CFrame.new(player.Character.HumanoidRootPart.Position) * CFrame.new(-2.5,2.5,30)
    end
end

local function resetCamera()
    camera.CameraSubject = player.Character.Humanoid
    camera.CameraType = Enum.CameraType.Custom
    camera.FieldOfView = 70 

    RunService:UnbindFromRenderStep("Camera")
end

local function updateCamera()
    UpdateCameraRemote.OnClientEvent:Connect(function(method)

        if method == "Lock" then
		    camera.CameraSubject = player.Character.HumanoidRootPart
            camera.CameraType = Enum.CameraType.Attach
            camera.FieldOfView = 30

            RunService:BindToRenderStep("Camera", Enum.RenderPriority.Camera.Value, onUpdate)
            onUpdate()
        elseif method == "Reset" then
            resetCamera()
        end
    end)
end

updateCamera()

