-- gui.lua
-- Возвращает таблицу с функциями CreateWindow и BindToggles
-- Версия: 1.0

local GUI = {}

function GUI:CreateWindow(Rayfield)
    local Window = Rayfield:CreateWindow({
        Name = "Ultimate Cheat Menu",
        LoadingTitle = "Loading scripts...",
        LoadingSubtitle = "by Poleray",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "UltimateCheat",
            FileName = "Settings"
        },
        DisableBuildWarnings = true
    })
    
    self.MainTab = Window:CreateTab("🏠 Main", nil)
    self.EspTab = Window:CreateTab("👁 ESP", nil)
    self.FutureTab = Window:CreateTab("🔮 Future", nil)
    
    self.MainTab:CreateSection("Основные функции")
    self.EspTab:CreateSection("Основные настройки")
    self.FutureTab:CreateSection("Дополнительные функции")
    
    return Window
end

function GUI:BindToggles(Modules)
    -- ================== MAIN TAB ==================
    
    -- GodMode
    self.MainTab:CreateToggle({
        Name = "GodMode (Бессмертие)",
        CurrentValue = false,
        Flag = "godmode_toggle",
        Callback = function(val) 
            if Modules.godmode and Modules.godmode.Toggle then
                Modules.godmode.Toggle(val)
            end
        end
    })
    
    -- NoClip
    self.MainTab:CreateToggle({
        Name = "NoClip",
        CurrentValue = false,
        Flag = "noclip_toggle",
        Callback = function(val) 
            if Modules.noclip and Modules.noclip.Toggle then
                Modules.noclip.Toggle(val)
            end
        end
    })
    
    -- AntiHitbox
    self.MainTab:CreateToggle({
        Name = "Anti-Hitbox (Десинхронизация)",
        CurrentValue = false,
        Flag = "antihit_toggle",
        Callback = function(val) 
            if Modules.antihit and Modules.antihit.Toggle then
                Modules.antihit.Toggle(val)
            end
        end
    })
    
    self.MainTab:CreateDivider()
    
    -- Кнопка сброса
    self.MainTab:CreateButton({
        Name = "Сбросить все настройки",
        Callback = function()
            print("[GUI] Сброс настроек (функция в разработке)")
        end
    })
    
    -- ================== ESP TAB ==================
    
    -- ESP Toggle
    self.EspTab:CreateToggle({
        Name = "Enable ESP",
        CurrentValue = false,
        Flag = "esp_toggle",
        Callback = function(val) 
            if Modules.esp and Modules.esp.Toggle then
                Modules.esp.Toggle(val)
            end
        end
    })
    
    self.EspTab:CreateDivider()
    self.EspTab:CreateSection("Визуальные настройки")
    
    -- Цвет подсветки
    self.EspTab:CreateColorPicker({
        Name = "Цвет подсветки",
        Color = Color3.fromRGB(255, 0, 0),
        Flag = "esp_color",
        Callback = function(color) 
            if Modules.esp and Modules.esp.SetColor then
                Modules.esp.SetColor(color)
            end
        end
    })
    
    -- Прозрачность заливки
    self.EspTab:CreateSlider({
        Name = "Прозрачность заливки",
        Range = {0, 100},
        Increment = 1,
        Suffix = "%",
        CurrentValue = 50,
        Flag = "esp_transparency",
        Callback = function(value) 
            if Modules.esp and Modules.esp.SetTransparency then
                Modules.esp.SetTransparency(value)
            end
        end
    })
    
    -- Толщина обводки (дополнительный ползунок)
    self.EspTab:CreateSlider({
        Name = "Толщина обводки",
        Range = {1, 10},
        Increment = 1,
        Suffix = "px",
        CurrentValue = 2,
        Flag = "esp_outline",
        Callback = function(value) 
            if Modules.esp and Modules.esp.SetOutlineThickness then
                Modules.esp.SetOutlineThickness(value)
            end
        end
    })
    
    -- ================== FUTURE TAB ==================
    
    self.FutureTab:CreateButton({
        Name = "Функция 1 (пусто)",
        Callback = function()
            print("[GUI] Место для твоей функции 1")
        end
    })
    
    self.FutureTab:CreateButton({
        Name = "Функция 2 (пусто)",
        Callback = function()
            print("[GUI] Место для твоей функции 2")
        end
    })
    
    self.FutureTab:CreateToggle({
        Name = "Пример переключателя",
        CurrentValue = false,
        Flag = "example_toggle",
        Callback = function(val)
            print("[GUI] Пример переключателя:", val)
        end
    })
    
    self.FutureTab:CreateSlider({
        Name = "Пример ползунка",
        Range = {0, 100},
        Increment = 5,
        Suffix = "%",
        CurrentValue = 50,
        Flag = "example_slider",
        Callback = function(val)
            print("[GUI] Пример ползунка:", val)
        end
    })
end

return GUI
