#!/data/data/com.termux/files/usr/bin/bash
# Alpine shell - debugging shell inside the same proot used by opencode
unset LD_PRELOAD
PREFIX=/data/data/com.termux/files/usr
HOME=/data/data/com.termux/files/home
ALPINE="$HOME/alpine"
exec "$PREFIX/bin/proot" \
  --link2symlink \
  -0 \
  -r "$ALPINE" \
  -b /dev \
  -b /proc \
  -b /sys \
  -b "$HOME:/home/host" \
  -w /root \
  /usr/bin/env -i \
    HOME=/root \
    TERM="${TERM:-xterm-256color}" \
    LANG=C.UTF-8 \
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
  /bin/sh -l
