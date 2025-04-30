--[[

discord.gg/25ms

--]]
repeat wait()until game:IsLoaded()local function e(e)local L,U=pcall(game.HttpGet,game,e)if L then return U end warn("HttpGet failed for:",e,"-",tostring(U))return nil end local L=e("https://raw.githubusercontent.com/cookieys/loader/refs/heads/main/Games.lua")if not L then return end local U,a=loadstring(L)if not U then warn("Games.lua loadstring failed:",tostring(a))return end local Q,X=pcall(U)if not Q or typeof(X)~="table"then warn("Games.lua execution failed or did not return a table. Error:",tostring(Q and typeof(X)or X))return end local J=(X)[game.PlaceId]if not J or typeof(J)~="string"then return end local t=e(J)if not t then return end local E,D=loadstring(t)if not E then warn("Target script loadstring failed:",J,"-",tostring(D))return end local N,T=pcall(E)if not N then warn("Target script execution failed:",J,"-",tostring(T))end
