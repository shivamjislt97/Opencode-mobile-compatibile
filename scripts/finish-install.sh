#!/data/data/com.termux/files/usr/bin/sh
# Finish install: launchers + external-apps flag + smoke test + sizes.
# Run AFTER setup-termux.sh and install-libs.sh, from the host via:
#   run-as com.termux /data/data/com.termux/files/usr/bin/sh /data/local/tmp/finish-install.sh
export PREFIX=/data/data/com.termux/files/usr
export HOME=/data/data/com.termux/files/home
export PATH=$PREFIX/bin:$PATH
export TMPDIR=$PREFIX/tmp
export LANG=en_US.UTF-8
unset LD_PRELOAD
cp /data/local/tmp/opencode-launcher.sh "$HOME/opencode"
cp /data/local/tmp/alpine-shell.sh "$HOME/alpine-sh"
chmod 700 "$HOME/opencode" "$HOME/alpine-sh"
mkdir -p "$HOME/.termux"
printf 'allow-external-apps=true\n' > "$HOME/.termux/termux.properties"
ls -l "$HOME/opencode" "$HOME/alpine-sh"
echo "=== smoke test ==="
"$HOME/opencode" --version
echo "=== sizes (cap 500MB) ==="
du -sh "$PREFIX" "$HOME" "$HOME/alpine"
echo "FINISH_DONE"
