---- Services ----

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TweenButton = require(Modules.TweenButton)
local ButtonStatus = require(Modules.ButtonStatus)
local Accessories = require(ReplicatedStorage.Data.Accessories)

---- Data ----

local ReplicatedData = Player:WaitForChild("ReplicatedData")

---- UI ----

local PlayerGui = Player.PlayerGui
local UI = PlayerGui:WaitForChild("UI")

local ScrapMenu = UI.ScrapMenu
local InvHolder = ScrapMenu.InvFrame.Holder
local ScrapFrame = ScrapMenu.ScrapFrame
local IconCopy = InvHolder.IconCopy

local IconScript = script.Parent.Icon
IconScript.Parent = IconCopy
IconScript.Enabled = true

---- UI Values ----

local CurrentAccessory = ScrapFrame.CurrentAccessory

---- Sound ----

local Sounds = Player:WaitForChild("Sounds")
local ClickSound = Sounds:WaitForChild("ClickSound")

---- Networking ----

local Networking = ReplicatedStorage.Networking
local ScrapAccessoryRemote = Networking.ScrapAccessory
local UpdateClientInventoryRemote = Networking.UpdateClientInventory

---- Private Functions ----

local function scrapAccessory(accessoryGUID)
   ScrapAccessoryRemote:InvokeServer(accessoryGUID)
end

local function updateInventory(ID, GUID, method)
    if method == "ADD" then
        local icon = IconCopy:Clone()
        icon.Visible = true
        icon.Name = GUID
        icon.IconImage.Image = "http://www.roblox.com/Thumbs/Asset.ashx?Width=256&Height=256&AssetID="..Accessories[ID].AssetID
        icon.Parent = InvHolder
    elseif method == "DEL" then
        local icon = InvHolder:FindFirstChild(GUID)
        if icon then
            icon:Destroy()
        end
    end
end

local function initInventory()
    for _, accessory in ReplicatedData.Accessories:GetChildren() do
        updateInventory(accessory.Value, accessory.Name, "ADD")
    end
end

initInventory()

UpdateClientInventoryRemote.OnClientEvent:Connect(function(accessory)
    updateInventory(accessory, "ADD")
end)

---- Buttons ----

local ExitButton = ScrapMenu.ExitButton
local ScrapButton = ScrapFrame.ScrapButton

local EXITBUTTON_ORIGINALSIZE = ExitButton.Size
local SCRAPBUTTON_ORIGINALSIZE = ScrapButton.Size

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
    ScrapMenu:TweenPosition(UDim2.new(0.5, 0, 2, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
end

local function exitMouseUp()
    TweenButton:Reset(ExitButton, EXITBUTTON_ORIGINALSIZE)
end

local function scrapHover()
    TweenButton:Grow(ScrapButton, SCRAPBUTTON_ORIGINALSIZE)
end

local function scrapLeave()
    TweenButton:Reset(ScrapButton, SCRAPBUTTON_ORIGINALSIZE)
end

local function scrapMouseDown()
    playClickSound()
    TweenButton:Shrink(ScrapButton, SCRAPBUTTON_ORIGINALSIZE)
    scrapAccessory(CurrentAccessory.Value)
    --ButtonStatus:AccessoryInventory(Player, CurrentAccessory.Value, ScrapButton)
end

local function scrapMouseUp()
    TweenButton:Reset(ScrapButton, SCRAPBUTTON_ORIGINALSIZE)
end

ExitButton.ClickDetector.MouseEnter:Connect(exitHover)
ExitButton.ClickDetector.MouseLeave:Connect(exitLeave)
ExitButton.ClickDetector.MouseButton1Down:Connect(exitMouseDown)
ExitButton.ClickDetector.MouseButton1Up:Connect(exitMouseUp)

ScrapButton.ClickDetector.MouseEnter:Connect(scrapHover)
ScrapButton.ClickDetector.MouseLeave:Connect(scrapLeave)
ScrapButton.ClickDetector.MouseButton1Down:Connect(scrapMouseDown)
ScrapButton.ClickDetector.MouseButton1Up:Connect(scrapMouseUp)