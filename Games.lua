local Games = {
    -- Rebirth Champion X
    [8540346411] = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/Rcx.lua",
    -- Fisch
    [16732694052] = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/Fisch.lua",
    -- Rebirth Champions: Ultimate
    [74260430392611] = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/Rc%20ultimate.lua",
    -- Add new games below:
    -- [PLACE_ID_HERE] = "URL_TO_SCRIPT_HERE.lua",
}

local FALLBACK_URL = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"
local CURRENT_PLACE_ID = game.PlaceId

-- Optimized utility function to load and execute a Lua script from a URL
local function loadScriptFromUrl(url)
    local success, result = pcall(game.HttpGet, game, url)
    if not success or not result then
        warn(string.format("❌ HttpGet failed or returned empty for URL: %s\nError: %s", url, tostring(result)))
        return false
    end

    local func, loadErr = loadstring(result)
    if not func then
        warn(string.format("❌ Failed to loadstring script from URL: %s\nError: %s", url, tostring(loadErr)))
        return false
    end

    local execSuccess, execErr = pcall(func)
    if not execSuccess then
        warn(string.format("❌ Failed to execute script from URL: %s\nError: %s", url, tostring(execErr)))
        return false
    end
    -- print(string.format("✅ Script successfully executed from URL: %s", url)) -- Optional: Uncomment for success logs
    return true
end

-- Main execution logic
local specificUrl = Games[CURRENT_PLACE_ID]
local specificLoadSuccess = false

if specificUrl then
    print(string.format("🔍 Found script for Place ID: %d. Loading: %s", CURRENT_PLACE_ID, specificUrl))
    specificLoadSuccess = loadScriptFromUrl(specificUrl)
end

-- Load fallback if specific script wasn't found OR if it failed to load
if not specificLoadSuccess then
    if specificUrl then -- Only print failure message if we actually tried the specific script
        print(string.format("⚠️ Failed to load game-specific script. Attempting fallback: %s", FALLBACK_URL))
    else
        print(string.format("⚠️ No script found for Place ID: %d. Loading fallback: %s", CURRENT_PLACE_ID, FALLBACK_URL))
    end
    loadScriptFromUrl(FALLBACK_URL) -- Attempt fallback
end
