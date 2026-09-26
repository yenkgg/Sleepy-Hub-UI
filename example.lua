--[[
    Example script for Sleepy Hub UI Library
    Place this in your executor and run it.
]]

-- ============================================================
-- 1. LOAD THE LIBRARY
-- ============================================================
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/yenkgg/Sleepy-Hub-UI/refs/heads/main/Library.lua"
))()

-- ============================================================
-- 2. CREATE THE WINDOW
-- ============================================================
local Window = Library:CreateWindow({
    Title       = "Example Hub",
    Center      = true,                    -- auto-center on screen
    AutoShow    = true,                    -- show immediately
    Font        = Enum.Font.Code,
    Size        = UDim2.fromOffset(620, 520),
    ToggleKeybind = Enum.KeyCode.RightShift -- shows/hides the UI
})

-- ============================================================
-- 3. CREATE TABS
-- ============================================================
local MainTab = Window:CreateTab({
    Name  = "Main",
    Icon  = "rbxassetid://6031075931",
    Color = Color3.fromRGB(0, 85, 255)
})

local CombatTab = Window:CreateTab({
    Name  = "Combat",
    Icon  = "rbxassetid://6031090990",
    Color = Color3.fromRGB(255, 60, 60)
})

local VisualsTab = Window:CreateTab({
    Name  = "Visuals",
    Icon  = "rbxassetid://6031091004",
    Color = Color3.fromRGB(100, 220, 100)
})

local MiscTab = Window:CreateTab({
    Name  = "Misc",
    Icon  = "rbxassetid://6031094667",
    Color = Color3.fromRGB(255, 180, 0)
})

-- ============================================================
-- 4. MAIN TAB
-- ============================================================
local MainBox = MainTab:AddLeftGroupbox("Welcome")

MainBox:AddLabel("Welcome to Example Hub!")

MainBox:AddButton({
    Text = "Print Hello",
    Func = function()
        print("Hello from Example Hub!")
        Library:Notify("You clicked Print Hello", 3)
    end
})

MainBox:AddDivider()

MainBox:AddLabel("This is a divider example.")

-- ============================================================
-- 5. COMBAT TAB
-- ============================================================
local AimbotBox = CombatTab:AddLeftGroupbox("Aimbot")

AimbotBox:AddToggle(1, {
    Text     = "Enable Aimbot",
    Default  = false,
    Callback = function(state)
        print("Aimbot:", state)
    end
})

AimbotBox:AddKeyPicker(2, {
    Default  = "E",
    Text     = "Aimbot Key",
    Mode     = "Toggle",           -- "Always" | "Toggle" | "Hold"
    Callback = function(state)
        print("Aimbot key state:", state)
    end
})

AimbotBox:AddSlider(3, {
    Text     = "FOV",
    Default  = 90,
    Min      = 0,
    Max      = 360,
    Rounding = 0,                  -- 0 = integer, 1 = 1 decimal
    Suffix   = "°",
    Callback = function(value)
        print("FOV:", value)
    end
})

AimbotBox:AddSlider(4, {
    Text     = "Smoothing",
    Default  = 0.15,
    Min      = 0.01,
    Max      = 1,
    Rounding = 2,
    Suffix   = "",
    Callback = function(value)
        print("Smoothing:", value)
    end
})

AimbotBox:AddDropdown(5, {
    Text     = "Target Part",
    Values   = { "Head", "Torso", "Nearest", "Random" },
    Default  = "Head",
    Multi    = false,              -- set true for multiselect
    Callback = function(option)
        print("Targeting:", option)
    end
})

AimbotBox:AddDropdown(6, {
    Text     = "Target Teams",
    Values   = { "Enemies", "Neutrals", "Allies" },
    Default  = { "Enemies" },      -- table = multi
    Multi    = true,
    Callback = function(selected)
        local str = ""
        for _, v in pairs(selected) do str = str .. v .. ", " end
        print("Targeting:", str)
    end
})

local VisualsAimBox = CombatTab:AddRightGroupbox("Visuals")

VisualsAimBox:AddColorPicker(7, {
    Title    = "Box Color",
    Default  = Color3.fromRGB(255, 60, 60),
    Callback = function(color)
        print("Box color:", color)
    end
})

-- ============================================================
-- 6. VISUALS TAB
-- ============================================================
local ESPBox = VisualsTab:AddLeftGroupbox("ESP")

ESPBox:AddToggle(10, {
    Text     = "Player ESP",
    Default  = false,
    Callback = function(state) print("Player ESP:", state) end
})

ESPBox:AddToggle(11, {
    Text     = "Boxes",
    Default  = true,
    Callback = function(state) print("Boxes:", state) end
})

ESPBox:AddToggle(12, {
    Text     = "Names",
    Default  = true,
    Callback = function(state) print("Names:", state) end
})

ESPBox:AddSlider(13, {
    Text     = "Max Distance",
    Default  = 1500,
    Min      = 100,
    Max      = 5000,
    Rounding = 0,
    Suffix   = " studs",
    Callback = function(v) print("Max distance:", v) end
})

local ESPColorBox = VisualsTab:AddRightGroupbox("Colors")

ESPColorBox:AddColorPicker(14, {
    Title    = "ESP Color",
    Default  = Color3.fromRGB(60, 180, 255),
    Callback = function(color) print("ESP color:", color) end
})

-- ============================================================
-- 7. MISC TAB
-- ============================================================
local MiscBox = MiscTab:AddLeftGroupbox("Character")

MiscBox:AddSlider(20, {
    Text     = "WalkSpeed",
    Default  = 16,
    Min      = 16,
    Max      = 200,
    Rounding = 0,
    Suffix   = "",
    Callback = function(value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid").WalkSpeed = value
        end
    end
})

MiscBox:AddSlider(21, {
    Text     = "JumpPower",
    Default  = 50,
    Min      = 50,
    Max      = 500,
    Rounding = 0,
    Suffix   = "",
    Callback = function(value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid").JumpPower = value
        end
    end
})

MiscBox:AddInput(22, {
    Text        = "Chat Message",
    Default     = "",
    Placeholder = "Type something...",
    Callback    = function(text)
        print("You typed:", text)
    end
})

MiscBox:AddButton({
    Text = "Reset Character",
    Func = function()
        local char = game.Players.LocalPlayer.Character
        if char then char:BreakJoints() end
    end
})

local MiscBoxRight = MiscTab:AddRightGroupbox("Notifications")

MiscBoxRight:AddButton({
    Text = "Send Notification",
    Func = function()
        Library:Notify("This is a test notification!", 3)
    end
})

-- ============================================================
-- 8. INITIAL NOTIFICATION
-- ============================================================
Library:Notify("Example Hub loaded successfully!", 4)

print("[Example Hub] Script loaded.")
