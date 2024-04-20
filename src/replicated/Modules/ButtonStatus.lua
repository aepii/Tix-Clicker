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

function ButtonStatus:Upgrade(player, currentUpgrade, purchaseButton)
    local upgradeEquipped = player.ReplicatedData.Upgrades
    local priceFrame, backgroundColor, shadowColor, strokeColor

    if upgradeEquipped:FindFirstChild(currentUpgrade) then
        priceFrame = "Owned"
        backgroundColor = Color3.fromRGB(82, 81, 81)
        shadowColor = Color3.fromRGB(36, 35, 35)
        strokeColor = Color3.fromRGB(36, 35, 35)
        purchaseButton.PriceFrame.PriceText.Text = priceFrame
        purchaseButton.PriceFrame.PriceText.Position = UDim2.new(0.5, 0, 0.5, 0)
        purchaseButton.PriceFrame.CurrencyIcon.Visible = false
    else
        backgroundColor = Color3.fromRGB(85, 170, 127)
        shadowColor = Color3.fromRGB(34, 68, 50)
        strokeColor = Color3.fromRGB(34, 68, 50)
        purchaseButton.PriceFrame.PriceText.Position = UDim2.new(0.6, 0, 0.5, 0)
        purchaseButton.PriceFrame.CurrencyIcon.Visible = true
    end
    purchaseButton.BackgroundColor3 = backgroundColor
    purchaseButton.Shadow.BackgroundColor3 = shadowColor
    purchaseButton.PriceFrame.PriceText.UIStroke.Color = strokeColor
end

function ButtonStatus:ValueUpgrade(player, currentUpgrade, purchaseButton)
    local upgradeEquipped = player.ReplicatedData.Upgrades
    local priceFrame, backgroundColor, shadowColor, strokeColor

    if upgradeEquipped:FindFirstChild(currentUpgrade) then
        priceFrame = "Owned"
        backgroundColor = Color3.fromRGB(82, 81, 81)
        shadowColor = Color3.fromRGB(36, 35, 35)
        strokeColor = Color3.fromRGB(36, 35, 35)
        purchaseButton.PriceFrame.PriceText.Text = priceFrame
        purchaseButton.PriceFrame.PriceText.Position = UDim2.new(0.5, 0, 0.5, 0)
        purchaseButton.PriceFrame.CurrencyIcon.Visible = false
    else
        backgroundColor = Color3.fromRGB(85, 170, 127)
        shadowColor = Color3.fromRGB(34, 68, 50)
        strokeColor = Color3.fromRGB(34, 68, 50)
        purchaseButton.PriceFrame.PriceText.Position = UDim2.new(0.6, 0, 0.5, 0)
        purchaseButton.PriceFrame.CurrencyIcon.Visible = true
    end
    purchaseButton.BackgroundColor3 = backgroundColor
    purchaseButton.Shadow.BackgroundColor3 = shadowColor
    purchaseButton.PriceFrame.PriceText.UIStroke.Color = strokeColor
end

return ButtonStatus