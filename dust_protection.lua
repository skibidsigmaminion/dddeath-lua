-- Undertale Judgement Simulator: Dustdust Sans Protection System FIXED
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Конфигурация
local Config = {
    GodMode = true,
    OneHitKill = false,
    GUIKey = Enum.KeyCode.F8
}

-- Функция создания защищенного GUI
local function CreateProtectedGUI()
    local GUI = Instance.new("ScreenGui")
    GUI.Name = "DustProtectionGUI_FIXED"
    GUI.ResetOnSpawn = false
    GUI.IgnoreGuiInset = true
    
    -- Защита GUI для Synapse
    if syn and syn.protect_gui then
        syn.protect_gui(GUI)
    end
    
    GUI.Parent = CoreGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 250, 0, 160)
    Frame.Position = UDim2.new(0.5, -125, 0.5, -80)
    Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Frame.BorderSizePixel = 0
    Frame.Parent = GUI

    local function CreateButton(text, yPos)
        local Button = Instance.new("TextButton")
        Button.Text = text
        Button.Size = UDim2.new(0.9, 0, 0.2, 0)
        Button.Position = UDim2.new(0.05, 0, yPos, 0)
        Button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        Button.TextColor3 = Color3.new(1, 1, 1)
        Button.Font = Enum.Font.GothamBold
        Button.TextSize = 14
        Button.Parent = Frame
        return Button
    end

    -- Элементы управления
    local GodButton = CreateButton("GOD MODE: ACTIVE", 0.1)
    local KillButton = CreateButton("ONE-HIT KILL: INACTIVE", 0.35)
    local StatusLabel = Instance.new("TextLabel")
    
    StatusLabel.Text = "STATUS: READY"
    StatusLabel.TextColor3 = Color3.new(0, 1, 0)
    StatusLabel.Size = UDim2.new(0.9, 0, 0.2, 0)
    StatusLabel.Position = UDim2.new(0.05, 0, 0.6, 0)
    StatusLabel.Font = GodButton.Font
    StatusLabel.TextSize = 14
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Parent = Frame

    return GUI, GodButton, KillButton, StatusLabel
end

-- Создание и инициализация GUI
local GUI, GodButton, KillButton, StatusLabel = CreateProtectedGUI()

-- Обработчики кнопок
GodButton.MouseButton1Click:Connect(function()
    Config.GodMode = not Config.GodMode
    GodButton.Text = Config.GodMode and "GOD MODE: ACTIVE 🔵" or "GOD MODE: INACTIVE ⚪"
end)

KillButton.MouseButton1Click:Connect(function()
    Config.OneHitKill = not Config.OneHitKill
    KillButton.Text = Config.OneHitKill and "ONE-HIT KILL: ACTIVE 💀" or "ONE-HIT KILL: INACTIVE ⚪"
end)

-- Переключатель GUI
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Config.GUIKey then
        GUI.Enabled = not GUI.Enabled
        StatusLabel.Text = GUI.Enabled and "STATUS: VISIBLE 👁️" : "STATUS: HIDDEN 👻"
    end
end)

warn("[Dust Protection System] GUI initialized! Press F8 to toggle menu.")
