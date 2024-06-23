---- Services ----

local ReplicatedStorage = game:GetService("ReplicatedStorage")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TemporaryData = require(Modules.TemporaryData)
local Upgrades = require(ReplicatedStorage.Data.Upgrades)
local PerSecondUpgrades = require(ReplicatedStorage.Data.PerSecondUpgrades)
local RebirthUpgrades = require(ReplicatedStorage.Data.RebirthUpgrades)
local Cases = require(ReplicatedStorage.Data.Cases)

---- Private Functions ----

local function canPurchase(player, upgrade)
    
    local ReplicatedData = player:WaitForChild("ReplicatedData")

    local cost = upgrade.Cost["Rocash"]

    if ReplicatedData.Rocash.Value < cost then
        return false
    end

    if upgrade.Cost["Materials"] then
        local materialCost = upgrade.Cost["Materials"]

        for key, materialData in materialCost do
            local materialID = materialData[1]
            local materialCostVal = materialData[2]
            if not ReplicatedData.Materials:FindFirstChild(materialID) then
                return false
            end
            if ReplicatedData.Materials[materialID].Value < materialCostVal then
                return false
            end
        end
    end
    return true
end

local function canPurchaseValue(player, valueUpgrade)
    
    local ReplicatedData = player:WaitForChild("ReplicatedData")

    local cost = valueUpgrade.Cost

    if ReplicatedData.Rocash.Value < cost then
        return false
    end

    return true
end

local function canPurchaseRebirth(player, valueUpgrade)
    
    local ReplicatedData = player:WaitForChild("ReplicatedData")
    local rebirthUpgrades = ReplicatedData:WaitForChild("RebirthUpgrades")
    local upgradeData = rebirthUpgrades:FindFirstChild(valueUpgrade.ID)
    local levelValue = rebirthUpgrades:FindFirstChild(valueUpgrade.ID) and rebirthUpgrades[valueUpgrade.ID].Value or 0
    local cost;

    if upgradeData then
        cost = TemporaryData:CalculateRebirthUpgradeCost(levelValue, valueUpgrade.ID, 1)
    else
        cost = valueUpgrade.Cost
    end

    if ReplicatedData["Rebirth Tix"].Value < cost then
        return false
    end

    return true
end

---- Button Status ----

local ButtonStatus = {}

function ButtonStatus:TixInventory(player, currentUpgrade, equipButton)
    local upgradeEquipped = player.ReplicatedData.ToolEquipped
    local equipText, backgroundColor, shadowColor, strokeColor
    if upgradeEquipped.Value == currentUpgrade then
        equipText = "Equipped"
        backgroundColor = Color3.fromRGB(82, 81, 81)
        shadowColor = Color3.fromRGB(36, 35, 35)
        strokeColor = Color3.fromRGB(36, 35, 35)
    else
        equipText = "Equip"
        backgroundColor = Color3.fromRGB(85, 170, 127)
        shadowColor = Color3.fromRGB(34, 68, 50)
        strokeColor = Color3.fromRGB(34, 68, 50)
    end

    equipButton.EquipText.Text = equipText
    equipButton.BackgroundColor3 = backgroundColor
    equipButton.Shadow.BackgroundColor3 = shadowColor
    equipButton.EquipText.UIStroke.Color = strokeColor
end

function ButtonStatus:AccessoryInventory(player, GUID, equipButton)
    local ID = player.ReplicatedData.Accessories[GUID].Value
    local equippedAccessory = player.ReplicatedData.EquippedAccessories:FindFirstChild(ID)
    local equippedAccessoriesCount = #player.ReplicatedData.EquippedAccessories:GetChildren()
    local equippedAccessoriesLimit = player.TemporaryData.EquippedAccessoriesLimit
    local equipText, backgroundColor, shadowColor, strokeColor
    if equippedAccessory then
        if equippedAccessory.Value == GUID then
            equipText = "Unequip"
            backgroundColor = Color3.fromRGB(236, 44, 75)
            shadowColor = Color3.fromRGB(73, 30, 30)
            strokeColor = Color3.fromRGB(73, 30, 30)
        else
            equipText = "Unavailable"
            backgroundColor = Color3.fromRGB(82, 81, 81)
            shadowColor = Color3.fromRGB(36, 35, 35)
            strokeColor = Color3.fromRGB(36, 35, 35)
        end
    else
        if equippedAccessoriesLimit.Value <= equippedAccessoriesCount then
            equipText = "Max Equipped"
            backgroundColor = Color3.fromRGB(82, 81, 81)
            shadowColor = Color3.fromRGB(36, 35, 35)
            strokeColor = Color3.fromRGB(36, 35, 35)
        else
            equipText = "Equip"
            backgroundColor = Color3.fromRGB(85, 170, 127)
            shadowColor = Color3.fromRGB(34, 68, 50)
            strokeColor = Color3.fromRGB(34, 68, 50)
        end
    end

    equipButton.EquipText.Text = equipText
    equipButton.BackgroundColor3 = backgroundColor
    equipButton.Shadow.BackgroundColor3 = shadowColor
    equipButton.EquipText.UIStroke.Color = strokeColor
end

function ButtonStatus:ScrapInventory(player, GUID, scrapButton)
    local ID = player.ReplicatedData.Accessories[GUID].Value
    local equippedAccessory = player.ReplicatedData.EquippedAccessories:FindFirstChild(ID)
    local equipText, backgroundColor, shadowColor, strokeColor
    if equippedAccessory then
        if equippedAccessory.Value == GUID then
            equipText = "Unavailable"
            backgroundColor = Color3.fromRGB(82, 81, 81)
            shadowColor = Color3.fromRGB(36, 35, 35)
            strokeColor = Color3.fromRGB(36, 35, 35)
        else
            equipText = "Scrap"
            backgroundColor = Color3.fromRGB(236, 44, 75)
            shadowColor = Color3.fromRGB(73, 30, 30)
            strokeColor = Color3.fromRGB(73, 30, 30)
        end
    else
        equipText = "Scrap"
        backgroundColor = Color3.fromRGB(236, 44, 75)
        shadowColor = Color3.fromRGB(73, 30, 30)
        strokeColor = Color3.fromRGB(73, 30, 30)
    end

    scrapButton.ScrapText.Text = equipText
    scrapButton.BackgroundColor3 = backgroundColor
    scrapButton.Shadow.BackgroundColor3 = shadowColor
    scrapButton.ScrapText.UIStroke.Color = strokeColor

end

function ButtonStatus:PurchaseUpgrade(player, currentUpgrade, purchaseButton)

    local upgradeEquipped = player.ReplicatedData.Upgrades
    local priceFrame, backgroundColor, shadowColor, strokeColor

    if upgradeEquipped:FindFirstChild(currentUpgrade) then
        priceFrame = "Owned"
        backgroundColor = Color3.fromRGB(82, 81, 81)
        shadowColor = Color3.fromRGB(36, 35, 35)
        strokeColor = Color3.fromRGB(36, 35, 35)
        purchaseButton.PriceFrame.PriceText.Text = priceFrame
        purchaseButton.PriceFrame.CurrencyIcon.Visible = false
    else
        if canPurchase(player, Upgrades[currentUpgrade]) then
            backgroundColor = Color3.fromRGB(85, 170, 127)
            shadowColor = Color3.fromRGB(34, 68, 50)
            strokeColor = Color3.fromRGB(34, 68, 50)
        else
            backgroundColor = Color3.fromRGB(236, 44, 75)
            shadowColor = Color3.fromRGB(73, 30, 30)
            strokeColor = Color3.fromRGB(73, 30, 30)
        end
        purchaseButton.PriceFrame.CurrencyIcon.Visible = true
    end
    purchaseButton.BackgroundColor3 = backgroundColor
    purchaseButton.Shadow.BackgroundColor3 = shadowColor
    purchaseButton.PriceFrame.PriceText.UIStroke.Color = strokeColor
end

function ButtonStatus:PurchasePerSecUpgrade(player, currentUpgrade, purchaseButton)

    local backgroundColor, shadowColor, strokeColor

    if canPurchaseValue(player, PerSecondUpgrades[currentUpgrade]) then
        backgroundColor = Color3.fromRGB(85, 170, 127)
        shadowColor = Color3.fromRGB(34, 68, 50)
        strokeColor = Color3.fromRGB(34, 68, 50)
    else
        backgroundColor = Color3.fromRGB(236, 44, 75)
        shadowColor = Color3.fromRGB(73, 30, 30)
        strokeColor = Color3.fromRGB(73, 30, 30)
    end

    purchaseButton.PriceFrame.CurrencyIcon.Visible = true
    purchaseButton.BackgroundColor3 = backgroundColor
    purchaseButton.Shadow.BackgroundColor3 = shadowColor
    purchaseButton.PriceFrame.PriceText.UIStroke.Color = strokeColor
end

function ButtonStatus:PurchaseCase(player, currentCase, purchaseButton)

    local backgroundColor, shadowColor, strokeColor

    if canPurchaseValue(player, Cases[currentCase]) then
        backgroundColor = Color3.fromRGB(85, 170, 127)
        shadowColor = Color3.fromRGB(34, 68, 50)
        strokeColor = Color3.fromRGB(34, 68, 50)
    else
        backgroundColor = Color3.fromRGB(236, 44, 75)
        shadowColor = Color3.fromRGB(73, 30, 30)
        strokeColor = Color3.fromRGB(73, 30, 30)
    end

    purchaseButton.PriceFrame.CurrencyIcon.Visible = true
    purchaseButton.BackgroundColor3 = backgroundColor
    purchaseButton.Shadow.BackgroundColor3 = shadowColor
    purchaseButton.PriceFrame.PriceText.UIStroke.Color = strokeColor
end


function ButtonStatus:PurchaseRebirthUpgrade(player, currentUpgrade, purchaseButton)

    local backgroundColor, shadowColor, strokeColor

    if canPurchaseRebirth(player, RebirthUpgrades[currentUpgrade]) then
        backgroundColor = Color3.fromRGB(85, 170, 127)
        shadowColor = Color3.fromRGB(34, 68, 50)
        strokeColor = Color3.fromRGB(34, 68, 50)
    else
        backgroundColor = Color3.fromRGB(236, 44, 75)
        shadowColor = Color3.fromRGB(73, 30, 30)
        strokeColor = Color3.fromRGB(73, 30, 30)
    end

    purchaseButton.PriceFrame.CurrencyIcon.Visible = true
    purchaseButton.BackgroundColor3 = backgroundColor
    purchaseButton.Shadow.BackgroundColor3 = shadowColor
    purchaseButton.PriceFrame.PriceText.UIStroke.Color = strokeColor
end

function ButtonStatus:CaseInventory(player, caseID, purchaseButton)

    local accessoriesCount = #player.ReplicatedData.Accessories:GetChildren()
    local accessoriesLimit = player.TemporaryData.AccessoriesLimit

    local cases = player.ReplicatedData.Cases
    local openText, backgroundColor, shadowColor, strokeColor

    if cases:FindFirstChild(caseID) then
        if accessoriesLimit.Value <= accessoriesCount then
            openText = "Accessories Full"
            backgroundColor = Color3.fromRGB(82, 81, 81)
            shadowColor = Color3.fromRGB(36, 35, 35)
            strokeColor = Color3.fromRGB(36, 35, 35)
        else
            openText = "Open"
            backgroundColor = Color3.fromRGB(85, 170, 127)
            shadowColor = Color3.fromRGB(34, 68, 50)
            strokeColor = Color3.fromRGB(34, 68, 50)
        end
    else
        openText = "Unavailable"
        backgroundColor = Color3.fromRGB(82, 81, 81)
        shadowColor = Color3.fromRGB(36, 35, 35)
        strokeColor = Color3.fromRGB(36, 35, 35)
    end
    purchaseButton.OpenText.Text = openText
    purchaseButton.BackgroundColor3 = backgroundColor
    purchaseButton.Shadow.BackgroundColor3 = shadowColor
    purchaseButton.OpenText.UIStroke.Color = strokeColor
end

function ButtonStatus:CollectibleCaseInventory(player, caseID, purchaseButton)
    local cases = player.ReplicatedData.CollectibleCases
    local openText, backgroundColor, shadowColor, strokeColor

    if cases:FindFirstChild(caseID) then
        openText = "Open"
        backgroundColor = Color3.fromRGB(85, 170, 127)
        shadowColor = Color3.fromRGB(34, 68, 50)
        strokeColor = Color3.fromRGB(34, 68, 50)
    else
        openText = "Unavailable"
        backgroundColor = Color3.fromRGB(82, 81, 81)
        shadowColor = Color3.fromRGB(36, 35, 35)
        strokeColor = Color3.fromRGB(36, 35, 35)
    end
    purchaseButton.OpenText.Text = openText
    purchaseButton.BackgroundColor3 = backgroundColor
    purchaseButton.Shadow.BackgroundColor3 = shadowColor
    purchaseButton.OpenText.UIStroke.Color = strokeColor
end

function ButtonStatus:CollectibleAccessoryInventory(player, GUID, equipButton)
    local ID = player.ReplicatedData.CollectibleAccessories[GUID].Value
    local equippedAccessory = player.ReplicatedData.EquippedCollectibleAccessories:FindFirstChild(ID)
    local equippedAccessoriesCount = #player.ReplicatedData.EquippedCollectibleAccessories:GetChildren()
    local equippedAccessoriesLimit = player.TemporaryData.EquippedCollectibleAccessoriesLimit
    local equipText, backgroundColor, shadowColor, strokeColor
    if equippedAccessory then
        if equippedAccessory.Value == GUID then
            equipText = "Unequip"
            backgroundColor = Color3.fromRGB(236, 44, 75)
            shadowColor = Color3.fromRGB(73, 30, 30)
            strokeColor = Color3.fromRGB(73, 30, 30)
        else
            equipText = "Unavailable"
            backgroundColor = Color3.fromRGB(82, 81, 81)
            shadowColor = Color3.fromRGB(36, 35, 35)
            strokeColor = Color3.fromRGB(36, 35, 35)
        end
    else
        if equippedAccessoriesLimit.Value <= equippedAccessoriesCount then
            equipText = "Max Equipped"
            backgroundColor = Color3.fromRGB(82, 81, 81)
            shadowColor = Color3.fromRGB(36, 35, 35)
            strokeColor = Color3.fromRGB(36, 35, 35)
        else
            equipText = "Equip"
            backgroundColor = Color3.fromRGB(85, 170, 127)
            shadowColor = Color3.fromRGB(34, 68, 50)
            strokeColor = Color3.fromRGB(34, 68, 50)
        end
    end

    equipButton.EquipText.Text = equipText
    equipButton.BackgroundColor3 = backgroundColor
    equipButton.Shadow.BackgroundColor3 = shadowColor
    equipButton.EquipText.UIStroke.Color = strokeColor
end

return ButtonStatus