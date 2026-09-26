--[[
    ============================================================
    Sleepy Hub UI (Mobile Port) - Example Script
    - Fixes the "Toggle UI button hides itself" bug
    ============================================================
]]

-- ============================================================
-- 1. FETCH + PATCH + LOAD THE LIBRARY
-- ============================================================
local LIB_URL = "https://raw.githubusercontent.com/yenkgg/Sleepy-Hub-UI/refs/heads/main/Library.lua"

local src = game:HttpGet(LIB_URL)

-- [PATCH] Replace the buggy Toggle UI button creation so that it
-- lives in its own ScreenGui instead of inside library["items"].
-- The original block starts with `-- [MOBILE] Toggle UI button`
-- and ends with the closing `end` of the `if is_mobile then` block.
-- We replace the whole block with a fixed version.

local patched_block = [[
            -- [MOBILE] Toggle UI button (PATCHED: separate ScreenGui)
            if is_mobile then
                local toggle_gui = library:create("ScreenGui", {
                    Parent = coregui;
                    Name = "\0";
                    Enabled = true;
                    ZIndexBehavior = Enum.ZIndexBehavior.Global;
                    IgnoreGuiInset = true;
                    DisplayOrder = 99999;
                })

                items[ "toggle_ui_button" ] = library:create( "TextButton" , {
                    Parent = toggle_gui;
                    Name = "\0";
                    Size = dim_offset(120, 40);
                    Position = dim_offset(16, 16);
                    BackgroundColor3 = themes.preset.accent;
                    BackgroundTransparency = 0.35;
                    BorderSizePixel = 0;
                    Text = "Toggle UI";
                    TextColor3 = rgb(255, 255, 255);
                    TextSize = 15;
                    FontFace = fonts.font;
                    AutoButtonColor = false;
                    ZIndex = 999;
                    Active = true;
                    Draggable = true;
                });

                library:create( "UICorner" , {
                    Parent = items[ "toggle_ui_button" ];
                    CornerRadius = dim(0, 8)
                });

                library:create( "UIStroke" , {
                    Parent = items[ "toggle_ui_button" ];
                    Color = rgb(255, 255, 255);
                    Transparency = 0.6;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                });

                local function do_toggle()
                    library[ "items" ].Enabled = not library[ "items" ].Enabled
                end

                items[ "toggle_ui_button" ].MouseButton1Click:Connect(do_toggle)
                items[ "toggle_ui_button" ].TouchTap:Connect(do_toggle)

                items[ "toggle_ui_button" ].MouseButton1Down:Connect(function()
                    library:tween(items[ "toggle_ui_button" ], {BackgroundTransparency = 0.6}, Enum.EasingStyle.Quad, 0.1)
                end)
                items[ "toggle_ui_button" ].MouseButton1Up:Connect(function()
                    library:tween(items[ "toggle_ui_button" ], {BackgroundTransparency = 0.35}, Enum.EasingStyle.Quad, 0.1)
                end)
            end
]]

-- Find and replace the original buggy block
local start_marker = "%-%- %[MOBILE%] Toggle UI button"
local _, start_idx = src:find(start_marker)
if start_idx then
    -- Find the matching "end" of the `if is_mobile then` block
    -- by scanning forward for the next "-- return setmetatable" (which follows it)
    local tail_marker = "return setmetatable%(cfg, library%)"
    local _, tail_idx = src:find(tail_marker, start_idx)
    if tail_idx then
        -- Back up to the start of that line's "return"
        local return_start = src:sub(1, tail_idx):find("return setmetatable")
        src = src:sub(1, start_idx - 1) .. patched_block .. "\n            " .. src:sub(return_start)
    end
end

local Library = (loadstring or load)(src, "Milenium")()

-- ============================================================
-- 2. CREATE THE WINDOW
-- ============================================================
local window = Library:window({
    name     = "example",
    suffix   = "hub",
    gameInfo = "Example Hub for Roblox"
})

-- ============================================================
-- 3. MAIN TAB
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
        callback  = function(bool)
            print("[Example] Enable Feature:", bool)
        end
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
        callback  = function(color, alpha)
            print("[Example] Color:", color, "Alpha:", alpha)
        end
    })

    rightSection:keybind({
        name     = "Toggle Menu",
        mode     = "Toggle",
        default  = false,
        callback = function(active)
            window.toggle_menu(not active)
        end
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
-- 4. VISUALS TAB
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
-- 5. MISC TAB
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
-- 6. NOTIFICATION
-- ============================================================
task.delay(1, function()
    Library.notifications:create_notification({
        name     = "Example Hub",
        info     = "Menu loaded successfully!",
        lifetime = 4
    })
end)

-- ============================================================
-- 7. INIT CONFIG TAB
-- ============================================================
Library:init_config(window)

print("[Example Hub] Script loaded.")
