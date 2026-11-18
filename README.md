# talks-slide-decks

Talk slide decks built with [decktile](https://github.com/decktile/decktile).

## Setup

```bash
uv tool install 'decktile[plot]'    # or: pipx install 'decktile[plot]'
```

`make` runs `make check` first, which installs or upgrades decktile when needed.

## Build

```bash
make                    # build all decks
make watch-<deck>       # watch and rebuild
```

## Decks

- `snow_corp_cncf.deck.md` - Shared GPU Scheduling (KubeCon Japan 2026)
- `hami_intro.deck.md` - HAMi Introduction and Features - Shared GPU Scheduling & Proactive Autoscaling (KubeCon Japan 2026)

## Assets

Images per deck live in `assets/<deck>/`. Symlinked into `dist/` on build.

## License

Slides, text, diagrams and code in this repository are licensed under
[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) (see `LICENSE`).
You can copy, adapt and reuse any of it, commercially too, as long as you credit:

> Reza Jelveh (github.com/fishman), Solution Architect, Dynamia AI - Makers of HAMi

Not covered: third-party logos and trademarks (CNCF, KubeCon, Linux Foundation, event
and company logos, adopter logos) and event backgrounds. Those belong to their owners.
