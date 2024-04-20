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
local ValueUpgrades = require(ReplicatedStorage.Data.ValueUpgrades)

---- Modules ----

local Modules = ReplicatedStorage.Modules
local ButtonStatus = require(Modules.ButtonStatus)

---- UI ----

local InfoUI = Player.PlayerGui:WaitForChild("InfoUI")
local PerSecInfo = InfoUI.PerSecInfo
local UpgradeInfo = InfoUI.UpgradeInfo

local CurrentUI = InfoUI.CurrentUI

---- Private Functions ----

local function getShopInfo(nearest)
    return string.find(nearest, "PerSec") and PerSecInfo or UpgradeInfo
end

local function updateShopInfo(nearest, shopInfo)
    local InfoFrame = shopInfo.InfoFrame
    local Icon = InfoFrame.Icon
    local ItemName = InfoFrame.ItemName
    local PurchaseButton = InfoFrame.PurchaseButton
    local RewardsFrame = InfoFrame.RewardsFrame

    local upgrade;
    if shopInfo.Name == "PerSecInfo" then
        upgrade = ValueUpgrades[nearest]
        PurchaseButton.PriceFrame.PriceText.Text = upgrade.Cost
        local levelValue = Player.ReplicatedData:FindFirstChild(nearest) and Player.ReplicatedData[nearest].Value or 0
        InfoFrame.LevelFrame.Level.Text = "Level " .. levelValue  
        RewardsFrame.TixPerSec.RewardText.Text = "+"..upgrade.Reward
    elseif shopInfo.Name == "UpgradeInfo" then
        upgrade = Upgrades[nearest]
        PurchaseButton.PriceFrame.PriceText.Text = upgrade.Cost["Rocash"]
        RewardsFrame.MultPerClick.RewardText.Text = "x"..upgrade.Reward["MultPerClick"]
        RewardsFrame.MultStorage.RewardText.Text = "x"..upgrade.Reward["MultStorage"]
    end
    Icon.IconImage.Image = upgrade.Image
    ItemName.Title.Text = upgrade.Title
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

Humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
	if Humanoid.MoveDirection.Magnitude > 0 then
		getNearest()
	end
end)
