local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Settings
local logoId = "rbxassetid://123456789" -- Replace with your logo asset ID
local panelColor = Color3.fromRGB(0, 255, 255)

-- GUI Setup
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "NeonAdminPanel"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3 = panelColor
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0

-- Draggable header
local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
header.BackgroundTransparency = 0.3
header.Active = true
header.Draggable = true

-- Logo
local logo = Instance.new("ImageLabel", header)
logo.Image = logoId
logo.Size = UDim2.new(0, 30, 0, 30)
logo.Position = UDim2.new(0, 5, 0.1, 0)
logo.BackgroundTransparency = 1

-- Title
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

-- UIListLayout for buttons
local buttonArea = Instance.new("Frame", frame)
buttonArea.Size = UDim2.new(1, -20, 1, -50)
buttonArea.Position = UDim2.new(0, 10, 0, 50)
buttonArea.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", buttonArea)
layout.Padding = UDim.new(0, 10)

local function createButton(text, callback)
	local btn = Instance.new("TextButton", buttonArea)
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
	btn.BackgroundColor3 = panelColor
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.MouseButton1Click:Connect(callback)
end

-- 1. Fly toggle
local flying = false
local flyVelocity

createButton("🚀 Toggle Fly", function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local humanoidRootPart = char:WaitForChild("HumanoidRootPart")

	if flying then
		if flyVelocity then flyVelocity:Destroy() end
		flying = false
	else
		flyVelocity = Instance.new("BodyVelocity")
		flyVelocity.Velocity = Vector3.new(0, 0, 0)
		flyVelocity.MaxForce = Vector3.new(999999, 999999, 999999)
		flyVelocity.Parent = humanoidRootPart
		flying = true

		-- Fly loop
		coroutine.wrap(function()
			while flying and flyVelocity.Parent do
				local direction = Vector3.zero
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then
					direction += workspace.CurrentCamera.CFrame.LookVector
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then
					direction -= workspace.CurrentCamera.CFrame.LookVector
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
					direction += Vector3.new(0, 1, 0)
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
					direction -= Vector3.new(0, 1, 0)
				end
				flyVelocity.Velocity = direction * 50
				task.wait()
			end
		end)()
	end
end)

-- 2. Speed boost
createButton("⚡ Speed Boost", function()
	local human = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if human then
		human.WalkSpeed = 100
	end
end)

-- 3. Morph to character ID
createButton("🧍 Morph to Character ID", function()
	local id = tonumber(game:GetService("StarterGui"):PromptTextInput("Enter Character Asset ID:"))
	if not id then return end
	local charModel = game:GetObjects("rbxassetid://" .. id)[1]
	if charModel and charModel:IsA("Model") then
		local oldChar = LocalPlayer.Character
		charModel.Parent = workspace
		LocalPlayer.Character = charModel
		task.wait()
		if oldChar then oldChar:Destroy() end
	end
end)

-- 4. Change skybox
createButton("🌈 Change Skybox", function()
	local id = tonumber(game:GetService("StarterGui"):PromptTextInput("Enter Skybox Asset ID:"))
	if not id then return end
	local sky = Instance.new("Sky")
	sky.SkyboxBk = "rbxassetid://" .. id
	sky.SkyboxDn = "rbxassetid://" .. id
	sky.SkyboxFt = "rbxassetid://" .. id
	sky.SkyboxLf = "rbxassetid://" .. id
	sky.SkyboxRt = "rbxassetid://" .. id
	sky.SkyboxUp = "rbxassetid://" .. id
	Lighting.Sky = sky
end)
