--[[
    hn-ammo - strip / prevent Mk2 explosive ammunition.
    Only polls the selected weapon when it is watched; inventory sweep is infrequent.
]]

local Watch = {} ---@type table<integer, { explosive: integer, defaultClip: integer }>
local WatchList = {} ---@type { weapon: integer, explosive: integer, defaultClip: integer }[]
local lastNotifyAt = 0

for i = 1, #Config.Weapons do
    local entry = Config.Weapons[i]
    local weapon = joaat(entry.weapon)
    local data = {
        weapon = weapon,
        explosive = joaat(entry.explosive),
        defaultClip = joaat(entry.defaultClip),
    }
    Watch[weapon] = data
    WatchList[#WatchList + 1] = data
end

local function notifyStrip()
    if not Config.NotifyOnStrip then return end
    local now = GetGameTimer()
    if now - lastNotifyAt < 2500 then return end
    lastNotifyAt = now

    if GetResourceState('hn-notify') == 'started' then
        pcall(function()
            exports['hn-notify']:Notify(Config.NotifyMessage, Config.NotifyOpts)
        end)
    end
end

---@param ped integer
---@param weapon integer
---@param data { explosive: integer, defaultClip: integer }
---@return boolean stripped
local function stripExplosive(ped, weapon, data)
    if not HasPedGotWeaponComponent(ped, weapon, data.explosive) then
        return false
    end

    RemoveWeaponComponentFromPed(ped, weapon, data.explosive)
    if not HasPedGotWeaponComponent(ped, weapon, data.defaultClip) then
        GiveWeaponComponentToPed(ped, weapon, data.defaultClip)
    end
    notifyStrip()
    return true
end

-- Selected-weapon monitor (adaptive wait)
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local weapon = GetSelectedPedWeapon(ped)
        local data = Watch[weapon]

        if not data then
            Wait(Config.IdleWait)
        elseif stripExplosive(ped, weapon, data) then
            -- Block firing the same frame(s) the clip is removed.
            local player = PlayerId()
            local untilAt = GetGameTimer() + 250
            while GetGameTimer() < untilAt do
                DisablePlayerFiring(player, true)
                DisableControlAction(0, 24, true)  -- attack
                DisableControlAction(0, 257, true) -- attack2
                DisableControlAction(0, 69, true)  -- vehicle attack
                DisableControlAction(0, 70, true)  -- vehicle attack2
                DisableControlAction(0, 92, true)  -- passenger attack
                Wait(0)
            end
        else
            Wait(Config.WatchWait)
        end
    end
end)

-- Inventory sweep: strip explosive clips on owned watched weapons even if not selected
CreateThread(function()
    while true do
        Wait(Config.InventorySweep)
        local ped = PlayerPedId()
        for i = 1, #WatchList do
            local data = WatchList[i]
            if HasPedGotWeapon(ped, data.weapon, false) then
                stripExplosive(ped, data.weapon, data)
            end
        end
    end
end)
