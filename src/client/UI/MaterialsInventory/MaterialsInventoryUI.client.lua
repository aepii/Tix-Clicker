---- Services ----

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

---- Data ----

local ReplicatedData = Player:WaitForChild("ReplicatedData")
local ReplicatedMaterials = ReplicatedData:WaitForChild("Materials")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local Materials = require(ReplicatedStorage.Data.Materials)
local RarityColors = require(Modules.RarityColors)
local TweenButton = require(Modules.TweenButton)

---- UI ----

local PlayerGui = Player.PlayerGui
local UI = PlayerGui:WaitForChild("UI")

local MaterialStats = UI.MaterialStats
local MaterialsFrame = MaterialStats.MaterialsFrame
local MaterialsHolder = MaterialsFrame.MaterialsHolder
local MaterialCopy = MaterialsHolder.MaterialCopy

---- UI VALUES ----

local UIActive = false

---- Sound ----

local Sounds = Player:WaitForChild("Sounds")
local ClickSound = Sounds:WaitForChild("ClickSound")
local ZipSound = Sounds:WaitForChild("ZipSound")

---- Networking ----

local Networking = ReplicatedStorage.Networking
local UpdateClientMaterialsInventoryRemote = Networking.UpdateClientMaterialsInventory

---- Private Functions ----

local function updateMaterialsInventory(amount, materialID, method)
    if method == "INIT" then
        for index, icon in MaterialsHolder:GetChildren() do
            if icon:IsA("Frame") and icon ~= MaterialCopy then
                icon:Destroy()
            end
        end
        initMaterialsInventory()
    elseif method == "ADD" then
        local icon = MaterialCopy:Clone()
        icon.Visible = true
        icon.Name = materialID
        icon.IconImage.Image = Materials[materialID].Image
        icon.Parent = MaterialsHolder
        icon.IconImage.Amount.Text = amount

        local gradient = RarityColors:GetGradient(Materials[materialID].Rarity)
        icon.IconImage.Amount.UIGradient.Color = gradient
    elseif method == "UPDATE" then
        local icon = MaterialsHolder:FindFirstChild(materialID)
        if icon then
            icon.IconImage.Amount.Text = amount
        end
    elseif method == "DEL" then
        local icon = MaterialsHolder:FindFirstChild(materialID)
        if icon then
            icon:Destroy()
        end
    end
end

---- Initialize ----

function initMaterialsInventory()
    for _, material in ReplicatedMaterials:GetChildren() do
        updateMaterialsInventory(material.Value, material.Name, "ADD")
    end
end

initMaterialsInventory()

UpdateClientMaterialsInventoryRemote.OnClientEvent:Connect(function(amount, materialID, method)
    updateMaterialsInventory(amount, materialID, method)
end)

---- Button ----

local button = MaterialStats.MaterialsButton
local originalSize = button.Size

local function buttonHover()
    TweenButton:Grow(button, originalSize)
end

local function buttonLeave()
    TweenButton:Reset(button, originalSize)
end

local function buttonMouseDown()
    SoundService:PlayLocalSound(ClickSound)
    SoundService:PlayLocalSound(ZipSound)
    TweenButton:Shrink(button, originalSize)
    if UIActive == true then
        MaterialsFrame:TweenSizeAndPosition(UDim2.new(0,0,0,0), UDim2.new(0.8,0,0.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        UIActive = false
    else
        MaterialsFrame:TweenSizeAndPosition(UDim2.new(1,0,0.8,0), UDim2.new(0.4,0,0.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        UIActive = true
    end
end

local function buttonMouseUp()
    TweenButton:Reset(button, originalSize)
end

button.MouseEnter:Connect(buttonHover)
button.MouseLeave:Connect(buttonLeave)
button.MouseButton1Down:Connect(buttonMouseDown)
button.MouseButton1Up:Connect(buttonMouseUp)