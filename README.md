# Better Fantasy

A single-file web app that gives you a better view of your **WSL Fantasy Surfing** league than the official site.

For each event, see the full league leaderboard plus every member's team — their picks per tier, who's eliminated, who's still active, per-surfer points, the power surfer, and round-by-round breakdown. Tap any surfer's photo for a full detail card.

Live deploy: [better-fantasy.pecar.me](https://better-fantasy.pecar.me)

## Why

The official [fantasy.worldsurfleague.com](https://fantasy.worldsurfleague.com) only lets you view one team at a time and buries the per-surfer scoring two clicks deep. This puts everyone in your league side-by-side on one screen so you can actually see how the event is unfolding.

## How it works

It's a thin browser-only client over the **undocumented** WSL Fantasy API at `https://gamesapi.worldsurfleague.com`. There is no backend — every request goes straight from your browser to WSL's servers. Your authentication tokens live only in `localStorage`, on your device.

Endpoints used (all reverse-engineered from HAR captures of the official site):

- `GET /fantasy/feeds/schedule/{tour_id}_en.json` — events for a tour
- `GET /fantasy/feeds/players/{tour_id}_{gameday_id}_en.json` — per-event surfer stats (points, round breakdown, heat scores, selected %)
- `GET /fantasy/feeds/countrylist/countries.json` — country lookup
- `GET /fantasy/feeds/translations/en.json` — used for the asset version (`imgVer`)
- `GET /fantasy/services/league/user/{guid}/private/leagues` — leagues you belong to
- `GET /fantasy/services/league/private/{guid}/private/rank` — leaderboard for a league + event
- `GET /fantasy/services/gameplay/view-other-team` — picks + eliminations for one member

Surfer photos and country flags are served from `…/static-assets/fantasy/static/build/images/{players,flags}/{id}.png?v={imgVer}`.

Every authenticated call sends two custom headers:

- `entity: ed0t4n$3!!` — a static app key embedded in the WSL frontend
- `x-game-token: <JWT>` — your per-user fantasy token, which the WSL site exchanges from your main `worldsurfleague.com` session JWT via `POST /fantasy/services/session/fantasy-login`

## Files

| File | Purpose |
|---|---|
| `index.html` | The whole app. Vanilla JS, no build step. |
| `icon.svg` / `icons/` | App icons for browsers / iOS / Android home screen |
| `manifest.webmanifest` | PWA manifest (installable) |
| `service-worker.js` | Caches the app shell for offline; bypasses the WSL API |

## Run locally

It's just static files. Either:

```sh
open index.html
```

## Caveats

- **Unofficial.** WSL can change or rate-limit this API at any time.
- **Static `entity` header.** Hardcoded in WSL's own frontend. If they ever rotate it, this app will need a one-line update to match.
- **Scope.** Read-only league/team viewing for `tour_id=1` (Championship Tour). No team editing, no other tours, no notifications.
- **Per-surfer points are only available for events that have a published feed.** Future events show picks (where applicable) and eliminations but no scoring breakdown.
