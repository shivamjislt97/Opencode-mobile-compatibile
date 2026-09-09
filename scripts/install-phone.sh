#!/data/data/com.termux/files/usr/bin/bash
# One-shot OpenCode installer for REAL Android phones (aarch64/ARM).
# Uses the Hope2333 glibc-track build (OpenCode 1.18.x) — VERIFIED working.
# (guysoft grafted builds only print Bun help on some Android 15 devices,
#  see README §5.14 — do NOT use them here.)
# Run INSIDE Termux on the phone (NOT on emulator, NOT on host):
#   bash install-phone.sh
# Needs: Termux from F-Droid/GitHub (Play Store build will fail), internet.
set -e
echo "=== 0. base packages ==="
pkg update -y && pkg upgrade -y
pkg install -y curl ripgrep
echo "=== 1. glibc runtime (opencode binary is glibc-linked) ==="
apt install -y glibc-repo
apt update
apt install -y glibc openssl-glibc
echo "=== 2. opencode 1.18.27 (Hope2333 Push260906, glibc-track) ==="
curl -sLO https://github.com/Hope2333/opencode-termux/releases/download/Push260906/opencode_1.18.27_aarch64.deb
dpkg -i opencode_1.18.27_aarch64.deb
echo "=== 3. verify (expect 1.18.27, NOT 1.2.13) ==="
opencode --version
rg --version | head -1
echo "INSTALL_PHONE_DONE — run: opencode   (then /connect for API key)"
