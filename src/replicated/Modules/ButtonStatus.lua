---- Services ----

local ReplicatedStorage = game:GetService("ReplicatedStorage")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TemporaryData = require(Modules.TemporaryData)
local Upgrades = require(ReplicatedStorage.Data.Upgrades)
local RebirthUpgrades = require(ReplicatedStorage.Data.RebirthUpgrades)
local Cases = require(ReplicatedStorage.Data.Cases)

---- Private Functions ----

local function canPurchase(player, upgrade)
    
    local ReplicatedData = player:WaitForChild("ReplicatedData")
    local ReplicatedRocash = ReplicatedData:WaitForChild("Rocash")
    local ReplicatedMaterials = ReplicatedData:WaitForChild("Materials")

    local cost = upgrade.Cost["Rocash"]

    if ReplicatedRocash.Value < cost then
        return false
    end

    if upgrade.Cost["Materials"] then
        local materialCost = upgrade.Cost["Materials"]

        for key, materialData in materialCost do
            local materialID = materialData[1]
            local materialCostVal = materialData[2]
            local replicatedMaterial = ReplicatedMaterials:FindFirstChild(materialID) 
            if not replicatedMaterial then
                return false
            end
            if replicatedMaterial.Value < materialCostVal then
                return false
            end
        end
    end
    return true
end
    
local function canPurchaseCase(player, case, amount)
    
    local ReplicatedData = player:WaitForChild("ReplicatedData")
    local ReplicatedRebirthTix = ReplicatedData:WaitForChild("Rebirth Tix")
    local ReplicatedRocash = ReplicatedData:WaitForChild("Rocash")
    local ReplicatedMaterials = ReplicatedData:WaitForChild("Materials")

    if case.Cost["RebirthTix"] then
        local cost = case.Cost["RebirthTix"] * amount
        if ReplicatedRebirthTix.Value < cost then
            return false
        end
    end

    if case.Cost["Rocash"] then
        local cost = case.Cost["Rocash"] * amount
        if ReplicatedRocash.Value < cost then
            return false
        end
    end
        
    if case.Cost["Materials"] then
        local cost = case.Cost["Materials"]

        for key, materialData in cost do
            local materialID = materialData[1]
            local materialCostVal = materialData[2] * amount
            local replicatedMaterial = ReplicatedMaterials:FindFirstChild(materialID) 
            if not replicatedMaterial then
                return false
            end
            if replicatedMaterial.Value < materialCostVal then
                return false
            end
        end
    end
    
    return true
end

local function canPurchaseRebirth(player, rebirthUpgrade)
    
    local ReplicatedData = player:WaitForChild("ReplicatedData")
    local rebirthUpgrades = ReplicatedData:WaitForChild("RebirthUpgrades")
    local upgradeData = rebirthUpgrades:FindFirstChild(rebirthUpgrade.ID)
    local levelValue = upgradeData and rebirthUpgrades[rebirthUpgrade.ID].Value or 0
    local cost;

    if upgradeData then
        cost = TemporaryData:CalculateRebirthUpgradeCost(levelValue, rebirthUpgrade.ID, 1)
    else
        cost = rebirthUpgrade.Cost
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
    local equipText, backgroundColor, shadowColor, strokeColor, gradientColor
    if upgradeEquipped.Value == currentUpgrade then
        equipText = "Equipped"
        gradientColor = ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(100,100,100))
        backgroundColor = Color3.fromRGB(82, 81, 81)
        shadowColor = Color3.fromRGB(36, 36, 36)
        strokeColor = Color3.fromRGB(36, 36, 36)
    else
        equipText = "Equip"
        gradientColor = ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(15,255,83))
        backgroundColor = Color3.fromRGB(85, 170, 127)
        shadowColor = Color3.fromRGB(34, 68, 50)
        strokeColor = Color3.fromRGB(34, 68, 50)
    end

    equipButton.UIGradient.Color = gradientColor
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
    local equipText, backgroundColor, shadowColor, strokeColor, gradientColor
    if equippedAccessory then
        if equippedAccessory.Value == GUID then
            equipText = "Unequip"
            gradientColor = ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(255,0,0))
            backgroundColor = Color3.fromRGB(236, 44, 75)
            shadowColor = Color3.fromRGB(73, 30, 30)
            strokeColor = Color3.fromRGB(73, 30, 30)
        else
            equipText = "Unavailable"
            gradientColor = ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(100,100,100))
            backgroundColor = Color3.fromRGB(82, 81, 81)
            shadowColor = Color3.fromRGB(36, 36, 36)
            strokeColor = Color3.fromRGB(36, 36, 36)
        end
    else
        if equippedAccessoriesLimit.Value <= equippedAccessoriesCount then
            equipText = "Max Equipped"
            gradientColor = ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(100,100,100))
            backgroundColor = Color3.fromRGB(82, 81, 81)
            shadowColor = Color3.fromRGB(36, 36, 36)
            strokeColor = Color3.fromRGB(36, 36, 36)
        else
            equipText = "Equip"
            gradientColor = ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(15,255,83))
            backgroundColor = Color3.fromRGB(85, 170, 127)
            shadowColor = Color3.fromRGB(34, 68, 50)
            strokeColor = Color3.fromRGB(34, 68, 50)
        end
    end

    equipButton.UIGradient.Color = gradientColor
    equipButton.EquipText.Text = equipText
    equipButton.BackgroundColor3 = backgroundColor
    equipButton.Shadow.BackgroundColor3 = shadowColor
    equipButton.EquipText.UIStroke.Color = strokeColor
end

function ButtonStatus:ScrapInventory(player, GUID, scrapButton)
    local ID = player.ReplicatedData.Accessories[GUID].Value
    local equippedAccessory = player.ReplicatedData.EquippedAccessories:FindFirstChild(ID)
    local equipText, backgroundColor, shadowColor, strokeColor, gradientColor
    if equippedAccessory then
        if equippedAccessory.Value == GUID then
            equipText = "Unavailable"
            gradientColor = ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(100,100,100))
            backgroundColor = Color3.fromRGB(82, 81, 81)
            shadowColor = Color3.fromRGB(36, 36, 36)
            strokeColor = Color3.fromRGB(36, 36, 36)
        else
            equipText = "Scrap"
            gradientColor = ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(255,0,0))
            backgroundColor = Color3.fromRGB(236, 44, 75)
            shadowColor = Color3.fromRGB(73, 30, 30)
            strokeColor = Color3.fromRGB(73, 30, 30)
        end
    else
        equipText = "Scrap"
        gradientColor = ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(255,0,0))
        backgroundColor = Color3.fromRGB(236, 44, 75)
        shadowColor = Color3.fromRGB(73, 30, 30)
        strokeColor = Color3.fromRGB(73, 30, 30)
    end

    scrapButton.UIGradient.Color = gradientColor
    scrapButton.ScrapText.Text = equipText
    scrapButton.BackgroundColor3 = backgroundColor
    scrapButton.Shadow.BackgroundColor3 = shadowColor
    scrapButton.ScrapText.UIStroke.Color = strokeColor

end

function ButtonStatus:PurchaseUpgrade(player, currentUpgrade, purchaseButton)

    local upgradeEquipped = player.ReplicatedData.Upgrades
    local priceFrame, backgroundColor, shadowColor, strokeColor, gradientColor

    if upgradeEquipped:FindFirstChild(currentUpgrade) then
        priceFrame = "Owned"
        gradientColor = ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(100,100,100))
        backgroundColor = Color3.fromRGB(82, 81, 81)
        shadowColor = Color3.fromRGB(36, 36, 36)
        strokeColor = Color3.fromRGB(36, 36, 36)
        purchaseButton.PriceFrame.PriceText.Text = priceFrame
        purchaseButton.PriceFrame.CurrencyIcon.Visible = false
    else
        if canPurchase(player, Upgrades[currentUpgrade]) then
            backgroundColor = Color3.fromRGB(85, 170, 127)
            gradientColor = ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(15,255,83))
            shadowColor = Color3.fromRGB(34, 68, 50)
            strokeColor = Color3.fromRGB(34, 68, 50)
        else
            backgroundColor = Color3.fromRGB(236, 44, 75)
            gradientColor = ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(255,0,0))
            shadowColor = Color3.fromRGB(73, 30, 30)
            strokeColor = Color3.fromRGB(73, 30, 30)
        end
        purchaseButton.PriceFrame.CurrencyIcon.Visible = true
    end

    purchaseButton.UIGradient.Color = gradientColor
    purchaseButton.BackgroundColor3 = backgroundColor
    purchaseButton.Shadow.BackgroundColor3 = shadowColor
    purchaseButton.PriceFrame.PriceText.UIStroke.Color = strokeColor
end

function ButtonStatus:PurchaseCase(player, currentCase, amount, purchaseButton)

    local backgroundColor, shadowColor, strokeColor, gradientColor

    if canPurchaseCase(player, Cases[currentCase], amount) then
        gradientColor = ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(15,255,83))
        backgroundColor = Color3.fromRGB(85, 170, 127)
        shadowColor = Color3.fromRGB(34, 68, 50)
        strokeColor = Color3.fromRGB(34, 68, 50)
    else
        gradientColor = ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(255,0,0))
        backgroundColor = Color3.fromRGB(236, 44, 75)
        shadowColor = Color3.fromRGB(73, 30, 30)
        strokeColor = Color3.fromRGB(73, 30, 30)
    end

    purchaseButton.UIGradient.Color = gradientColor
    purchaseButton.PriceFrame.CurrencyIcon.Visible = true
    purchaseButton.BackgroundColor3 = backgroundColor
    purchaseButton.Shadow.BackgroundColor3 = shadowColor
    purchaseButton.PriceFrame.PriceText.UIStroke.Color = strokeColor
end


function ButtonStatus:PurchaseRebirthUpgrade(player, currentUpgrade, purchaseButton)

    local backgroundColor, shadowColor, strokeColor, gradientColor

    if canPurchaseRebirth(player, RebirthUpgrades[currentUpgrade]) then
        gradientColor = ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(15,255,83))
        backgroundColor = Color3.fromRGB(85, 170, 127)
        shadowColor = Color3.fromRGB(34, 68, 50)
        strokeColor = Color3.fromRGB(34, 68, 50)
    else
        gradientColor = ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(255,0,0))
        backgroundColor = Color3.fromRGB(236, 44, 75)
        shadowColor = Color3.fromRGB(73, 30, 30)
        strokeColor = Color3.fromRGB(73, 30, 30)
    end

    purchaseButton.UIGradient.Color = gradientColor
    purchaseButton.PriceFrame.CurrencyIcon.Visible = true
    purchaseButton.BackgroundColor3 = backgroundColor
    purchaseButton.Shadow.BackgroundColor3 = shadowColor
    purchaseButton.PriceFrame.PriceText.UIStroke.Color = strokeColor
end

function ButtonStatus:CaseInventory(player, caseID, purchaseButton)

    local accessoriesCount = #player.ReplicatedData.Accessories:GetChildren()
    local accessoriesLimit = player.TemporaryData.AccessoriesLimit

    local cases = player.ReplicatedData.Cases
    local openText, backgroundColor, shadowColor, strokeColor, gradientColor

    if cases:FindFirstChild(caseID) then
        if accessoriesLimit.Value <= accessoriesCount then
            openText = "Accessories Full"
            gradientColor = ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(100,100,100))
            backgroundColor = Color3.fromRGB(82, 81, 81)
            shadowColor = Color3.fromRGB(36, 36, 36)
            strokeColor = Color3.fromRGB(36, 36, 36)
        else
            openText = "Open"
            gradientColor = ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(15,255,83))
            backgroundColor = Color3.fromRGB(85, 170, 127)
            shadowColor = Color3.fromRGB(34, 68, 50)
            strokeColor = Color3.fromRGB(34, 68, 50)
        end
    else
        openText = "Unavailable"
        gradientColor = ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(100,100,100))
        backgroundColor = Color3.fromRGB(82, 81, 81)
        shadowColor = Color3.fromRGB(36, 36, 36)
        strokeColor = Color3.fromRGB(36, 36, 36)
    end

    purchaseButton.UIGradient.Color = gradientColor
    purchaseButton.OpenText.Text = openText
    purchaseButton.BackgroundColor3 = backgroundColor
    purchaseButton.Shadow.BackgroundColor3 = shadowColor
    purchaseButton.OpenText.UIStroke.Color = strokeColor
end

return ButtonStatus