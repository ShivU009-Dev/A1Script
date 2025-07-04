--[[
🛠 Admin Panel Script for Shivraj
Only visible to LocalPlayer. Includes:
- Fly, Speed, Morph, Sky, Invisibility, Noclip, Freecam
--]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- UI
local logoId = "rbxassetid://97827306574180"
local panelColor = Color3.fromRGB(0, 255, 255)

-- GUI
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "AdminPanel"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 420)
frame.Position = UDim2.new(0.5, -200, 0.5, -200)
frame.BackgroundColor3 = panelColor
frame.BorderSizePixel = 0

local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
header.BackgroundTransparency = 0.3
header.Active = true
header.Draggable = true

local logo = Instance.new("ImageLabel", header)
logo.Image = logoId
logo.Size = UDim2.new(0, 30, 0, 30)
logo.Position = UDim2.new(0, 5, 0.1, 0)
logo.BackgroundTransparency = 1

local title = Instance.new("TextLabel", header)
title.Text = "Admin Panel"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 40, 0, 0)
title.TextXAlignment = Enum.TextXAlignment.Left

-- Control Buttons
local function makeControl(text, pos, callback)
	local btn = Instance.new("TextButton", header)
	btn.Size = UDim2.new(0, 30, 0, 30)
	btn.Position = pos
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 18
	btn.MouseButton1Click:Connect(callback)
end

makeControl("-", UDim2.new(1, -90, 0.1, 0), function() frame.Visible = false end)
makeControl("[]", UDim2.new(1, -60, 0.1, 0), function() frame.Visible = true end)
makeControl("×", UDim2.new(1, -30, 0.1, 0), function() gui:Destroy() end)

-- Layout
local container = Instance.new("Frame", frame)
container.Size = UDim2.new(1, -20, 1, -50)
container.Position = UDim2.new(0, 10, 0, 50)
container.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0, 6)

local function createButton(text, callback)
	local btn = Instance.new("TextButton", container)
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
	btn.BackgroundColor3 = panelColor
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.MouseButton1Click:Connect(callback)
end

-- FLY SYSTEM
local flying = false
local flySpeed = 50
local velocity

createButton("🚀 Toggle Fly", function()
	local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	if flying then
		flying = false
		if velocity then velocity:Destroy() end
	else
		flying = true
		velocity = Instance.new("BodyVelocity")
		velocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		velocity.Velocity = Vector3.zero
		velocity.Parent = hrp

		RunService.RenderStepped:Connect(function()
			if flying and velocity and hrp then
				local dir = Vector3.zero
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then
					dir += workspace.CurrentCamera.CFrame.LookVector
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then
					dir -= workspace.CurrentCamera.CFrame.LookVector
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
					dir += Vector3.new(0, 1, 0)
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
					dir -= Vector3.new(0, 1, 0)
				end
				velocity.Velocity = dir.Unit * flySpeed
			end
		end)
	end
end)

-- SPEED
local speed = 16
createButton("⚡ Speed +", function()
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		speed += 10
		hum.WalkSpeed = speed
	end
end)

createButton("🐌 Speed -", function()
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		speed = math.max(16, speed - 10)
		hum.WalkSpeed = speed
	end
end)

-- MORPH INPUT
createButton("🧍 Morph to ID", function()
	StarterGui:SetCore("ChatMakeSystemMessage", { Text = "Enter Morph ID in chat" })
	local con
	con = LocalPlayer.Chatted:Connect(function(msg)
		local id = tonumber(msg)
		if id then
			local model = game:GetObjects("rbxassetid://" .. id)[1]
			if model and model:IsA("Model") then
				model.Parent = workspace
				LocalPlayer.Character = model
			end
		end
		con:Disconnect()
	end)
end)

-- SKYBOX INPUT
createButton("🌌 Change Skybox", function()
	StarterGui:SetCore("ChatMakeSystemMessage", { Text = "Enter Skybox ID in chat" })
	local con
	con = LocalPlayer.Chatted:Connect(function(msg)
		local id = tonumber(msg)
		if id then
			local sky = Instance.new("Sky")
			for _, face in ipairs({ "Bk", "Dn", "Ft", "Lf", "Rt", "Up" }) do
				sky["Skybox" .. face] = "rbxassetid://" .. id
			end
			Lighting.Sky = sky
		end
		con:Disconnect()
	end)
end)

-- INVISIBILITY
createButton("👻 Invisibility", function()
	local char = LocalPlayer.Character
	if char then
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") or part:IsA("Decal") then
				part.Transparency = 1
			elseif part:IsA("Humanoid") then
				part.NameDisplayDistance = 0
			end
		end
	end
end)

-- NOCLIP
local noclip = false
RunService.Stepped:Connect(function()
	if noclip and LocalPlayer.Character then
		for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

createButton("🧱 Toggle Noclip", function()
	noclip = not noclip
end)

-- FREECAM
createButton("🎥 Enable Freecam (Shift+P)", function()
	StarterGui:SetCore("ChatMakeSystemMessage", {
		Text = "Press Shift+P to use Roblox freecam (if enabled in game settings)",
	})
end)
