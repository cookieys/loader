if not game:IsLoaded() then
    game.Loaded:Wait()
end

pcall(function()
    local gamesListUrl = "https://raw.githubusercontent.com/cookieys/loader/refs/heads/main/Games.lua"
    local gamesResponse = request({ Url = gamesListUrl, Method = "GET" })

    if not (gamesResponse and gamesResponse.Success and gamesResponse.StatusCode == 200 and gamesResponse.Body) then return end

    local gamesChunk = loadstring(gamesResponse.Body)
    if not gamesChunk then return end

    local success, gamesTable = pcall(gamesChunk)
    if not success or typeof(gamesTable) ~= "table" then return end

    local scriptUrl = gamesTable[game.PlaceId]
    if not (scriptUrl and typeof(scriptUrl) == "string") then return end

    local scriptResponse = request({ Url = scriptUrl, Method = "GET" })
    if scriptResponse and scriptResponse.Success and scriptResponse.StatusCode == 200 and scriptResponse.Body then
        loadstring(scriptResponse.Body)()
    end
end)
