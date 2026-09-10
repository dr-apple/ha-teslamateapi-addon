# TeslaMate API Add-on Repository

Home Assistant add-on repository wrapping [tobiasehlert/teslamateapi](https://github.com/tobiasehlert/teslamateapi) as a proper installable/updatable add-on.

## Why this repo exists

Home Assistant's Supervisor can only detect and offer updates for add-ons that come from a real add-on repository (a git repo with a `repository.yaml` + one folder per add-on). A `local`-repository add-on (built directly on the host under `/addons/local/...`) has no upstream to compare against, so it can never show "update available" — even if the underlying project publishes new releases.

This repo fixes that: it's a minimal add-on repository containing just the `teslamateapi` add-on, pinned to a specific upstream image tag in `teslamateapi/Dockerfile`.

## Staying up to date automatically

[`.github/workflows/check-upstream.yml`](.github/workflows/check-upstream.yml) runs daily, checks the latest release of [tobiasehlert/teslamateapi](https://github.com/tobiasehlert/teslamateapi), and if it's newer than the pinned tag, bumps `teslamateapi/Dockerfile`'s `BUILD_FROM` and `teslamateapi/config.yaml`'s `version` and pushes the commit. Home Assistant Supervisor then sees the new version the next time it checks this repo, and (since this add-on has "Auto update" enabled) updates itself.

## Setup

1. Add this repository under **Settings → Add-ons → Add-on Store → ⋮ → Repositories**: `https://github.com/dr-apple/ha-teslamateapi-addon`
2. Install "TeslaMate API" from the store.
3. Fill in the options (database/MQTT/TeslaMate connection details, API token) — they're left blank in this repo on purpose, since this repo is public.
4. Remove the old `local_teslamateapi` add-on once the new one is running and configured the same way.
