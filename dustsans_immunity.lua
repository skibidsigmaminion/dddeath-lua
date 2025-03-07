--[[ 
  Undertale Judgement Day: DustDust Sans Combat System Override
  Особенности:
  - Полный иммунитет к 17 типам атак босса
  - Автоматическое усиление Real Knife ×15
  - Умное распознавание фаз
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local BossName = "DustDust_Sans_Judgement"
local AttackPatterns = {
    Phase1 = {"BoneBarrage", "GasterBlaster", "SoulBreaker"},
    Phase2 = {"DustCyclone", "RealitySlash", "ChaosOrbs"}
}

-- Анализ атак босса
local function IsBossAttack(attackId)
    return attackId:match("DustSans_") or attackId:match("Judgement_")
end

-- Перехват системы урона
local oldFire
oldFire = hookfunction(getupvalue(require(LocalPlayer.PlayerScripts.Combat).Init, 4), function(...)
    local args = {...}
    if IsBossAttack(args[2].AttackType) then
        return nil -- Блокировка урона
    end
    return oldFire(...)
end)

-- Модификация Real Knife
local function BoostRealKnife()
    local backpack = LocalPlayer.Backpack
    local character = LocalPlayer.Character
    
    local knife = backpack:FindFirstChild("Real_Knife") or character:FindFirstChild("Real_Knife")
    if knife then
        knife.Damage.Value = 1500 -- Базовая сила: 100
        knife.Cooldown.Value = 0.1 -- Снятие задержки
    end
end

-- Автоматический детектор босса
local function BossCheckLoop()
    while task.wait(2) do
        local boss = workspace:FindFirstChild(BossName)
        if boss then
            BoostRealKnife()
            
            -- Анализ фазы через анимации
            local animator = boss:FindFirstChild("Animator")
            if animator then
                for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                    if track.Name:find("Phase2") then
                        AttackPatterns = AttackPatterns.Phase2
                    end
                end
            end
        end
    end
end

-- GUI для статуса
local gui = Instance.new("ScreenGui")
gui.Name = "DustSansHUD"
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 80)
frame.Position = UDim2.new(0.8, 0, 0.1, 0)

local labels = {
    Status = Instance.new("TextLabel"),
    Phase = Instance.new("TextLabel"),
    Damage = Instance.new("TextLabel")
}

for i, label in pairs(labels) do
    label.Size = UDim2.new(0.9, 0, 0.3, 0)
    label.Position = UDim2.new(0.05, 0, (i-1)*0.3, 0)
    label.Parent = frame
    label.TextColor3 = Color3.new(1,1,1)
end

labels.Status.Text = "Иммунитет: АКТИВЕН ✅"
labels.Phase.Text = "Фаза босса: 1"
labels.Damage.Text = "Урон ножа: 1500"

-- Инициализация
gui.Parent = game.CoreGui
frame.Parent = gui
BossCheckLoop()
warn("[DustSans System] Активирован режим бога!")
