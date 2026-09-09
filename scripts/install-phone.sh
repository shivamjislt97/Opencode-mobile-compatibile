#!/data/data/com.termux/files/usr/bin/bash
# One-shot OpenCode installer for REAL Android phones (aarch64/ARM).
# Run INSIDE Termux on the phone (NOT on emulator, NOT on host):
#   bash install-phone.sh
# Needs: Termux from F-Droid/GitHub (Play Store build will fail), internet.
set -e
echo "=== 0. base packages ==="
pkg update -y && pkg upgrade -y
pkg install -y curl jq unzip ripgrep
echo "=== 1. latest native Android build (guysoft/opencode-termux) ==="
DEB_URL=$(curl -s https://api.github.com/repos/guysoft/opencode-termux/releases/latest \
  | jq -r '.assets[] | select(.name | endswith("_aarch64.deb")) | .browser_download_url')
echo "downloading: $DEB_URL"
curl -LO "$DEB_URL"
DEB_FILE=$(basename "$DEB_URL")
echo "=== 2. install ==="
dpkg -i "$DEB_FILE"
echo "=== 3. verify ==="
opencode --version
rg --version | head -2
echo "INSTALL_PHONE_DONE — run: opencode   (then /connect for API key)"
