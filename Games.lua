-- Game List: Maps Place IDs to script URLs
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

-- Function to load and execute a Lua script from a URL
local function loadScript(url)
    local success, result = pcall(function()
        -- Fetch and execute the script from the URL
        return loadstring(game:HttpGet(url, true))()
    end)

    if success then
        print("✅ Script successfully loaded and executed from URL:", url)
    else
        warn("❌ Failed to load script from URL:", url, "\nError:", result)
    end
end

-- Main Execution
local function main()
    -- Get the current game's Place ID
    local currentPlaceId = game.PlaceId

    -- Get the script URL for the current Place ID
    local scriptUrl = Games[currentPlaceId]

    -- Load and execute the script if found, otherwise load Infinite Yield
    if scriptUrl then
        print("🔍 Found script for Place ID:", currentPlaceId)
        loadScript(scriptUrl)
    else
        print("⚠️ No script found for Place ID:", currentPlaceId, "- Loading Infinite Yield as fallback.")
        loadScript("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
    end
end

-- Run the main function
main()
