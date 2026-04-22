local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
-- gui.lua (исправленная версия с явными секциями)
local GUI = {}

function GUI:CreateWindow(Rayfield)
    local Window = Rayfield:CreateWindow({
        Name = "Ultimate Cheat Menu",
        LoadingTitle = "Loading...",
        LoadingSubtitle = "by Poleray",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "UltimateCheat",
            FileName = "Settings"
        }
    })
    
    -- Создаём вкладки (без эмодзи, только текст)
    self.MainTab = Window:CreateTab("Main", 4483362458)
    self.EspTab = Window:CreateTab("ESP", 4483362458)
    self.FutureTab = Window:CreateTab("Future", 4483362458)
    
    return Window
end

function GUI:BindToggles(Modules)
    -- ================== MAIN TAB ==================
    -- Создаём секцию и сохраняем её в переменную
    local mainSection = self.MainTab:CreateSection("Main Functions")
    
    -- GodMode
    self.MainTab:CreateToggle({
        Name = "GodMode",
        CurrentValue = false,
        Flag = "godmode_toggle",
        Section = mainSection,
        Callback = function(val)
            if Modules.godmode then Modules.godmode.Toggle(val) end
        end
    })
    
    -- NoClip
    self.MainTab:CreateToggle({
        Name = "NoClip",
        CurrentValue = false,
        Flag = "noclip_toggle",
        Section = mainSection,
        Callback = function(val)
            if Modules.noclip then Modules.noclip.Toggle(val) end
        end
    })
    
    -- Anti-Hitbox
    self.MainTab:CreateToggle({
        Name = "Anti-Hitbox",
        CurrentValue = false,
        Flag = "antihit_toggle",
        Section = mainSection,
        Callback = function(val)
            if Modules.antihit then Modules.antihit.Toggle(val) end
        end
    })
    
    self.MainTab:CreateButton({
        Name = "Reset Settings",
        Section = mainSection,
        Callback = function()
            print("[GUI] Reset not implemented yet")
        end
    })
    
    -- ================== ESP TAB ==================
    local espMainSection = self.EspTab:CreateSection("ESP Controls")
    
    -- Enable ESP
    self.EspTab:CreateToggle({
        Name = "Enable ESP",
        CurrentValue = false,
        Flag = "esp_toggle",
        Section = espMainSection,
        Callback = function(val)
            if Modules.esp then Modules.esp.Toggle(val) end
        end
    })
    
    local espVisualSection = self.EspTab:CreateSection("Visual Settings")
    
    -- Color Picker
    self.EspTab:CreateColorPicker({
        Name = "Highlight Color",
        Color = Color3.fromRGB(255, 0, 0),
        Flag = "esp_color",
        Section = espVisualSection,
        Callback = function(color)
            if Modules.esp and Modules.esp.SetColor then
                Modules.esp.SetColor(color)
            end
        end
    })
    
    -- Transparency Slider
    self.EspTab:CreateSlider({
        Name = "Fill Transparency",
        Range = {0, 100},
        Increment = 1,
        Suffix = "%",
        CurrentValue = 50,
        Flag = "esp_transparency",
        Section = espVisualSection,
        Callback = function(value)
            if Modules.esp and Modules.esp.SetTransparency then
                Modules.esp.SetTransparency(value)
            end
        end
    })
    
    -- Outline Thickness Slider
    self.EspTab:CreateSlider({
        Name = "Outline Thickness",
        Range = {1, 10},
        Increment = 1,
        Suffix = "px",
        CurrentValue = 2,
        Flag = "esp_outline",
        Section = espVisualSection,
        Callback = function(value)
            if Modules.esp and Modules.esp.SetOutlineThickness then
                Modules.esp.SetOutlineThickness(value)
            end
        end
    })
    
    -- ================== FUTURE TAB ==================
    local futureSection = self.FutureTab:CreateSection("Extra Features")
    
    self.FutureTab:CreateButton({
        Name = "Placeholder Button 1",
        Section = futureSection,
        Callback = function()
            print("[GUI] Button 1 clicked")
        end
    })
    
    self.FutureTab:CreateButton({
        Name = "Placeholder Button 2",
        Section = futureSection,
        Callback = function()
            print("[GUI] Button 2 clicked")
        end
    })
    
    self.FutureTab:CreateToggle({
        Name = "Example Toggle",
        CurrentValue = false,
        Flag = "example_toggle",
        Section = futureSection,
        Callback = function(val)
            print("[GUI] Example toggle:", val)
        end
    })
    
    self.FutureTab:CreateSlider({
        Name = "Example Slider",
        Range = {0, 100},
        Increment = 5,
        Suffix = "%",
        CurrentValue = 50,
        Flag = "example_slider",
        Section = futureSection,
        Callback = function(val)
            print("[GUI] Example slider:", val)
        end
    })
end

return GUI
