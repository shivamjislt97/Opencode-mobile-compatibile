#!/data/data/com.termux/files/usr/bin/bash
# Full OpenCode install from INSIDE the Termux app on x86_64 emulator (MuMu).
# No PC, no adb, no PowerShell needed. Run in Termux:
#   bash scripts/install-emulator.sh
# (Clone the repo in Termux first: pkg install -y git && git clone <repo-url>)
set -e
echo "=== 0. packages (needs internet in Termux app) ==="
pkg update -y
pkg install -y proot curl tar
echo "=== 1. downloads ==="
mkdir -p ~/alpine ~/dl
cd ~/dl
curl -sLO https://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/x86_64/alpine-minirootfs-3.24.1-x86_64.tar.gz
curl -sLO https://github.com/sst/opencode/releases/download/v1.18.30/opencode-linux-x64-baseline-musl.tar.gz
curl -sLO https://github.com/BurntSushi/ripgrep/releases/download/15.2.0/ripgrep-15.2.0-x86_64-unknown-linux-musl.tar.gz
curl -sLO https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/libgcc-15.2.0-r5.apk
curl -sL -o libstdcpp.apk "https://dl-cdn.alpinelinux.org/alpine/v3.24/main/x86_64/libstdc%2B%2B-15.2.0-r5.apk"
echo "=== 2. extract into ~/alpine ==="
tar -xzf alpine-minirootfs-3.24.1-x86_64.tar.gz -C ~/alpine
tar -xzf opencode-linux-x64-baseline-musl.tar.gz -C ~/alpine/usr/local/bin opencode
mkdir -p ~/dl/rg
tar -xzf ripgrep-*-musl.tar.gz -C ~/dl/rg
cp ~/dl/rg/ripgrep-*/rg ~/alpine/usr/local/bin/rg
tar -xzf libgcc.apk -C ~/alpine --exclude='.SIGN*'
tar -xzf libstdcpp.apk -C ~/alpine --exclude='.SIGN*'
chmod +x ~/alpine/usr/local/bin/opencode ~/alpine/usr/local/bin/rg
printf 'nameserver 10.0.2.3\nnameserver 168.63.129.16\n' > ~/alpine/etc/resolv.conf
mkdir -p ~/.termux
printf 'allow-external-apps=true\n' > ~/.termux/termux.properties
echo "=== 3. cleanup downloads (~70 MB) ==="
rm -rf ~/dl
echo "=== 4. verify ==="
du -sh "$PREFIX" ~ ~/alpine
echo "INSTALL_EMULATOR_DONE — next:"
echo "  cp scripts/opencode-launcher.sh ~/opencode && cp scripts/alpine-shell.sh ~/alpine-sh"
echo "  chmod 700 ~/opencode ~/alpine-sh && ~/opencode --version"
