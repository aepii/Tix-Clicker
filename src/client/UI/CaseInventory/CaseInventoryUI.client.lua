---- Services ----

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TweenButton = require(Modules.TweenButton)
local ButtonStatus = require(Modules.ButtonStatus)
local Cases = require(ReplicatedStorage.Data.Cases)
local CollectibleCases = require(ReplicatedStorage.Data.CollectibleCases)

---- Data ----

local ReplicatedData = Player:WaitForChild("ReplicatedData")

---- UI ----

local PlayerGui = Player.PlayerGui
local UI = PlayerGui:WaitForChild("UI")

local CaseInventory = UI.CaseInventory
local InvFrame = CaseInventory.InvFrame
local CollectibleInvFrame = CaseInventory.CollectibleInvFrame
local InvHolder = InvFrame.Holder
local CollectibleInvHolder = CollectibleInvFrame.Holder
local OpenFrame = CaseInventory.OpenFrame
local CollectibleOpenFrame = CaseInventory.CollectibleOpenFrame

local IconCopy = InvHolder.IconCopy

local IconScript = script.Parent.Icon
IconScript.Parent = IconCopy
IconScript.Enabled = true

local CollectibleIconCopy = CollectibleInvHolder.IconCopy

local CollectibleIconScript = script.Parent.CollectibleIcon
CollectibleIconScript.Parent = CollectibleIconCopy
CollectibleIconScript.Enabled = true

---- UI Values ----

local CurrentCase = OpenFrame.CurrentCase
local CollectibleCurrentCase = CollectibleOpenFrame.CurrentCase
local UIVisible = UI.UIVisible
local CurrentUI = UI.CurrentUI
local Category = "Standard"

---- Sound ----

local Sounds = Player:WaitForChild("Sounds")
local ClickSound = Sounds:WaitForChild("ClickSound")

---- Networking ----

local Networking = ReplicatedStorage.Networking
local OpenCaseRemote = Networking.OpenCase
local OpenCollectibleCaseRemote = Networking.OpenCollectibleCase
local UpdateClientCaseInventoryRemote = Networking.UpdateClientCaseInventory
local UpdateClientCollectibleCaseInventoryRemote = Networking.UpdateClientCollectibleCaseInventory
local UpdateClientAccessoriesInventoryRemote = Networking.UpdateClientAccessoriesInventory
local UpdateClientCollectibleAccessoriesInventoryRemote = Networking.UpdateClientCollectibleAccessoriesInventory

---- Private Functions ----

local function openCase(caseID)
    OpenCaseRemote:InvokeServer(caseID)
end

local function openCollectibleCase(caseID)
    OpenCollectibleCaseRemote:InvokeServer(caseID)
end


local function updateInventory(case, method)
    if method == "INIT" then
        OpenFrame:TweenPosition(UDim2.new(.05,0,2,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        InvFrame:TweenSizeAndPosition(UDim2.new(0.95,0,0.8,0), UDim2.new(0.5,0,0.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
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
            OpenFrame:TweenPosition(UDim2.new(.05,0,2,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
            InvFrame:TweenSizeAndPosition(UDim2.new(0.95,0,0.8,0), UDim2.new(0.5,0,0.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        end
        if icon then
            icon:Destroy()
        end
    end
end

local function updateCollectibleInventory(case, method)
    if method == "INIT" then
        CollectibleOpenFrame:TweenPosition(UDim2.new(.05,0,2,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        CollectibleInvFrame:TweenSizeAndPosition(UDim2.new(0.95,0,0.8,0), UDim2.new(0.5,0,0.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        UIVisible.Value = false
        for index, icon in CollectibleInvHolder:GetChildren() do
            if icon:IsA("Frame") and icon ~= CollectibleIconCopy then
                icon:Destroy()
            end
        end
        initInventory()
    elseif method == "ADD" then
        local icon = CollectibleIconCopy:Clone()
        icon.Visible = true
        icon.Name = case.ID
        icon.IconImage.Image = case.Image
        icon.Parent = CollectibleInvHolder
    elseif method == "UPDATE" then
        if CollectibleCurrentCase.Value == case.ID then
            local ownedValue = Player.ReplicatedData.CollectibleCases:FindFirstChild(case.ID) and Player.ReplicatedData.CollectibleCases[case.ID].Value or 0
            CollectibleOpenFrame.OwnedFrame.Owned.Text = "Owned " .. ownedValue  
        end
     elseif method == "DEL" then
        local icon = CollectibleInvHolder:FindFirstChild(case.ID)
        if case.ID == CollectibleCurrentCase.Value then
            CollectibleOpenFrame:TweenPosition(UDim2.new(.05,0,2,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
            CollectibleInvFrame:TweenSizeAndPosition(UDim2.new(0.95,0,0.8,0), UDim2.new(0.5,0,0.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
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

function initCollectibleInventory()
    for _, case in ReplicatedData.CollectibleCases:GetChildren() do
        updateCollectibleInventory(CollectibleCases[case.Name], "ADD")
    end
end

initCollectibleInventory()

UpdateClientCaseInventoryRemote.OnClientEvent:Connect(function(case, method)
    updateInventory(case, method)
end)

UpdateClientCollectibleCaseInventoryRemote.OnClientEvent:Connect(function(case, method)
    updateCollectibleInventory(case, method)
end)

---- Buttons ----

local ExitButton = CaseInventory.ExitButton
local OpenButton = OpenFrame.OpenButton
local CollectibleOpenButton = CollectibleOpenFrame.OpenButton
local StandardButton = CaseInventory.StandardButton
local CollectibleButton = CaseInventory.CollectibleButton

local EXITBUTTON_ORIGINALSIZE = ExitButton.Size
local OPENBUTTON_ORIGINALSIZE = OpenButton.Size
local STANDARDBUTTON_ORIGINALSIZE = StandardButton.Size
local COLLECTIBLEBUTTON_ORIGINALSIZE = CollectibleButton.Size
local COLLECTIBLEOPENBUTTON_ORIGINALSIZE = CollectibleOpenButton.Size

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

local function standardHover()
    TweenButton:Grow(StandardButton, STANDARDBUTTON_ORIGINALSIZE)
end

local function standardLeave()
    TweenButton:Reset(StandardButton, STANDARDBUTTON_ORIGINALSIZE)
end

local function standardMouseDown()
    playClickSound()
    TweenButton:Shrink(StandardButton, STANDARDBUTTON_ORIGINALSIZE)

    if Category == "Collectible" then
        CollectibleInvFrame.Visible = false
        OpenFrame.Visible = true
        CollectibleOpenFrame.Visible = false
        InvFrame.Visible = true
        Category = "Standard"
    end
end

local function standardMouseUp()
    TweenButton:Reset(StandardButton, STANDARDBUTTON_ORIGINALSIZE)
end


local function collectibleHover()
    TweenButton:Grow(CollectibleButton, COLLECTIBLEBUTTON_ORIGINALSIZE)
end

local function collectibleLeave()
    TweenButton:Reset(CollectibleButton, COLLECTIBLEBUTTON_ORIGINALSIZE)
end

local function collectibleMouseDown()
    playClickSound()
    TweenButton:Shrink(CollectibleButton, COLLECTIBLEBUTTON_ORIGINALSIZE)

    if Category == "Standard" then
        CollectibleInvFrame.Visible = true
        OpenFrame.Visible = false
        CollectibleOpenFrame.Visible = true
        InvFrame.Visible = false
        Category = "Collectible"
    end
end

local function collectibleMouseUp()
    TweenButton:Reset(CollectibleButton, COLLECTIBLEBUTTON_ORIGINALSIZE)
end

local function collectibleOpenHover()
    TweenButton:Grow(CollectibleOpenButton, COLLECTIBLEOPENBUTTON_ORIGINALSIZE)
end

local function collectibleOpenLeave()
    TweenButton:Reset(CollectibleOpenButton, COLLECTIBLEOPENBUTTON_ORIGINALSIZE)
end

local function collectibleOpenMouseDown()
    playClickSound()
    TweenButton:Shrink(CollectibleOpenButton, COLLECTIBLEOPENBUTTON_ORIGINALSIZE)
    local currentIcon = CollectibleInvHolder:FindFirstChild(CollectibleCurrentCase.Value)
    if currentIcon then
        openCollectibleCase(CollectibleCurrentCase.Value)
        CollectibleCurrentCase.Value = currentIcon.Name
    end
end

UpdateClientCollectibleAccessoriesInventoryRemote.OnClientEvent:Connect(function(ID, GUID, method)
    ButtonStatus:CollectibleCaseInventory(Player, CollectibleCurrentCase.Value, CollectibleOpenButton)
end)

local function collectibleOpenMouseUp()
    TweenButton:Reset(CollectibleOpenButton, COLLECTIBLEOPENBUTTON_ORIGINALSIZE)
end

ExitButton.ClickDetector.MouseEnter:Connect(exitHover)
ExitButton.ClickDetector.MouseLeave:Connect(exitLeave)
ExitButton.ClickDetector.MouseButton1Down:Connect(exitMouseDown)
ExitButton.ClickDetector.MouseButton1Up:Connect(exitMouseUp)

OpenButton.ClickDetector.MouseEnter:Connect(openHover)
OpenButton.ClickDetector.MouseLeave:Connect(openLeave)
OpenButton.ClickDetector.MouseButton1Down:Connect(openMouseDown)
OpenButton.ClickDetector.MouseButton1Up:Connect(openMouseUp)

CollectibleOpenButton.ClickDetector.MouseEnter:Connect(collectibleOpenHover)
CollectibleOpenButton.ClickDetector.MouseLeave:Connect(collectibleOpenLeave)
CollectibleOpenButton.ClickDetector.MouseButton1Down:Connect(collectibleOpenMouseDown)
CollectibleOpenButton.ClickDetector.MouseButton1Up:Connect(collectibleOpenMouseUp)


StandardButton.ClickDetector.MouseEnter:Connect(standardHover)
StandardButton.ClickDetector.MouseLeave:Connect(standardLeave)
StandardButton.ClickDetector.MouseButton1Down:Connect(standardMouseDown)
StandardButton.ClickDetector.MouseButton1Up:Connect(standardMouseUp)

CollectibleButton.ClickDetector.MouseEnter:Connect(collectibleHover)
CollectibleButton.ClickDetector.MouseLeave:Connect(collectibleLeave)
CollectibleButton.ClickDetector.MouseButton1Down:Connect(collectibleMouseDown)
CollectibleButton.ClickDetector.MouseButton1Up:Connect(collectibleMouseUp)