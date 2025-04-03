-- Function to fetch and load a Lua script from a URL
local function fetchAndLoadScript(url)
    local success, script_code = pcall(game.HttpGet, game, url)
    if not success or not script_code then
        warn("Failed to fetch script from URL:", url, "\nError:", script_code)
        return nil, script_code
    end

    local script_func, script_err = loadstring(script_code)
    if not script_func then
        warn("Failed to load script from URL:", url, "\nError:", script_err)
        return nil, script_err
    end

    return script_func, nil
end

-- Fetch and execute Games.lua
local games_func, games_err = fetchAndLoadScript("https://raw.githubusercontent.com/cookieys/loader/refs/heads/main/Games.lua")
if not games_func then return end

local success_games, games_table = pcall(games_func)
if not success_games or typeof(games_table) ~= "table" then
    warn("Failed to execute Games.lua or result is not a table:", games_table)
    return
end

-- Fetch and execute the script for the current PlaceId
local currentPlaceId = game.PlaceId
local scriptUrl = games_table[currentPlaceId]

if scriptUrl then
    local script_func, script_err = fetchAndLoadScript(scriptUrl)
    if not script_func then return end

    local success_exec, exec_err = pcall(script_func)
    if not success_exec then
        warn("Failed to execute script for PlaceID " .. currentPlaceId .. ":", exec_err)
    end
else
    print("No script found for PlaceID: " .. currentPlaceId)
end
