local function fetchUrl(url)
    local success, result = pcall(game.HttpGet, game, url)
    if success then return result end
    warn("HttpGet failed for:", url, "-", tostring(result))
    return nil
end

-- Fetch Games.lua content
local gamesCode = fetchUrl("https://raw.githubusercontent.com/cookieys/loader/refs/heads/main/Games.lua")
if not gamesCode then return end -- Exit silently if fetch fails

-- Load Games.lua code into a function
local gamesFunc, loadErr = loadstring(gamesCode)
if not gamesFunc then
    warn("Games.lua loadstring failed:", tostring(loadErr))
    return
end

-- Execute Games.lua to get the table
local success, gamesTable = pcall(gamesFunc)
if not success or typeof(gamesTable) ~= "table" then
    warn("Games.lua execution failed or did not return a table. Error:", tostring(success and typeof(gamesTable) or gamesTable))
    return
end

-- Find script URL for current game
local scriptUrl = gamesTable[game.PlaceId] -- Use PlaceId directly as key
if not scriptUrl or typeof(scriptUrl) ~= "string" then
    -- No script found for this place, exit silently. Can uncomment print for debug.
    -- print("No script configured for PlaceID:", game.PlaceId)
    return
end

-- Fetch the target script content
local scriptCode = fetchUrl(scriptUrl)
if not scriptCode then return end -- Exit silently if fetch fails

-- Load the target script code
local scriptFunc, scriptLoadErr = loadstring(scriptCode)
if not scriptFunc then
    warn("Target script loadstring failed:", scriptUrl, "-", tostring(scriptLoadErr))
    return
end

-- Execute the target script
local execSuccess, execErr = pcall(scriptFunc)
if not execSuccess then
    warn("Target script execution failed:", scriptUrl, "-", tostring(execErr))
end
