---- Services ----

local ReplicatedStorage = game:GetService("ReplicatedStorage")

---- Data ----

local DataModules = script.Parent.Parent.Data
local GlobalData = require(DataModules.GlobalData)

---- Networking ----

local Networking = ReplicatedStorage.Networking
local GetAccessoryCountRemote = Networking.GetAccessoryCount

---- Private Functions ---- 

GetAccessoryCountRemote.OnServerInvoke = function(player, accessoryID)
    return GlobalData:GetAccessoryCount(accessoryID)
end

--- Initialize ----

GlobalData:Init()

spawn(function()
    while task.wait(1) do
        local data = GlobalData:GetQueue()
        if #data > 0 then
            print(data)
        end
    end
end)
