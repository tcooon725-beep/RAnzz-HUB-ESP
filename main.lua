--// RAnzz Hitbox ESP v1.1
--// By RAnzz 😈

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")

local ESPEnabled = true
local RainbowSpeed = 0.5
local MaxDistance = 100
local toggleKey = Enum.KeyCode.H
local ESPs = {}

-- Rainbow color
local function getRainbowColor()
    local hue = tick() * RainbowSpeed % 1
    return Color3.fromHSV(hue,1,1)
end

-- Destroy ESP lama kalo ada
local function destroyESP(player)
    local esp = ESPs[player]
    if esp then
        if esp.Box then esp.Box:Destroy() end
        if esp.HealthBar then esp.HealthBar:Destroy() end
        ESPs[player] = nil
    end
end

-- Buat ESP baru
local function createESP(player)
    destroyESP(player)
    if not player.Character then return end

    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    local head = player.Character:FindFirstChild("Head")
    local hum = player.Character:FindFirstChild("Humanoid")
    if not hrp or not head or not hum then return end

    -- Box
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = hrp
    box.AlwaysOnTop = true
    box.ZIndex = 2
    box.Size = Vector3.new(2,5,1)
    box.Transparency = 0.5
    box.Color3 = getRainbowColor()
    box.Parent = hrp

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(hum.Health/hum.MaxHealth,0,1,0)
    bar.BackgroundColor3 = Color3.fromRGB(255,0,0)
    bar.BorderSizePixel = 0
    bar.Parent = healthBar

    ESPs[player] = {Box = box, HealthBar = bar, Humanoid = hum}
end

-- Update ESP tiap frame
local function updateESP()
    for player, esp in pairs(ESPs) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Head") then
            esp.Box.Adornee = player.Character.HumanoidRootPart
            esp.HealthBar.Parent = player.Character.Head
            esp.Box.Color3 = getRainbowColor()
            if esp.Humanoid then
                esp.HealthBar.Frame.Size = UDim2.new(math.clamp(esp.Humanoid.Health/esp.Humanoid.MaxHealth,0,1),0,1,0)
            end
        else
            destroyESP(player)
        end
    end
end

RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        updateESP()
    end
end)

-- Toggle ESP
UIS.InputBegan:Connect(function(input,gpe)
    if gpe then return end
    if input.KeyCode == toggleKey then
        ESPEnabled = not ESPEnabled
        if not ESPEnabled then
            for player,_ in pairs(ESPs) do
                destroyESP(player)
            end
        else
            for _,player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    createESP(player)
                end
            end
        end
    end
end)

-- Auto create ESP untuk player baru & respawn
local function setupPlayer(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        createESP(player)
    end)
end

for _,player in pairs(Players:GetPlayers()) do
    setupPlayer(player)
    createESP(player)
end

Players.PlayerAdded:Connect(function(player)
    setupPlayer(player)
end)
