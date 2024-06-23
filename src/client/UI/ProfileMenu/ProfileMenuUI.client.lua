---- Services ----

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TweenButton = require(Modules.TweenButton)
local SuffixHandler = require(Modules.SuffixHandler)

---- Data ----

local ReplicatedData = Player:WaitForChild("ReplicatedData")

local JoinTime = ReplicatedData["Join Time"]
local LifetimeTix = ReplicatedData["Lifetime Tix"]
local LifetimeRocash = ReplicatedData["Lifetime Rocash"]
local LifetimeRebirthTix = ReplicatedData["Lifetime Rebirth Tix"]
local LifetimeValue = ReplicatedData["Lifetime Value"]
local LifetimeCases = ReplicatedData["Lifetime Cases"]
--local LifetimeScrapped = ReplicatedData["Lifetime Scrapped"]
local LifetimeMaterials = ReplicatedData["Lifetime Materials"]
local LifetimeRobuxSpent = ReplicatedData["Lifetime Robux Spent"]
local LifetimePlaytime = ReplicatedData["Lifetime Playtime"]

---- UI ----

local PlayerGui = Player.PlayerGui
local UI = PlayerGui:WaitForChild("UI")

local Buttons = UI.Buttons
local ProfileMenu = UI.ProfileMenu
local Stats = ProfileMenu.StatsFrame.Holder

local JoinTimeHolder = Stats.JoinDate
local TixHolder = Stats.TixEarned
local RocashHolder = Stats.RocashEarned
local RebirthTixHolder = Stats.RebirthTixEarned
local ValueHolder = Stats.ValueEarned
local CasesHolder = Stats.CasesOpened
local MaterialsHolder = Stats.MaterialsEarned
local RobuxHolder = Stats.RobuxSpent
local TimeHolder = Stats.TimePlayed

---- UI Values ----

local UIVisible = UI.UIVisible
local CurrentUI = UI.CurrentUI

local UIFrames = {
    TixInventory = UI.TixInventory,
    CaseInventory = UI.CaseInventory,
    AccessoryInventory = UI.AccessoryInventory,
    ProfileMenu = UI.ProfileMenu,
    SettingsMenu = UI.SettingsMenu,
    --RewardsMenu = UI.RewardsMenu,
    --QuestsMenu = UI.QuestsMenu,
    --ShopMenu = UI.ShopMenu,
}

---- Sound ----

local Sounds = Player:WaitForChild("Sounds")
local ClickSound = Sounds:WaitForChild("ClickSound")

---- Private Functions ----

local function updateJoinTimeHolder()
    local dateTable = os.date("*t", JoinTime.Value) -- Convert timestamp to table

    local month = dateTable.month
    local day = dateTable.day
    local year = dateTable.year

    JoinTimeHolder.ValueText.Text = month .. "/" .. day .. "/" .. year
end
JoinTime.Changed:Connect(updateJoinTimeHolder)

local function updateTixHolder()
    TixHolder.ValueText.Text = SuffixHandler:Convert(LifetimeTix.Value)
end
LifetimeTix.Changed:Connect(updateTixHolder)

local function updateRocashHolder()
    RocashHolder.ValueText.Text = SuffixHandler:Convert(LifetimeRocash.Value)
end
LifetimeRocash.Changed:Connect(updateRocashHolder)

local function updateRebirthTixHolder()
    RebirthTixHolder.ValueText.Text = SuffixHandler:Convert(LifetimeRebirthTix.Value)
end
LifetimeRebirthTix.Changed:Connect(updateRebirthTixHolder)

local function updateValueHolder()
    ValueHolder.ValueText.Text = SuffixHandler:Convert(LifetimeValue.Value)
end
LifetimeValue.Changed:Connect(updateValueHolder)

local function updateCasesHolder()
    CasesHolder.ValueText.Text = SuffixHandler:Convert(LifetimeCases.Value)
end
LifetimeCases.Changed:Connect(updateCasesHolder)

local function updateMaterialsHolder()
    MaterialsHolder.ValueText.Text = SuffixHandler:Convert(LifetimeMaterials.Value)
end
LifetimeMaterials.Changed:Connect(updateMaterialsHolder)

local function updateRobuxHolder()
    RobuxHolder.ValueText.Text = SuffixHandler:Convert(LifetimeRobuxSpent.Value)
end
LifetimeRobuxSpent.Changed:Connect(updateRobuxHolder)

local function updateTimeHolder()
    local playtimeSeconds = LifetimePlaytime.Value
    local days = math.floor(playtimeSeconds / (24 * 3600))
    playtimeSeconds = playtimeSeconds % (24 * 3600)
    local hours = math.floor(playtimeSeconds / 3600)
    playtimeSeconds = playtimeSeconds % 3600
    local minutes = math.floor(playtimeSeconds / 60)
    local seconds = playtimeSeconds % 60

    TimeHolder.ValueText.Text = string.format("%d:%02d:%02d:%02d", days, hours, minutes, seconds)
end
LifetimePlaytime.Changed:Connect(updateTimeHolder)

local function init()
    updateTixHolder()
    updateJoinTimeHolder()
    updateRocashHolder()
    updateRebirthTixHolder()
    updateValueHolder()
    updateCasesHolder()
    updateMaterialsHolder()
    updateRobuxHolder()
    updateTimeHolder()
end
init()

---- Buttons ----

local ExitButton = ProfileMenu.ExitButton
local ProfileButton = Buttons.ProfileButton

local EXITBUTTON_ORIGINALSIZE = ExitButton.Size
local PROFILEBUTTON_ORIGINALSIZE = ProfileButton.UIScale.Scale

local function playClickSound()
    SoundService:PlayLocalSound(ClickSound)
end

local function exitHover()
    TweenButton:Grow(ExitButton, EXITBUTTON_ORIGINALSIZE)
end

local function exitLeave()
    TweenButton:Reset(ExitButton, EXITBUTTON_ORIGINALSIZE)
end

local function exitMouseDown()
    playClickSound()
    TweenButton:Shrink(ExitButton, EXITBUTTON_ORIGINALSIZE)
    ProfileMenu:TweenPosition(UDim2.new(0.5, 0, 2, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
    CurrentUI.Value = ""
    UIVisible.Value = false
end

local function exitMouseUp()
    TweenButton:Reset(ExitButton, EXITBUTTON_ORIGINALSIZE)
end

local function profileHover()
    TweenButton:Grow(ProfileButton.UIScale, PROFILEBUTTON_ORIGINALSIZE)
end

local function profileLeave()
    TweenButton:Reset(ProfileButton.UIScale, PROFILEBUTTON_ORIGINALSIZE)
end

local function profileMouseDown()
    playClickSound()
    TweenButton:Shrink(ProfileButton.UIScale, PROFILEBUTTON_ORIGINALSIZE)

    if CurrentUI.Value ~= "ProfileMenu" then
        if CurrentUI.Value == "RebirthMenu" or CurrentUI.Value == "ScrapMenu" then
            return
        end
            ProfileMenu:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
            local currentFrame = UIFrames[CurrentUI.Value]
            if currentFrame then
                currentFrame:TweenPosition(UDim2.new(0.5, 0, 2, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
            end
            CurrentUI.Value = "ProfileMenu"
            UIVisible.Value = true
    else
        ProfileMenu:TweenPosition(UDim2.new(0.5, 0, 2, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
        CurrentUI.Value = ""
        UIVisible.Value = false
    end
end

local function profileMouseUp()
    TweenButton:Reset(ProfileButton.UIScale, PROFILEBUTTON_ORIGINALSIZE)
end


ExitButton.ClickDetector.MouseEnter:Connect(exitHover)
ExitButton.ClickDetector.MouseLeave:Connect(exitLeave)
ExitButton.ClickDetector.MouseButton1Down:Connect(exitMouseDown)
ExitButton.ClickDetector.MouseButton1Up:Connect(exitMouseUp)

ProfileButton.ClickDetector.MouseEnter:Connect(profileHover)
ProfileButton.ClickDetector.MouseLeave:Connect(profileLeave)
ProfileButton.ClickDetector.MouseButton1Down:Connect(profileMouseDown)
ProfileButton.ClickDetector.MouseButton1Up:Connect(profileMouseUp)


