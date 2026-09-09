#!/data/data/com.termux/files/usr/bin/sh
export PREFIX=/data/data/com.termux/files/usr
export HOME=/data/data/com.termux/files/home
export PATH=$PREFIX/bin:$PATH
export TMPDIR=$PREFIX/tmp
export LANG=en_US.UTF-8
unset LD_PRELOAD
cd "$HOME"
echo "=== extracting libgcc + libstdc++ into alpine ==="
tar -xzf /data/local/tmp/libgcc.apk -C "$HOME/alpine" --exclude='.SIGN*'
tar -xzf /data/local/tmp/libstdcpp.apk -C "$HOME/alpine" --exclude='.SIGN*'
ls -l "$HOME/alpine/usr/lib/libgcc_s.so.1" "$HOME/alpine/usr/lib/libstdc++.so.6"
echo "=== opencode version ==="
proot --link2symlink -0 -r "$HOME/alpine" -b /dev -b /proc -b /sys -w /root /usr/bin/env -i HOME=/root TERM=xterm-256color PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin /usr/local/bin/opencode --version 2>&1 | head -10
echo "LIBS_DONE"
