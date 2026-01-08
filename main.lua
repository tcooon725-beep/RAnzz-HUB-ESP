--// RAnzz Mini Head ESP v1.0
--// Username + Avatar + Health Bar
--// Toggle ON/OFF | Client Side

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ESP_ENABLED = true
local ESPs = {}

-- ===== GUI TOGGLE =====
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Name = "RAnzzESP"

local Toggle = Instance.new("TextButton", ScreenGui)
Toggle.Size = UDim2.new(0, 90, 0, 30)
Toggle.Position = UDim2.new(0, 10, 0, 150)
Toggle.Text = "ESP : ON"
Toggle.BackgroundColor3 = Color3.fromRGB(20,20,20)
Toggle.TextColor3 = Color3.new(1,1,1)
Toggle.TextSize = 14
Toggle.BorderSizePixel = 0

Toggle.MouseButton1Click:Connect(function()
	ESP_ENABLED = not ESP_ENABLED
	Toggle.Text = ESP_ENABLED and "ESP : ON" or "ESP : OFF"

	for _,gui in pairs(ESPs) do
		if gui then
			gui.Enabled = ESP_ENABLED
		end
	end
end)

-- ===== FUNCTION CREATE ESP =====
local function CreateESP(player)
	if player == LocalPlayer then return end

	local function Setup(char)
		local head = char:WaitForChild("Head",5)
		local hum = char:WaitForChild("Humanoid",5)
		if not head or not hum then return end

		local billboard = Instance.new("BillboardGui", head)
		billboard.Name = "RAnzzESP_UI"
		billboard.Size = UDim2.new(0,120,0,40)
		billboard.StudsOffset = Vector3.new(0,2.2,0)
		billboard.AlwaysOnTop = true
		billboard.Enabled = ESP_ENABLED

		-- Avatar
		local avatar = Instance.new("ImageLabel", billboard)
		avatar.Size = UDim2.new(0,30,0,30)
		avatar.Position = UDim2.new(0,0,0,5)
		avatar.BackgroundTransparency = 1

		local img = Players:GetUserThumbnailAsync(
			player.UserId,
			Enum.ThumbnailType.HeadShot,
			Enum.ThumbnailSize.Size48x48
		)
		avatar.Image = img

		-- Username
		local name = Instance.new("TextLabel", billboard)
		name.Position = UDim2.new(0,35,0,2)
		name.Size = UDim2.new(0,80,0,14)
		name.Text = player.Name
		name.TextScaled = true
		name.TextColor3 = Color3.new(1,1,1)
		name.BackgroundTransparency = 1

		-- Health BG
		local bg = Instance.new("Frame", billboard)
		bg.Position = UDim2.new(0,35,0,20)
		bg.Size = UDim2.new(0,80,0,6)
		bg.BackgroundColor3 = Color3.fromRGB(40,40,40)
		bg.BorderSizePixel = 0

		-- Health Bar
		local bar = Instance.new("Frame", bg)
		bar.Size = UDim2.new(1,0,1,0)
		bar.BackgroundColor3 = Color3.fromRGB(0,255,0)
		bar.BorderSizePixel = 0

		hum.HealthChanged:Connect(function()
			local hp = hum.Health / hum.MaxHealth
			bar.Size = UDim2.new(hp,0,1,0)
			bar.BackgroundColor3 = Color3.fromRGB(255 - (hp*255), hp*255, 0)
		end)

		ESPs[player] = billboard
	end

	if player.Character then
		Setup(player.Character)
	end
	player.CharacterAdded:Connect(Setup)
end

-- ===== INIT =====
for _,plr in pairs(Players:GetPlayers()) do
	CreateESP(plr)
end

Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(function(plr)
	if ESPs[plr] then
		ESPs[plr]:Destroy()
		ESPs[plr] = nil
	end
end)
