# Sleepy Hub UI — Complete Tutorial (Mobile Port)

A full guide to using the **Sleepy Hub UI** library in your Roblox scripts — including the mobile-friendly patches (touch support + toggle UI button).

---

## Table of Contents

1. [Installation](#1-installation)
2. [Creating a Window](#2-creating-a-window)
3. [Tabs](#3-tabs)
4. [Columns & Sections](#4-columns--sections)
5. [Elements](#5-elements)
   - [Label](#label)
   - [Button](#button)
   - [Toggle](#toggle)
   - [Slider](#slider)
   - [Dropdown](#dropdown)
   - [Multibox](#multibox)
   - [Textbox](#textbox)
   - [Keybind](#keybind)
   - [Colorpicker](#colorpicker)
   - [Settings submenu](#settings-submenu)
6. [Notifications](#6-notifications)
7. [Configs (save / load)](#7-configs-save--load)
8. [Mobile Port Notes](#8-mobile-port-notes)
9. [Common Mistakes](#9-common-mistakes)
10. [Full Example](#10-full-example)

---

## 1. Installation

### 1.1 Loading the library

At the top of your script, fetch and load the library:

```lua
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/yenkgg/Sleepy-Hub-UI/refs/heads/main/Library.lua"
))()
```

The `()` at the end **calls** the chunk that `loadstring` returns, so `Library` becomes a table with all the UI functions.

### 1.2 Requirements

- An executor with `loadstring` or `load` (Delta, Solara, Wave, Krnl, etc.)
- `game.HttpGet` enabled (on by default in most executors)
- Write access to `CoreGui` — needed for the UI to render
- `writefile` / `readfile` / `delfile` / `listfiles` / `makefolder` — only needed if you want the **config** system to work

### 1.3 Optional: host your own copy

If you patch `Library.lua`, host the modified file on a GitHub gist / repo and change the URL:

```lua
local Library = loadstring(game:HttpGet("YOUR_URL_HERE"))()
```

---

## 2. Creating a Window

```lua
local window = Library:window({
    name     = "example",      -- shown in the title, e.g. "exampletech"
    suffix   = "hub",          -- second half of the title
    gameInfo = "My Hub v1.0"   -- shown in the bottom bar
})
```

**Options:**

| Key | Type | Default | Description |
|---|---|---|---|
| `name` | string | `"nebula"` | First part of the title (accent-colored) |
| `suffix` | string | `"tech"` | Second part of the title (white) |
| `gameInfo` | string | `"Milenium for CS:GO"` | Info text in the bottom bar |
| `size` | UDim2 | auto | Window size — auto-fits on mobile |

**Returns:** a `window` object you'll use to add tabs and separators.

---

## 3. Tabs

A window holds tabs in a vertical list on the left side.

### Single tab

```lua
local mainTab = window:tab({
    name = "Main",
    tabs = { "Main" }
})
```

### Multi tab (tab with sub-tabs)

```lua
local enemies, teammates, selfTab = window:tab({
    name = "Visuals",
    tabs = { "Enemies", "Teammates", "Self" }
})
```

Each name inside `tabs` becomes a button at the top of the page. The tab function **returns one object per name**, so unpack them:

```lua
local a, b, c = window:tab({ name = "T", tabs = { "One", "Two", "Three" } })
-- a = tab "One", b = tab "Two", c = tab "Three"
```

### Separators (section labels in the sidebar)

```lua
window:seperator({ name = "Settings" })
```

Separators are just visual labels above groups of tabs. Note the misspelling — it's `seperator`, not `separator`.

---

## 4. Columns & Sections

Each tab contains **columns**, and each column contains **sections**. Columns control horizontal layout; sections control vertical groups of elements.

### Basic layout

```lua
local column  = tab:column({})
local section = column:section({
    name    = "General",
    default = true,
    icon    = "rbxassetid://6022668898"
})
```

### Two sections side by side

Give each section `size = 0.5`:

```lua
local col = tab:column({})

local leftSection  = col:section({ name = "Left",  size = 0.5, default = true })
local rightSection = col:section({ name = "Right", size = 0.5, default = true })
```

### Multiple columns

You can have several columns per tab — great for a wide layout:

```lua
local col1 = tab:column({})
local col2 = tab:column({})
```

### Section options

| Key | Type | Default | Description |
|---|---|---|---|
| `name` | string | `"section"` | Header title |
| `size` | number | `0.5` | Vertical size as a fraction of the column |
| `default` | bool | `false` | Show expanded on load |
| `icon` | string | rbxasset | Header icon |
| `fading` | bool | `false` | Adds a small on/off toggle on the header |

Sections scroll internally if content overflows.

---

## 5. Elements

All elements are added **inside a section** by calling `section:<element>(options)`.

---

### Label

Static text (title + optional info paragraph):

```lua
section:label({
    name = "Welcome!",
    info = "Optional smaller text below."
})
```

---

### Button

```lua
section:button({
    name     = "Print Hello",
    callback = function()
        print("Hello!")
    end
})
```

| Key | Type | Description |
|---|---|---|
| `name` | string | Button text |
| `callback` | function | Fires when clicked |

---

### Toggle

```lua
section:toggle({
    name      = "Enable Feature",
    default   = false,
    seperator = true,       -- draws a thin line below
    info      = "Optional info text",
    callback  = function(state)
        print("Toggled:", state)
    end
})
```

| Key | Type | Default | Description |
|---|---|---|---|
| `name` | string | `"Toggle"` | Row title |
| `default` | bool | `false` | Initial value |
| `seperator` | bool | `false` | Line below the row |
| `info` | string | nil | Extra description |
| `callback` | function | no-op | Fires with the new state |

The library randomly picks **toggle** or **checkbox** style. Force it:

```lua
section:toggle({
    name = "Force Checkbox",
    type = "checkbox",     -- or "toggle"
    default = false
})
```

---

### Slider

```lua
section:slider({
    name      = "Speed",
    min       = 16,
    max       = 200,
    interval  = 1,          -- step (also accepts "decimal")
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
```

| Key | Type | Default | Description |
|---|---|---|---|
| `name` | string | nil | Row title |
| `min` / `max` | number | `0` / `100` | Range |
| `interval` | number | `1` | Step size |
| `default` | number | `10` | Initial value |
| `suffix` | string | `""` | Text appended to the value (e.g. `"%"`) |
| `seperator` | bool | `true` | Line below |
| `callback` | function | no-op | Fires with the new value |

---

### Dropdown

Single-select:

```lua
section:dropdown({
    name      = "Mode",
    items     = { "Legit", "Rage", "Custom" },
    default   = "Legit",
    seperator = true,
    callback  = function(option) print("Chose:", option) end
})
```

Multi-select:

```lua
section:dropdown({
    name      = "Flags",
    items     = { "Scoped", "Flashed", "Knocked", "Touched" },
    default   = { "Scoped", "Flashed" },     -- table = multi
    multi     = true,
    seperator = true,
    callback  = function(selected)
        local str = ""
        for _, v in pairs(selected) do str = str .. v .. ", " end
        print("Selected:", str)
    end
})
```

| Key | Type | Default | Description |
|---|---|---|---|
| `name` | string | nil | Row title |
| `items` | table | `{""}` | Options |
| `default` | string/table | first item | Initial selection |
| `multi` | bool | `false` | Allow multi-select |
| `width` | number | `130` | Dropdown width |
| `seperator` | bool | `true` | Line below |

---

### Multibox

An alias — use `dropdown` with `multi = true` instead. The library doesn't define `CreateMultibox`; use the drop-down method above.

---

### Textbox

```lua
section:textbox({
    name        = "Your Name",
    placeholder = "Type here...",
    default     = "",
    callback    = function(text)
        print("You typed:", text)
    end
})
```

| Key | Type | Default | Description |
|---|---|---|---|
| `name` | string | `"TextBox"` | Row title |
| `placeholder` | string | `"type here..."` | Grey text when empty |
| `default` | string | `""` | Initial content |
| `callback` | function | no-op | Fires every keystroke |

---

### Keybind

```lua
section:keybind({
    name     = "Toggle Menu",
    mode     = "Toggle",      -- "Toggle" | "Hold" | "Always"
    default  = false,
    callback = function(state)
        print("Keybind active:", state)
    end
})
```

| Key | Type | Default | Description |
|---|---|---|---|
| `name` | string | nil | Row title |
| `mode` | string | `"Toggle"` | Behavior mode |
| `default` | bool | `false` | Initial active state |
| `callback` | function | no-op | Fires on press/release |

**Using the keybind:**

- **Left-click / tap** the pill → binds a key
- **Right-click / hold** → opens a mode picker (Hold / Toggle / Always)

---

### Colorpicker

Standalone:

```lua
section:colorpicker({
    name      = "Box Color",
    color     = Color3.fromRGB(255, 60, 60),
    seperator = true,
    callback  = function(color, alpha)
        print("Color:", color, "Alpha:", alpha)
    end
})
```

**Chained off a toggle** (adds a small swatch to the right of the toggle):

```lua
section:toggle({ name = "Box", default = true }):colorpicker({
    name = "Box Color",
    color = Color3.fromRGB(255, 60, 60)
})
```

| Key | Type | Description |
|---|---|---|
| `name` | string | Row title |
| `color` | Color3 | Initial color |
| `alpha` | number | Initial transparency (0 = opaque, 1 = invisible) |
| `callback` | function | Fires with `(Color3, alpha)` |

---

### Settings submenu

Nest extra controls under a toggle so they only appear when you click the small arrow next to it:

```lua
local nameToggle = section:toggle({ name = "Name", default = true })

local sub = nameToggle:settings({})
sub:toggle({ name = "Show Display Names", default = false })
sub:dropdown({
    name    = "Font",
    items   = { "ProggyTiny", "MonoSpace", "Tahoma" },
    default = "MonoSpace"
})
sub:slider({
    name = "Text Size", min = 8, max = 24, interval = 1, default = 14
})
```

The submenu uses the **same API** as a section — you can add toggles, sliders, dropdowns, textboxes, keybinds, and colorpickers inside it.

---

## 6. Notifications

Pop a floating notification in the top-left corner:

```lua
Library.notifications:create_notification({
    name     = "Title",
    info     = "Body text here",
    lifetime = 4           -- seconds before fading out
})
```

Useful places to call it: after a script action, on config save, or as a load indicator:

```lua
task.delay(1, function()
    Library.notifications:create_notification({
        name = "Example Hub",
        info = "Loaded successfully!"
    })
end)
```

---

## 7. Configs (save / load)

Add a built-in **Configs** tab that lets users save and load their settings:

```lua
Library:init_config(window)
```

Call this **after** you've created the window and all your tabs. It adds:

- A **Configs** list you can select from
- A **Config name** textbox
- **Save**, **Load**, **Delete** buttons
- An accent color picker
- A menu keybind

Saved configs go to `milenium/configs/<name>.cfg`.

> Requires `writefile`, `readfile`, `delfile`, `listfiles`, `makefolder` — most modern executors support these.

---

## 8. Mobile Port Notes

The library has been patched for touch devices. Here's what changes on mobile vs PC:

### Touch interactions

| Action | PC | Mobile |
|---|---|---|
| Click a button / toggle | LMB | Tap |
| Drag the window | Click title bar and drag | Tap + drag |
| Resize window | Drag bottom-right corner | Not available |
| Change keybind | Left-click pill, press a key | Tap pill, tap a key |
| Open keybind modes | Right-click pill | Long-press pill |
| Open colorpicker | Click the swatch | Tap the swatch |
| Move sliders | Click + drag the bar | Tap + drag the bar |

### Window sizing

- **PC:** `700 × 565` (fixed)
- **Mobile:** auto-fits to `min(94% viewport width, 700) × min(82% viewport height, 565)` so it never goes off-screen

### Sidebar width

- **PC:** `196px`
- **Mobile:** `130px` — more room for content on narrow screens

### Toggle UI Button

The library **no longer creates its own toggle button**. You create it yourself in your script (see below). The reason: the library's built-in button was a child of the menu ScreenGui, so tapping it also hid the button — making it impossible to bring the menu back.

**Add this to your script** (mobile only):

```lua
local uis = game:GetService("UserInputService")
local is_mobile = uis.TouchEnabled and not uis.KeyboardEnabled

if is_mobile then
    local toggle_gui = Instance.new("ScreenGui")
    toggle_gui.Name = "ToggleUIOverlay"
    toggle_gui.ResetOnSpawn = false
    toggle_gui.IgnoreGuiInset = true
    toggle_gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    toggle_gui.DisplayOrder = 99999

    local ok = pcall(function() toggle_gui.Parent = game:GetService("CoreGui") end)
    if not ok then
        toggle_gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    local btn = Instance.new("TextButton")
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
    btn.Draggable = true          -- movable
    btn.Parent = toggle_gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.6
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = btn

    local function toggle_menu()
        Library["items"].Enabled = not Library["items"].Enabled
    end

    btn.MouseButton1Click:Connect(toggle_menu)
    btn.TouchTap:Connect(toggle_menu)
end
```

**Why this works:** the button lives in its own ScreenGui (`ToggleUIOverlay`), separate from `Library["items"]`. Toggling the menu never touches the button.

**To change the button's look:**
- `BackgroundColor3` — button color
- `BackgroundTransparency` — `0.35` = translucent, `0` = solid
- `Text` — button label
- `Size` / `Position` — initial location

### Double-toggle bug (fixed in the library)

On mobile, having `TouchTap` handlers on **both** the toggle row and its inner switch caused two toggles per tap, netting zero change. The fixed library has `TouchTap` **only on the row** — mobile taps still work because Roblox converts taps to `MouseButton1Click` on the row.

If you're using an **unpatched** `Library.lua`, find these blocks and remove the duplicates:

```lua
-- REMOVE this block in library:toggle —
items[ "toggle_button" ].TouchTap:Connect(function()
    cfg.enabled = not cfg.enabled 
    cfg.set(cfg.enabled)
end)

-- REMOVE this block in library:section (fading toggle) —
items[ "button" ].TouchTap:Connect(function()
    cfg.default = not cfg.default 
    cfg.toggle_section(cfg.default)
end)

-- REMOVE this block in library:settings —
items[ "tick" ].TouchTap:Connect(function()
    cfg.open = not cfg.open 
    cfg.set_visible(cfg.open)
end)
```

---

## 9. Common Mistakes

| Mistake | Fix |
|---|---|
| `attempt to index nil with 'window'` | Library didn't return a table. Make sure the file ends with `return library`. |
| Library loads, menu doesn't show | Check `library["items"].Enabled = true` — try toggling it manually. |
| Tapping toggles does nothing on mobile | You have the unpatched `Library.lua`. Remove the duplicate `TouchTap` handlers. |
| Toggle UI button hides itself | Move the button to its own ScreenGui (see section 8). |
| Dropdown opens off-screen | The popup is anchored to `dropdown.AbsolutePosition + 80`. Make sure the row isn't near the bottom of the screen. |
| Configs won't save | `writefile` etc. are disabled in your executor. |
| Keybind doesn't respond | The default `mode = "Toggle"` needs an active keybind. Left-click the pill to bind a key. |

---

## 10. Full Example

Here's a **complete working script** you can copy and paste:

```lua
-- ============================================================
-- 1. LOAD LIBRARY
-- ============================================================
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/yenkgg/Sleepy-Hub-UI/refs/heads/main/Library.lua"
))()

-- ============================================================
-- 2. WINDOW
-- ============================================================
local window = Library:window({
    name     = "example",
    suffix   = "hub",
    gameInfo = "Example Hub for Roblox"
})

-- ============================================================
-- 3. MOBILE TOGGLE UI BUTTON
-- ============================================================
local uis = game:GetService("UserInputService")
local tween_service = game:GetService("TweenService")

if uis.TouchEnabled and not uis.KeyboardEnabled then
    local toggle_gui = Instance.new("ScreenGui")
    toggle_gui.Name = "ToggleUIOverlay"
    toggle_gui.ResetOnSpawn = false
    toggle_gui.IgnoreGuiInset = true
    toggle_gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    toggle_gui.DisplayOrder = 99999

    local ok = pcall(function() toggle_gui.Parent = game:GetService("CoreGui") end)
    if not ok then
        toggle_gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    local btn = Instance.new("TextButton")
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
    btn.Parent = toggle_gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.6
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = btn

    local function toggle_menu()
        Library["items"].Enabled = not Library["items"].Enabled
    end

    btn.MouseButton1Click:Connect(toggle_menu)
    btn.TouchTap:Connect(toggle_menu)
end

-- ============================================================
-- 4. MAIN TAB
-- ============================================================
window:seperator({ name = "Main" })

local mainTab = window:tab({ name = "Main", tabs = { "Main" } })

do
    local leftCol = mainTab:column({})
    local leftSec = leftCol:section({
        name = "General", default = true,
        icon = "rbxassetid://6022668898"
    })

    leftSec:label({ name = "Welcome!", info = "Built with Sleepy Hub UI." })

    leftSec:toggle({
        name = "Enable Feature", default = false, seperator = true,
        callback = function(state) print("Feature:", state) end
    })

    leftSec:slider({
        name = "WalkSpeed", min = 16, max = 200, interval = 1,
        default = 16, suffix = " ws", seperator = true,
        callback = function(v)
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char:FindFirstChildOfClass("Humanoid").WalkSpeed = v
            end
        end
    })

    leftSec:dropdown({
        name = "Mode",
        items = { "Legit", "Rage", "Custom" },
        default = "Legit", seperator = true,
        callback = function(o) print("Mode:", o) end
    })

    local rightCol = mainTab:column({})
    local rightSec = rightCol:section({
        name = "Appearance", default = true,
        icon = "rbxassetid://129380150574313"
    })

    rightSec:colorpicker({
        name = "Accent", color = Color3.fromRGB(155, 150, 219), seperator = true,
        callback = function(c, a) print(c, a) end
    })

    rightSec:button({ name = "Print Hello", callback = function() print("Hi!") end })
end

-- ============================================================
-- 5. VISUALS TAB
-- ============================================================
window:seperator({ name = "Visuals" })

local enemies, teammates, selfTab = window:tab({
    name = "Visuals",
    tabs = { "Enemies", "Teammates", "Self" }
})

for _, tab in { enemies, teammates, selfTab } do
    local col = tab:column({})
    local sec = col:section({
        name = "ESP", default = true,
        icon = "rbxassetid://6022668898"
    })

    sec:toggle({ name = "Enable ESP", default = false, seperator = true })
    sec:toggle({ name = "Boxes", default = true, seperator = true })
        :colorpicker({ name = "Box Color", color = Color3.fromRGB(255, 60, 60) })

    local nameT = sec:toggle({ name = "Name", default = true, seperator = true })
    nameT:colorpicker({ name = "Name Color" })

    local sub = nameT:settings({})
    sub:toggle({ name = "Show Display Names", default = false, seperator = true })
    sub:dropdown({
        name = "Font",
        items = { "ProggyTiny", "MonoSpace", "Tahoma" },
        default = "MonoSpace", seperator = true
    })
end

-- ============================================================
-- 6. NOTIFICATION
-- ============================================================
task.delay(1, function()
    Library.notifications:create_notification({
        name = "Example Hub",
        info = "Loaded successfully!",
        lifetime = 4
    })
end)

-- ============================================================
-- 7. CONFIGS TAB
-- ============================================================
Library:init_config(window)
```

---

## Cheatsheet

```lua
-- Load
local Library = loadstring(game:HttpGet("URL"))()

-- Window
local window = Library:window({ name = "n", suffix = "s", gameInfo = "info" })

-- Separator
window:seperator({ name = "Section" })

-- Tab
local tab = window:tab({ name = "Main", tabs = { "Main" } })
local a, b, c = window:tab({ name = "Multi", tabs = { "A", "B", "C" } })

-- Column & Section
local col = tab:column({})
local sec = col:section({ name = "General", default = true, size = 0.5 })

-- Elements
sec:label({ name = "Text" })
sec:button({ name = "Click", callback = function() end })
sec:toggle({ name = "Toggle", default = false, callback = function(s) end })
sec:slider({ name = "Slider", min = 0, max = 100, interval = 1, default = 50, callback = function(v) end })
sec:dropdown({ name = "Drop", items = {"A","B"}, default = "A", callback = function(o) end })
sec:textbox({ name = "Input", callback = function(t) end })
sec:keybind({ name = "Key", mode = "Toggle", callback = function(s) end })
sec:colorpicker({ name = "Color", color = Color3.new(1,1,1), callback = function(c,a) end })

-- Chaining
sec:toggle({ name = "Box" }):colorpicker({ name = "Box Color" })
sec:toggle({ name = "Name" }):settings({}):toggle({ name = "Sub" })

-- Notification
Library.notifications:create_notification({ name = "Title", info = "Body", lifetime = 4 })

-- Configs
Library:init_config(window)

-- Menu toggle (from your own code)
Library["items"].Enabled = not Library["items"].Enabled
```

---

That's the whole API. Copy the **Full Example** at the bottom of section 10, paste it into your executor, and you'll have a working mobile-compatible menu in under a minute. From there, swap the demo elements for whatever features your script needs.
