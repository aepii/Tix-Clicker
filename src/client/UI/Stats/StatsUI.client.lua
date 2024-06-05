---- Services ----

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

---- Modules ----

local Modules = ReplicatedStorage:WaitForChild("Modules")
local TemporaryData = require(Modules:WaitForChild("TemporaryData"))

---- Data ----

local ReplicatedData = Player:WaitForChild("ReplicatedData")
local ReplicatedTemporaryData = Player:WaitForChild("TemporaryData")
local leaderstats = Player:WaitForChild("leaderstats")

local TixLeaderstat = leaderstats[TemporaryData:GetLeaderstatDisplayName("Tix")]
local RocashLeaderstat = leaderstats[TemporaryData:GetLeaderstatDisplayName("Rocash")]
local RebirthTixLeaderstat = leaderstats[TemporaryData:GetLeaderstatDisplayName("Rebirth Tix")]

local TixStorage = ReplicatedTemporaryData.TixStorage
local Tix = ReplicatedData.Tix

---- UI ----

local PlayerGui = Player.PlayerGui
local UI = PlayerGui:WaitForChild("UI")

local Stats = UI.Stats
local TixHolder = Stats["1"]
local RocashHolder = Stats["2"]
local RebirthTixHolder = Stats["3"]

---- Private Functions ----

local function animateTixBar()
    TixHolder.TixBar:TweenSize(UDim2.new(math.min((Tix.Value/TixStorage.Value)*0.95, 0.95), 0, 0.7, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
end

local function updateTixHolder()
    TixHolder.Amount.Text = TixLeaderstat.Value
    animateTixBar()
end

TixLeaderstat.Changed:Connect(updateTixHolder)

local function updateRocashHolder()
    RocashHolder.Amount.Text = RocashLeaderstat.Value
end

RocashLeaderstat.Changed:Connect(updateRocashHolder)

local function updateRebirthTixHolder()
    RebirthTixHolder.Amount.Text = RebirthTixLeaderstat.Value
end

RebirthTixLeaderstat.Changed:Connect(updateRebirthTixHolder)

---- Initialize ----

local function init()
    updateTixHolder()
    updateRocashHolder()
    updateRebirthTixHolder()
end

init()



