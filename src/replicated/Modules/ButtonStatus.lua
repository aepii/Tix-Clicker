local Players = game:GetService("Players")
local ButtonStatus = {}

function ButtonStatus:TixInventory(player, currentUpgrade, equipButton)
    local upgradeEquipped = player.ReplicatedData.ToolEquipped
    local equipText, backgroundColor, shadowColor, strokeColor
    print( upgradeEquipped.Value, currentUpgrade)
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
    local equipText, backgroundColor, shadowColor, strokeColor
    print(GUID, equippedAccessory)
    if equippedAccessory then
        if equippedAccessory.Value == GUID then
            equipText = "Unequip"
            backgroundColor = Color3.fromRGB(170, 85, 89)
            shadowColor = Color3.fromRGB(102, 63, 64)
            strokeColor = Color3.fromRGB(102, 63, 64)
        else
            equipText = "Unavailable"
            backgroundColor = Color3.fromRGB(82, 81, 81)
            shadowColor = Color3.fromRGB(36, 35, 35)
            strokeColor = Color3.fromRGB(36, 35, 35)
        end
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
            backgroundColor = Color3.fromRGB(255, 192, 16)
            shadowColor = Color3.fromRGB(234, 160, 19)
            strokeColor = Color3.fromRGB(234, 160, 19)
        end
    else
        equipText = "Scrap"
        backgroundColor = Color3.fromRGB(255, 192, 16)
        shadowColor = Color3.fromRGB(234, 160, 19)
        strokeColor = Color3.fromRGB(234, 160, 19)
    end

    scrapButton.ScrapText.Text = equipText
    scrapButton.BackgroundColor3 = backgroundColor
    scrapButton.Shadow.BackgroundColor3 = shadowColor
    scrapButton.ScrapText.UIStroke.Color = strokeColor

end

function ButtonStatus:Upgrade(player, currentUpgrade, purchaseButton)

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
        backgroundColor = Color3.fromRGB(85, 170, 127)
        shadowColor = Color3.fromRGB(34, 68, 50)
        strokeColor = Color3.fromRGB(34, 68, 50)
        purchaseButton.PriceFrame.CurrencyIcon.Visible = true
    end
    purchaseButton.BackgroundColor3 = backgroundColor
    purchaseButton.Shadow.BackgroundColor3 = shadowColor
    purchaseButton.PriceFrame.PriceText.UIStroke.Color = strokeColor
end


return ButtonStatus