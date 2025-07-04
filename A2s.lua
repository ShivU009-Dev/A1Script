-- Create UI
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ToggleNameHighlighter"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Create Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 100, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "Highlight: OFF"
toggleButton.Parent = screenGui

local isOn = false

-- Function to change name color
local function toggleNameHighlight()
	local character = player.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			if isOn then
				humanoid.NameDisplayDistance = 100
				humanoid.NameDisplayType = Enum.HumanoidDisplayType.Text
				humanoid.DisplayName = player.DisplayName
				humanoid.NameOcclusion = Enum.NameOcclusion.NoOcclusion
				humanoid:SetAttribute("NameColor", "Green")
				humanoid:FindFirstChild("DisplayNameLabel").TextColor3 = Color3.new(0, 1, 0)
			else
				humanoid:SetAttribute("NameColor", "Default")
				-- Resetting by respawning the display name (this method resets color)
				humanoid.DisplayName = player.DisplayName
			end
		end
	end
end

-- Fallback highlight method using BillboardGui
local function applyBillboardHighlight()
	local char = player.Character or player.CharacterAdded:Wait()
	local head = char:WaitForChild("Head")

	-- Remove existing highlight
	local oldGui = head:FindFirstChild("HighlightGui")
	if oldGui then oldGui:Destroy() end

	if isOn then
		local billboard = Instance.new("BillboardGui")
		billboard.Name = "HighlightGui"
		billboard.Size = UDim2.new(0, 200, 0, 50)
		billboard.StudsOffset = Vector3.new(0, 2, 0)
		billboard.AlwaysOnTop = true
		billboard.Parent = head

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.new(0, 1, 0)
		label.TextStrokeTransparency = 0.5
		label.Text = player.DisplayName
		label.Font = Enum.Font.SourceSansBold
		label.TextScaled = true
		label.Parent = billboard
	end
end

-- Toggle button event
toggleButton.MouseButton1Click:Connect(function()
	isOn = not isOn
	toggleButton.Text = isOn and "Highlight: ON" or "Highlight: OFF"
	applyBillboardHighlight()
end)

-- Update on character spawn
player.CharacterAdded:Connect(function()
	wait(1)
	if isOn then
		applyBillboardHighlight()
	end
end)
