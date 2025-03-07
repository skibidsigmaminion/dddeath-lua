-- Undertale Judgement Simulator: Dustdust Sans Protection System
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local CombatEvent = ReplicatedStorage:FindFirstChild("CombatEvent")
local TakeDamageEvent = ReplicatedStorage:FindFirstChild("TakeDamage")

local Config = {
    GodMode = true,
    OneHitKill = false,
    CurrentPhase = 1,
    DamageMultiplier = 1000
}

-- Обнаружение атак босса
local function IsDustAttack(attackId)
    return attackId:match("DUST_P1_") or attackId:match("DUST_P2_")
end

-- Перехват системы урона
if TakeDamageEvent then
    local originalTakeDamage = TakeDamageEvent.FireServer
    TakeDamageEvent.FireServer = function(self, ...)
        if Config.GodMode and IsDustAttack((...)) then
            return nil
        end
        return originalTakeDamage(self, ...)
    end
end

-- Модификатор атаки игрока
if CombatEvent then
    local originalCombat = CombatEvent.FireServer
    CombatEvent.FireServer = function(self, ...)
        local args = ...
        if Config.OneHitKill then
            if type(args) == "table" then
                args.damage = args.damage * Config.DamageMultiplier
            end
        end
        return originalCombat(self, args)
    end
end

-- GUI интерфейс
local function CreateGUI()
    local GUI = Instance.new("ScreenGui")
    GUI.Name = "DustProtectionGUI"
    GUI.Parent = game.CoreGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 220, 0, 150)
    Frame.Position = UDim2.new(0.78, 0, 0.2, 0)
    Frame.BackgroundTransparency = 0.8
    Frame.Parent = GUI

    local function CreateControl(text, yPos, callback)
        local Button = Instance.new("TextButton")
        Button.Text = text
        Button.Size = UDim2.new(0.9, 0, 0.25, 0)
        Button.Position = UDim2.new(0.05, 0, yPos, 0)
        Button.MouseButton1Click = callback
        Button.Parent = Frame
        return Button
    end

    local GodButton = CreateControl("Бессмертие: ВКЛ", 0.05, function()
        Config.GodMode = not Config.GodMode
        GodButton.Text = Config.GodMode and "Бессмертие: ВКЛ ✅" or "Бессмертие: ВЫКЛ ❌"
    end)

    local KillButton = CreateControl("Смерт.удар: ВЫКЛ", 0.35, function()
        Config.OneHitKill = not Config.OneHitKill
        KillButton.Text = Config.OneHitKill and "Смерт.удар: ВКЛ ☠️" or "Смерт.удар: ВЫКЛ ⚪"
    end)

    return GUI
end

-- Автоматическая настройка
local ProtectionGUI = CreateGUI()

RunService.Heartbeat:Connect(function()
    ProtectionGUI.Enabled = LocalPlayer.PlayerGui:FindFirstChild("SingleplayerGUI") ~= nil
end)

warn("[Dust Protection System] Активирован в singleplayer режиме!")
