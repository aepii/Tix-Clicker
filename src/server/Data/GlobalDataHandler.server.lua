---- Services ----

local ReplicatedStorage = game:GetService("ReplicatedStorage")

---- Data ----

local GlobalData = require(script.Parent.GlobalData)

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
        print(data)
    end
end)
