# hn-ammo

Keeps Mk2 explosive ammo off players. If someone equips explosive rounds (or slugs), this strips them back to a normal clip and blocks the shot for a beat so nothing goes off.

Only two weapons in GTA actually have explosive special ammo:

- Heavy Sniper Mk2
- Pump Shotgun Mk2

Everything else (Assault Rifle Mk2, Carbine, SMG, etc.) has other special ammo types, not explosive. RPGs, grenade launchers, and sticky bombs are left alone on purpose.

## How it runs

Most of the time it barely does anything. If you're not holding one of those two guns it waits longer between checks. When you are holding one, it checks a bit more often. Every few seconds it also peeks at your inventory so an explosive clip can't sit on a stowed weapon.

Hashes are baked once when the resource starts.

## Config

All in [`config.lua`](config.lua):

- which weapons / components to watch
- how often to poll vs sweep inventory
- whether to toast via [hn-notify](https://github.com/hugsndnugs/hn-notify) when something gets stripped (optional; skipped if that resource isn't running)

## Optional dependency

Strip / block works on its own. For the toast when a clip is removed, install [hn-notify](https://github.com/hugsndnugs/hn-notify) and start it before `hn-ammo`.

## Install

```cfg
ensure hn-notify
ensure hn-ammo
```

Already set up after `vMenu` in this server's `server.cfg`.
