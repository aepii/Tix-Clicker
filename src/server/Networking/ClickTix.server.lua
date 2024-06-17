---- Services ----

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

---- Modules ----

local Modules = ReplicatedStorage.Modules
local TemporaryData = require(Modules.TemporaryData)

---- Data ----

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local DataManager = require(ServerScriptService.Data.DataManager)
local Upgrades = require(ReplicatedStorage.Data.Upgrades)

---- Networking ----

local Networking = ReplicatedStorage.Networking
local ClickTixRemote = Networking.ClickTix

---- Private Functions ----

local function isCrit(critChance)
    local randomNumber = math.random() * 1000

    if critChance*10 >= randomNumber then
        return true
    else
        return false
    end
end

ClickTixRemote.OnServerInvoke = (function(player)
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data

    local temporaryData = player.TemporaryData
    local lastClickTime = player.TemporaryData.LastClickTime

    local tixStorage = TemporaryData:CalculateTixStorage(player, data)
    local tixPerClick = TemporaryData:CalculateTixPerClick(player, data)
    
    local elapsedTime = os.clock() - lastClickTime.Value 
    local tixValue;


    if temporaryData.ActiveCaseOpening.Value == false then
        if elapsedTime >= (1/temporaryData.ClickRate.Value) then
            lastClickTime.Value = os.clock()
            if data.Tix < tixStorage then
                
                local crit = isCrit(temporaryData.CriticalChance.Value)
                if crit then
                    tixPerClick *= (TemporaryData:CalculateCriticalPower(player, data) / 100) + 1
                    tixValue = math.min(data.Tix + tixPerClick, tixStorage)
                else
                    tixValue = math.min(data.Tix + tixPerClick, tixStorage)
                end

                DataManager:SetValue(player, profile, {"Tix"}, tixValue)
                DataManager:SetValue(player, profile, {"Lifetime Tix"}, tixValue)

                DataManager:UpdateLeaderstats(player, profile, "Tix")
                
                if player.TemporaryData.RageMode.Value == false then
                    temporaryData.XP.Value = math.min(temporaryData.XP.Value + 1, temporaryData.RequiredXP.Value)
                end
                
                return tixPerClick, crit
            end
        end
    end
    return
end)
