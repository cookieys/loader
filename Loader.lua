local function fetchUrl(url)
    local success, result = pcall(game.HttpGet, game, url)
    if success then return result end
    warn("HttpGet failed for:", url, "-", tostring(result))
    return nil
end

local gamesCode = fetchUrl("https://raw.githubusercontent.com/cookieys/loader/refs/heads/main/Games.lua")
if not gamesCode then return end

local gamesFunc, loadErr = loadstring(gamesCode)
if not gamesFunc then
    warn("Games.lua loadstring failed:", tostring(loadErr))
    return
end

local success, gamesTable = pcall(gamesFunc)
if not success or typeof(gamesTable) ~= "table" then
    warn("Games.lua execution failed or did not return a table. Error:", tostring(success and typeof(gamesTable) or gamesTable))
    return
end

local scriptUrl = gamesTable[game.PlaceId]
if not scriptUrl or typeof(scriptUrl) ~= "string" then
    return
end

local scriptCode = fetchUrl(scriptUrl)
if not scriptCode then return end

local scriptFunc, scriptLoadErr = loadstring(scriptCode)
if not scriptFunc then
    warn("Target script loadstring failed:", scriptUrl, "-", tostring(scriptLoadErr))
    return
end

local execSuccess, execErr = pcall(scriptFunc)
if not execSuccess then
    warn("Target script execution failed:", scriptUrl, "-", tostring(execErr))
end
