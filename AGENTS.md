# Repository Guidelines

## Project Overview
This project provides a robust, automated bash installer for **MetaTrader 5 (MT5)** on **Arch Linux**. It leverages `wine-staging` and `winetricks` to create a pre-configured environment that supports modern MT5 features like the Market and Signals tabs via the WebView2 Runtime.

## Architecture & Data Flow
The project is centered around a single monolithic installer script (`mt5archlinux.sh`) that follows a linear execution flow:
1.  **Environment Validation**: Checks for `multilib` (required for 32-bit Wine support on Arch) and network connectivity.
2.  **User Confirmation**: Ensures the user is ready to proceed.
3.  **Dependency Injection**: Installs required system packages via `pacman`.
4.  **Prefix Initialization**: Creates an isolated Wine prefix (`~/.wine_mt5`) and sets it to Windows 10 mode.
5.  **Asset Acquisition**: Downloads the MT5 setup and WebView2 runtime.
6.  **Component Installation**: Installs WebView2 (silent) followed by the MT5 GUI installer.
7.  **System Integration**: Copies icons and creates a `.desktop` entry in `~/.local/share/applications`.
8.  **Metadata Persistence**: Logs installation details to `$WINEPREFIX/.mt5_install_info`.

## Key Directories
- `/` : Root containing the primary installer and documentation.
- `/Misc/` : Auxiliary scripts, deprecated versions, and assets (icons, alternate installers).
- `/assets/` : Screenshots and visual documentation assets.
- `/build/` : (Gitignored/Transient) Directory used for downloading installers during runtime.

## Development Commands
- **Linting**: Use `shellcheck` to validate scripts. A `.shellcheckrc` is provided in the root to enforce strict bash standards.
    ```bash
    shellcheck mt5archlinux.sh
    ```
- **Syntax Check**: Quick bash syntax validation.
    ```bash
    bash -n mt5archlinux.sh
    ```

## Code Conventions & Common Patterns
- **Shell Safety**: All scripts MUST start with `set -euo pipefail` and `IFS=$'\n\t'`.
- **UI Feedback**: Use the provided colorized functions for consistency:
    - `info` (Blue): Progress updates.
    - `success` (Green): Completed steps.
    - `warn` (Yellow): Non-fatal issues or skip notices.
    - `error` (Red): Critical failures requiring exit.
- **Variable Naming**: Use `UPPER_SNAKE_CASE` for global constants and URLs; `lower_snake_case` for local variables and function names.
- **Path Handling**: Always use `"$HOME"` or relative paths. Ensure all paths containing variables are double-quoted.

## Important Files
- `mt5archlinux.sh`: The source of truth for installation logic.
- `Misc/MetaTrader5.png`: The official icon used for desktop integration.
- `.shellcheckrc`: Defines the project's code quality standards.
- `~/.wine_mt5/.mt5_install_info`: The persistent state file for the installation.

## Runtime/Tooling Preferences
- **Runtime**: `bash` (version 4.0+ recommended).
- **Package Manager**: `pacman` (Arch Linux exclusive).
- **Core Dependencies**: `wine-staging`, `winetricks`, `wget`.
- **Configuration**: `/etc/pacman.conf` must have `[multilib]` enabled.

## Testing & QA
- **Manual Verification**: After changes, verify the generation of the `.desktop` file and the validity of the metadata file.
- **Simulated Dry Runs**: Comment out `pacman -S` and `wine` execution lines to test logic flow and variable expansion.
- **LSP**: Use `bash-language-server` for real-time diagnostics.
