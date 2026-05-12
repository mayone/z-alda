# z-alda

Playing with [Alda](https://alda.io/) — a text-based music composition language.

---

## Requirements

- [`just`](https://just.systems/) — task runner (`brew install just`)
- `curl` — for downloading the Alda binaries
- `java` — Alda needs the JVM; setup will install Temurin (macOS) or default-jdk (Linux) for you if missing

Supported platforms: macOS (Intel & Apple Silicon), Linux (amd64 & arm64), Windows (Git Bash / WSL).

---

## Quick start

```console
cp .env.example .env
just setup
just t
```

`just setup` is cached — it skips reinstalling if `bin/alda` already exists. Use `just setup-force` to reinstall.

---

## Just targets

| Target | Alias | Description |
|---|---|---|
| `just setup` | `just s` | Install Alda (skips if already installed) |
| `just setup-force` |  | Reinstall Alda from scratch |
| `just update` | `just u` | Run `alda update` to fetch the latest version |
| `just test` | `just t` | Run `alda version` / `doctor` / a quick trumpet sample |
| `just run <FILE>` | `just r <FILE>` | Play an Alda file |

Examples:

```console
just r examples/hello_world.alda
just r examples/z.alda
```

---

## Configuration

All knobs live in `.env` (copy from `.env.example`):

| Key | Purpose |
|---|---|
| `ALDA_HOME` | Where the binaries are installed (defaults to `./bin`) |
| `ALDA_RELEASES_URL` | Alda CDN base URL |
| `ALDA`, `ALDA_PLAYER` | Binary names |
| `ALDA_OS` | Override auto-detected OS (`darwin` / `linux` / `windows`) |
| `ALDA_ARCH` | Override auto-detected arch (`amd64` / `arm64`) |

The platform overrides are only needed when you want to force a non-native build (e.g. running amd64 under Rosetta on Apple Silicon).

---

## Manual setup (without just)

```console
cp .env.example .env
bash ./setup.sh
alda play --file examples/hello_world.alda
```

---

## Troubleshooting

- **Apple Silicon**: the script downloads the native `darwin-arm64` build. If you hit issues, set `ALDA_ARCH="amd64"` in `.env` to use the Intel build via Rosetta.
- **`alda doctor`**: run after setup to verify everything (Java, player, soundfont).
- **Windows**: install Java manually (Temurin recommended), then `bash ./setup.sh` from Git Bash or WSL.

---

## References

- [alda.io](https://alda.io/)
- [alda-lang/alda](https://github.com/alda-lang/alda)
  - [List of Instruments](https://github.com/alda-lang/alda/blob/master/doc/list-of-instruments.md)
  - [Editor Plugins](https://github.com/alda-lang/alda/blob/master/doc/editor-plugins.md)
