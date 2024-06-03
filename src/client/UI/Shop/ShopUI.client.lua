---- Services ----

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

---- Shop ----

local Shop = Workspace.NoobShop:WaitForChild("Stand")

---- Player ----

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

---- Data ----

local Upgrades = require(ReplicatedStorage.Data.Upgrades)
local PerSecondUpgrades = require(ReplicatedStorage.Data.PerSecondUpgrades)
local Cases = require(ReplicatedStorage.Data.Cases)

---- Modules ----

local Modules = ReplicatedStorage.Modules
local ButtonStatus = require(Modules.ButtonStatus)
local TemporaryData = require(Modules.TemporaryData)
local RarityColors = require(Modules.RarityColors)

---- UI ----

local InfoUI = Player.PlayerGui:WaitForChild("InfoUI")
local PerSecInfo = InfoUI.PerSecInfo
local UpgradeInfo = InfoUI.UpgradeInfo
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

local function updateShopInfo(nearest, shopInfo)
    local InfoFrame = shopInfo.InfoFrame
    local Icon = InfoFrame.Icon
    local ItemName = InfoFrame.ItemName
    local PurchaseButton = InfoFrame.PurchaseButton
    local RewardsFrame = InfoFrame.RewardsFrame

    local item;
    if shopInfo.Name == "CaseInfo" then
        item = Cases[nearest]
        local ownedValue = Player.ReplicatedData.Cases:FindFirstChild(nearest) and Player.ReplicatedData.Cases[nearest].Value or 0
        PurchaseButton.PriceFrame.PriceText.Text = item.Cost
        InfoFrame.OwnedFrame.Owned.Text = "Owned " .. ownedValue  
        populateCaseRarity(item.Weights, RewardsFrame)
    else
        if shopInfo.Name == "PerSecInfo" then
            item = PerSecondUpgrades[nearest]
            local levelValue = Player.ReplicatedData.PerSecondUpgrades:FindFirstChild(nearest) and Player.ReplicatedData.PerSecondUpgrades[nearest].Value or 0
            PurchaseButton.PriceFrame.PriceText.Text = TemporaryData:CalculateTixPerSecondCost(levelValue, nearest, 1)
            InfoFrame.LevelFrame.Level.Text = "Level " .. levelValue  
            RewardsFrame.TixPerSec.RewardText.Text = "+"..item.Reward
        elseif shopInfo.Name == "UpgradeInfo" then
            item = Upgrades[nearest]
            PurchaseButton.PriceFrame.PriceText.Text = item.Cost["Rocash"]
            RewardsFrame.MultPerClick.RewardText.Text = "x"..item.Reward["MultPerClick"]
            RewardsFrame.MultStorage.RewardText.Text = "x"..item.Reward["MultStorage"]
        end
    end
    Icon.IconImage.Image = item.Image
    ItemName.Title.Text = item.Name
    ButtonStatus:Upgrade(Player, CurrentUI.Value, PurchaseButton)
end

local function getNearest()
    local distance = 5
    local nearest = nil

    for _, item in Shop:GetChildren() do
        local itemDistance = (item.Position - Character.HumanoidRootPart.Position).Magnitude
        if itemDistance < distance then
            distance = itemDistance
            nearest = item
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
    print(shopName)
    updateShopInfo(CurrentUI.Value,getShopInfo(shopName))
end)
