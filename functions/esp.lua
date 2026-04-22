-- esp.lua
-- Модуль ESP: подсветка игроков с информацией о здоровье и дистанции

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ESP = {}
ESP.Enabled = false
ESP.HighlightColor = Color3.fromRGB(255, 0, 0)
ESP.FillTransparency = 0.5

-- Таблица для хранения данных ESP каждого игрока
local espData = {}

-- Служебные переменные
local renderConnection = nil
local playerAddedConn = nil
local playerRemovingConn = nil

-- Функция создания ESP для конкретного игрока
local function createESP(player, character)
    if not ESP.Enabled or player == LocalPlayer then return end
    if espData[player] then return end
    
    local head = character:WaitForChild("Head")
    local humanoid = character:WaitForChild("Humanoid")
    
    local highlight = Instance.new("Highlight")
    highlight.Parent = character
    highlight.FillColor = ESP.HighlightColor
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = ESP.FillTransparency
    
    local billboard = Instance.new("BillboardGui")
    billboard.Parent = head
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboard
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextSize = 14
    textLabel.Font = Enum.Font.SourceSansBold
    
    espData[player] = {
        highlight = highlight,
        billboard = billboard,
        textLabel = textLabel,
        character = character,
        head = head,
        humanoid = humanoid
    }
    
    local function updateBillboard()
        local data = espData[player]
        if not data or not data.character or not data.character.Parent then return end
        
        local health = data.humanoid.Health > 0 and math.floor(data.humanoid.Health) or "DEAD"
        local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
            and math.floor((LocalPlayer.Character.HumanoidRootPart.Position - data.head.Position).Magnitude) or "?"
        
        data.textLabel.Text = string.format("%s\n[%s HP | %sm]", player.Name, tostring(health), tostring(distance))
        
        if data.humanoid.Health <= 0 then
            data.highlight.FillColor = Color3.fromRGB(50, 50, 50)
            data.highlight.OutlineColor = Color3.fromRGB(100, 100, 100)
        else
            data.highlight.FillColor = ESP.HighlightColor
            data.highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        end
    end
    
    humanoid:GetPropertyChangedSignal("Health"):Connect(updateBillboard)
    updateBillboard()
end

-- Функция удаления ESP игрока
local function removeESP(player)
    local data = espData[player]
    if data then
        if data.highlight then data.highlight:Destroy() end
        if data.billboard then data.billboard:Destroy() end
        espData[player] = nil
    end
end

-- Очистка всего ESP
local function clearAllESP()
    for player, _ in pairs(espData) do
        removeESP(player)
    end
end

-- Функция обновления существующих ESP (при изменении цвета/прозрачности)
local function updateAllESPVisuals()
    for _, data in pairs(espData) do
        if data.highlight then
            data.highlight.FillColor = ESP.HighlightColor
            data.highlight.FillTransparency = ESP.FillTransparency
        end
    end
end

-- Главный цикл обновления (дистанция и проверка жизни)
local function onRenderStep()
    if not ESP.Enabled then return end
    for player, data in pairs(espData) do
        -- Проверка валидности
        if not data.character or not data.character.Parent then
            removeESP(player)
        elseif player.Character ~= data.character then
            removeESP(player)
            if player.Character then
                createESP(player, player.Character)
            end
        else
            -- Обновление текста
            if data.textLabel and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local distance = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - data.head.Position).Magnitude)
                local health = data.humanoid.Health > 0 and math.floor(data.humanoid.Health) or "DEAD"
                data.textLabel.Text = string.format("%s\n[%s HP | %sm]", player.Name, tostring(health), tostring(distance))
                
                -- Обновление цвета подсветки в зависимости от жизни
                if data.humanoid.Health <= 0 then
                    data.highlight.FillColor = Color3.fromRGB(50, 50, 50)
                    data.highlight.OutlineColor = Color3.fromRGB(100, 100, 100)
                else
                    data.highlight.FillColor = ESP.HighlightColor
                    data.highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                end
            end
        end
    end
end

-- ================== ПУБЛИЧНЫЕ МЕТОДЫ МОДУЛЯ ==================

function ESP:Init()
    -- Подписываемся на появление новых игроков
    playerAddedConn = Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            if ESP.Enabled then
                createESP(player, character)
            end
        end)
    end)
    
    -- Подписываемся на удаление игроков
    playerRemovingConn = Players.PlayerRemoving:Connect(removeESP)
    
    -- Для уже существующих игроков
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            createESP(player, player.Character)
        end
        player.CharacterAdded:Connect(function(character)
            if ESP.Enabled then
                createESP(player, character)
            end
        end)
    end
    
    -- Запускаем цикл обновления (будет активироваться при включении)
    renderConnection = RunService.RenderStepped:Connect(onRenderStep)
end

function ESP:Toggle(state)
    ESP.Enabled = state
    if state then
        -- Создаём ESP для всех текущих персонажей
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                createESP(player, player.Character)
            end
        end
    else
        clearAllESP()
    end
end

function ESP:SetColor(color)
    ESP.HighlightColor = color
    if ESP.Enabled then
        updateAllESPVisuals()
    end
end

function ESP:SetTransparency(value)
    ESP.FillTransparency = value / 100  -- ожидаем значение 0-100
    if ESP.Enabled then
        updateAllESPVisuals()
    end
end

-- Опционально: можно добавить метод для полной очистки при выгрузке модуля
function ESP:Destroy()
    if renderConnection then renderConnection:Disconnect() end
    if playerAddedConn then playerAddedConn:Disconnect() end
    if playerRemovingConn then playerRemovingConn:Disconnect() end
    clearAllESP()
end

return ESP
