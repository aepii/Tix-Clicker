---- Services ----

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TemporaryData = require(Modules.TemporaryData)

---- Data ----

local ReplicatedTemporaryData = Player:WaitForChild("TemporaryData")
local ReplicatedData = Player:WaitForChild("ReplicatedData")
local leaderstats = Player:WaitForChild("leaderstats")

local Tix = leaderstats[TemporaryData:GetDisplayName("Tix")]
local Rocash = leaderstats[TemporaryData:GetDisplayName("Rocash")]

---- UI ----

local PlayerGui = Player.PlayerGui
local UI = PlayerGui:WaitForChild("UI")

local Stats = UI.Stats
local TixHolder = Stats["1"]
local RocashHolder = Stats["2"]

---- Private Functions ----

local function animateTixBar()
    local tixStorage = ReplicatedTemporaryData.TixStorage
    local tix = ReplicatedData.Tix
    TixHolder.TixBar:TweenSize(UDim2.new((tix.Value/tixStorage.Value)*0.95, 0, 0.7, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, 0.1, true)
end


local function updateTixHolder()
    TixHolder.Amount.Text = Tix.Value
    animateTixBar()
end

Tix.Changed:Connect(updateTixHolder)

local function updateRocashHolder()
    RocashHolder.Amount.Text = Rocash.Value
end

Rocash.Changed:Connect(updateRocashHolder)

local function init()
    updateTixHolder()
    updateRocashHolder()
end

init()



