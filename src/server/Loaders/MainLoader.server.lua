local DataModules = script.Parent.Parent.Data
local ProfileCacher = require(DataModules.ProfileCacher)
local HandlersLoader = require(script.Parent.HandlersLoader)
ProfileCacher:Init()
HandlersLoader:Init()