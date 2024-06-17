---- Services ----

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TweenButton = require(Modules.TweenButton)
local ButtonStatus = require(Modules.ButtonStatus)
local Cases = require(ReplicatedStorage.Data.Cases)

---- Data ----

local ReplicatedData = Player:WaitForChild("ReplicatedData")

---- UI ----

local PlayerGui = Player.PlayerGui
local UI = PlayerGui:WaitForChild("UI")


local CaseInventory = UI.CaseInventory
local InvHolder = CaseInventory.InvFrame.Holder
local InvFrame = InvHolder.Parent
local OpenFrame = CaseInventory.OpenFrame
local IconCopy = InvHolder.IconCopy

local IconScript = script.Parent.Icon
IconScript.Parent = IconCopy
IconScript.Enabled = true

---- UI Values ----

local CurrentCase = OpenFrame.CurrentCase
local UIVisible = UI.UIVisible
local CurrentUI = UI.CurrentUI

---- Sound ----

local Sounds = Player:WaitForChild("Sounds")
local ClickSound = Sounds:WaitForChild("ClickSound")

---- Networking ----

local Networking = ReplicatedStorage.Networking
local OpenCaseRemote = Networking.OpenCase
local UpdateClientCaseInventoryRemote = Networking.UpdateClientCaseInventory
local UpdateClientAccessoriesInventoryRemote = Networking.UpdateClientAccessoriesInventory

---- Private Functions ----

local function openCase(caseID)
    OpenCaseRemote:InvokeServer(caseID)
end

local function updateInventory(case, method)
    if method == "INIT" then
        OpenFrame:TweenPosition(UDim2.new(0,0,2,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        InvFrame:TweenSizeAndPosition(UDim2.new(0.9,0,0.8,0), UDim2.new(0.5,0,0.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        UIVisible.Value = false
        for index, icon in InvHolder:GetChildren() do
            if icon:IsA("Frame") and icon ~= IconCopy then
                icon:Destroy()
            end
        end
        initInventory()
    elseif method == "ADD" then
        local icon = IconCopy:Clone()
        icon.Visible = true
        icon.Name = case.ID
        icon.IconImage.Image = case.Image
        icon.Parent = InvHolder
    elseif method == "UPDATE" then
        if CurrentCase.Value == case.ID then
            local ownedValue = Player.ReplicatedData.Cases:FindFirstChild(case.ID) and Player.ReplicatedData.Cases[case.ID].Value or 0
            OpenFrame.OwnedFrame.Owned.Text = "Owned " .. ownedValue  
        end
     elseif method == "DEL" then
        local icon = InvHolder:FindFirstChild(case.ID)
        if case.ID == CurrentCase.Value then
            OpenFrame:TweenPosition(UDim2.new(0,0,2,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
            InvFrame:TweenSizeAndPosition(UDim2.new(0.9,0,0.8,0), UDim2.new(0.5,0,0.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        end
        if icon then
            icon:Destroy()
        end
    end
end

function initInventory()
    for _, case in ReplicatedData.Cases:GetChildren() do
        updateInventory(Cases[case.Name], "ADD")
    end
end

initInventory()

UpdateClientCaseInventoryRemote.OnClientEvent:Connect(function(case, method)
    updateInventory(case, method)
end)

---- Buttons ----

local ExitButton = CaseInventory.ExitButton
local OpenButton = OpenFrame.OpenButton

local EXITBUTTON_ORIGINALSIZE = ExitButton.Size
local OPENBUTTON_ORIGINALSIZE = OpenButton.Size

local function playClickSound()
    SoundService:PlayLocalSound(ClickSound)
end

local function exitHover()
    TweenButton:Grow(ExitButton, EXITBUTTON_ORIGINALSIZE)
end

local function exitLeave()
    TweenButton:Reset(ExitButton, EXITBUTTON_ORIGINALSIZE)
end

local function exitMouseDown()
    playClickSound()
    TweenButton:Shrink(ExitButton, EXITBUTTON_ORIGINALSIZE)
    CaseInventory:TweenPosition(UDim2.new(0.5, 0, 2, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
    CurrentUI.Value = ""
    UIVisible.Value = false
end

local function exitMouseUp()
    TweenButton:Reset(ExitButton, EXITBUTTON_ORIGINALSIZE)
end

local function openHover()
    TweenButton:Grow(OpenButton, OPENBUTTON_ORIGINALSIZE)
end

local function openLeave()
    TweenButton:Reset(OpenButton, OPENBUTTON_ORIGINALSIZE)
end

local function openMouseDown()
    playClickSound()
    TweenButton:Shrink(OpenButton, OPENBUTTON_ORIGINALSIZE)
    local currentIcon = InvHolder:FindFirstChild(CurrentCase.Value)
    if currentIcon then
        openCase(CurrentCase.Value)
        CurrentCase.Value = currentIcon.Name
    end
end

UpdateClientAccessoriesInventoryRemote.OnClientEvent:Connect(function(ID, GUID, method)
    ButtonStatus:CaseInventory(Player, CurrentCase.Value, OpenButton)
end)

local function openMouseUp()
    TweenButton:Reset(OpenButton, OPENBUTTON_ORIGINALSIZE)
end

ExitButton.ClickDetector.MouseEnter:Connect(exitHover)
ExitButton.ClickDetector.MouseLeave:Connect(exitLeave)
ExitButton.ClickDetector.MouseButton1Down:Connect(exitMouseDown)
ExitButton.ClickDetector.MouseButton1Up:Connect(exitMouseUp)

OpenButton.ClickDetector.MouseEnter:Connect(openHover)
OpenButton.ClickDetector.MouseLeave:Connect(openLeave)
OpenButton.ClickDetector.MouseButton1Down:Connect(openMouseDown)
OpenButton.ClickDetector.MouseButton1Up:Connect(openMouseUp)