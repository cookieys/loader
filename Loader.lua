--[[

discord.gg/25ms

--]]
local s="https://raw.githubusercontent.com/cookieys/loader/refs/heads/main/Games.lua"local U,D=pcall(function()return(loadstring(game:HttpGet(s)))()end)if U and D then local s=game.PlaceId if D[s]then local U,v=pcall(function()return(loadstring(game:HttpGet(D[s])))()end)if not U then print("Error loading game script:",v)game.Players.LocalPlayer:Kick("Error loading game script.")end else print("Game not supported. Kicking player.")game.Players.LocalPlayer:Kick("This game is not supported by the script.")end else print("Error loading games list:",D)end
