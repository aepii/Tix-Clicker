---- Services ----

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

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
local CollectibleCases = require(ReplicatedStorage.Data.CollectibleCases)
local CollectibleAccessories = require(ReplicatedStorage.Data.CollectibleAccessories)

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

local CC1Info = InfoUI.CC1Info

local CurrentUI = InfoUI.CurrentUI

---- Networking ----

local Networking = ReplicatedStorage.Networking
local UpdateClientShopInfoRemote = Networking.UpdateClientShopInfo

---- Private Functions ----

local function getShopInfo(nearest)
    if string.sub(nearest, 1, 2) == "CC" then
        return CC1Info
    elseif string.sub(nearest, 1, 1) == "P" then
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

local function populateCaseItems(weights, rewardsFrame)

    local InvFrame = rewardsFrame.InvFrame
    local Holder = InvFrame.Holder
    local IconCopy = Holder.IconCopy

    for index, icon in Holder:GetChildren() do
        if icon:IsA("Frame") and icon ~= IconCopy then
            icon:Destroy()
        end
    end

    for index, data in weights do
        local icon = IconCopy:Clone()
        icon.Name = data[1]
        icon.ChanceFrame.ChanceText.Text = data[2] / 1000 .. "%"
        icon.IconImage.Image = "http://www.roblox.com/Thumbs/Asset.ashx?Width=256&Height=256&AssetID=" .. CollectibleAccessories[data[1]].AssetID
        icon.Visible = true
        CollectionService:RemoveTag(icon.Shadow.UIStroke, "Ignore")
        CollectionService:RemoveTag(icon.ChanceFrame.ChanceText.UIStroke, "Ignore")
        icon.Parent = Holder
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
    if shopInfo.Name == "CC1Info" then
        item = CollectibleCases[nearest]
        if item then
            local MaterialsHolder = InfoFrame.MaterialsFrame.MaterialsHolder
            local ownedValue = Player.ReplicatedData.CollectibleCases:FindFirstChild(nearest) and Player.ReplicatedData.CollectibleCases[nearest].Value or 0
            PurchaseButton.PriceFrame.PriceText.Text = SuffixHandler:Convert(item.Cost["RebirthTix"])
            InfoFrame.OwnedFrame.Owned.Text = "Owned " .. ownedValue
            populateCaseItems(item.Weights, RewardsFrame)
            populateMaterialCost(item.Cost["Materials"] or nil, MaterialsHolder)
            --ButtonStatus:PurchaseCase(Player, CurrentUI.Value, PurchaseButton)
        end
    elseif shopInfo.Name == "CaseInfo" then
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
