---- Services ----

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

---- Shop ----

local Shop = Workspace.ShopUpgrades

---- Player ----

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

---- Data ----

local Materials = require(ReplicatedStorage.Data.Materials)
local Upgrades = require(ReplicatedStorage.Data.Upgrades)
local PerSecondUpgrades = require(ReplicatedStorage.Data.PerSecondUpgrades)
local RebirthUpgrades = require(ReplicatedStorage.Data.RebirthUpgrades)
local Cases = require(ReplicatedStorage.Data.Cases)

---- Modules ----

local Modules = ReplicatedStorage.Modules
local ButtonStatus = require(Modules.ButtonStatus)
local TemporaryData = require(Modules.TemporaryData)
local RarityColors = require(Modules.RarityColors)
local SuffixHandler = require(Modules.SuffixHandler)

---- UI ----

local InfoUI = Player.PlayerGui:WaitForChild("InfoUI")
local PerSecInfo = InfoUI.PerSecInfo
local UpgradeInfo = InfoUI.UpgradeInfo
local RebirthInfo = InfoUI.RebirthInfo
local CaseInfo = InfoUI.CaseInfo

local CurrentUI = InfoUI.CurrentUI

local PurchaseValueButton = PerSecInfo.InfoFrame.PurchaseButton

---- Networking ----

local Networking = ReplicatedStorage.Networking
local UpdateClientShopInfoRemote = Networking.UpdateClientShopInfo

---- Private Functions ----

local function getShopInfo(nearest)
    if string.sub(nearest, 1, 1) == "P" then
        return PerSecInfo
    elseif string.sub(nearest, 1, 1) == "C" then
        return CaseInfo
    elseif string.sub(nearest, 1, 1) == "U" then
        return UpgradeInfo
    elseif string.sub(nearest, 1, 1) == "R" then
        return RebirthInfo
    end
end

local function populateCaseRarity(weights, rewardsFrame)
    local i;
    for index, data in weights do
        local gradient = RarityColors:GetGradient(data[1])
        rewardsFrame[index].ChanceText.Text = data[2] .. "%"
        rewardsFrame[index].RarityText.Text = data[1]
        rewardsFrame[index].Visible = true
        rewardsFrame[index].RarityText.UIGradient.Color = gradient
        rewardsFrame[index].ChanceText.UIGradient.Color = gradient
        i = index
    end
    for count = i+1, 5 do
        rewardsFrame[count].Visible = false
    end
end

local function populateMaterialCost(itemCosts, materialsHolder)
    for count = 1, 3 do
        materialsHolder[count].Visible = false
    end
    if itemCosts == nil then
        materialsHolder.Parent.Visible = false
        return
    end
    materialsHolder.Parent.Visible = true
    local index = 1
    for key, data in itemCosts do

        local materialID = data[1]
        local materialCost = data[2]

        local material = Materials[materialID]

        local gradient = RarityColors:GetGradient(material.Rarity)
        
        materialsHolder[index].CostText.Text = materialCost
        materialsHolder[index].MaterialIcon.Image = material.Image
        materialsHolder[index].Visible = true
        materialsHolder[index].CostText.UIGradient.Color = gradient
        index += 1
    end
end

local function updateShopInfo(nearest, shopInfo)
    local InfoFrame = shopInfo.InfoFrame
    local Icon = InfoFrame.Icon
    local ItemName = InfoFrame.ItemName
    local PurchaseButton = InfoFrame.PurchaseButton
    local RewardsFrame = InfoFrame.RewardsFrame

    local item;
    if shopInfo.Name == "CaseInfo" then
        item = Cases[nearest]
        if item then
            local ownedValue = Player.ReplicatedData.Cases:FindFirstChild(nearest) and Player.ReplicatedData.Cases[nearest].Value or 0
            PurchaseButton.PriceFrame.PriceText.Text = SuffixHandler:Convert(item.Cost)
            InfoFrame.OwnedFrame.Owned.Text = "Owned " .. ownedValue
            populateCaseRarity(item.Weights, RewardsFrame)
            ButtonStatus:PurchaseCase(Player, CurrentUI.Value, PurchaseButton)
        end
    elseif shopInfo.Name == "PerSecInfo" then
        item = PerSecondUpgrades[nearest]
        if item then
            local levelValue = Player.ReplicatedData.PerSecondUpgrades:FindFirstChild(nearest) and Player.ReplicatedData.PerSecondUpgrades[nearest].Value or 0
            PurchaseButton.PriceFrame.PriceText.Text = SuffixHandler:Convert(TemporaryData:CalculateTixPerSecondCost(levelValue, nearest, 1))
            InfoFrame.LevelFrame.Level.Text = "Level " .. levelValue  
            RewardsFrame["1"].RewardText.Text = "+".. SuffixHandler:Convert(item.Reward.AddPerSecond)
            RewardsFrame["2"].RewardText.Text = "-".. SuffixHandler:Convert(item.Reward.AddConvert)
            ButtonStatus:PurchasePerSecUpgrade(Player, CurrentUI.Value, PurchaseButton)
        end
    elseif shopInfo.Name == "UpgradeInfo" then
        local MaterialsHolder = InfoFrame.MaterialsFrame.MaterialsHolder
        item = Upgrades[nearest]
        if item then
            PurchaseButton.PriceFrame.PriceText.Text = SuffixHandler:Convert(item.Cost["Rocash"])
            RewardsFrame.MultPerClick.RewardText.Text = "x"..SuffixHandler:Convert(item.Reward["MultPerClick"])
            RewardsFrame.MultStorage.RewardText.Text = "x"..SuffixHandler:Convert(item.Reward["MultStorage"])
            populateMaterialCost(item.Cost["Materials"] or nil, MaterialsHolder)
            ButtonStatus:PurchaseUpgrade(Player, CurrentUI.Value, PurchaseButton)
        end
    elseif shopInfo.Name == "RebirthInfo" then
        item = RebirthUpgrades[nearest]
        if item then
            local levelValue = Player.ReplicatedData.RebirthUpgrades:FindFirstChild(nearest) and Player.ReplicatedData.RebirthUpgrades[nearest].Value or 0
            PurchaseButton.PriceFrame.PriceText.Text = SuffixHandler:Convert(TemporaryData:CalculateRebirthUpgradeCost(levelValue, nearest, 1))
            InfoFrame.LevelFrame.Level.Text = "Level " .. levelValue  .. "/" .. item.Limit
            
            local ampersandReplacement;

            if item.Type == "Increase" then
                ampersandReplacement = item.Initial + (levelValue * item.Reward)
            elseif item.Type == "Decrease" then
                ampersandReplacement = item.Initial - (levelValue * item.Reward)
            end

            local initialMessage = item.InitialMessage:gsub("&", ampersandReplacement)

            RewardsFrame.InitialText.Text = initialMessage
            RewardsFrame.RewardText.Text = item.RewardMessage
            ButtonStatus:PurchaseRebirthUpgrade(Player, CurrentUI.Value, PurchaseButton)
        end
    end
    if item then
        Icon.IconImage.Image = item.Image
        ItemName.Title.Text = item.Name
    end
end

local function getNearest()
    local distance = 10
    local nearest = nil

    for _, item in Shop:GetChildren() do
        if Character:FindFirstChild("HumanoidRootPart") then
            local itemDistance = (item.Position - Character.HumanoidRootPart.Position).Magnitude
            if itemDistance < distance then
                distance = itemDistance
                nearest = item
            end
        end
    end

    if nearest then
        local nearestName = nearest.Name
        if CurrentUI.Value ~= nearestName then
            if CurrentUI.Value ~= "" and Shop:FindFirstChild(CurrentUI.Value) then
                local currentUI = getShopInfo(CurrentUI.Value)
                currentUI.Enabled = false
            end
            local shopInfo = getShopInfo(nearestName)
            shopInfo.Adornee = nearest
            shopInfo.Enabled = true
            CurrentUI.Value = nearestName
            updateShopInfo(nearestName, shopInfo)
        end
    elseif CurrentUI.Value ~= "" then
        if Shop:FindFirstChild(CurrentUI.Value) then
            local currentUI = getShopInfo(CurrentUI.Value)
            currentUI.Enabled = false
        end
        CurrentUI.Value = ""
    end
end

RunService.RenderStepped:Connect(function()
	getNearest()
end)

UpdateClientShopInfoRemote.OnClientEvent:Connect(function(shopName)
    updateShopInfo(CurrentUI.Value,getShopInfo(shopName))
end)
