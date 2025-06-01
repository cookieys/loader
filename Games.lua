--!nolint UnusedGlobal
-- Game-specific script URLs mapped by PlaceId
local GAME_SPECIFIC_SCRIPTS = {
    -- Rebirth Champion X
    [8540346411] = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/Rcx.lua",
    -- Fisch
    [16732694052] = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/Fisch.lua",
    -- Rebirth Champions: Ultimate
    [74260430392611] = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/Rc%20ultimate.lua",
    -- Blade Ball
    [13772394625] = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/Blade%20ball.lua",
    -- Blade Ball Training Place (Solo)
    [15234596844] = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/Bb%20train.lua",
    -- Beaks
    [122678592501168] = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/Beaks.lua",
    -- Your New Game Here
    -- [PLACE_ID_HERE] = "URL_TO_SCRIPT_HERE.lua",
}

local UNIVERSAL_LOADER_URL = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/universal.lua"
local CURRENT_PLACE_ID = game.PlaceId

-- Enhanced logging function
local function logMessage(level, message)
    local prefix = {
        INFO = "ℹ️ [INFO]",
        WARN = "⚠️ [WARN]",
        ERROR = "❌ [ERROR]",
        SUCCESS = "✅ [SUCCESS]",
        DEBUG = "🔍 [DEBUG]"
    }
    print(string.format("%s %s", prefix[level] or "[LOG]", message))
end

-- Function to attempt loading and executing a script from a given URL
local function tryLoadScriptFromUrl(url, scriptName)
    scriptName = scriptName or "Script" -- Default script name for logging
    logMessage("DEBUG", string.format("Attempting to HttpGet '%s' from URL: %s", scriptName, url))

    local success, contentOrError = pcall(function()
        return game:HttpGet(url, true) -- Second argument 'true' for no-cache, can be useful for development
    end)

    if not success or not contentOrError then
        logMessage("ERROR", string.format("HttpGet failed for '%s' at URL: %s\nNetwork Error: %s", scriptName, url, tostring(contentOrError)))
        return false, "HttpGet request failed"
    end

    if contentOrError == "" then -- Check if content is empty string specifically
        logMessage("WARN", string.format("HttpGet for '%s' from URL: %s returned empty content.", scriptName, url))
        -- Depending on strictness, you might want to treat this as a failure or allow it.
        -- For script loading, empty content is usually a failure.
        return false, "HttpGet returned empty"
    end

    logMessage("DEBUG", string.format("HttpGet successful for '%s'. Content length: %d. Attempting to loadstring.", scriptName, #contentOrError))

    local loadedFunction, loadstringError = loadstring(contentOrError)
    if not loadedFunction then
        logMessage("ERROR", string.format("loadstring failed for '%s' from URL: %s\nLoadstring Error: %s", scriptName, url, tostring(loadstringError)))
        return false, "loadstring compilation failed"
    end

    logMessage("DEBUG", string.format("loadstring successful for '%s'. Attempting to execute.", scriptName))

    local executionSuccess, executionError = pcall(loadedFunction)
    if not executionSuccess then
        logMessage("ERROR", string.format("Execution failed for '%s' from URL: %s\nExecution Error: %s", scriptName, url, tostring(executionError)))
        return false, "Script execution failed"
    end

    logMessage("SUCCESS", string.format("Successfully loaded and executed '%s' from: %s", scriptName, url))
    return true, "Successfully loaded"
end

-- Main execution logic
local function main()
    logMessage("INFO", string.format("Current Place ID: %d", CURRENT_PLACE_ID))

    local specificScriptUrl = GAME_SPECIFIC_SCRIPTS[CURRENT_PLACE_ID]
    local specificScriptLoaded = false
    local specificScriptErrorMsg = ""

    if specificScriptUrl then
        logMessage("INFO", string.format("Found game-specific script for Place ID %d. URL: %s", CURRENT_PLACE_ID, specificScriptUrl))
        specificScriptLoaded, specificScriptErrorMsg = tryLoadScriptFromUrl(specificScriptUrl, "Game-Specific Script")
    else
        logMessage("INFO", string.format("No game-specific script found for Place ID: %d.", CURRENT_PLACE_ID))
    end

    if not specificScriptLoaded then
        if specificScriptUrl then -- This means a specific script was found but failed to load
            logMessage("WARN", string.format("Game-specific script failed to load (Reason: %s). Attempting to load Universal Loader.", specificScriptErrorMsg))
        else -- This means no specific script was found in the first place
            logMessage("INFO", "Attempting to load Universal Loader as no game-specific script was designated.")
        end
        
        logMessage("DEBUG", string.format("Universal Loader URL: %s", UNIVERSAL_LOADER_URL))
        local universalLoaded, universalErrorMsg = tryLoadScriptFromUrl(UNIVERSAL_LOADER_URL, "Universal Loader")

        if not universalLoaded then
            logMessage("ERROR", string.format("Critical: Failed to load Universal Loader.\nReason: %s", universalErrorMsg))
            logMessage("ERROR", "Neither game-specific (if attempted/found) nor universal script could be loaded. Please check network or script URLs.")
            -- Consider adding a user-facing notification here if this is part of a GUI
            -- For example, if you have a notification system:
            -- YourNotificationSystem:ShowError("Failed to load required scripts. Functionality may be limited.")
        end
    else
        logMessage("INFO", "Game-specific script loaded successfully. Universal Loader will not be loaded.")
    end
    logMessage("INFO", "Script loader finished.")
end

-- Run the main logic in a protected call to catch any unexpected errors in the loader itself
local loaderSuccess, loaderError = pcall(main)
if not loaderSuccess then
    logMessage("ERROR", string.format("Unhandled error in script loader: %s", tostring(loaderError)))
end
