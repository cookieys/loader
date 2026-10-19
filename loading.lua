local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local lp = Players.LocalPlayer

-- Settings
local MIN_TIME = 3        -- minimum seconds on screen
local BLUR_SIZE = 28
local FADE_TIME = 0.6
local DIM = 0.35          -- background darkness (0 = black, 1 = clear)

-- Game name (falls back to game.Name in Studio or unpublished places)
local gameName = game.Name
local ok, info = pcall(MarketplaceService.GetProductInfo, MarketplaceService, game.PlaceId)
if ok and info and info.Name then gameName = info.Name end

-- Blur
local blur = Instance.new("BlurEffect")
blur.Name = "LoadingBlur"
blur.Size = 0
blur.Parent = Lighting
TweenService:Create(blur, TweenInfo.new(FADE_TIME), { Size = BLUR_SIZE }):Play()

-- UI
local gui = Instance.new("ScreenGui")
gui.Name = "LoadingScreen"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.Parent = lp:WaitForChild("PlayerGui")

local root = Instance.new("CanvasGroup")
root.Size = UDim2.fromScale(1, 1)
root.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
root.BackgroundTransparency = DIM
root.GroupTransparency = 1
root.Parent = gui

local function label(text, size, y, color, font)
	local l = Instance.new("TextLabel")
	l.AnchorPoint = Vector2.new(0.5, 0.5)
	l.Position = UDim2.new(0.5, 0, 0.5, y)
	l.Size = UDim2.new(0.9, 0, 0, size + 8)
	l.BackgroundTransparency = 1
	l.Text = text
	l.TextColor3 = color
	l.TextSize = size
	l.Font = font
	l.TextScaled = false
	l.TextWrapped = true
	l.Parent = root
	return l
end

label(gameName, 36, -30, Color3.new(1, 1, 1), Enum.Font.GothamBold)
label("Place ID: " .. game.PlaceId, 18, 15, Color3.fromRGB(190, 190, 200), Enum.Font.Gotham)
local status = label("Loading", 16, 60, Color3.fromRGB(140, 140, 150), Enum.Font.Gotham)

TweenService:Create(root, TweenInfo.new(FADE_TIME), { GroupTransparency = 0 }):Play()

-- Animated dots
local running = true
task.spawn(function()
	local i = 0
	while running do
		status.Text = "Loading" .. string.rep(".", i % 4)
		i += 1
		task.wait(0.4)
	end
end)

-- Wait for game, then fade out
local start = os.clock()
if not game:IsLoaded() then game.Loaded:Wait() end
local left = MIN_TIME - (os.clock() - start)
if left > 0 then task.wait(left) end

running = false
local info2 = TweenInfo.new(FADE_TIME)
TweenService:Create(root, info2, { GroupTransparency = 1 }):Play()
local out = TweenService:Create(blur, info2, { Size = 0 })
out:Play()
out.Completed:Wait()

blur:Destroy()
gui:Destroy()
