-- VIP GUI Script for Roblox
-- This script creates a comprehensive VIP menu with multiple features by shivuDev

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Feature States
local features = {
    xray = false,
    esp = false,
    speed = false,
    fly = false,
    noclip = false,
    godmode = false
}

-- Create GUI
local function createVIPGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "VIP_GUI"
    screenGui.Parent = playerGui
    screenGui.ResetOnSpawn = false
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 10)
    headerCorner.Parent = header
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -100, 1, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "👑 VIP MENU"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 20
    title.Parent = header
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -45, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.TextSize = 20
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = header
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 8)
    closeBtnCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Content Frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -20, 1, -70)
    contentFrame.Position = UDim2.new(0, 10, 0, 60)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    -- Create Buttons
    local buttonData = {
        {"🔍 X-Ray", Color3.fromRGB(150, 100, 255), "xray"},
        {"👥 ESP", Color3.fromRGB(100, 255, 150), "esp"},
        {"💨 Speed", Color3.fromRGB(255, 255, 100), "speed"},
        {"✈️ Fly", Color3.fromRGB(100, 200, 255), "fly"},
        {"👻 NoClip", Color3.fromRGB(255, 150, 150), "noclip"},
        {"🛡️ God Mode", Color3.fromRGB(200, 100, 255), "godmode"}
    }
    
    for i, data in pairs(buttonData) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.45, 0, 0, 60)
        button.Position = UDim2.new((i-1) % 2 * 0.5 + 0.025, 0, math.floor((i-1)/2) * 0.18 + 0.05, 0)
        button.BackgroundColor3 = data[2]
        button.Text = data[1]
        button.TextColor3 = Color3.new(1, 1, 1)
        button.TextSize = 16
        button.Font = Enum.Font.Gotham
        button.Parent = contentFrame
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 8)
        buttonCorner.Parent = button
        
        button.MouseButton1Click:Connect(function()
            toggleFeature(data[3], button)
        end)
    end
end

-- Feature Functions
local function toggleFeature(featureName, button)
    features[featureName] = not features[featureName]
    
    if features[featureName] then
        button.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        button.Text = button.Text .. " ✓"
    else
        button.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        button.Text = string.gsub(button.Text, " ✓", "")
    end
    
    -- Execute feature logic
    if featureName == "xray" then
        toggleXRay()
    elseif featureName == "esp" then
        toggleESP()
    elseif featureName == "speed" then
        toggleSpeed()
    elseif featureName == "fly" then
        toggleFly()
    elseif featureName == "noclip" then
        toggleNoClip()
    elseif featureName == "godmode" then
        toggleGodMode()
    end
end

-- X-Ray Implementation
local function toggleXRay()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Parent.Name ~= player.Name then
            if features.xray then
                obj.Transparency = 0.7
                obj.BrickColor = BrickColor.new("Bright blue")
            else
                obj.Transparency = 0
                obj.BrickColor = BrickColor.new("Medium stone grey")
            end
        end
    end
end

-- ESP Implementation
local function toggleESP()
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local highlight = otherPlayer.Character:FindFirstChild("Highlight")
            
            if features.esp and not highlight then
                highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = otherPlayer.Character
            elseif not features.esp and highlight then
                highlight:Destroy()
            end
        end
    end
end

-- Speed Implementation
local function toggleSpeed()
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = features.speed and 50 or 16
    end
end

-- Fly Implementation
local flyConnection
local function toggleFly()
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if features.fly then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = rootPart
        
        flyConnection = RunService.Heartbeat:Connect(function()
            local moveVector = humanoid.MoveDirection * 50
            bodyVelocity.Velocity = Vector3.new(moveVector.X, 0, moveVector.Z)
        end)
    else
        if flyConnection then
            flyConnection:Disconnect()
        end
        local bodyVelocity = rootPart:FindFirstChild("BodyVelocity")
        if bodyVelocity then
            bodyVelocity:Destroy()
        end
    end
end

-- NoClip Implementation
local noclipConnection
local function toggleNoClip()
    if features.noclip then
        noclipConnection = RunService.Stepped:Connect(function()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
        end
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- God Mode Implementation
local function toggleGodMode()
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
        if features.godmode then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        else
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end
    end
end

-- Toggle GUI with key
UserInputService.InputBegan:Connect(function(key, gameProcessed)
    if not gameProcessed and key.KeyCode == Enum.KeyCode.RightControl then
        if playerGui:FindFirstChild("VIP_GUI") then
            playerGui.VIP_GUI:Destroy()
        else
            createVIPGUI()
        end
    end
end)

-- Initialize
createVIPGUI()
