local Handlers = script.Parent.Parent.Handlers
local AccessoryHandler = require(Handlers.AccessoryHandler)
local ConvertPerSecondHandler = require(Handlers.ConvertPerSecondHandler)
local DisplayNameHandler = require(Handlers.DisplayNameHandler)
local ExchangeTixHandler = require(Handlers.ExchangeTixHandler)
local PlayerCollisionHandler = require(Handlers.PlayerCollisionHandler)
local PlaytimeHandler = require(Handlers.PlaytimeHandler)
local TixPerSecondHandler = require(Handlers.TixPerSecondHandler)
local TixRageMeterHandler = require(Handlers.TixRageMeterHandler)
local TeleportHandler = require(Handlers.TeleportHandler)
local LeaderboardHandler = require(Handlers.LeaderboardHandler)

local HandlersLoader = {}

function HandlersLoader:Init()
  print("INIT")
  AccessoryHandler:Init()
  ConvertPerSecondHandler:Init()
  DisplayNameHandler:Init()
  ExchangeTixHandler:Init()
  PlayerCollisionHandler:Init()
  PlaytimeHandler:Init()
  TixPerSecondHandler:Init()
  TixRageMeterHandler:Init()
  TeleportHandler:Init()
  LeaderboardHandler:Init()
end

return HandlersLoader
