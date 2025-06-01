if not game:IsLoaded() then
    local success, err = pcall(function() game.Loaded:Wait() end)
    if not success then
        warn("Loader: Error waiting for game.Loaded:", tostring(err))
        return
    end
end

task.wait(1)

local function fetchUrl(url)
    local success, result = pcall(function() return game:HttpGet(url, true) end)
    if success then
        if result then
            return result
        else
            warn("Loader: HttpGet for URL:", url, "returned nil (e.g., 404 or empty response).")
            return nil
        end
    end
    warn("Loader: HttpGet pcall failed for URL:", url, "Error:", tostring(result))
    return nil
end

local gamesListUrl = "https://raw.githubusercontent.com/cookieys/loader/refs/heads/main/Games.lua"
local gamesCode = fetchUrl(gamesListUrl)

if not gamesCode then
    warn("Loader: Failed to fetch Games.lua from", gamesListUrl, "- Script cannot proceed.")
    return
end

local gamesFunc, gamesLoadError = loadstring(gamesCode)
if not gamesFunc then
    warn("Loader: Failed to load Games.lua string. Error:", tostring(gamesLoadError))
    return
end

local success, gamesTableOrError = pcall(gamesFunc)
if not success then
    warn("Loader: Error executing Games.lua. Error:", tostring(gamesTableOrError))
    return
end

if typeof(gamesTableOrError) ~= "table" then
    warn("Loader: Games.lua did not return a table. Expected 'table', got '", typeof(gamesTableOrError), "'. Value:", tostring(gamesTableOrError))
    return
end
local gamesTable = gamesTableOrError

local currentPlaceId = game.PlaceId
local scriptUrl = gamesTable[currentPlaceId]

if not scriptUrl then
    return
end

if typeof(scriptUrl) ~= "string" then
    warn("Loader: Script URL for PlaceId:", currentPlaceId, "is not a string. Expected 'string', got '", typeof(scriptUrl), "'. Value:", tostring(scriptUrl))
    return
end

local targetScriptCode = fetchUrl(scriptUrl)
if not targetScriptCode then
    warn("Loader: Failed to fetch target script from URL:", scriptUrl, "- Script cannot proceed.")
    return
end

local targetScriptFunc, targetScriptLoadError = loadstring(targetScriptCode)
if not targetScriptFunc then
    warn("Loader: Failed to load target script string from URL:", scriptUrl, "Error:", tostring(targetScriptLoadError))
    return
end

local execSuccess, execError = pcall(targetScriptFunc)
if not execSuccess then
    warn("Loader: Error executing target script from URL:", scriptUrl, "Error:", tostring(execError))
end
