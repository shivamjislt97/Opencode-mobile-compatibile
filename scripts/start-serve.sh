#!/data/data/com.termux/files/usr/bin/bash
# Start opencode serve (headless) in background, log to file
export HOME=/data/data/com.termux/files/home
export PATH=/data/data/com.termux/files/usr/bin:$PATH
unset LD_PRELOAD
LOG="$HOME/oc-serve.log"
PIDF="$HOME/oc-serve.pid"
if [ -f "$PIDF" ]; then kill "$(cat "$PIDF")" 2>/dev/null; fi
sleep 1
setsid "$HOME/opencode" serve --port 4096 --hostname 127.0.0.1 > "$LOG" 2>&1 < /dev/null &
echo $! > "$PIDF"
sleep 6
echo "pid=$(cat "$PIDF")"
if kill -0 "$(cat "$PIDF")" 2>/dev/null; then echo "PROCESS_ALIVE"; else echo "PROCESS_DEAD"; fi
echo "--- log head ---"
head -20 "$LOG"
echo "--- listen check (4096=0x1000) ---"
grep -i ':1000' /proc/net/tcp 2>/dev/null | head -3
echo "SERVE_START_DONE"
