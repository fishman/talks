# talks-slide-decks

Talk slide decks built with [slidr](https://github.com/slidr-cli/slidr).

## Setup

```bash
git clone --recurse-submodules <this-repo>
# or if already cloned:
git submodule update --init
pdm install
```

`pdm install` installs slidr from the `slidr/` submodule so `pdm run slidr`
works from the project root.

## Build

```bash
make                    # build all decks
make watch-<deck>       # watch and rebuild
```

## Decks

- `snow_corp_cncf.md` - Shared GPU Scheduling (KubeCon Japan 2026)
- `hami_intro.md` - HAMi Introduction and Features - Shared GPU Scheduling & Proactive Autoscaling (KubeCon Japan 2026)

## Assets

Images per deck live in `assets/<deck>/`. Symlinked into `dist/` on build.
