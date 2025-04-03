local function fetchUrl(url)
    local success, result = pcall(game.HttpGet, game, url)
    if not success then
        warn("Failed to fetch URL:", url, result)
        return nil
    end
    return result
end

local function loadAndExecute(code)
    local func, err = loadstring(code)
    if not func then
        warn("Failed to load code:", err)
        return false
    end

    local success, exec_err = pcall(func)
    if not success then
        warn("Failed to execute code:", exec_err)
        return false
    end

    return true
end

local games_code = fetchUrl("https://raw.githubusercontent.com/cookieys/loader/refs/heads/main/Games.lua")
if not games_code then return end

local games_func = loadstring(games_code)
if not games_func then return end

local success_games, games_table = pcall(games_func)
if not success_games or typeof(games_table) ~= "table" then
    warn("Failed to execute Games.lua or result is not a table")
    return
end

local currentPlaceId = game.PlaceId
local scriptUrl = games_table[currentPlaceId]

if scriptUrl then
    local script_code = fetchUrl(scriptUrl)
    if script_code then
        loadAndExecute(script_code)
    end
else
    print("No script found for PlaceID: " .. currentPlaceId)
end
