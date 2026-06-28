# useful — Unraid Plugin

A web UI plugin for Unraid that provides a central place to view, configure, and trigger useful scripts and settings.

## Install

In Unraid → Plugins → Install Plugin, paste:

```
https://raw.githubusercontent.com/bluepantsdev/unraid_plugin_useful/main/useful.plg
```

## Development

### Repo Structure

```
useful/
├── useful.plg                          # Plugin descriptor (install/update/remove)
├── build.sh                            # Build useful.txz from src/
├── src/
│   └── usr/local/emhttp/plugins/useful/
│       ├── useful.page                 # Web UI tab metadata
│       ├── include/
│       │   └── useful.php              # Main PHP logic
│       ├── scripts/                    # Shell scripts exposed in the UI
│       ├── icons/                      # Plugin icon(s)
│       └── event/                      # Unraid event hooks (started, stopped, etc.)
├── release/                            # Built artifacts (gitignored)
└── .github/workflows/release.yml       # Auto-build on version tag push
```

### Building a Release

```bash
bash build.sh
```

Then tag and push to trigger the GitHub Actions release:

```bash
git tag 2026.06.27
git push origin 2026.06.27
```

The workflow builds `useful.txz`, generates SHA256, attaches both to the GitHub Release,
and the `.plg` URL always points to `main` so Unraid picks up updates automatically.

### Persistent vs RAM paths

| Path | Survives reboot? |
|------|-----------------|
| `/boot/config/plugins/useful/` | ✅ Yes (USB flash) |
| `/usr/local/emhttp/plugins/useful/` | ❌ No (RAM) |

Config files go in `/boot/config/plugins/useful/`.
Plugin files (PHP, scripts) are re-extracted from the `.txz` on each install/update.

### Adding Scripts

Drop scripts into `src/usr/local/emhttp/plugins/useful/scripts/` and update `include/useful.php` to list/run them.
