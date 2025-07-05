# Cookieys Hub Loader

A dynamic script loader for Roblox that automatically executes the appropriate script based on the current game's Place ID.

## Overview

This loader is designed to streamline the process of using game-specific scripts. It intelligently detects the game you are currently playing and fetches the corresponding script from the [Cookieys Hub repository](https://github.com/cookieys/cookieys-hub). If a script for the specific game doesn't exist or fails to load, it automatically falls back to a universal script.

### Key Features

-   **Automatic Game Detection:** Identifies the current game using its `PlaceId`.
-   **Dynamic Script Loading:** Fetches and executes scripts tailored for the specific game you're in.
-   **Fallback Mechanism:** Loads a default universal script (e.g., Infinite Yield) if a game-specific one is not found or fails.
-   **Centralized Configuration:** Game-to-script mappings are managed in a single, easy-to-edit `Games.lua` file.

## How to Use

1.  Copy the following one-line command:
    ```lua
    loadstring(game:HttpGet("https://raw.githubusercontent.com/cookieys/loader/main/Loader.lua", true))()
    ```
2.  Paste the command into your Roblox Lua executor.
3.  Execute the script while in-game.

## Supported Games

The list of supported games is defined in the `Games.lua` configuration file within the repository. For an up-to-date list, please refer to the source.

[**View Supported Games Configuration**](https://github.com/cookieys/loader/blob/main/Games.lua)

---

## ⚠️ Disclaimer

> This project is intended for educational purposes only. Using third-party scripts to exploit or modify the Roblox client is a direct violation of the Roblox Terms of Service. The user assumes all responsibility and risk associated with the use of this loader.
