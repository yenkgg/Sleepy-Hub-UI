local dihh = "https://raw.githubusercontent.com/yenkgg/Sleepy-Hub-UI/refs/heads/main/Library.lua"

local ok, result = pcall(function()
    return loadstring(game:HttpGet(dihh))()
end)

print("=== LOAD RESULT ===")
print("Success:", ok)
print("Result type:", typeof(result))

if ok then
    print("Library.window:", typeof(result.window))
else
    print("ERROR MESSAGE:")
    print(result)
end
