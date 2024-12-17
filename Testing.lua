-- โหลด Fluent และ Addons
local a1 = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local a2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local a3 = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- สร้างหน้าต่าง Fluent
local w1 = a1:CreateWindow({
    Title = "Canmuay X " .. a1.Version,
    SubTitle = "Auto Fishing testing",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark"
})

local t1 = {
    m1 = w1:AddTab({ Title = "Main", Icon = "" }),
    m2 = w1:AddTab({ Title = "Misc", Icon = "tool" }),
    m3 = w1:AddTab({ Title = "Settings", Icon = "settings" })
}

local o1 = a1.Options
local p1 = game:GetService("Players")
local p2 = game:GetService("ReplicatedStorage")
local p3 = p1.LocalPlayer
local c1 = p3.Character
local c2 = c1 and c1:FindFirstChild("HumanoidRootPart")
local c3 = c2 and c2.CFrame

-- ฟังก์ชัน SetCFrame
local function f1()
    if c2 then
        c3 = c2.CFrame
        a1:Notify({
            Title = "SetCFrame",
            Content = "Position has been updated.",
            Duration = 5
        })
    end
end

-- ฟังก์ชัน Anti AFK
local function f2()
    local a4 = { [1] = false }
    p2:WaitForChild("events"):WaitForChild("afk"):FireServer(unpack(a4))
    a1:Notify({
        Title = "Anti AFK",
        Content = "You are now active!",
        Duration = 5
    })
end

-- ฟังก์ชันติดตั้งไอเทม
local function f3(v)
    if p3.Backpack:FindFirstChild(v) then
        local eq = p3.Backpack:FindFirstChild(v)
        p3.Character.Humanoid:EquipTool(eq)
    end
end

-- ฟังก์ชัน Autocast
local function f4()
    if c2 and c3 then
        if (c3.Position - c2.Position).Magnitude >= 1 then
            c2.CFrame = c3
        end
        local rod = p3.Character:FindFirstChildOfClass("Tool")
        if rod and rod:FindFirstChild("events") then
            rod.events.cast:FireServer(100, 1)
        end
    end
end

-- ฟังก์ชัน AutoReel
local function f5()
    local a5 = { [1] = 100, [2] = true }
    p2:WaitForChild("events"):WaitForChild("reelfinished"):FireServer(unpack(a5))
end

-- สร้างปุ่ม GUI สำหรับแท็บ Main
t1.m1:AddButton({
    Title = "Set CFrame",
    Callback = function()
        f1()
    end
})

local t2 = t1.m1:AddToggle("AutocastToggle", { Title = "Enable Autocast", Default = false })
t2:OnChanged(function()
    while t2.Value do
        f4()
        task.wait(1)
    end
end)

local t3 = t1.m1:AddToggle("AutoreelToggle", { Title = "Enable AutoReel", Default = false })
t3:OnChanged(function()
    while t3.Value do
        f5()
        task.wait(1)
    end
end)

-- ปุ่มสำหรับติดตั้ง Fishing Rod
t1.m1:AddButton({
    Title = "Equip Fishing Rod",
    Callback = function()
        for i, v in pairs(p3.Backpack:GetChildren()) do
            if v:IsA("Tool") and v.Name:lower():find("rod") then
                f3(v.Name)
            end
        end
        print("Fishing Rod Equipped!")
    end
})

-- สร้างปุ่ม GUI สำหรับแท็บ Misc
t1.m2:AddButton({
    Title = "Anti AFK",
    Callback = function()
        f2()
    end
})

-- ตั้งค่าต่าง ๆ
a3:SetLibrary(a1)
a2:SetLibrary(a1)
a2:IgnoreThemeSettings()
a2:SetIgnoreIndexes({})
a2:SetFolder("FluentScriptHub/specific-game")
a3:SetFolder("FluentScriptHub")
a3:BuildInterfaceSection(t1.m3)
a2:BuildConfigSection(t1.m3)

w1:SelectTab(1)
a2:LoadAutoloadConfig()

a1:Notify({
    Title = "Fluent",
    Content = "Auto Fishing Script Loaded!",
    Duration = 8
})
