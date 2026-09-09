#!/data/data/com.termux/files/usr/bin/sh
set -e
export PREFIX=/data/data/com.termux/files/usr
export HOME=/data/data/com.termux/files/home
export PATH=$PREFIX/bin:$PATH
export LD_PRELOAD=$PREFIX/lib/libtermux-exec.so
export TMPDIR=$PREFIX/tmp
export LANG=en_US.UTF-8
cd "$HOME"
echo "=== 1. installing proot debs (offline) ==="
dpkg -i /data/local/tmp/libtalloc.deb /data/local/tmp/libandroid-shmem.deb /data/local/tmp/proot.deb
echo "=== 2. extracting alpine rootfs ==="
mkdir -p "$HOME/alpine"
tar -xzf /data/local/tmp/alpine.tar.gz -C "$HOME/alpine"
echo "=== 3. installing opencode musl-baseline binary ==="
tar -xzf /data/local/tmp/opencode-musl.tar.gz -C "$HOME/alpine/usr/local/bin" opencode
chmod +x "$HOME/alpine/usr/local/bin/opencode"
echo "=== 4. installing ripgrep musl binary ==="
mkdir -p "$HOME/.tmp-rg"
tar -xzf /data/local/tmp/rg-musl.tar.gz -C "$HOME/.tmp-rg"
cp "$HOME/.tmp-rg"/ripgrep-*/rg "$HOME/alpine/usr/local/bin/rg"
chmod +x "$HOME/alpine/usr/local/bin/rg"
rm -rf "$HOME/.tmp-rg"
echo "=== 5. alpine resolv.conf (direct DNS) ==="
printf 'nameserver 10.0.2.3\nnameserver 168.63.129.16\n' > "$HOME/alpine/etc/resolv.conf"
cat "$HOME/alpine/etc/resolv.conf"
echo "=== 6. sizes ==="
du -sh "$PREFIX" "$HOME" "$HOME/alpine"
proot --version
ls -l "$HOME/alpine/usr/local/bin/"
echo "SETUP_DONE"
