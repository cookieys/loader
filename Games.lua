--[[
    Game List:
    Maps Roblox Place IDs to their corresponding script URLs.
    The loader script will use this table to find and execute the correct
    script based on the current game's Place ID.
]]
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
        return loadstring(game:HttpGet(url, true))()
    end)

    if not success then
        warn("Failed to load script from URL:", url, "\nError:", result)
    else
        print("Script loaded and executed successfully from URL:", url)
    end
end

-- Get the current game's Place ID
local currentPlaceId = game.PlaceId

-- Get the script URL for the current Place ID
local scriptUrl = Games[currentPlaceId]

-- Load and execute the script if found, otherwise load Infinite Yield
if scriptUrl then
    loadScript(scriptUrl)
else
    loadScript("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
end
