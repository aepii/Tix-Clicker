---- Services ----
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")

---- Data ----
local AccessoryDataStore = DataStoreService:GetDataStore("AccessoryCounts1")

---- Global Data Module ----
local GlobalData = {}
GlobalData.queue = {}
GlobalData.saving = false

function GlobalData:Init()
	print("[GLOBAL DATA]: Initialized.")
    -- Start the periodic save loop
    spawn(function()
        while task.wait(10) do
			print("[GLOBAL DATA]: Processing queue.")
            self:ProcessQueue()
        end
    end)
    
    -- Bind the save function to server shutdown
    if RunService:IsServer() then
        game:BindToClose(function()
			print("[GLOBAL DATA]: Processing queue.")
            self:ProcessQueue()
        end)
    end
end

function GlobalData:QueueAccessoryCountUpdate(accessoryID, count)
	print("[GLOBAL DATA]: Queued x"..count.." "..accessoryID..".")
    self.queue[accessoryID] = (self.queue[accessoryID] or 0) + count
end

function GlobalData:ProcessQueue()
    if self.saving then return end
    self.saving = true
    
    for accessoryID, count in pairs(self.queue) do
        local success, result = pcall(function()
            return AccessoryDataStore:UpdateAsync(accessoryID, function(currentCount)
                currentCount = currentCount or 0
                return currentCount + count
            end)
        end)
        
        if success then
            print("Successfully updated count for " .. accessoryID .. ": " .. result)
            self.queue[accessoryID] = nil 
        else
            warn("Failed to update count for " .. accessoryID .. ": " .. result)
        end
    end
    
    self.saving = false
end

function GlobalData:GetAccessoryCount(accessoryID)
    local success, result = pcall(function()
        return AccessoryDataStore:GetAsync(accessoryID)
    end)
    
    if success then
        print("Current count for " .. accessoryID .. ": " .. (result or 0))
        return result or 0
    else
        warn("Failed to get count for " .. accessoryID .. ": " .. result)
        return 0
    end
end

function GlobalData:GetQueue()
    return self.queue
end


return GlobalData
