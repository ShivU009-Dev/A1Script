-- Roblox X-Ray ESP Script with Golden Glow
-- Created for educational purposes only

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Configuration
local ESP_ENABLED = true
local XRAY_ENABLED = true
local ESP_COLOR = Color3.fromRGB(255, 215, 0) -- Golden color
local ESP_TRANSPARENCY = 0.7
local GLOW_INTENSITY = 2

-- Storage for ESP objects
local espObjects = {}

-- Create ESP Box
local function createESPBox(player)
    if player == LocalPlayer then return end
    
    local espBox = {}
    
    -- Main box frame
    local box = Instance.new("Frame")
    box.Name = "ESPBox_" .. player.Name
    box.BackgroundTransparency = ESP_TRANSPARENCY
    box.BackgroundColor3 = ESP_COLOR
    box.BorderSizePixel = 2
    box.BorderColor3 = ESP_COLOR
    box.Size = UDim2.new(0, 100, 0, 100)
    box.Parent = LocalPlayer.PlayerGui.CoreGui
    
    -- Glow effect
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.BackgroundTransparency = 1
    glow.Image = "rbxasset://textures/ui/Glow.png"
    glow.ImageColor3 = ESP_COLOR
    glow.ImageTransparency = 0.3
    glow.Size = UDim2.new(1, 20, 1, 20)
    glow.Position = UDim2.new(0, -10, 0, -10)
    glow.Parent = box
    
    -- Player name label
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.Position = UDim2.new(0, 0, 0, -25)
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = ESP_COLOR
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextSize = 14
    nameLabel.Parent = box
    
    -- Distance label
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "DistanceLabel"
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Size = UDim2.new(1, 0, 0, 20)
    distanceLabel.Position = UDim2.new(0, 0, 1, 5)
    distanceLabel.Text = "0m"
    distanceLabel.TextColor3 = ESP_COLOR
    distanceLabel.TextStrokeTransparency = 0
    distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    distanceLabel.Font = Enum.Font.SourceSans
    distanceLabel.TextSize = 12
    distanceLabel.Parent = box
    
    espBox.box = box
    espBox.glow = glow
    espBox.nameLabel = nameLabel
    espBox.distanceLabel = distanceLabel
    espBox.player = player
    
    return espBox
end

-- Apply X-Ray effect
local function applyXRay(character)
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Transparency = 0.5
            part.CanCollide = false
            
            -- Add golden outline
            local selectionBox = Instance.new("SelectionBox")
            selectionBox.Adornee = part
            selectionBox.Color3 = ESP_COLOR
            selectionBox.LineThickness = 0.2
            selectionBox.Transparency = 0.3
            selectionBox.Parent = part
        end
    end
end

-- Remove X-Ray effect
local function removeXRay(character)
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Transparency = 0
            part.CanCollide = true
            
            local selectionBox = part:FindFirstChild("SelectionBox")
            if selectionBox then
                selectionBox:Destroy()
            end
        end
    end
end

-- Update ESP positions
local function updateESP()
    for _, espData in pairs(espObjects) do
        local player = espData.player
        local character = player.Character
        
        if character and character:FindFirstChild("HumanoidRootPart") then
            local rootPart = character.HumanoidRootPart
            local vector, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                -- Calculate distance
                local distance = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude)
                
                -- Update ESP box position and size
                local size = math.max(50, 1000 / distance)
                espData.box.Size = UDim2.new(0, size, 0, size * 1.5)
                espData.box.Position = UDim2.new(0, vector.X - size/2, 0, vector.Y - size * 0.75)
                espData.box.Visible = true
                
                -- Update distance label
                espData.distanceLabel.Text = distance .. "m"
                
                -- Animate glow effect
                local glowTween = math.sin(tick() * 3) * 0.2 + 0.5
                espData.glow.ImageTransparency = glowTween
            else
                espData.box.Visible = false
            end
        else
            espData.box.Visible = false
        end
    end
end

-- Handle new players
local function onPlayerAdded(player)
    if player == LocalPlayer then return end
    
    -- Create ESP
    if ESP_ENABLED then
        espObjects[player] = createESPBox(player)
    end
    
    -- Handle character spawning
    player.CharacterAdded:Connect(function(character)
        if XRAY_ENABLED then
            character.ChildAdded:Connect(function(child)
                if child:IsA("BasePart") then
                    wait(0.1)
                    applyXRay(character)
                end
            end)
            wait(1)
            applyXRay(character)
        end
    end)
end

-- Handle player leaving
local function onPlayerRemoving(player)
    if espObjects[player] then
        espObjects[player].box:Destroy()
        espObjects[player] = nil
    end
end

-- Toggle functions
local function toggleESP()
    ESP_ENABLED = not ESP_ENABLED
    for _, espData in pairs(espObjects) do
        espData.box.Visible = ESP_ENABLED
    end
    print("ESP " .. (ESP_ENABLED and "Enabled" or "Disabled"))
end

local function toggleXRay()
    XRAY_ENABLED = not XRAY_ENABLED
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player ~= LocalPlayer then
            if XRAY_ENABLED then
                applyXRay(player.Character)
            else
                removeXRay(player.Character)
            end
        end
    end
    print("X-Ray " .. (XRAY_ENABLED and "Enabled" or "Disabled"))
end

-- Key bindings
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        toggleESP()
    elseif input.KeyCode == Enum.KeyCode.F2 then
        toggleXRay()
    end
end)

-- Initialize
for _, player in pairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Main update loop
RunService.Heartbeat:Connect(updateESP)

print("Golden ESP X-Ray Script Loaded!")
print("Press F1 to toggle ESP")
print("Press F2 to toggle X-Ray")
