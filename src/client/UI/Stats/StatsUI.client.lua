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
local TixStorage = ReplicatedTemporaryData.TixStorage

---- UI ----

local PlayerGui = Player.PlayerGui
local UI = PlayerGui:WaitForChild("UI")

local Stats = UI.Stats
local TixHolder = Stats["1"]
local RocashHolder = Stats["2"]

---- Private Functions ----

local function animateTixBar()
    local tix = ReplicatedData.Tix
    TixHolder.TixBar:TweenSize(UDim2.new(math.min((tix.Value/TixStorage.Value)*0.95, 0.95), 0, 0.7, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
end


local function updateTixHolder()
    TixHolder.Amount.Text = Tix.Value
    animateTixBar()
end

Tix.Changed:Connect(updateTixHolder)
TixStorage.Changed:Connect(updateTixHolder)

local function updateRocashHolder()
    RocashHolder.Amount.Text = Rocash.Value
end

Rocash.Changed:Connect(updateRocashHolder)

local function init()
    updateTixHolder()
    updateRocashHolder()
end

init()



