---- Services ----

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

---- Data ----

local ReplicatedData = Player:WaitForChild("ReplicatedData")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local Materials = require(ReplicatedStorage.Data.Materials)
local RarityColors = require(Modules.RarityColors)

---- UI ----

local PlayerGui = Player.PlayerGui
local UI = PlayerGui:WaitForChild("UI")

local MaterialsButton = UI.MaterialsButton
local MaterialsFrame = MaterialsButton.MaterialsFrame
local MaterialsHolder = MaterialsFrame.MaterialsHolder
local MaterialCopy = MaterialsHolder.MaterialCopy

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
        print("UPDATEDDDD", amount)
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
    for _, material in ReplicatedData.Materials:GetChildren() do
        updateMaterialsInventory(material.Value, material.Name, "ADD")
    end
end

initMaterialsInventory()

UpdateClientMaterialsInventoryRemote.OnClientEvent:Connect(function(amount, materialID, method)
    print(amount, materialID, method)
    updateMaterialsInventory(amount, materialID, method)
end)