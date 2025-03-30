--[[
    Game List:
    Maps Roblox Place IDs to their corresponding script URLs.
    The loader script will use this table to find and execute the correct
    script based on the current game's Place ID.
]]
local Games = {
    -- Rebirth Champion X
    [8540346411] = "https://raw.githubusercontent.com/X7N6Y/X7N6Y/refs/heads/main/Rebirth.lua",

    -- Fisch
    [16732694052] = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/Fisch.lua",

    -- Add new games below:
    -- [PLACE_ID_HERE] = "URL_TO_SCRIPT_HERE.lua",
}

local currentPlaceId = game.PlaceId
local scriptUrl = Games[currentPlaceId]

if scriptUrl then
    loadstring(game:HttpGet(scriptUrl))()
else
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end
