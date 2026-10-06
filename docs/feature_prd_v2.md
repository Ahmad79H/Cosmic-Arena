# Cosmic Arena — Feature PRD v2

## Goal
Take the current scaffold (setup → deterministic battle → result) into a polished mobile experience that pulls real effects/animations from the internet and remains moddable.

## New features (v2)
1. **Asset pipeline screen** — search & preview free asset packs from Kenney, itch.io CC0, Freesound, LottieFiles by keyword (e.g., "laser", "shockwave"); one-tap import into `assets/` with manifest logging.
2. **VFX bursts** — dotlottie animations on hit/critical; sprite-sheet eruption effects from downloaded PNGs.
3. **Streaks / stripes shader overlay** — CC0 speed-line textures composited over the Flame canvas; subtle parallax starfield background.
4. **Battle entities** — 4 fully data-driven entities from JSON; health bars, damage numbers, telegraphed attack rings.
5. **Camera polish** — gentle shake on crit, hit-stop freeze 2–4 frames, reduced-motion toggle.
6. **Result share** — `render` captures 9:16 replay card and exports MP4/GIF.
7. **Saved battles / replay** — store seed + entity IDs + events in local JSON; replay verdict later.
8. **Daily seeded challenge** — fixed seed derived from local date so both clients get the same fight.
9. **Accessibility** — reduced motion toggle, sound-off readability checklist, text scaling.
10. **CI polish** — separate asset-manifest validation step in GitHub Actions.

## Skills / MCPs needed (free — none currently installed via marketplace)
| Purpose | Free tool | Status in this env |
|---|---|---|
| Web docs / API lookup | `context7` MCP (already present) | available |
| GitHub code search | `gh_grep` tool (already present) | available |
| Asset download & page inspection | `webfetch`, `websearch`, `browser` tools | available |
| Local filesystem / file ops | shell + read/write/edit | available |
| Full browser automation | Playwright MCP (`@playwright/mcp`) — free | install if needed |
| Generic fetch proxy | `fetch` MCP (`mcp-server-fetch`) — free | install if needed |
| Test running | `flutter test` via CI (no local SDK) | via GitHub Actions |
| Repo management | `git` CLI (installed) | available |

## Operating model
1. Use `websearch`/`webfetch` to find free (CC0/CC-BY/Pixabay/Mixkit) effects PNGs, Lottie JSONs, spritesheets, audio.
2. Use `browser` tools to preview; download via PowerShell `Invoke-WebRequest`.
3. Record every asset in `docs/ASSET_MANIFEST.md`.
4. Wire each into the Flutter app: Flame sprite component, dotlottie burst, audio SFX.
5. Push to GitHub → CI builds APK.
