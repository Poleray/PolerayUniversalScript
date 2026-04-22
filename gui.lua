-- Единый скрипт с Orion GUI
-- Работает гарантированно

-- 1. Загружаем Orion
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

-- 2. Создаём окно
local Window = OrionLib:MakeWindow({
    Name = "Ultimate Cheat",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "UltimateCheat",
    IntroEnabled = false
})

-- 3. Вкладки
local MainTab = Window:MakeTab({ Name = "Main", Icon = "rbxassetid://4483345998" })
local EspTab = Window:MakeTab({ Name = "ESP", Icon = "rbxassetid://4483345998" })

-- ================== ПЕРЕМЕННЫЕ И МОДУЛИ ==================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Флаги
local godmodeEnabled = false
local noclipEnabled = false
local espEnabled = false
local espColor = Color3.fromRGB(255, 0, 0)
local espTransparency = 0.5

-- Таблица ESP
local espData = {}

-- ================== ФУНКЦИИ МОДУЛЕЙ ==================

-- GODMODE
local function applyGodMode(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge
    humanoid.TakeDamage = function() end
    humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if humanoid.Health < math.huge then humanoid.Health = math.huge end
    end)
    local fakeHP = character:FindFirstChild("FakeHP")
    if fakeHP then
        fakeHP.Value = math.huge
        fakeHP:GetPropertyChangedSignal("Value"):Connect(function()
            if fakeHP.Value < math.huge then fakeHP.Value = math.huge end
        end)
    end
end

local function onCharGodmode(char)
    if godmodeEnabled then applyGodMode(char) end
end

-- NOCLIP
local function enableNoclip(char)
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide = false end
    end
    char.DescendantAdded:Connect(function(d)
        if d:IsA("BasePart") then d.CanCollide = false end
    end)
end

local function onCharNoclip(char)
    if noclipEnabled then enableNoclip(char) end
end

-- ESP
local function createESP(player, char)
    if not espEnabled or player == LocalPlayer then return end
    if espData[player] then return end
    
    local head = char:FindFirstChild("Head")
    local humanoid = char:FindFirstChild("Humanoid")
    if not head or not humanoid then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Parent = char
    highlight.FillColor = espColor
    highlight.OutlineColor = Color3.fromRGB(255,255,255)
    highlight.FillTransparency = espTransparency
    
    local billboard = Instance.new("BillboardGui")
    billboard.Parent = head
    billboard.Adornee = head
    billboard.Size = UDim2.new(0,200,0,50)
    billboard.StudsOffset = Vector3.new(0,3,0)
    
    local label = Instance.new("TextLabel")
    label.Parent = billboard
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextSize = 14
    label.Font = Enum.Font.SourceSansBold
    
    espData[player] = { highlight=highlight, billboard=billboard, label=label, char=char, head=head, humanoid=humanoid }
    
    local function update()
        local d = espData[player]
        if not d or not d.char or not d.char.Parent then return end
        local hp = d.humanoid.Health > 0 and math.floor(d.humanoid.Health) or "DEAD"
        local dist = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and math.floor((LocalPlayer.Character.HumanoidRootPart.Position - d.head.Position).Magnitude) or "?"
        d.label.Text = string.format("%s\n[%s HP | %sm]", player.Name, tostring(hp), tostring(dist))
        if d.humanoid.Health <= 0 then
            d.highlight.FillColor = Color3.fromRGB(50,50,50)
        else
            d.highlight.FillColor = espColor
        end
    end
    
    humanoid:GetPropertyChangedSignal("Health"):Connect(update)
    update()
end

local function removeESP(player)
    local d = espData[player]
    if d then
        if d.highlight then d.highlight:Destroy() end
        if d.billboard then d.billboard:Destroy() end
        espData[player] = nil
    end
end

local function clearESP()
    for p,_ in pairs(espData) do removeESP(p) end
end

local function updateAllESPColor()
    for _,d in pairs(espData) do
        if d.highlight and d.humanoid.Health > 0 then d.highlight.FillColor = espColor end
    end
end

local function updateAllESPTransparency()
    for _,d in pairs(espData) do
        if d.highlight then d.highlight.FillTransparency = espTransparency end
    end
end

-- Обновление ESP каждый кадр
RunService.RenderStepped:Connect(function()
    if not espEnabled then return end
    for p,d in pairs(espData) do
        if not d.char or not d.char.Parent then removeESP(p)
        elseif p.Character ~= d.char then removeESP(p); if p.Character then createESP(p,p.Character) end
        else
            if d.label and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - d.head.Position).Magnitude)
                local hp = d.humanoid.Health > 0 and math.floor(d.humanoid.Health) or "DEAD"
                d.label.Text = string.format("%s\n[%s HP | %sm]", p.Name, tostring(hp), tostring(dist))
                if d.humanoid.Health <= 0 then d.highlight.FillColor = Color3.fromRGB(50,50,50)
                else d.highlight.FillColor = espColor end
            end
        end
    end
end)

-- Подписки
LocalPlayer.CharacterAdded:Connect(function(char)
    onCharGodmode(char)
    onCharNoclip(char)
end)

if LocalPlayer.Character then
    onCharGodmode(LocalPlayer.Character)
    onCharNoclip(LocalPlayer.Character)
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(char)
        if espEnabled then createESP(p,char) end
    end)
end)
Players.PlayerRemoving:Connect(removeESP)

for _,p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer and p.Character then
        if espEnabled then createESP(p,p.Character) end
    end
    p.CharacterAdded:Connect(function(char)
        if espEnabled then createESP(p,char) end
    end)
end

-- ================== GUI ЭЛЕМЕНТЫ ==================

-- MAIN
MainTab:AddSection("Main Functions")

MainTab:AddToggle({
    Name = "GodMode",
    Default = false,
    Callback = function(val)
        godmodeEnabled = val
        if val and LocalPlayer.Character then applyGodMode(LocalPlayer.Character) end
    end
})

MainTab:AddToggle({
    Name = "NoClip",
    Default = false,
    Callback = function(val)
        noclipEnabled = val
        if LocalPlayer.Character then
            if val then enableNoclip(LocalPlayer.Character)
            else
                for _,p in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = true end
                end
            end
        end
    end
})

-- ESP
EspTab:AddSection("ESP Controls")
EspTab:AddToggle({
    Name = "Enable ESP",
    Default = false,
    Callback = function(val)
        espEnabled = val
        if val then
            for _,p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then createESP(p,p.Character) end
            end
        else
            clearESP()
        end
    end
})

EspTab:AddSection("Visuals")
EspTab:AddColorpicker({
    Name = "Highlight Color",
    Default = espColor,
    Callback = function(color)
        espColor = color
        if espEnabled then updateAllESPColor() end
    end
})

EspTab:AddSlider({
    Name = "Fill Transparency",
    Min = 0,
    Max = 100,
    Default = 50,
    Color = Color3.fromRGB(25,25,25),
    Increment = 1,
    ValueName = "%",
    Callback = function(val)
        espTransparency = val / 100
        if espEnabled then updateAllESPTransparency() end
    end
})

-- Инициализация Orion
OrionLib:Init()

print("✅ Ultimate Cheat (Orion) загружен и готов к работе!")
