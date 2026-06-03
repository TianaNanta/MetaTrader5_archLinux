#!/usr/bin/env bash
# ============================================
#  Script Name : install_mt5_arch.sh
#  Description : Installs MetaTrader 5 with Wine on Arch Linux
#  Author      : Ashish Kushwaha
#  Date        : 2025-07-05
# ============================================

# --- Shell Safety ---
set -euo pipefail
IFS=$'\n\t'

# --- Color Output Functions ---
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"
info() { echo -e "${BLUE}ℹ  $*${RESET}"; }
success() { echo -e "${GREEN}✅ $*${RESET}"; }
error() { echo -e "${RED}❌ $*${RESET}"; }
warn() { echo -e "${YELLOW}⚠️  $*${RESET}"; }

# --- Variables ---
INSTALLER_URL="https://download.terminal.free/cdn/web/metaquotes.ltd/mt5/mt5setup.exe"
WEBVIEW2_URL="https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/c1336fd6-a2eb-4669-9b03-949fc70ace0e/MicrosoftEdgeWebview2Setup.exe"
WINEPREFIX_PATH="$HOME/.wine_mt5"
INSTALLER_NAME="mt5setup.exe"
WEBVIEW2_NAME="MicrosoftEdgeWebview2Setup.exe"

check_multilib() {
  info "Checking if multilib is enabled..."
  if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    error "multilib repository is not enabled in /etc/pacman.conf."
    info "Please enable it by uncommenting the [multilib] section and the Include line below it."
    info "Then run 'sudo pacman -Syu' and restart this script."
    exit 1
  fi
confirm_installation() {
  read -p $'\nDo you want to install MetaTrader 5 on Arch Linux? [y/n]: ' confirm
  if [[ ! $confirm =~ ^[Yy]$ ]]; then
    warn "Installation cancelled by user."
    exit 0
  fi
}

  success "multilib is enabled."
}

# --- Functions ---
check_network() {
  info "Checking internet connectivity..."
  if ! ping -q -c 1 -W 2 archlinux.org &>/dev/null; then
    error "No internet connection detected. Exiting."
    exit 1
  fi
  success "Internet connection is active."
}

install_dependencies() {
  info "Installing required packages..."
  if ! command -v wine &>/dev/null; then
    sudo pacman -Syu --noconfirm wine-staging winetricks wine-gecko wget figlet lolcat
    success "All dependencies installed."
  else
    success "Dependencies already installed."
  fi
}

setup_wine() {
  if [ ! -d "$WINEPREFIX_PATH" ]; then
    info "Creating Wine prefix at: $WINEPREFIX_PATH"
    mkdir -p "$WINEPREFIX_PATH"
    WINEPREFIX="$WINEPREFIX_PATH" wineboot &>/dev/null
    info "Configuring Wine for Windows 10..."
    WINEPREFIX="$WINEPREFIX_PATH" winetricks -q settings win10 &>/dev/null
    success "Wine prefix initialized and configured."
  else
    success "Wine prefix already exists at: $WINEPREFIX_PATH"
  fi
}

download_installers() {
  if [ ! -f "$INSTALLER_NAME" ]; then
    info "Downloading MetaTrader 5 installer..."
    wget --show-progress -O "$INSTALLER_NAME" "$INSTALLER_URL"
    success "Installer downloaded: $INSTALLER_NAME"
  else
    warn "Installer already exists: $INSTALLER_NAME (skipping download)"
  fi

  if [ ! -f "$WEBVIEW2_NAME" ]; then
    info "Downloading WebView2 Runtime..."
    wget --show-progress -O "$WEBVIEW2_NAME" "$WEBVIEW2_URL"
    success "WebView2 downloaded: $WEBVIEW2_NAME"
  else
    warn "WebView2 already exists: $WEBVIEW2_NAME (skipping download)"
  fi
}
install_webview() {
  info "Installing WebView2 Runtime..."
  if WINEPREFIX="$WINEPREFIX_PATH" wine "$WEBVIEW2_NAME" /silent /install &>/dev/null; then
    success "WebView2 installed."
  else
    warn "WebView2 installation might have failed. Market features might be affected."
  fi
}


launch_installer() {
  info "Launching MetaTrader 5 installer..."
  WINEPREFIX="$WINEPREFIX_PATH" wine "$INSTALLER_NAME"
  success "Installer executed. Follow the on-screen instructions."
}
setup_dotDesktop() {
  wine_desktop="$HOME/.local/share/applications/wine/Programs/MetaTrader 5/MetaTrader 5.desktop"
  manual_desktop="$HOME/.local/share/applications/metatrader5.desktop"
  icon_source="./Misc/MetaTrader5.png"
  icon_target="$HOME/.local/share/icons/MetaTrader5.png"

  # --- Copy icon if needed ---
  if [[ -f "$icon_source" ]]; then
    mkdir -p "$(dirname "$icon_target")"
    cp "$icon_source" "$icon_target"
    success "Icon copied to: $icon_target"
  else
    warn "Icon not found at $icon_source. Default system icon will be used."
  fi

  # --- Create or Verify Desktop Entry ---
  if [[ -f "$wine_desktop" ]]; then
    success "Auto-generated desktop entry found at: $wine_desktop"
  elif [[ -f "$manual_desktop" ]]; then
    info "Manual desktop entry already exists at: $manual_desktop"
  else
    info "No desktop entry found. Creating one manually..."
    cat >"$manual_desktop" <<EOF
[Desktop Entry]
Name=MetaTrader 5
Comment=Launch MetaTrader 5 using Wine
Exec=env WINEPREFIX=$WINEPREFIX_PATH wine "$WINEPREFIX_PATH/drive_c/Program Files/MetaTrader 5/terminal64.exe"
Icon=MetaTrader5
Terminal=false
Type=Application
Categories=Finance;Trading;Application;
StartupNotify=true
EOF

    chmod +x "$manual_desktop"
    success "Manual desktop launcher created: $manual_desktop"
  fi
}
save_config() {
  info "Saving installation metadata..."
  {
    echo "INSTALL_DATE=$(date -Iseconds)"
    echo "WINE_VERSION=$(wine --version)"
    echo "PREFIX_PATH=$WINEPREFIX_PATH"
  } > "$WINEPREFIX_PATH/.mt5_install_info"
  success "Metadata saved to $WINEPREFIX_PATH/.mt5_install_info"
}




# --- Main Execution ---
check_multilib
check_network
confirm_installation
install_dependencies
setup_wine
download_installers
install_webview
launch_installer
setup_dotDesktop
save_config

success "MetaTrader 5 installation script completed!"
