-- Undertale Judgement Day: DustDust Sans Instant Win
local Player = game:GetService("Players").LocalPlayer
local BossName = "DustDust_Sans"
local CheatActive = true

local function DeleteBoss()
    local boss = workspace:FindFirstChild(BossName) 
    if not boss then return end

    -- Уничтожение механик босса
    for _,v in ipairs(boss:GetDescendants()) do
        if v:IsA("BasePart") then
            v:Destroy()
        elseif v:IsA("Script") then
            v.Disabled = true
        end
    end

    -- Форсированная победа
    local Events = game:GetService("ReplicatedStorage"):FindFirstChild("BossFightEvents")
    if Events then
        Events.Defeated:FireServer(boss)
    end

    -- Фикс игрового прогресса
    game:GetService("Players").LocalPlayer.PlayerGui.BossGUI.Enabled = false
end

local function GodMode()
    local humanoid = Player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Health = humanoid.MaxHealth
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end
end

-- GUI для контроля
local gui = Instance.new("ScreenGui")
local button = Instance.new("TextButton")
gui.Parent = game.CoreGui
button.Text = "🔥 ACTIVATE DUSTDUST KILL"
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, -100, 0.9, 0)
button.Parent = gui

button.MouseButton1Click:Connect(function()
    CheatActive = not CheatActive
    button.Text = CheatActive and "CHEAT: ON ✅" or "CHEAT: OFF ❌"
end)

-- Главный цикл
while task.wait(1) do
    if CheatActive then
        DeleteBoss()
        GodMode()
        
        -- Авто-атака
        local VirtualInput = game:GetService("VirtualInputManager")
        VirtualInput:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
    end
end
