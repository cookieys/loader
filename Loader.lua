local Games = loadstring(game:HttpGet("https://raw.githubusercontent.com/cookieys/loader/refs/heads/main/Games.lua"))()

for PlaceID, Execute in pairs(Games) do
    if PlaceID == game.PlaceId then
        loadstring(game:HttpGet(Execute))()
    end
end
