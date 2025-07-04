-- 🔒 SETTINGS
local ADMIN_USER_ID = 8791237630 -- <<== Replace with YOUR UserId

-- SERVICES
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

-- 🔒 Ban List (memory-based)
local BanList = {}

-- 🔁 Auto-kick banned players
Players.PlayerAdded:Connect(function(player)
	if BanList[player.UserId] then
		player:Kick("You are banned from this game.")
	end
end)

-- 🧠 Function to create the admin UI for the admin player
local function createAdminMenu(admin)
	local gui = Instance.new("ScreenGui")
	gui.Name = "AdminMenu"
	gui.ResetOnSpawn = false

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 300, 0, 400)
	frame.Position = UDim2.new(0, 20, 0, 100)
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	frame.Parent = gui

	local list = Instance.new("UIListLayout", frame)
	list.Padding = UDim.new(0, 5)

	-- Creates row for each player
	local function addPlayerRow(target)
		if target == admin then return end

		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, 0, 0, 40)
		row.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		row.Parent = frame

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Text = target.Name
		nameLabel.Size = UDim2.new(0.4, 0, 1, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.TextColor3 = Color3.new(1, 1, 1)
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left
		nameLabel.Parent = row

		local killBtn = Instance.new("TextButton")
		killBtn.Size = UDim2.new(0.2, 0, 1, 0)
		killBtn.Position = UDim2.new(0.4, 0, 0, 0)
		killBtn.Text = "Kill"
		killBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
		killBtn.TextColor3 = Color3.new(1, 1, 1)
		killBtn.Parent = row
		killBtn.MouseButton1Click:Connect(function()
			if target.Character and target.Character:FindFirstChild("Humanoid") then
				target.Character.Humanoid.Health = 0
			end
		end)

		local kickBtn = Instance.new("TextButton")
		kickBtn.Size = UDim2.new(0.2, 0, 1, 0)
		kickBtn.Position = UDim2.new(0.6, 0, 0, 0)
		kickBtn.Text = "Kick"
		kickBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
		kickBtn.TextColor3 = Color3.new(1, 1, 1)
		kickBtn.Parent = row
		kickBtn.MouseButton1Click:Connect(function()
			target:Kick("You have been kicked by the admin.")
		end)

		local banBtn = Instance.new("TextButton")
		banBtn.Size = UDim2.new(0.2, 0, 1, 0)
		banBtn.Position = UDim2.new(0.8, 0, 0, 0)
		banBtn.Text = "Ban"
		banBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		banBtn.TextColor3 = Color3.new(1, 1, 1)
		banBtn.Parent = row
		banBtn.MouseButton1Click:Connect(function()
			BanList[target.UserId] = true
			target:Kick("You have been banned by the admin.")
		end)
	end

	-- Add all players
	for _, p in ipairs(Players:GetPlayers()) do
		addPlayerRow(p)
	end

	-- Add new player rows when players join
	Players.PlayerAdded:Connect(function(p)
		wait(1)
		if admin and admin.Parent then
			addPlayerRow(p)
		end
	end)

	gui.Parent = admin:WaitForChild("PlayerGui")
end

-- 🧠 When admin joins, give them the menu
Players.PlayerAdded:Connect(function(player)
	if player.UserId == ADMIN_USER_ID then
		wait(1)
		createAdminMenu(player)
	end
end)
