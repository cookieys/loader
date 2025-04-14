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

-- Improved utility function to load and execute a Lua script from a URL
local function loadScriptFromUrl(url)
    local success, scriptContent = pcall(game.HttpGet, game, url)
    if not success then
        warn(string.format("❌ HttpGet failed for URL: %s\nError: %s", url, tostring(scriptContent)))
        return false
    end
    if not scriptContent then
         warn(string.format("❌ HttpGet returned empty content for URL: %s", url))
         return false
    end

    local func, loadErr = loadstring(scriptContent)
    if not func then
        warn(string.format("❌ Failed to loadstring script from URL: %s\nError: %s", url, tostring(loadErr)))
        return false
    end

    local execSuccess, execErr = pcall(func)
    if not execSuccess then
        warn(string.format("❌ Failed to execute script from URL: %s\nError: %s", url, tostring(execErr)))
        return false
    end

    -- Optional: Keep print statement if desired, removed for cleaner output by default
    -- print(string.format("✅ Script successfully loaded and executed from URL: %s", url))
    return true
end

-- Main execution logic
local currentPlaceId = game.PlaceId
local scriptUrl = Games[currentPlaceId]
local fallbackUrl = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source" -- Define fallback URL

if scriptUrl then
    -- Attempt to load the game-specific script
    print(string.format("🔍 Found script for Place ID: %d. Loading: %s", currentPlaceId, scriptUrl))
    if not loadScriptFromUrl(scriptUrl) then
        -- If game-specific script fails, try fallback
        print(string.format("⚠️ Failed to load game-specific script. Attempting fallback: %s", fallbackUrl))
        loadScriptFromUrl(fallbackUrl) -- Attempt fallback, ignore its return status for now
    end
else
    -- No script found, load fallback directly
    print(string.format("⚠️ No script found for Place ID: %d. Loading fallback: %s", currentPlaceId, fallbackUrl))
    loadScriptFromUrl(fallbackUrl) -- Attempt fallback, ignore its return status
end
