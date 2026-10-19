local BASE = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/"
local UNIVERSAL = "universal.lua"
local RETRIES = 3

local GameScripts = {
    -- Rebirth Champions X
    [8540346411] = "Rcx.lua",
    -- Fisch
    [16732694052] = "Fisch.lua",
    -- Rebirth Champions: Ultimate
    [74260430392611] = "Rc%20ultimate.lua",
    -- Blade Ball
    [13772394625] = "Blade%20ball.lua",
    -- Blade Ball Training Place
    [15234596844] = "Bb%20train.lua",
    -- Beaks
    [122678592501168] = "Beaks.lua",
    -- Grow a Garden
    [126884695634066] = "Gag.lua",
    -- Murder Mystery 2
    [142823291] = "Mm2.lua"
}

local httpRequest =
    request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request)

local function fetch(url)
    for attempt = 1, RETRIES do
        local body
        if httpRequest then
            local ok, res = pcall(httpRequest, {Url = url, Method = "GET"})
            if ok and type(res) == "table" and res.StatusCode == 200 then
                body = res.Body
            end
        else
            local ok, res = pcall(game.HttpGet, game, url, true)
            if ok then
                body = res
            end
        end
        if type(body) == "string" and body ~= "" and not body:match("^%s*<") then
            return body
        end
        if attempt < RETRIES then
            task.wait(attempt)
        end
    end
end

-- Returns false only if the script could not be downloaded or compiled
local function load(file)
    local src = fetch(BASE .. file)
    if not src then
        return false
    end

    local fn, err = loadstring(src, "=" .. file)
    if not fn then
        warn(("[Loader] %s: syntax error: %s"):format(file, tostring(err)))
        return false
    end

    local ok, runErr = xpcall(fn, debug.traceback)
    if not ok then
        warn(("[Loader] %s errored:\n%s"):format(file, tostring(runErr)))
    end
    return true
end

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local file = GameScripts[game.PlaceId]
if not (file and load(file)) then
    load(UNIVERSAL)
end
