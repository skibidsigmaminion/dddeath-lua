local BossPhases = {
    Phase1 = true,
    Phase2 = true,
    BossDead = false
}

local GUI = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")

-- Настройка интерфейса
GUI.Name = "DustDustHelper"
GUI.Parent = game.CoreGui

Frame.Size = UDim2.new(0, 250, 0, 120)
Frame.Position = UDim2.new(0.78, 0, 0.2, 0)
Frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Frame.Parent = GUI

Title.Text = "DustDust Control Panel v3.1"
Title.Size = UDim2.new(0.9, 0, 0.2, 0)
Title.Position = UDim2.new(0.05, 0, 0.05, 0)
Title.Parent = Frame

ToggleButton.Text = "АКТИВИРОВАТЬ"
ToggleButton.Size = UDim2.new(0.6, 0, 0.3, 0)
ToggleButton.Position = UDim2.new(0.2, 0, 0.3, 0)
ToggleButton.Parent = Frame

StatusLabel.Text = "Статус: Выключено ❌"
StatusLabel.Size = UDim2
