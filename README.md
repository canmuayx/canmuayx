-- โหลด Fluent และ Addons
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

--- สร้างหน้าต่าง Fluent
local Window = Fluent:CreateWindow({
    Title = "Canmuay X " .. Fluent.Version,
    SubTitle = "Auto Fishing testing",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark"
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "tool" }), -- เพิ่มแท็บ Misc
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- บริการหลัก
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Char = LocalPlayer.Character
local HR = Char and Char:FindFirstChild("HumanoidRootPart")

-- ตัวแปรตำแหน่ง CFrame
local SetCFrame = HR and HR.CFrame

-- ฟังก์ชัน SetCFrame
local function UpdateSetCFrame()
    if HR then
        SetCFrame = HR.CFrame
        Fluent:Notify({
            Title = "SetCFrame",
            Content = "Position has been updated.",
            Duration = 5
        })
    end
end

-- ฟังก์ชัน Anti AFK
local function AntiAFK()
    local args = { [1] = false }
    ReplicatedStorage:WaitForChild("events"):WaitForChild("afk"):FireServer(unpack(args))
    Fluent:Notify({
        Title = "Anti AFK",
        Content = "You are now active!",
        Duration = 5
    })
end

-- ฟังก์ชันติดตั้งไอเทม
local function equipitem(v)
    if LocalPlayer.Backpack:FindFirstChild(v) then
        local Eq = LocalPlayer.Backpack:FindFirstChild(v)
        LocalPlayer.Character.Humanoid:EquipTool(Eq)
    end
end

-- ฟังก์ชัน Autocast
local function AutoCast()
    if HR and SetCFrame then
        -- ย้ายกลับไปยังตำแหน่ง SetCFrame
        if (SetCFrame.Position - HR.Position).Magnitude >= 1 then
            HR.CFrame = SetCFrame
        end

        -- ใช้งาน Rod
        local Rod = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if Rod and Rod:FindFirstChild("events") then
            Rod.events.cast:FireServer(100, 1)
        end
    end
end

-- ฟังก์ชัน AutoReel
local function AutoReel()
    local args = {
        [1] = 100,
        [2] = true
    }
    ReplicatedStorage:WaitForChild("events"):WaitForChild("reelfinished"):FireServer(unpack(args))
end

-- สร้างปุ่ม GUI สำหรับแท็บ Main
Tabs.Main:AddButton({
    Title = "Set CFrame",
    Callback = function()
        UpdateSetCFrame()
    end
})

local autocastToggle = Tabs.Main:AddToggle("AutocastToggle", { Title = "Enable Autocast", Default = false })
autocastToggle:OnChanged(function()
    while autocastToggle.Value do
        AutoCast()
        task.wait(1) -- Delay เพื่อป้องกันการทำงานเร็วเกินไป
    end
end)

local autoreelToggle = Tabs.Main:AddToggle("AutoreelToggle", { Title = "Enable AutoReel", Default = false })
autoreelToggle:OnChanged(function()
    while autoreelToggle.Value do
        AutoReel()
        task.wait(1) -- Delay เพื่อป้องกันการรบกวนเซิร์ฟเวอร์
    end
end)

-- ปุ่มสำหรับติดตั้ง Fishing Rod
Tabs.Main:AddButton({
    Title = "Equip Fishing Rod",
    Callback = function()
        for i, v in pairs(LocalPlayer.Backpack:GetChildren()) do
            if v:IsA("Tool") and v.Name:lower():find("rod") then
                equipitem(v.Name)
            end
        end
        print("Fishing Rod Equipped!")
    end
})

-- สร้างปุ่ม GUI สำหรับแท็บ Misc
Tabs.Misc:AddButton({
    Title = "Anti AFK",
    Callback = function()
        AntiAFK()
    end
})

-- ตั้งค่าต่าง ๆ
InterfaceManager:SetLibrary(Fluent)
SaveManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:SetFolder("FluentScriptHub")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()

Fluent:Notify({
    Title = "Fluent",
    Content = "Auto Fishing Script Loaded!",
    Duration = 8
})
