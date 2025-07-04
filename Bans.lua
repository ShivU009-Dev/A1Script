local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Your UserId only
if LocalPlayer.UserId ~= 8791237630 then return end

-- RemoteEvents
local BanRemote = ReplicatedStorage:WaitForChild("BanMisuser")
local KickRemote = ReplicatedStorage:WaitForChild("AdminKick")
local KillRemote = ReplicatedStorage:WaitForChild("AdminKill")

-- Create GUI
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "AdminControlMenu"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0, 10, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 5)

-- Create button row for each player
local function createPlayerRow(targetPlayer)
	if targetPlayer == LocalPlayer then return end

	local row = Instance.new("Frame", frame)
	row.Size = UDim2.new(1, 0, 0, 40)
	row.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

	local nameLabel = Instance.new("TextLabel", row)
	nameLabel.Text = targetPlayer.Name
	nameLabel.Size = UDim2.new(0.4, 0, 1, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextColor3 = Color3.new(1, 1, 1)
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left

	local killBtn = Instance.new("TextButton", row)
	killBtn.Size = UDim2.new(0.2, 0, 1, 0)
	killBtn.Position = UDim2.new(0.4, 0, 0, 0)
	killBtn.Text = "Kill"
	killBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
	killBtn.TextColor3 = Color3.new(1, 1, 1)
	killBtn.MouseButton1Click:Connect(function()
		KillRemote:FireServer(targetPlayer.Name)
	end)

	local kickBtn = Instance.new("TextButton", row)
	kickBtn.Size = UDim2.new(0.2, 0, 1, 0)
	kickBtn.Position = UDim2.new(0.6, 0, 0, 0)
	kickBtn.Text = "Kick"
	kickBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
	kickBtn.TextColor3 = Color3.new(1, 1, 1)
	kickBtn.MouseButton1Click:Connect(function()
		KickRemote:FireServer(targetPlayer.Name)
	end)

	local banBtn = Instance.new("TextButton", row)
	banBtn.Size = UDim2.new(0.2, 0, 1, 0)
	banBtn.Position = UDim2.new(0.8, 0, 0, 0)
	banBtn.Text = "Ban"
	banBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	banBtn.TextColor3 = Color3.new(1, 1, 1)
	banBtn.MouseButton1Click:Connect(function()
		BanRemote:FireServer("manual", targetPlayer.UserId)
	end)
end

-- Create UI for all players
for _, p in ipairs(Players:GetPlayers()) do
	createPlayerRow(p)
end

-- Add new players when they join
Players.PlayerAdded:Connect(function(p)
	task.wait(1)
	createPlayerRow(p)
end)
