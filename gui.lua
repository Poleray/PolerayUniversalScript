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
    
    -- ================== ESP ==================
    self.EspTab:CreateSection("Основные настройки")
    
    -- ESP Toggle (включение/выключение)
    self.EspTab:CreateToggle({
        Name = "Enable ESP",
        Flag = "esp_toggle",
        Callback = function(val) 
            Modules.esp.Toggle(val) 
        end
    })
    
    self.EspTab:CreateSection("Визуальные настройки")
    
    -- Цвет подсветки
    self.EspTab:CreateColorPicker({
        Name = "Цвет подсветки",
        Color = Color3.fromRGB(255, 0, 0),
        Flag = "esp_color",
        Callback = function(color) 
            if Modules.esp.SetColor then
                Modules.esp.SetColor(color)
            end
        end
    })
    
    -- Прозрачность (ползунок)
    self.EspTab:CreateSlider({
        Name = "Прозрачность заливки",
        Range = {0, 100},
        Increment = 1,
        Suffix = "%",
        CurrentValue = 50,
        Flag = "esp_transparency",
        Callback = function(value) 
            if Modules.esp.SetTransparency then
                Modules.esp.SetTransparency(value)
            end
        end
    })
end
