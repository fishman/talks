# talks-slide-decks

Talk slide decks built with [slidr](https://github.com/slidr-cli/slidr).

## Setup



Slidr must be cloned alongside as `../slidr`.

## Build

```bash
make snow_corp_cncf     # build a specific deck
make                    # build all
make watch-snow_corp_cncf  # watch and rebuild
```

Slidr is referenced from `../slidr` via `pdm`. Install slidr first, then
build decks from this directory.

## Decks

- `snow_corp_cncf.md` - Shared GPU Scheduling (KubeCon Japan 2026)
- `hami_intro.md` - HAMi Introduction and Features - Shared GPU Scheduling & Proactive Autoscaling (KubeCon Japan 2026)

## Assets

Images per deck live in `assets/<deck>/`. Symlinked into `dist/` on build.
