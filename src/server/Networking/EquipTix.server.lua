---- Services ----

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

---- Data ----

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local Upgrades = require(ReplicatedStorage.Data.Upgrades)

---- Private Functions ----

local function equipTool(player, tool)
    local character = player.Character
    local rightHand = character.RightHand
    local toolClone = tool:Clone()
    toolClone.Name = "Upgrade"
    toolClone.Parent = rightHand

    local weld = Instance.new("Weld")
	weld.Name = "UpgradeWeld"
	weld.Part0 = toolClone
	weld.Part1 = rightHand
	weld.C0 = weld.Part0.RightGripAttachment.CFrame
	weld.C1 = weld.Part1.RightGripAttachment.CFrame
	weld.Parent = toolClone
end

local function unequipTool(player)
    local character = player.Character
    local rightHand = character.RightHand

    local tool = rightHand:FindFirstChild("Upgrade")
    if tool then
        tool:Destroy()
    end
end

---- Networking ----

local Networking = ReplicatedStorage.Networking
local EquipTixRemote = Networking.EquipTix

EquipTixRemote.OnServerEvent:Connect(function(player, upgradeName)
    local data = ProfileCacher:GetProfile(player).Data
    local upgrade = Upgrades[upgradeName]
    if table.find(data.Upgrades, upgradeName) then
        if data.ToolEquipped ~= upgradeName then
            unequipTool(player)
        end
        local tool = upgrade.Tool
        equipTool(player, tool)
        data.ToolEquipped = upgradeName
    end
end)

---- Setup ----

local function animateTool(player)
	local character = player.Character
	local humanoid = character.Humanoid
	
	local animationTrack = humanoid:LoadAnimation(character.Animate.toolnone.ToolNoneAnim) 
	animationTrack:Play()
end

local function playerAdded(player)
    local data = ProfileCacher:GetProfile(player).Data
    local upgradeName = data.ToolEquipped
    local upgrade = Upgrades[upgradeName]
    local tool = upgrade.Tool
    equipTool(player, tool)
    animateTool(player)
end 

game.Players.PlayerAdded:Connect(playerAdded)
