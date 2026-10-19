local CONFIG = {
    Url = "https://raw.githubusercontent.com/cookieys/loader/refs/heads/main/Games.lua",
    Retries = 3,
    Debug = true,
}

local TAG = "[Cookieys Loader]: "
local httpRequest = (syn and syn.request) or (http and http.request) or http_request
    or (fluxus and fluxus.request) or request

local function log(msg, isWarn)
    if not CONFIG.Debug then return end
    (isWarn and warn or print)(TAG .. tostring(msg))
end

local function fetch(url)
    for attempt = 1, CONFIG.Retries do
        local body
        if httpRequest then
            local ok, res = pcall(httpRequest, { Url = url, Method = "GET" })
            if ok and type(res) == "table" and res.StatusCode == 200 then body = res.Body end
        else
            local ok, res = pcall(game.HttpGet, game, url, true)
            if ok then body = res end
        end

        if type(body) == "string" and body ~= "" and not body:match("^%s*<") then
            return body
        end

        if attempt < CONFIG.Retries then
            log(("Fetch failed (%d/%d), retrying..."):format(attempt, CONFIG.Retries), true)
            task.wait(attempt)
        end
    end
    return nil, "Failed to fetch after " .. CONFIG.Retries .. " attempts: " .. url
end

local function compile(src, name)
    local fn, err = loadstring(src, "=" .. name)
    if not fn then return nil, "Syntax error in " .. name .. ": " .. tostring(err) end
    return fn
end

if not game:IsLoaded() then game.Loaded:Wait() end

task.spawn(function()
    log("Fetching games list...")
    local listSrc, err = fetch(CONFIG.Url)
    if not listSrc then return log(err, true) end

    local listFn, cerr = compile(listSrc, "Games.lua")
    if not listFn then return log(cerr, true) end

    local ok, list = pcall(listFn)
    if not ok then return log("Games.lua errored: " .. tostring(list), true) end
    if type(list) ~= "table" then return log("Games.lua did not return a table.", true) end

    local placeId, gameId = game.PlaceId, game.GameId
    local scriptUrl = list[placeId] or list[tostring(placeId)]
        or list[gameId] or list[tostring(gameId)]

    if not scriptUrl then
        log("No game-specific script, checking Universal...")
        scriptUrl = list.Universal or list.universal
    end
    if not scriptUrl then
        return log("No supported script for PlaceId " .. placeId, true)
    end

    log("Loading script from: " .. scriptUrl)
    local src, ferr = fetch(scriptUrl)
    if not src then return log("Download failed: " .. tostring(ferr), true) end

    local fn, serr = compile(src, "GameScript")
    if not fn then return log(serr, true) end

    local runOk, runErr = xpcall(fn, debug.traceback)
    if runOk then
        log("Script executed successfully!")
    else
        log("Script errored:\n" .. tostring(runErr), true)
    end
end)
