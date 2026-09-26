--[[
    ============================================================
    Sleepy Hub UI (Mobile Port) - Example Script
    - Library no longer creates the Toggle UI button
    - Library has the double-toggle bug fixed
    - This script creates its own standalone Toggle UI button
      in a separate ScreenGui so it can never be hidden by
      the menu itself.
    ============================================================
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
local window = Library:window({
    name     = "example",
    suffix   = "hub",
    gameInfo = "Example Hub for Roblox"
})

-- ============================================================
-- 3. STANDALONE MOBILE TOGGLE UI BUTTON
--    Own ScreenGui → never hidden by library["items"].Enabled
-- ============================================================
local uis = game:GetService("UserInputService")
local tween_service = game:GetService("TweenService")
local is_mobile = uis.TouchEnabled and not uis.KeyboardEnabled

if is_mobile then
    local toggle_gui = Instance.new("ScreenGui")
    toggle_gui.Name = "ToggleUIOverlay"
    toggle_gui.ResetOnSpawn = false
    toggle_gui.IgnoreGuiInset = true
    toggle_gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    toggle_gui.DisplayOrder = 99999

    local ok = pcall(function()
        toggle_gui.Parent = game:GetService("CoreGui")
    end)
    if not ok then
        toggle_gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    local btn = Instance.new("TextButton")
    btn.Name = "ToggleUIButton"
    btn.Size = UDim2.fromOffset(120, 40)
    btn.Position = UDim2.fromOffset(16, 16)
    btn.BackgroundColor3 = Color3.fromRGB(155, 150, 219)
    btn.BackgroundTransparency = 0.35
    btn.BorderSizePixel = 0
    btn.Text = "Toggle UI"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 15
    btn.Font = Enum.Font.Code
    btn.AutoButtonColor = false
    btn.Active = true
    btn.Draggable = true
    btn.ZIndex = 5
    btn.Parent = toggle_gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.6
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = btn

    local function press_feedback(t)
        tween_service:Create(
            btn,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad),
            { BackgroundTransparency = t }
        ):Play()
    end

    local function toggle_menu()
        Library["items"].Enabled = not Library["items"].Enabled
    end

    btn.MouseButton1Click:Connect(toggle_menu)
    btn.TouchTap:Connect(toggle_menu)
    btn.MouseButton1Down:Connect(function() press_feedback(0.6) end)
    btn.MouseButton1Up:Connect(function()   press_feedback(0.35) end)
end

-- ============================================================
-- 4. MAIN TAB
-- ============================================================
window:seperator({ name = "Main" })

local mainTab = window:tab({ name = "Main", tabs = { "Main" } })

do
    local leftColumn  = mainTab:column({})
    local leftSection = leftColumn:section({
        name    = "General",
        default = true,
        icon    = "rbxassetid://6022668898"
    })

    leftSection:label({
        name = "Welcome!",
        info = "This menu was built with the Sleepy Hub UI library."
    })

    leftSection:toggle({
        name      = "Enable Feature",
        default   = false,
        seperator = true,
        callback  = function(bool) print("[Example] Enable Feature:", bool) end
    })

    leftSection:slider({
        name      = "Speed",
        min       = 16,
        max       = 200,
        interval  = 1,
        default   = 16,
        suffix    = " ws",
        seperator = true,
        callback  = function(value)
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char:FindFirstChildOfClass("Humanoid").WalkSpeed = value
            end
        end
    })

    leftSection:slider({
        name      = "Jump Power",
        min       = 50,
        max       = 500,
        interval  = 5,
        default   = 50,
        seperator = true,
        callback  = function(value)
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char:FindFirstChildOfClass("Humanoid").JumpPower = value
            end
        end
    })

    leftSection:dropdown({
        name      = "Mode",
        items     = { "Legit", "Rage", "Custom" },
        default   = "Legit",
        seperator = true,
        callback  = function(option) print("[Example] Mode:", option) end
    })

    leftSection:dropdown({
        name      = "Flags",
        items     = { "Scoped", "Flashed", "Knocked", "Touched" },
        default   = { "Scoped", "Flashed" },
        multi     = true,
        seperator = true,
        callback  = function(selected)
            local str = ""
            for _, v in pairs(selected) do str = str .. v .. ", " end
            print("[Example] Flags:", str)
        end
    })

    local rightColumn  = mainTab:column({})
    local rightSection = rightColumn:section({
        name    = "Appearance",
        default = true,
        icon    = "rbxassetid://129380150574313"
    })

    rightSection:colorpicker({
        name      = "Accent Color",
        color     = Color3.fromRGB(155, 150, 219),
        seperator = true,
        callback  = function(color, alpha) print("[Example] Color:", color, "Alpha:", alpha) end
    })

    rightSection:keybind({
        name     = "Toggle Menu",
        mode     = "Toggle",
        default  = false,
        callback = function(active) window.toggle_menu(not active) end
    })

    rightSection:button({
        name     = "Print Hello",
        callback = function() print("[Example] Hello!") end
    })

    rightSection:button({
        name     = "Reset Character",
        callback = function()
            local char = game.Players.LocalPlayer.Character
            if char then char:BreakJoints() end
        end
    })

    rightSection:textbox({
        name        = "Your Name",
        placeholder = "Type here...",
        callback    = function(text) print("[Example] Typed:", text) end
    })
end

-- ============================================================
-- 5. VISUALS TAB
-- ============================================================
window:seperator({ name = "Visuals" })

local enemiesTab, teammatesTab, selfTab = window:tab({
    name = "Visuals",
    tabs = { "Enemies", "Teammates", "Self" }
})

for _, tab in { enemiesTab, teammatesTab, selfTab } do
    local column  = tab:column({})
    local section = column:section({
        name    = "ESP",
        default = true,
        icon    = "rbxassetid://6022668898"
    })

    section:toggle({ name = "Enable ESP", default = false, seperator = true })
    section:toggle({ name = "Through Walls", default = false, seperator = true })

    section:toggle({ name = "Box", default = true, seperator = true }):colorpicker({
        name  = "Box Color",
        color = Color3.fromRGB(255, 60, 60)
    })

    local nameToggle = section:toggle({ name = "Name", default = true, seperator = true })
    nameToggle:colorpicker({ name = "Name Color" })

    local nameSettings = nameToggle:settings({})
    nameSettings:toggle({ name = "Show Display Names", default = false, seperator = true })
    nameSettings:dropdown({
        name      = "Font",
        items     = { "ProggyTiny", "MonoSpace", "Tahoma" },
        default   = "MonoSpace",
        seperator = true
    })
    nameSettings:slider({
        name      = "Text Size",
        min       = 8,
        max       = 24,
        interval  = 1,
        default   = 14,
        seperator = true
    })

    section:slider({
        name      = "Max Distance",
        min       = 100,
        max       = 5000,
        interval  = 100,
        default   = 1500,
        suffix    = " studs",
        seperator = false
    })
end

-- ============================================================
-- 6. MISC TAB
-- ============================================================
window:seperator({ name = "Misc" })

local miscTab = window:tab({ name = "Misc", tabs = { "Misc" } })

do
    local column = miscTab:column({})

    local sectionA = column:section({
        name = "Section A", default = true, size = 0.5,
        icon = "rbxassetid://6022668898"
    })
    sectionA:toggle({ name = "A Toggle 1", default = false, seperator = true })
    sectionA:toggle({ name = "A Toggle 2", default = true,  seperator = true })
    sectionA:button({ name = "A Button", callback = function() print("A pressed") end })

    local sectionB = column:section({
        name = "Section B", default = true, size = 0.5,
        icon = "rbxassetid://6022668898"
    })
    sectionB:toggle({ name = "B Toggle 1", default = false, seperator = true })
    sectionB:slider({
        name = "B Slider", min = 0, max = 100, interval = 1,
        default = 50, seperator = true
    })
    sectionB:textbox({
        name        = "B Textbox",
        placeholder = "Type here...",
        callback    = function(text) print("Typed:", text) end
    })
end

-- ============================================================
-- 7. LOAD NOTIFICATION
-- ============================================================
task.delay(1, function()
    Library.notifications:create_notification({
        name     = "Example Hub",
        info     = "Menu loaded successfully!",
        lifetime = 4
    })
end)

-- ============================================================
-- 8. INIT CONFIG TAB
-- ============================================================
Library:init_config(window)

print("[Example Hub] Script loaded.")
