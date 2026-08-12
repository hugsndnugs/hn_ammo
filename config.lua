Config = {}

-- GTA V only has explosive special ammo on these two Mk2 weapons.
Config.Weapons = {
    {
        weapon = 'WEAPON_HEAVYSNIPER_MK2',
        explosive = 'COMPONENT_HEAVYSNIPER_MK2_CLIP_EXPLOSIVE',
        defaultClip = 'COMPONENT_HEAVYSNIPER_MK2_CLIP_01',
    },
    {
        weapon = 'WEAPON_PUMPSHOTGUN_MK2',
        explosive = 'COMPONENT_PUMPSHOTGUN_MK2_CLIP_EXPLOSIVE',
        defaultClip = 'COMPONENT_PUMPSHOTGUN_MK2_CLIP_01',
    },
}

-- Adaptive poll intervals (ms)
Config.IdleWait = 750       -- selected weapon is not watched
Config.WatchWait = 150      -- holding a watched Mk2 with no explosive clip
Config.InventorySweep = 5000 -- full inventory check for equipped explosive clips

-- Soft dependency on hn-notify (skipped if resource is not started)
Config.NotifyOnStrip = true
Config.NotifyMessage = 'Explosive ammunition is not allowed.'
Config.NotifyOpts = {
    prefix = 'Ammo',
    type = 'error',
    duration = 3000,
}
