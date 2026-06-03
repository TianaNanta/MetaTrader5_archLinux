# 🧙‍♂️ MetaTrader 5 Installer Script for Arch Linux

> A fully automated bash script to install **MetaTrader 5** (MT5) on Arch Linux using **Wine Staging**.

![After Install Screenshot](./assets/metaTrader5ScriptBG.png)

## ⚠️ Warning: Uses Wine-Staging

This script uses `wine-staging`, the **experimental** branch of Wine. It includes bleeding-edge patches that may offer **better compatibility** but **may also cause instability**. Use with caution if you rely on a stable Wine environment.

## 📦 Dependencies

The following packages will be installed if not already present:

| Package        | Purpose                                    |
| -------------- | ------------------------------------------ |
| `wine-staging` | Runs Windows applications on Linux         |
| `wine-gecko`   | Adds Internet Explorer rendering support   |
| `winetricks`   | Helps install DLLs, fonts, and tweaks      |
| `wget`         | Used to download the MT5 installer         |
| `figlet`       | Fancy terminal banners (optional)          |
| `lolcat`       | Rainbow-colored terminal output (optional) |

> 🛠 Already installed packages will **not** be reinstalled.

## 🚀 How to Use

### 1. Clone or Download the Script

```bash
git clone https://github.com/Ashish-Kushwaha/MetaTrader5_archLinux.git
cd MetaTrader5_archLinux
chmod +x mt5archlinux.sh
```

### 2. Run the Script

```bash
./mt5archlinux.sh
```

## 🔍 Features & What This Script Does

1.  **System Checks:** Ensures `multilib` is enabled (required for Wine on Arch).
2.  **Internet Connectivity:** Verifies network before starting.
3.  **Dependency Management:** Installs `wine-staging`, `winetricks`, `wget`, etc.
4.  **Wine Prefix Setup:** Creates an isolated environment at `~/.wine_mt5` configured for Windows 10.
5.  **WebView2 Runtime:** Automatically installs WebView2 for modern MT5 features (Market, Signals).
6.  **MetaTrader 5 Installer:** Downloads and launches the official MT5 setup.
7.  **Desktop Integration:** Creates a `.desktop` file for your application menu with the official icon.
8.  **Installation Metadata:** Saves installation details for future reference.


## 🏁 After Installation

You can launch MetaTrader 5 from your application menu or via the terminal:

```bash
WINEPREFIX=~/.wine_mt5 wine "$HOME/.wine_mt5/drive_c/Program Files/MetaTrader 5/terminal64.exe"
```


## 🧹 Uninstallation

To remove MetaTrader 5 and the Wine environment:

```bash
rm -rf ~/.wine_mt5 mt5setup.exe
```

## 📁 File Structure

```
.
├── mt5archlinux.sh          # Main installer script
├── mt5setup.exe             # (Downloaded) MT5 installer
└── ~/.wine_mt5              # Wine prefix containing MT5
```

- **Prefix Persistence:** The script saves metadata in `~/.wine_mt5/.mt5_install_info`.
- **Custom Icons:** The script uses `Misc/MetaTrader5.png` for desktop integration.
## 🛠 Development

To verify the script's integrity:

1.  **ShellCheck:** Run `shellcheck mt5archlinux.sh` to catch common shell script errors.
2.  **Multilib Check:** Ensure your system has `multilib` enabled in `/etc/pacman.conf`.



## 📄 License

This project is licensed under the MIT License. Feel free to use, modify, and distribute — just give credit!
