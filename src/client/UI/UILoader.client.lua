---- Services ----

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UI = ReplicatedStorage:WaitForChild("UI")

---- Loaded Modules ----
local SoundLoader = require(UI:WaitForChild("SoundLoader"))

local AccessoryInventoryUI = require(UI:WaitForChild("AccessoryInventory"):WaitForChild("AccessoryInventoryUI"))
local AchievementsMenuUI = require(UI:WaitForChild("AchievementsMenu"):WaitForChild("AchievementsMenuUI"))
local BottomBarUI = require(UI:WaitForChild("BottomBar"):WaitForChild("BottomBarUI"))
local CartoonCircleUI = require(UI:WaitForChild("CartoonCircle"):WaitForChild("CartoonCircleUI"))
local CaseInventoryUI = require(UI:WaitForChild("CaseInventory"):WaitForChild("CaseInventoryUI"))
local CaseOpeningUI = require(UI:WaitForChild("CaseOpening"):WaitForChild("CaseOpeningUI"))
local MaterialsInventoryUI = require(UI:WaitForChild("MaterialsInventory"):WaitForChild("MaterialsInventoryUI"))
local PortalsUI = require(UI:WaitForChild("Portals"):WaitForChild("PortalsUI"))
local ProfileMenuUI = require(UI:WaitForChild("ProfileMenu"):WaitForChild("ProfileMenuUI"))
local RebirthMenuUI = require(UI:WaitForChild("RebirthMenu"):WaitForChild("RebirthMenuUI"))
local ScrapMenuUI = require(UI:WaitForChild("ScrapMenu"):WaitForChild("ScrapMenuUI"))
local SettingsMenuUI = require(UI:WaitForChild("SettingsMenu"):WaitForChild("SettingsMenuUI"))
local ShopMenuUI = require(UI:WaitForChild("ShopMenu"):WaitForChild("ShopMenuUI"))
local StatsUI = require(UI:WaitForChild("Stats"):WaitForChild("StatsUI"))
local TixInventoryUI = require(UI:WaitForChild("TixInventory"):WaitForChild("TixInventoryUI"))
local LeaderboardsUI = require(UI:WaitForChild("Leaderboards"):WaitForChild("LeaderboardsUI"))

---- Networking ----

local Networking = ReplicatedStorage.Networking
local LoadUI = Networking.LoadUI

---- UILoader ----

LoadUI.OnClientEvent:Connect(function()
  print("Loading Sounds")
  SoundLoader:Init()
  print("Loading UI")
  AccessoryInventoryUI:Init()
  AchievementsMenuUI:Init()
  BottomBarUI:Init()
  CartoonCircleUI:Init()
  CaseInventoryUI:Init()
  CaseOpeningUI:Init()
  MaterialsInventoryUI:Init()
  PortalsUI:Init()
  ProfileMenuUI:Init()
  RebirthMenuUI:Init()
  ScrapMenuUI:Init()
  SettingsMenuUI:Init()
  ShopMenuUI:Init()
  StatsUI:Init()
  TixInventoryUI:Init()
  LeaderboardsUI:Init()
  print("Finished Loading UI")
end)
