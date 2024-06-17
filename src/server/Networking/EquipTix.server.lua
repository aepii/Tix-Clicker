---- Services ----

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

---- Data ----

local ProfileCacher = require(ServerScriptService.Data.ProfileCacher)
local DataManager = require(ServerScriptService.Data.DataManager)
local Upgrades = require(ReplicatedStorage.Data.Upgrades)

---- Private Functions ----

function equipTool(player, tool)
    local character = player.Character or player.CharacterAdded:Wait()
    local rightHand = character:WaitForChild("RightHand")
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

function unequipTool(player)
    local character = player.Character or player.CharacterAdded:Wait()
    local rightHand = character:WaitForChild("RightHand")

    local tool = rightHand:FindFirstChild("Upgrade")
    if tool then
        tool:Destroy()
    end
end

---- Networking ----

local Networking = ReplicatedStorage.Networking
local EquipTixRemote = Networking.EquipTix

EquipTixRemote.OnServerInvoke = (function(player, upgradeID)
    local profile = ProfileCacher:GetProfile(player)
    local data = profile.Data

    local upgrade = Upgrades[upgradeID]

    local temporaryData = player.TemporaryData

    if temporaryData.ActiveCaseOpening.Value == false then
        if table.find(data.Upgrades, upgradeID) then
            if data.ToolEquipped ~= upgradeID then
                DataManager:SetValue(player, profile, {"ToolEquipped"}, upgradeID)
                unequipTool(player)
                local tool = upgrade.Tool
                equipTool(player, tool)
                return true
            end
        end
    end
end)

local BindableEquipTix = Networking.BindableEquipTix

BindableEquipTix.Event:Connect(function(player, upgradeID)
    unequipTool(player)
    local tool = Upgrades[upgradeID].Tool
    equipTool(player, tool)
end)


---- Setup ----

local function animateTool(player)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
	local animator = humanoid:FindFirstChildOfClass("Animator")

	local animationTrack = animator:LoadAnimation(character.Animate.toolnone.ToolNoneAnim)
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
