local Games = {
    
    [8540346411] = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/Rcx.lua",
    
    [16732694052] = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/Fisch.lua",
    
    [74260430392611] = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/Rc%20ultimate.lua",
    
    [13772394625] = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/Blade%20ball.lua",
    
    [15234596844] = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/Bb%20train.lua", 
    
    [122678592501168] = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/Beaks.lua",
    
    
}


local UNIVERSAL_LOADER_URL = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/universal.lua"
local CURRENT_PLACE_ID = game.PlaceId

local function loadScriptFromUrl(url)
    local success, result = pcall(game.HttpGet, game, url)
    if not success or not result then
        warn(string.format("❌ HttpGet failed or returned empty for URL: %s\nError: %s", url, tostring(result)))
        return false, "HttpGet failed or returned empty"
    end

    local func, loadErr = loadstring(result)
    if not func then
        warn(string.format("❌ Failed to loadstring script from URL: %s\nError: %s", url, tostring(loadErr)))
        return false, "loadstring failed"
    end

    local execSuccess, execErr = pcall(func)
    if not execSuccess then
        warn(string.format("❌ Failed to execute script from URL: %s\nError: %s", url, tostring(execErr)))
        return false, "Execution failed"
    end

    print(string.format("✅ Successfully loaded and executed script from: %s", url))
    return true, "Success"
end

local specificUrl = Games[CURRENT_PLACE_ID]
local specificLoadSuccess = false
local specificLoadError = ""

if specificUrl then
    print(string.format("🔍 Found game-specific script for Place ID: %d. Loading: %s", CURRENT_PLACE_ID, specificUrl))
    specificLoadSuccess, specificLoadError = loadScriptFromUrl(specificUrl)
end

if not specificLoadSuccess then
    if specificUrl then
        print(string.format("⚠️ Failed to load game-specific script (%s). Loading Universal Loader: %s", specificLoadError, UNIVERSAL_LOADER_URL))
    else
        print(string.format("⚠️ No game-specific script found for Place ID: %d. Loading Universal Loader: %s", CURRENT_PLACE_ID, UNIVERSAL_LOADER_URL))
    end
    
    local universalLoadSuccess, universalLoadError = loadScriptFromUrl(UNIVERSAL_LOADER_URL)
    if not universalLoadSuccess then
        warn(string.format("❌ Critical Error: Failed to load both game-specific (if attempted) and universal loader (%s).", universalLoadError))
        
        print("Please check your internet connection or the script URLs.")
    end
end
