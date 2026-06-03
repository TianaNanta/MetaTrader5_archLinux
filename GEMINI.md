# MetaTrader 5 Arch Linux Installer

A collection of fully automated bash scripts to install and configure **MetaTrader 5 (MT5)** on Arch Linux (and variations for other distros) using **Wine Staging**.

## Project Overview

The project aims to simplify the installation of MT5 on Linux systems by automating the setup of a dedicated Wine prefix, installing necessary dependencies, and handling the download of the MT5 installer.

- **Main Technologies:** Bash, Wine (Staging), Winetricks, Arch Linux (Pacman).
- **Core Strategy:** Use isolated Wine prefixes (`~/.wine_mt5` or `~/.mt5`) to prevent interference with other Windows applications.

## Building and Running

Since this is a collection of shell scripts, there is no "build" step.

### Installation
To install MetaTrader 5, run the main script from the root:
```bash
chmod +x mt5archlinux.sh
./mt5archlinux.sh
```

### Post-Installation Launch
After installation, MT5 can be launched with the following command (adjust prefix if needed):
```bash
WINEPREFIX=~/.wine_mt5 wine "$HOME/.wine_mt5/drive_c/Program Files/MetaTrader 5/terminal64.exe"
```

### Uninstallation
To remove the MT5 environment:
```bash
rm -rf ~/.wine_mt5 mt5setup.exe
```

## Key Files and Directories

| File/Path | Description |
| :--- | :--- |
| `mt5archlinux.sh` | The primary installer script for Arch Linux. |
| `Readme.md` | Main project documentation and usage guide. |
| `Misc/` | Contains alternative scripts (`mt5ubuntu.sh`), legacy versions, and experimental scripts with WebView2 support. |
| `Misc/mt5arch.sh` | A more comprehensive version of the installer that includes WebView2 and desktop entry creation. |
| `assets/` | Contains visual assets like screenshots for the README. |
| `build/` | Temporary directory used by some scripts to store installers. |

## Development Conventions

- **Shell Safety:** Scripts should use `set -euo pipefail` to ensure they exit on errors and handle pipes safely.
- **Portability:** While focused on Arch Linux, variations in the `Misc/` directory should be maintained for other distributions when possible.
- **Wine Prefixing:** Always use a dedicated `WINEPREFIX` for MT5 to maintain a clean environment.
- **Dependency Management:** Scripts check for and install dependencies using `sudo pacman`.
