-- gui.lua
-- Полностью переработанная версия, совместимая с Rayfield

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
        }
    })
    
    -- Создаём вкладки (без иконок, чтобы не было проблем)
    self.MainTab = Window:CreateTab("Main")
    self.EspTab = Window:CreateTab("ESP")
    self.FutureTab = Window:CreateTab("Future")
    
    return Window
end

function GUI:BindToggles(Modules)
    -- === MAIN TAB ===
    local mainSection = self.MainTab:CreateSection("Основные функции")
    
    self.MainTab:CreateToggle({
        Name = "GodMode",
        CurrentValue = false,
        Section = mainSection,
        Callback = function(val)
            if Modules.godmode then Modules.godmode.Toggle(val) end
        end
    })
    
    self.MainTab:CreateToggle({
        Name = "NoClip",
        CurrentValue = false,
        Section = mainSection,
        Callback = function(val)
            if Modules.noclip then Modules.noclip.Toggle(val) end
        end
    })
    
    self.MainTab:CreateToggle({
        Name = "Anti-Hitbox",
        CurrentValue = false,
        Section = mainSection,
        Callback = function(val)
            if Modules.antihit then Modules.antihit.Toggle(val) end
        end
    })
    
    -- === ESP TAB ===
    local espMainSection = self.EspTab:CreateSection("Основные настройки")
    
    self.EspTab:CreateToggle({
        Name = "Enable ESP",
        CurrentValue = false,
        Section = espMainSection,
        Callback = function(val)
            if Modules.esp then Modules.esp.Toggle(val) end
        end
    })
    
    local espVisualSection = self.EspTab:CreateSection("Визуальные настройки")
    
    self.EspTab:CreateColorPicker({
        Name = "Цвет подсветки",
        Color = Color3.fromRGB(255, 0, 0),
        Section = espVisualSection,
        Callback = function(color)
            if Modules.esp and Modules.esp.SetColor then
                Modules.esp.SetColor(color)
            end
        end
    })
    
    self.EspTab:CreateSlider({
        Name = "Прозрачность заливки",
        Range = {0, 100},
        Increment = 1,
        Suffix = "%",
        CurrentValue = 50,
        Section = espVisualSection,
        Callback = function(value)
            if Modules.esp and Modules.esp.SetTransparency then
                Modules.esp.SetTransparency(value)
            end
        end
    })
    
    self.EspTab:CreateSlider({
        Name = "Толщина обводки",
        Range = {1, 10},
        Increment = 1,
        Suffix = "px",
        CurrentValue = 2,
        Section = espVisualSection,
        Callback = function(value)
            if Modules.esp and Modules.esp.SetOutlineThickness then
                Modules.esp.SetOutlineThickness(value)
            end
        end
    })
    
    -- === FUTURE TAB ===
    local futureSection = self.FutureTab:CreateSection("Эксперименты")
    
    self.FutureTab:CreateButton({
        Name = "Кнопка 1",
        Section = futureSection,
        Callback = function()
            print("Кнопка 1 нажата")
        end
    })
    
    self.FutureTab:CreateButton({
        Name = "Кнопка 2",
        Section = futureSection,
        Callback = function()
            print("Кнопка 2 нажата")
        end
    })
    
    self.FutureTab:CreateToggle({
        Name = "Пример переключателя",
        CurrentValue = false,
        Section = futureSection,
        Callback = function(val)
            print("Toggle:", val)
        end
    })
    
    self.FutureTab:CreateSlider({
        Name = "Пример слайдера",
        Range = {0, 100},
        Increment = 5,
        CurrentValue = 50,
        Suffix = "%",
        Section = futureSection,
        Callback = function(val)
            print("Slider:", val)
        end
    })
end

return GUI
