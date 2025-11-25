local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- --- Configuration & Constants ---
local GUI_NAME = "SyncedLoadingScreen_Revamped"
local BLUR_NAME = "LoadingBlur_Revamped"
local LOAD_TIME = 4.5
local EASING_STYLE = Enum.EasingStyle.Quart
local EASING_DIRECTION = Enum.EasingDirection.Out

-- --- 1. Cleanup Previous Instances ---
-- This ensures that if you execute the script multiple times, the old one is removed first.
local function cleanupPrevious()
    -- Check CoreGui (for exploits)
    if CoreGui:FindFirstChild(GUI_NAME) then
        CoreGui[GUI_NAME]:Destroy()
    end
    -- Check PlayerGui (fallback)
    if Players.LocalPlayer:FindFirstChild("PlayerGui") and Players.LocalPlayer.PlayerGui:FindFirstChild(GUI_NAME) then
        Players.LocalPlayer.PlayerGui[GUI_NAME]:Destroy()
    end
    -- Check Lighting for old blur
    if Lighting:FindFirstChild(BLUR_NAME) then
        Lighting[BLUR_NAME]:Destroy()
    end
end

cleanupPrevious()

-- --- 2. Get Game Information ---
local success, gameInfo = pcall(function()
    return MarketplaceService:GetProductInfo(game.PlaceId)
end)
local gameTitle = success and gameInfo.Name or "Unknown Game"

-- --- 3. Create UI Parent ---
local function getGuiParent()
    local s, gui = pcall(function() return CoreGui end)
    if s then return gui end
    return Players.LocalPlayer:WaitForChild("PlayerGui")
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = GUI_NAME
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 100
ScreenGui.Parent = getGuiParent()

-- --- 4. Create Blur ---
local Blur = Instance.new("BlurEffect")
Blur.Name = BLUR_NAME
Blur.Size = 24
Blur.Parent = Lighting

-- --- 5. Create UI Elements ---
local Background = Instance.new("Frame")
Background.Name = "Background"
Background.Size = UDim2.fromScale(1, 1)
Background.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Background.BackgroundTransparency = 0.2
Background.BorderSizePixel = 0
Background.Parent = ScreenGui

-- Game Title
local GameTitleLabel = Instance.new("TextLabel")
GameTitleLabel.Name = "GameTitle"
GameTitleLabel.Text = string.upper(gameTitle)
GameTitleLabel.Size = UDim2.new(1, 0, 0, 50)
GameTitleLabel.Position = UDim2.new(0, 0, 0.42, -40)
GameTitleLabel.BackgroundTransparency = 1
GameTitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
GameTitleLabel.Font = Enum.Font.GothamBlack
GameTitleLabel.TextSize = 32
GameTitleLabel.Parent = Background

-- Subtitle (Optional)
local SubTitle = Instance.new("TextLabel")
SubTitle.Text = "INITIALIZING SCRIPT..."
SubTitle.Size = UDim2.new(1, 0, 0, 20)
SubTitle.Position = UDim2.new(0, 0, 0.42, 15)
SubTitle.BackgroundTransparency = 1
SubTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextSize = 14
SubTitle.Parent = Background

-- Bar Container (Modern Look)
local BarContainer = Instance.new("Frame")
BarContainer.Name = "BarContainer"
BarContainer.Size = UDim2.new(0.35, 0, 0, 6)
BarContainer.Position = UDim2.fromScale(0.325, 0.58)
BarContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
BarContainer.BorderSizePixel = 0
BarContainer.Parent = Background

local ContainerCorner = Instance.new("UICorner")
ContainerCorner.CornerRadius = UDim.new(1, 0)
ContainerCorner.Parent = BarContainer

-- Bar Fill
local BarFill = Instance.new("Frame")
BarFill.Name = "BarFill"
BarFill.Size = UDim2.fromScale(0, 1) -- Start empty
BarFill.BackgroundColor3 = Color3.fromHex("#FF0055") -- Vibrant Accent Color
BarFill.BorderSizePixel = 0
BarFill.Parent = BarContainer

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(1, 0)
FillCorner.Parent = BarFill

-- Percentage Text (Floating above bar)
local ProgressText = Instance.new("TextLabel")
ProgressText.Name = "ProgressText"
ProgressText.Text = "0%"
ProgressText.Size = UDim2.new(0, 50, 0, 20)
ProgressText.AnchorPoint = Vector2.new(0.5, 1)
ProgressText.Position = UDim2.new(0, 0, -0.5, 0) -- Will move with bar
ProgressText.BackgroundTransparency = 1
ProgressText.TextColor3 = Color3.fromHex("#FF0055")
ProgressText.Font = Enum.Font.GothamBold
ProgressText.TextSize = 14
ProgressText.Parent = BarFill -- Parented to Fill so it moves with it

-- --- 6. Animation & Sync Logic ---

-- Create the tween
local tweenInfo = TweenInfo.new(LOAD_TIME, EASING_STYLE, EASING_DIRECTION)
local loadTween = TweenService:Create(BarFill, tweenInfo, { Size = UDim2.fromScale(1, 1) })

-- Sync Loop
local connection
connection = RunService.RenderStepped:Connect(function()
    if not BarFill.Parent then 
        connection:Disconnect() 
        return 
    end

    local currentScale = BarFill.Size.X.Scale
    local percent = math.clamp(math.floor(currentScale * 100), 0, 100)
    
    ProgressText.Text = percent .. "%"
    
    -- Ensure the text stays at the tip of the bar, but doesn't go off the left edge
    if currentScale < 0.1 then
        ProgressText.Position = UDim2.new(1, 15, -0.5, 0)
    else
        ProgressText.Position = UDim2.new(1, 0, -0.5, 0)
    end
    
    if currentScale >= 0.999 then
        ProgressText.Text = "DONE"
        if connection then connection:Disconnect() end
    end
end)

loadTween:Play()
loadTween.Completed:Wait()

task.wait(0.5)

-- --- 7. Fade Out & Self-Destruct ---
local fadeInfo = TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

-- Function to tween transparency property safely
local function fadeObject(obj, property)
    local target = {}
    target[property] = 1
    TweenService:Create(obj, fadeInfo, target):Play()
end

fadeObject(Background, "BackgroundTransparency")
fadeObject(GameTitleLabel, "TextTransparency")
fadeObject(SubTitle, "TextTransparency")
fadeObject(BarContainer, "BackgroundTransparency")
fadeObject(BarFill, "BackgroundTransparency")
fadeObject(ProgressText, "TextTransparency")
TweenService:Create(Blur, fadeInfo, {Size = 0}):Play()

task.wait(0.8)

-- Final Cleanup
cleanupPrevious()
if connection then connection:Disconnect() end