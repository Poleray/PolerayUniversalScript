-- gui.lua
-- Возвращает таблицу с функциями CreateWindow и BindToggles

local GUI = {}

function GUI:CreateWindow(Rayfield)
    local Window = Rayfield:CreateWindow({
        Name = "Ultimate Cheat",
        LoadingTitle = "Loading...",
        ConfigurationSaving = { Enabled = true }
    })
    
    self.MainTab = Window:CreateTab("🏠 Main", nil)
    self.EspTab = Window:CreateTab("👁 ESP", nil)
    self.FutureTab = Window:CreateTab("🔮 Future", nil)
    
    self.MainTab:CreateSection("Основные функции")
    self.EspTab:CreateSection("Настройки ESP")
    
    return Window
end

function GUI:BindToggles(Modules)
    -- GodMode
    self.MainTab:CreateToggle({
        Name = "GodMode",
        Flag = "godmode",
        Callback = function(val) Modules.godmode.Toggle(val) end
    })
    
    -- NoClip
    self.MainTab:CreateToggle({
        Name = "NoClip",
        Flag = "noclip",
        Callback = function(val) Modules.noclip.Toggle(val) end
    })
    
    -- AntiHitbox
    self.MainTab:CreateToggle({
        Name = "Anti-Hitbox",
        Flag = "antihit",
        Callback = function(val) Modules.antihit.Toggle(val) end
    })
    
    -- ESP Toggle
    self.EspTab:CreateToggle({
        Name = "Enable ESP",
        Flag = "esp",
        Callback = function(val) Modules.esp.Toggle(val) end
    })

    -- Цвет подсветки
    self.EspTab:CreateColorPicker({
        Name = "Цвет подсветки",
        Color = Color3.fromRGB(255, 0, 0),
        Flag = "esp_color",
        Callback = function(color) Modules.esp.SetColor(color) end
    })

    -- Прозрачность
    self.EspTab:CreateSlider({
        Name = "Прозрачность заливки",
        Range = {0, 100},
        Increment = 1,
        Suffix = "%",
        CurrentValue = 50,
        Flag = "esp_transparency",
        Callback = function(value) Modules.esp.SetTransparency(value) end
    })
    
    -- Сюда можно добавить слайдеры и колорпикеры, обращаясь к Modules.esp напрямую
end

return GUI