-- Universal DustDust Sans Immunity System v4.0
return (function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local BossName = "DustDust_Sans"
    
    -- Конфигурация
    local Config = {
        Immunity = {
            Active = true,
            Attacks = {
                "BoneBarrage", "GasterBlast", "ChaosOrb", 
                "JudgementCut", "DustCyclone", "RealitySlash"
            }
        },
        RealKnife = {
            DamageMultiplier = 15,
            Cooldown = 0.05
        }
    }

    -- Перехват системы урона
    local CombatModule = require(LocalPlayer.PlayerScripts:WaitForChild("Combat"))
    local originalTakeDamage = CombatModule.TakeDamage

    CombatModule.TakeDamage = function(...)
        if Config.Immunity.Active then
            local attackType = select(2, ...).AttackType
            if table.find(Config.Immunity.Attacks, attackType) then
                return nil
            end
        end
        return originalTakeDamage(...)
    end

    -- Модификация Real Knife
    local function BoostWeapon()
        local function UpdateKnife(tool)
            if tool.Name == "Real_Knife" then
                local damage = tool:FindFirstChild("Damage")
                if damage then
                    damage.Value = 100 * Config.RealKnife.DamageMultiplier
                end
                tool.Cooldown.Value = Config.RealKnife.Cooldown
            end
        end

        LocalPlayer.Backpack.ChildAdded:Connect(UpdateKnife)
        LocalPlayer.Character.ChildAdded:Connect(UpdateKnife)
        
        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
            UpdateKnife(tool)
        end
    end

    -- Интерактивный GUI
    local function CreateInterface()
        local GUI = Instance.new("ScreenGui")
        GUI.Name = "SansFightHUD"
        GUI.Parent = game:GetService("CoreGui")

        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(0, 300, 0, 120)
        Frame.Position = UDim2.new(0.8, 0, 0.05, 0)
        Frame.BackgroundTransparency = 0.8

        local Elements = {
            Status = Instance.new("TextLabel"),
            Damage = Instance.new("TextLabel"),
            Phase = Instance.new("TextLabel")
        }

        for i, element in pairs(Elements) do
            element.Size = UDim2.new(0.9, 0, 0.3, 0)
            element.Position = UDim2.new(0.05, 0, (i-1)*0.3, 0)
            element.TextColor3 = Color3.new(1,1,1)
            element.Font = Enum.Font.GothamBold
            element.Parent = Frame
        end

        Elements.Status.Text = "🛡️ Иммунитет: АКТИВЕН"
        Elements.Damage.Text = "🗡️ Урон: x"..Config.RealKnife.DamageMultiplier
        Elements.Phase.Text = "⚡ Фаза: 1"

        return GUI, Elements
    end

    -- Инициализация
    BoostWeapon()
    CreateInterface()

    -- Автоопределение фазы
    game:GetService("RunService").Heartbeat:Connect(function()
        local boss = workspace:FindFirstChild(BossName)
        if boss and boss:FindFirstChild("Phase2Marker") then
            Config.Immunity.Attacks = {"RealitySlash", "FinalJudgement", "DustNova"}
            Elements.Phase.Text = "⚡ Фаза: 2"
        end
    end)
end)()
