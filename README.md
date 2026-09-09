# Opencode Mobile Compatible

Run **OpenCode 1.18.30** inside Termux on an **x86_64 Android emulator** (MuMuPlayer),
fully offline-capable install, total footprint **~282 MB** (under a 500 MB cap).

> Real ARM phones: use the native `guysoft/opencode-termux` build instead.
> This repo covers the rare **x86_64 + Termux** case (no community x64 assets exist),
> solved with `proot` + Alpine + official `opencode-linux-x64-baseline-musl`.

![OpenCode TUI running in Termux](sh_tui.png)

## Verified environment

- Host: Windows, MuMuPlayer (Netease `MuMuNxMain`), emulator `emulator-5554`
- Guest: Android 15, model SM-A235F, Termux arch **x86_64**, CPU without guest AVX2
  (AMD EPYC host) → **baseline** build required
- ADB: `D:\Program Files\Netease\MuMuPlayer\nx_main\adb.exe`
- Termux APK: GitHub `github-debug` build (debuggable → `run-as com.termux` works)

## How it works

1. Termux base bootstrap (~78 MB, bundled in APK, works offline).
2. Host downloads everything (guest has restricted network under `run-as`):
   - `proot` + `libtalloc` + `libandroid-shmem` `.deb`s from Termux repo (x86_64)
   - `alpine-minirootfs-3.24.1-x86_64.tar.gz` (~3.7 MB)
   - `opencode-linux-x64-baseline-musl.tar.gz` v1.18.30 (~63 MB)
   - `ripgrep-15.2.0-x86_64-unknown-linux-musl.tar.gz` (~2.2 MB)
   - Alpine `libgcc` + `libstdc++` `.apk`s (~1 MB, opencode needs them)
3. `adb push` → `/data/local/tmp/` (`run-as` cannot read `/sdcard`, but can read
   `/data/local/tmp`), then `run-as com.termux` copies into Termux and installs
   with offline `dpkg -i` / `tar -xzf` (no `apt` network needed).
4. Launch via `proot` (with `unset LD_PRELOAD` to avoid termux-exec conflict).

## Files

| Path in Termux | Source script | Purpose |
|---|---|---|
| `~/alpine/` (~203 MB) | `scripts/setup-termux.sh` | Alpine rootfs + `/usr/local/bin/opencode` (186 MB) + `/usr/local/bin/rg` + `libgcc_s`/`libstdc++` + `etc/resolv.conf` |
| `~/opencode` | `scripts/opencode-launcher.sh` | Launcher: proot + binds (`~/` → `/home/host`), passes args |
| `~/alpine-sh` | `scripts/alpine-shell.sh` | Debug shell in the same proot |
| `~/start-serve.sh` | `scripts/start-serve.sh` | Starts `opencode serve --port 4096` headless with log |
| `~/.termux/termux.properties` | — | `allow-external-apps=true` (enables `RUN_COMMAND` automation) |
| `$PREFIX` additions | `scripts/setup-termux.sh` | `proot`, `libtalloc`, `libandroid-shmem` (~1 MB) |

`scripts/install-libs.sh` extracts the Alpine C++ libs into the rootfs.

## Storage (measured with `du -sh`, MiB)

- `$PREFIX`: 79 (base 78 + proot stack ~1)
- `$HOME`: 203 (`~/alpine` 203: opencode 186 + rg 5.2 + libs ~3 + rootfs ~8)
- **Total: ~282 / 500 cap (~218 free)**

## Usage (inside Termux app)

```bash
./opencode --version   # 1.18.30
./opencode             # TUI, then /connect to add an AI provider key
./opencode run "explain this repo"
~/start-serve.sh       # headless server on 127.0.0.1:4096 (log: ~/oc-serve.log)
```

Headless control from host (no typing needed):

```bash
adb shell run-as com.termux am startservice --user 0 \
  -n com.termux/com.termux.app.RunCommandService \
  -a com.termux.RUN_COMMAND \
  --es com.termux.RUN_COMMAND_PATH /data/data/com.termux/files/home/start-serve.sh \
  --es com.termux.RUN_COMMAND_WORKDIR /data/data/com.termux/files/home \
  --ez com.termux.RUN_COMMAND_BACKGROUND true
```

## Known emulator quirks found

- `run-as` shell has no DNS/external TCP (SELinux context), but the real Termux
  app process has full network (verified: `curl https://api.github.com/zen` OK,
  and DNS+HTTPS work inside Alpine proot from app context).
- Termux activity may open on a secondary display (`mumuscreen003`); target it
  with `input -d <display-id>` and capture with `screencap -d <surfaceflinger-id>`.
- Soft keyboard may report "view is not served" until the terminal window is
  tapped/focused; `show_ime_with_hard_keyboard=1` helps.
