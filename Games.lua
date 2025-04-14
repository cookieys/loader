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

-- Utility function to load and execute a Lua script from a URL
local function loadScript(url)
    local success, result = pcall(function()
        -- Fetch and execute the script from the URL
        return loadstring(game:HttpGet(url, true))()
    end)

    if success then
        print(string.format("✅ Script successfully loaded and executed from URL: %s", url))
    else
        warn(string.format("❌ Failed to load script from URL: %s\nError: %s", url, result))
    end
end

-- Main function to fetch and execute the appropriate script
local function main()
    -- Get the current game's Place ID
    local currentPlaceId = game.PlaceId

    -- Look up the script URL for the current Place ID
    local scriptUrl = Games[currentPlaceId]

    if scriptUrl then
        -- Load and execute the script for the current game
        print(string.format("🔍 Found script for Place ID: %d\nLoading script from: %s", currentPlaceId, scriptUrl))
        loadScript(scriptUrl)
    else
        -- Fallback to Infinite Yield if no script is found
        print(string.format("⚠️ No script found for Place ID: %d. Loading Infinite Yield as fallback.", currentPlaceId))
        loadScript("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
    end
end

-- Run the main function
main()
