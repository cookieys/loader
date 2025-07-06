local GameScripts = {
    -- Rebirth Champions X
    [8540346411] = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/Rcx.lua",
    -- Fisch
    [16732694052] = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/Fisch.lua",
    -- Rebirth Champions: Ultimate
    [74260430392611] = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/Rc%20ultimate.lua",
    -- Blade Ball
    [13772394625] = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/Blade%20ball.lua",
    -- Blade Ball Traning Place
    [15234596844] = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/Bb%20train.lua",
    -- Beaks
    [122678592501168] = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/Beaks.lua",
    -- Grow a Garden
    [126884695634066] = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/Gag.lua",
}

local UniversalScript = "https://raw.githubusercontent.com/cookieys/cookieys-hub/refs/heads/main/universal.lua"
local CurrentPlaceId = game.PlaceId

local function ExecuteFromUrl(url)
    local success, result = pcall(function()
        local response = request({ Url = url, Method = "GET" })
        if response and response.Success and response.StatusCode == 200 and response.Body and response.Body ~= "" then
            local fn, err = loadstring(response.Body)
            if fn then
                return pcall(fn)
            end
        end
        return false
    end)
    return success and result
end

local specificUrl = GameScripts[CurrentPlaceId]

if not specificUrl or not ExecuteFromUrl(specificUrl) then
    ExecuteFromUrl(UniversalScript)
end
