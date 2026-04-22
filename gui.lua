local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Test Window",
   LoadingTitle = "Test",
   ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("Test", 4483362458)
local Section = Tab:CreateSection("Test Section")

Tab:CreateToggle({
   Name = "Test Toggle",
   CurrentValue = false,
   Section = Section,
   Callback = function(val) print("Toggle:", val) end
})

Tab:CreateSlider({
   Name = "Test Slider",
   Range = {0, 100},
   Increment = 1,
   CurrentValue = 50,
   Section = Section,
   Callback = function(val) print("Slider:", val) end
})

Tab:CreateButton({
   Name = "Test Button",
   Section = Section,
   Callback = function() print("Button clicked") end
})

print("Test GUI loaded")
