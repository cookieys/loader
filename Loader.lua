-- Utility function to fetch the content of a URL
local function fetchUrl(url)
    local success, result = pcall(game.HttpGet, game, url)
    if success then
        return result
    else
        warn(string.format("❌ Failed to fetch URL: %s\nError: %s", url, result))
        return nil
    end
end

-- Utility function to load and execute Lua code
local function loadAndExecute(code)
    local func, loadErr = loadstring(code)
    if not func then
        warn(string.format("❌ Failed to load code:\nError: %s", loadErr))
        return false
    end

    local success, execErr = pcall(func)
    if not success then
        warn(string.format("❌ Failed to execute code:\nError: %s", execErr))
        return false
    end

    return true
end

-- Fetch and execute the Games.lua script
local function loadGamesTable()
    local gamesCode = fetchUrl("https://raw.githubusercontent.com/cookieys/loader/refs/heads/main/Games.lua")
    if not gamesCode then return nil end

    local gamesFunc, loadErr = loadstring(gamesCode)
    if not gamesFunc then
        warn(string.format("❌ Failed to load Games.lua:\nError: %s", loadErr))
        return nil
    end

    local success, gamesTable = pcall(gamesFunc)
    if not success or typeof(gamesTable) ~= "table" then
        warn("❌ Failed to execute Games.lua or result is not a table")
        return nil
    end

    return gamesTable
end

-- Main execution logic
local function main()
    local gamesTable = loadGamesTable()
    if not gamesTable then return end

    local currentPlaceId = game.PlaceId
    local scriptUrl = gamesTable[currentPlaceId]

    if scriptUrl then
        print(string.format("🔍 Found script for PlaceID: %d\nLoading script from: %s", currentPlaceId, scriptUrl))
        local scriptCode = fetchUrl(scriptUrl)
        if scriptCode then
            loadAndExecute(scriptCode)
        end
    else
        print(string.format("⚠️ No script found for PlaceID: %d", currentPlaceId))
    end
end

-- Run the main function
main()
