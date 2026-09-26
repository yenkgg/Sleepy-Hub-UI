local LIB_URL = "https://raw.githubusercontent.com/yenkgg/Sleepy-Hub-UI/refs/heads/main/Library.lua"

print("=== STEP 1: FETCH ===")
local ok, src = pcall(function() return game:HttpGet(LIB_URL) end)
print("Fetch ok:", ok)
print("Source type:", typeof(src))
print("Source length:", type(src) == "string" and #src or "N/A")
if type(src) == "string" then
    print("First 60 chars:", src:sub(1, 60))
    print("Last 60 chars: ", src:sub(-60))
end

print("=== STEP 2: COMPILE ===")
local chunk, err = loadstring(src)
print("Chunk ok:", chunk ~= nil)
if not chunk then
    print("Compile error:", err)
    return
end

print("=== STEP 3: EXECUTE ===")
local ok2, result = pcall(chunk)
print("Execute ok:", ok2)
print("Result type:", typeof(result))
if not ok2 then
    print("Execute error:", result)
    return
end

if type(result) ~= "table" then
    print("Library did NOT return a table. Got:", result)
    return
end

print("=== STEP 4: CHECK METHODS ===")
print("Library.window =", typeof(result.window))
print("Library.tab =", typeof(result.tab))
print("Library.init_config =", typeof(result.init_config))
