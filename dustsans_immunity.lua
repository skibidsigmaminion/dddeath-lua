-- Undertale Judgement Day: DustDust Sans Immunity System
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local BossName = "DustDust_Sans_Judgement"
local RealKnifeName = "Real_Knife"

-- Конфигурация
local Config = {
    GodMode = true,
    DamageMultiplier = 15,
    KnifeCooldown = 0.1
}

-- Перехват системы урона
local function BlockBossDamage()
    local CombatModule
    for _, script in pairs(LocalPlayer.PlayerScripts:GetChildren()) do
        if script.Name == "Combat" then
            CombatModule = require(script)
            break
        end
    end

    if CombatModule then
        local originalTakeDamage = CombatModule.TakeDamage
        CombatModule.TakeDamage = function(...)
            local args = {...}
            if Config.GodMode and args[2] and args[2].AttackerName == BossName then
                return nil
            end
            return originalTakeDamage(...)
        end
    end
end

-- Усиление Real Knife
local function ModifyWeaponStats()
    local function UpdateKnife(knife)
        if knife:IsA("Tool") and knife.Name == RealKnifeName then
            knife.Damage.Value = 100 * Config.DamageMultiplier
            knife.Cooldown.Value = Config.KnifeCooldown
        end
    end

    LocalPlayer.Backpack.ChildAdded:Connect(UpdateKnife)
    LocalPlayer.Character.ChildAdded:Connect(UpdateKnife)
    
    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
        UpdateKnife(tool)
    end
end

-- GUI интерфейс
local function CreateHUD()
    local GUI = Instance.new("ScreenGui")
    GUI.Name = "DustSansHUD"
    GUI.Parent = CoreGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 250, 0, 100)
    Frame.Position = UDim2.new(0.8, 0, 0.1, 0)
    Frame.BackgroundTransparency = 0.7
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Text = "⚔️ ИММУНИТЕТ: АКТИВЕН"
    StatusLabel.TextColor3 = Color3.new(0, 1, 0)
    StatusLabel.Size = UDim2.new(0.9, 0, 0.3, 0)
    StatusLabel.Position = UDim2.new(0.05, 0, 0.1, 0)

    local DamageLabel = Instance.new("TextLabel")
    DamageLabel.Text = string.format("УРОН НОЖА: x%d", Config.DamageMultiplier)
    DamageLabel.TextColor3 = Color3.new(1, 0.5, 0)
    DamageLabel.Size = UDim2.new(0.9, 0, 0.3, 0)
    DamageLabel.Position = UDim2.new(0.05, 0, 0.5, 0)

    StatusLabel.Parent = Frame
    DamageLabel.Parent = Frame
    Frame.Parent = GUI

    return GUI
end

-- Инициализация
BlockBossDamage()
ModifyWeaponStats()
CreateHUD()

warn("[DustSans System] Система активирована!")
print("▄▀▄▀▄▀▄ НАСТРОЙКИ ▄▀▄▀▄▀▄")
print("Иммунитет: Включен")
print("Множитель урона: x"..Config.DamageMultiplier)
