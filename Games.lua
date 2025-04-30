local Games = {
    -- Rebirth Champion X
    [8540346411] = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/Rcx.lua",
    -- Fisch
    [16732694052] = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/Fisch.lua",
    -- Rebirth Champions: Ultimate
    [74260430392611] = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/Rc%20ultimate.lua",
    -- Blade Ball
    [13772394625] = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/Blade%20ball.lua",
    -- Your New Game Here
    -- [PLACE_ID_HERE] = "URL_TO_SCRIPT_HERE.lua",
}

local FALLBACK_URL = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"
local CURRENT_PLACE_ID = game.PlaceId

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
    return true
end

local specificUrl = Games[CURRENT_PLACE_ID]
local specificLoadSuccess = false

if specificUrl then
    print(string.format("🔍 Found script for Place ID: %d. Loading: %s", CURRENT_PLACE_ID, specificUrl))
    specificLoadSuccess = loadScriptFromUrl(specificUrl)
end

if not specificLoadSuccess then
    if specificUrl then
        print(string.format("⚠️ Failed to load game-specific script. Attempting fallback: %s", FALLBACK_URL))
    else
        print(string.format("⚠️ No script found for Place ID: %d. Loading fallback: %s", CURRENT_PLACE_ID, FALLBACK_URL))
    end
    loadScriptFromUrl(FALLBACK_URL)
end
