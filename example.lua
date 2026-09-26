--[[
    ============================================================
    Sleepy Hub UI - Example Script
    ============================================================
    A complete example showing how to load and use the UI library
    with toggles, sliders, dropdowns, buttons, keybinds, and
    notifications.
    ============================================================
]]

-- ============================================================
-- 1. LOAD THE LIBRARY
-- ============================================================
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/yenkgg/Sleepy-Hub-UI/refs/heads/main/Library.lua"
))()

-- ============================================================
-- 2. CREATE THE MAIN WINDOW
-- ============================================================
local Window = Library:CreateWindow({
    Title    = "Example Hub",
    Subtitle = "v1.0.0 | by you",
    Size     = UDim2.new(0, 620, 0, 420),
    Theme    = "Dark",                 -- "Dark" | "Light"
    Keybind  = Enum.KeyCode.RightShift,-- toggle the UI
    Logo     = "rbxassetid://0000000000" -- optional
})

-- ============================================================
-- 3. CREATE TABS
-- ============================================================
local MainTab    = Window:CreateTab({ Name = "Main",    Icon = "rbxassetid://6031075931" })
local CombatTab  = Window:CreateTab({ Name = "Combat",  Icon = "rbxassetid://6031090990" })
local VisualsTab = Window:CreateTab({ Name = "Visuals", Icon = "rbxassetid://6031091004" })
local MiscTab    = Window:CreateTab({ Name = "Misc",    Icon = "rbxassetid://6031094667" })
local ConfigTab  = Window:CreateTab({ Name = "Config",  Icon = "rbxassetid://6031280882" })

-- ============================================================
-- 4. MAIN TAB
-- ============================================================
local MainSection = MainTab:CreateSection("Welcome")

MainSection:CreateLabel({
    Text = "Welcome to Example Hub!"
})

MainSection:CreateButton({
    Name = "Print Hello",
    Callback = function()
        print("Hello from Example Hub!")
        Library:Notify({
            Title    = "Button Pressed",
            Text     = "You clicked Print Hello",
            Duration = 3
        })
    end
})

-- ============================================================
-- 5. COMBAT TAB
-- ============================================================
local AimbotSection = CombatTab:CreateSection("Aimbot")

AimbotSection:CreateToggle({
    Name     = "Enable Aimbot",
    Default  = false,
    Callback = function(state)
        print("Aimbot:", state)
    end
})

AimbotSection:CreateKeybind({
    Name     = "Aimbot Key",
    Default  = Enum.KeyCode.E,
    Callback = function(key)
        print("Aimbot key set to:", key.Name)
    end
})

AimbotSection:CreateSlider({
    Name     = "FOV",
    Min      = 0,
    Max      = 360,
    Default  = 90,
    Suffix   = "°",
    Decimals = 0,
    Callback = function(value)
        print("FOV changed to:", value)
    end
})

AimbotSection:CreateSlider({
    Name     = "Smoothing",
    Min      = 0.01,
    Max      = 1,
    Default  = 0.15,
    Suffix   = "",
    Decimals = 2,
    Callback = function(value)
        print("Smoothing:", value)
    end
})

AimbotSection:CreateDropdown({
    Name     = "Target Part",
    Options  = { "Head", "Torso", "Nearest", "Random" },
    Default  = "Head",
    Callback = function(option)
        print("Targeting:", option)
    end
})

AimbotSection:CreateMultibox({
    Name     = "Target Teams",
    Options  = { "Enemies", "Neutrals", "Allies" },
    Default  = { "Enemies" },
    Callback = function(selected)
        print("Targeting:", table.concat(selected, ", "))
    end
})

-- ============================================================
-- 6. VISUALS TAB
-- ============================================================
local ESP = VisualsTab:CreateSection("ESP")

ESP:CreateToggle({
    Name     = "Player ESP",
    Default  = false,
    Callback = function(state)
        print("Player ESP:", state)
    end
})

ESP:CreateToggle({
    Name     = "Boxes",
    Default  = true,
    Callback = function(state) print("Boxes:", state) end
})

ESP:CreateToggle({
    Name     = "Names",
    Default  = true,
    Callback = function(state) print("Names:", state) end
})

ESP:CreateColorpicker({
    Name     = "Box Color",
    Default  = Color3.fromRGB(255, 60, 60),
    Callback = function(color)
        print("Box color:", color)
    end
})

ESP:CreateSlider({
    Name     = "Max Distance",
    Min      = 100,
    Max      = 5000,
    Default  = 1500,
    Suffix   = " studs",
    Decimals = 0,
    Callback = function(value) print("Max distance:", value) end
})

-- ============================================================
-- 7. MISC TAB
-- ============================================================
local MiscSection = MiscTab:CreateSection("Character")

MiscSection:CreateSlider({
    Name     = "WalkSpeed",
    Min      = 16,
    Max      = 200,
    Default  = 16,
    Decimals = 0,
    Callback = function(value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid").WalkSpeed = value
        end
    end
})

MiscSection:CreateSlider({
    Name     = "JumpPower",
    Min      = 50,
    Max      = 500,
    Default  = 50,
    Decimals = 0,
    Callback = function(value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid").JumpPower = value
        end
    end
})

MiscSection:CreateTextbox({
    Name        = "Chat Message",
    Placeholder = "Type something...",
    Callback    = function(text)
        game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
        print("You typed:", text)
    end
})

MiscSection:CreateButton({
    Name = "Reset Character",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char then
            char:BreakJoints()
        end
    end
})

-- ============================================================
-- 8. CONFIG TAB
-- ============================================================
local ConfigSection = ConfigTab:CreateSection("Save / Load")

ConfigSection:CreateButton({
    Name = "Save Config",
    Callback = function()
        Library:SaveConfig("myconfig")
        Library:Notify({ Title = "Saved", Text = "Config saved as 'myconfig'", Duration = 3 })
    end
})

ConfigSection:CreateButton({
    Name = "Load Config",
    Callback = function()
        Library:LoadConfig("myconfig")
        Library:Notify({ Title = "Loaded", Text = "Config 'myconfig' loaded", Duration = 3 })
    end
})

ConfigSection:CreateDropdown({
    Name     = "Select Config",
    Options  = { "Default", "myconfig" },
    Default  = "Default",
    Callback = function(option)
        print("Selected config:", option)
    end
})

-- ============================================================
-- 9. NOTIFICATIONS
-- ============================================================
Library:Notify({
    Title    = "Example Hub",
    Text     = "Loaded successfully!",
    Duration = 4,
    Icon     = "rbxassetid://6031075931"
})

-- ============================================================
-- 10. CLEANUP (optional)
-- ============================================================
-- Uncomment to remove the UI after 60 seconds:
-- task.delay(60, function()
--     Library:Destroy()
-- end)

print("[Example Hub] Script loaded.")
