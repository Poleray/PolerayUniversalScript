-- loader.lua
-- Этот скрипт ты вставляешь в эксплойт и выполняешь.

-- Загружаем библиотеку Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Создаём окно и вкладки (описано в gui.lua)
local GUI = loadstring(game:HttpGet('C:\Users\User\Desktop\CheatMenu\gui.lua'))()
local Window = GUI:CreateWindow(Rayfield)

-- Загружаем все модули функций
local Modules = {}
local function LoadModule(name)
    local module = loadstring(game:HttpGet('C:\Users\User\Desktop\CheatMenu/functions/' .. name .. '.lua'))()
    Modules[name] = module
    module.Init()
end

LoadModule('godmode')
LoadModule('noclip')
LoadModule('antihit')
LoadModule('esp')

-- Связываем GUI с модулями
GUI:BindToggles(Modules)

print('✅ Все модули загружены!')