local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Accessories = require(ReplicatedStorage.Data.Accessories)
local Player = game.Players.LocalPlayer

local Modules = ReplicatedStorage:WaitForChild("Modules")
local SuffixHandler = require(Modules.SuffixHandler)

local Button = script.Parent
local Icon = Button.ImageLabel
local Icon_OriginalSize = Icon.Size
local Icon_Scale = 1.25
local Icon_Time = 0.1

local ClickSound = Button.Parent.Parent.Parent.ClickSound

local Frame = Button.Parent.Parent.Parent.EquipFrame
local InvFrame = Button.Parent.Parent.Parent.InvFrame

local function equipStatus(ID, GUID)
    for _, accessory in Player.ReplicatedData.EquippedAccessories:GetChildren() do
        if accessory.Name == ID and accessory.Value == GUID then
            Frame.EquipButton.EquipText.Text = "Unequip"
            Frame.EquipButton.BackgroundColor3 = Color3.fromRGB(170, 85, 89)
            Frame.EquipButton.Shadow.BackgroundColor3 = Color3.fromRGB(102, 63, 64)
            Frame.EquipButton.EquipText.UIStroke.Color = Color3.fromRGB(102, 63, 64)
            return
        end
    end
    Frame.EquipButton.EquipText.Text = "Equip"
    Frame.EquipButton.BackgroundColor3 = Color3.fromRGB(85, 170, 127)
    Frame.EquipButton.Shadow.BackgroundColor3 = Color3.fromRGB(34, 68, 50)
    Frame.EquipButton.EquipText.UIStroke.Color = Color3.fromRGB(34, 68, 50)
end

local function updateEquipFrame()
    local GUID = script.Parent.Name
    local ID = Player.ReplicatedData.Accessories[GUID].Value
    local accessory = Accessories[ID]

    for _, rewardFrame in Frame.RewardsFrame:GetChildren() do
        if rewardFrame:IsA("Frame") then
            local reward = accessory.Reward[rewardFrame.Name]
            if reward then
                if string.find(rewardFrame.Name, "Add") then
                    prefix = "+" 
                elseif string.find(rewardFrame.Name, "Mult") then
                    prefix = "x"
                end
                Frame.CurrentGUID.Value = GUID
                rewardFrame.RewardText.Text = prefix .. SuffixHandler:Convert(reward)
                rewardFrame.Visible = true
                rewardFrame.Parent = Frame.RewardsFrame
            else
                rewardFrame.Visible = false
            end
            equipStatus(ID, GUID)
        end
    end

    Frame.ItemName.Title.Text = accessory.Name
    Frame.Icon.ImageLabel.Image = "http://www.roblox.com/Thumbs/Asset.ashx?Width=256&Height=256&AssetID="..accessory.AssetID
end

local function iconMouseDown()
    ClickSound:Play()
    local newScaledSize = UDim2.new(
        Icon_OriginalSize.X.Scale / Icon_Scale,
        0,
        Icon_OriginalSize.Y.Scale / Icon_Scale,
        0
    )
    Icon:TweenSize(newScaledSize, Enum.EasingDirection.In, Enum.EasingStyle.Quad, Icon_Time, true)
end

local function iconMouseUp()
    Icon:TweenSize(Icon_OriginalSize, Enum.EasingDirection.In, Enum.EasingStyle.Quad, Icon_Time, true)
    Frame:TweenPosition(UDim2.new(0,0,.5,0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, Icon_Time, true)
    InvFrame:TweenPosition(UDim2.new(0.6,0,0.56,0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, Icon_Time, true)
    updateEquipFrame()
end

local function iconHover()
    local newScaledSize = UDim2.new(
        Icon_OriginalSize.X.Scale * Icon_Scale,
        0,
        Icon_OriginalSize.Y.Scale * Icon_Scale,
        0
    )
    print(newScaledSize)
    Icon:TweenSize(newScaledSize, Enum.EasingDirection.In, Enum.EasingStyle.Quad, Icon_Time, true)
end

local function iconLeave()
    Icon:TweenSize(Icon_OriginalSize, Enum.EasingDirection.In, Enum.EasingStyle.Quad, Icon_Time, true)
end

Button.ClickDetector.MouseEnter:Connect(iconHover)
Button.ClickDetector.MouseLeave:Connect(iconLeave)
Button.ClickDetector.MouseButton1Down:Connect(iconMouseDown)
Button.ClickDetector.MouseButton1Up:Connect(iconMouseUp)