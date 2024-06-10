---- Services ----

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TweenButton = require(Modules.TweenButton)
local Cases = require(ReplicatedStorage.Data.Cases)

---- Data ----

local ReplicatedData = Player:WaitForChild("ReplicatedData")

---- UI ----

local PlayerGui = Player.PlayerGui
local UI = PlayerGui:WaitForChild("UI")

local CaseInventory = UI.CaseInventory
local InvHolder = CaseInventory.InvFrame.Holder
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

---- Private Functions ----

local function openCase(caseID)
    OpenCaseRemote:InvokeServer(caseID)
end

local function updateInventory(case, method)
    if method == "INIT" then
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

local function equipHover()
    TweenButton:Grow(OpenButton, OPENBUTTON_ORIGINALSIZE)
end

local function equipLeave()
    TweenButton:Reset(OpenButton, OPENBUTTON_ORIGINALSIZE)
end

local function equipMouseDown()
    playClickSound()
    TweenButton:Shrink(OpenButton, OPENBUTTON_ORIGINALSIZE)
    openCase(CurrentCase.Value)
end

local function equipMouseUp()
    TweenButton:Reset(OpenButton, OPENBUTTON_ORIGINALSIZE)
end

ExitButton.ClickDetector.MouseEnter:Connect(exitHover)
ExitButton.ClickDetector.MouseLeave:Connect(exitLeave)
ExitButton.ClickDetector.MouseButton1Down:Connect(exitMouseDown)
ExitButton.ClickDetector.MouseButton1Up:Connect(exitMouseUp)

OpenButton.ClickDetector.MouseEnter:Connect(equipHover)
OpenButton.ClickDetector.MouseLeave:Connect(equipLeave)
OpenButton.ClickDetector.MouseButton1Down:Connect(equipMouseDown)
OpenButton.ClickDetector.MouseButton1Up:Connect(equipMouseUp)