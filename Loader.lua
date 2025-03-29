local success, games_code = pcall(game.HttpGet, game, "https://raw.githubusercontent.com/cookieys/loader/refs/heads/main/Games.lua")
if not success or not games_code then
    warn("Failed to fetch Games.lua:", games_code)
    return
end

local games_func, games_err = loadstring(games_code)
if not games_func then
    warn("Failed to load Games.lua:", games_err)
    return
end

local success_games, games_table = pcall(games_func)
if not success_games or typeof(games_table) ~= "table" then
    warn("Failed to execute Games.lua or result is not a table:", games_table)
    return
end

local currentPlaceId = game.PlaceId
local scriptUrl = games_table[currentPlaceId]

if scriptUrl then
    local success_script, script_code = pcall(game.HttpGet, game, scriptUrl)
    if not success_script or not script_code then
        warn("Failed to fetch script for PlaceID " .. currentPlaceId .. ":", script_code)
        return
    end

    local script_func, script_err = loadstring(script_code)
    if not script_func then
        warn("Failed to load script for PlaceID " .. currentPlaceId .. ":", script_err)
        return
    end

    local success_exec, exec_err = pcall(script_func)
    if not success_exec then
        warn("Failed to execute script for PlaceID " .. currentPlaceId .. ":", exec_err)
    end
else
    print("No script found for PlaceID: " .. currentPlaceId)
end
