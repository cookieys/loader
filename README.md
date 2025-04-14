# Cookieys Hub Loader

A versatile Lua script designed for Roblox executors. It intelligently detects the current game you're playing (using its Place ID) and loads the appropriate script from the [Cookieys Hub](https://github.com/cookieys/cookieys-hub) repository.

## Features

*   **Automatic Game Detection:** Identifies the current Roblox game via its Place ID.
*   **Targeted Script Loading:** Loads specific Lua scripts tailored for supported games.
*   **Fallback Support:** Automatically loads a default script (like Infinite Yield) if the current game isn't explicitly supported in the configuration.
*   **Easy Configuration:** Game IDs and script URLs are managed in a central configuration (likely `Games.lua` or directly within the loader).

## How to Use

1.  **Obtain the Loader Script:**
    *   You can copy the raw Lua code directly from the main loader file in this repository (e.g., `loader.lua` - *adjust filename if needed*).
    *   Or use a raw GitHub link if provided: `https://raw.githubusercontent.com/cookieys/loader/main/loader.lua` (*adjust URL if needed*)

2.  **Execute:**
    *   Open your preferred Roblox Lua script executor.
    *   Paste the copied loader script into the executor.
    *   Execute the script while you are inside a Roblox game.

The loader will then automatically attempt to find and run the correct script for your current game or the fallback script.

## Supported Games

The list of supported games and their corresponding script URLs is defined within the loader script or its configuration file (e.g., `Games.lua`). Check the source code for the current list.

*(Optional: Add a direct link to the Games.lua or list a few examples here)*

## Disclaimer

*   This script is intended for educational purposes only.
*   Using scripts to exploit games violates Roblox's Terms of Service.
*   Use this software at your own risk. The developers are not responsible for any actions taken against your account (e.g., bans) as a result of using this loader.
