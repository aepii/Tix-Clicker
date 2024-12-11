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
local ReplicatedAccessories = ReplicatedData:WaitForChild("Accessories")
local ReplicatedCases = ReplicatedData:WaitForChild("Cases")
local TemporaryData = Player:WaitForChild("TemporaryData")
local ActiveCaseOpening = TemporaryData:WaitForChild("ActiveCaseOpening")
local AccessoriesLimit = TemporaryData:WaitForChild("AccessoriesLimit")

---- UI ----

local PlayerGui = Player.PlayerGui
local UI = PlayerGui:WaitForChild("UI")

local CaseOpenUI = PlayerGui:WaitForChild("CaseOpenUI")

local CaseInventory = UI.CaseInventory
local InvFrame = CaseInventory.InvFrame
local InvHolder = InvFrame.Holder
local OpenFrame = CaseInventory.OpenFrame
local CustomOpenFrame = CaseInventory.CustomOpenFrame

local IconCopy = InvHolder.IconCopy

local IconScript = script.Parent.Icon
IconScript.Parent = IconCopy
IconScript.Enabled = true

local CustomIconCopy = InvHolder.CustomIconCopy

local CustomIconScript = script.Parent.CustomIcon
CustomIconScript.Parent = CustomIconCopy
CustomIconScript.Enabled = true

local AutoOpenButton = CaseInventory.AutoOpenButton
local CancelAutoOpenButton = CaseOpenUI.CancelAutoOpenButton

---- UI Values ----

local CurrentCase = CaseInventory.CurrentCase
local AutoOpen = CaseInventory.AutoOpen
local UIVisible = UI.UIVisible
local CurrentUI = UI.CurrentUI

local Amount = CaseInventory.Amount

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
    local caseData = ReplicatedCases:FindFirstChild(caseID)
    local availableCases = caseData and caseData.Value or 0
    local amount = math.min(availableCases, Amount.Value, AccessoriesLimit.Value - #ReplicatedAccessories:GetChildren())

    if AutoOpen.Value == false then
        OpenCaseRemote:InvokeServer(caseID, amount)
    else
        while AutoOpen.Value == true and #ReplicatedAccessories:GetChildren() + amount <= AccessoriesLimit.Value do
            task.wait()
            if ActiveCaseOpening.Value == false then
                OpenCaseRemote:InvokeServer(caseID, amount)
            end
            amount = math.min(availableCases, Amount.Value, AccessoriesLimit.Value - #ReplicatedAccessories:GetChildren())
        end
        AutoOpenButton.AutoText.Text = "Auto Open"
        CancelAutoOpenButton.Visible = false
        AutoOpen.Value = false
    end
end

local function getIcon(caseID)
    for index, icon in InvHolder:GetChildren() do
        if icon:IsA("Frame") and icon.Name == caseID then
            return icon
        end
    end
end

local function updateInventory(case, method)
    if method == "INIT" then
        OpenFrame:TweenPosition(UDim2.new(.05,0,2,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        CustomOpenFrame:TweenPosition(UDim2.new(.05,0,2,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        InvFrame:TweenSizeAndPosition(UDim2.new(0.95,0,0.8,0), UDim2.new(0.5,0,0.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        UIVisible.Value = false
        for index, icon in InvHolder:GetChildren() do
            if icon:IsA("Frame") and (icon ~= IconCopy and icon ~= CustomIconCopy) then
                icon:Destroy()
            end
        end
        initInventory()
    elseif method == "ADD" then
        if string.sub(case.ID, 1, 2) == "CC" then
            local customIcon = CustomIconCopy:Clone()
            customIcon.Visible = true
            customIcon.Name = case.ID
            customIcon.IconImage.Image = case.Image
            customIcon.OwnedFrame.OwnedText.Text = "x"..(ReplicatedCases:FindFirstChild(case.ID) and ReplicatedCases[case.ID].Value or 0)
            customIcon.Parent = InvHolder
        else
            local icon = IconCopy:Clone()
            icon.Visible = true
            icon.Name = case.ID
            icon.IconImage.Image = case.Image
            icon.OwnedFrame.OwnedText.Text =  "x"..(ReplicatedCases:FindFirstChild(case.ID) and ReplicatedCases[case.ID].Value or 0)
            icon.Parent = InvHolder
        end
    elseif method == "UPDATE" then
        local icon = getIcon(case.ID)
        icon.OwnedFrame.OwnedText.Text = "x"..(ReplicatedCases:FindFirstChild(case.ID) and ReplicatedCases[case.ID].Value or 0)
        if CurrentCase.Value == case.ID then
            local ownedValue = ReplicatedCases:FindFirstChild(case.ID) and ReplicatedCases[case.ID].Value or 0
            OpenFrame.OwnedFrame.Owned.Text = "Owned " .. ownedValue  
        end
     elseif method == "DEL" then
        local icon = InvHolder:FindFirstChild(case.ID)
        if case.ID == CurrentCase.Value then
            OpenFrame:TweenPosition(UDim2.new(.05,0,2,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
            CustomOpenFrame:TweenPosition(UDim2.new(.05,0,2,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
            InvFrame:TweenSizeAndPosition(UDim2.new(0.95,0,0.8,0), UDim2.new(0.5,0,0.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        end
        if icon then
            icon:Destroy()
        end
    end
end

function initInventory()
    for _, case in ReplicatedCases:GetChildren() do
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
local CustomOpenButton = CustomOpenFrame.OpenButton

local EXITBUTTON_ORIGINALSIZE = ExitButton.Size
local OPENBUTTON_ORIGINALSIZE = OpenButton.Size
local CUSTOMOPENBUTTON_ORIGINALSIZE = CustomOpenButton.Size
local AUTOOPENBUTTON_ORIGINALSIZE = AutoOpenButton.Size

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

local function openMouseUp()
    TweenButton:Reset(OpenButton, OPENBUTTON_ORIGINALSIZE)
end


local function customOpenHover()
    TweenButton:Grow(CustomOpenButton, CUSTOMOPENBUTTON_ORIGINALSIZE)
end

local function customOpenLeave()
    TweenButton:Reset(CustomOpenButton, CUSTOMOPENBUTTON_ORIGINALSIZE)
end

local function customOpenMouseDown()
    playClickSound()
    TweenButton:Shrink(CustomOpenButton, CUSTOMOPENBUTTON_ORIGINALSIZE)
    local currentIcon = InvHolder:FindFirstChild(CurrentCase.Value)
    if currentIcon then
        openCase(CurrentCase.Value)
        CurrentCase.Value = currentIcon.Name
    end
end

local function customOpenMouseUp()
    TweenButton:Reset(CustomOpenButton, CUSTOMOPENBUTTON_ORIGINALSIZE)
end

local function autoOpenHover()
    TweenButton:Grow(AutoOpenButton, AUTOOPENBUTTON_ORIGINALSIZE)
end

local function autoOpenLeave()
    TweenButton:Reset(AutoOpenButton, AUTOOPENBUTTON_ORIGINALSIZE)
end

local function autoOpenMouseDown()
    playClickSound()
    TweenButton:Shrink(AutoOpenButton, AUTOOPENBUTTON_ORIGINALSIZE)
    if AutoOpen.Value == false then
        AutoOpenButton.AutoText.Text = "Cancel"
        CancelAutoOpenButton.Visible = true
        AutoOpen.Value = true
    else
        AutoOpenButton.AutoText.Text = "Auto Open"
        CancelAutoOpenButton.Visible = false
        AutoOpen.Value = false
    end
end

local function autoOpenMouseUp()
    TweenButton:Reset(AutoOpenButton, AUTOOPENBUTTON_ORIGINALSIZE)
end

UpdateClientAccessoriesInventoryRemote.OnClientEvent:Connect(function(ID, GUID, method)
    ButtonStatus:CaseInventory(Player, CurrentCase.Value, OpenButton)
end)

ExitButton.ClickDetector.MouseEnter:Connect(exitHover)
ExitButton.ClickDetector.MouseLeave:Connect(exitLeave)
ExitButton.ClickDetector.MouseButton1Down:Connect(exitMouseDown)
ExitButton.ClickDetector.MouseButton1Up:Connect(exitMouseUp)

OpenButton.ClickDetector.MouseEnter:Connect(openHover)
OpenButton.ClickDetector.MouseLeave:Connect(openLeave)
OpenButton.ClickDetector.MouseButton1Down:Connect(openMouseDown)
OpenButton.ClickDetector.MouseButton1Up:Connect(openMouseUp)

CustomOpenButton.ClickDetector.MouseEnter:Connect(customOpenHover)
CustomOpenButton.ClickDetector.MouseLeave:Connect(customOpenLeave)
CustomOpenButton.ClickDetector.MouseButton1Down:Connect(customOpenMouseDown)
CustomOpenButton.ClickDetector.MouseButton1Up:Connect(customOpenMouseUp)

AutoOpenButton.ClickDetector.MouseEnter:Connect(autoOpenHover)
AutoOpenButton.ClickDetector.MouseLeave:Connect(autoOpenLeave)
AutoOpenButton.ClickDetector.MouseButton1Down:Connect(autoOpenMouseDown)
AutoOpenButton.ClickDetector.MouseButton1Up:Connect(autoOpenMouseUp)
