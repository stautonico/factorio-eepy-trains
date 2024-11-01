local last_train_sound_tick = {} -- Track when the last sound was played

local function honk_shoo_enabled()
    return settings.global["eepy-trains-honk-shoo-mode"].value
end

local function get_sound_file ()
    if honk_shoo_enabled() then
        return "eepy-trains-honk-shoo"
    else
        return "eepy-trains-honk-mimimi"
    end
end

local function get_sound_cooldown ()
    if honk_shoo_enabled() then
        return 288
    else
        return 218
    end
end



script.on_nth_tick(60, function()
    local current_tick = game.tick;

    for _, train in pairs(game.train_manager.get_trains {}) do
        if train.state == defines.train_state.destination_full then
            last_train_sound_tick[train.id] = last_train_sound_tick[train.id] or 0

            if (current_tick - last_train_sound_tick[train.id]) >= get_sound_cooldown() then
                train.front_stock.surface.play_sound {
                    path = get_sound_file(),
                    position = train.front_stock.position
                }

                last_train_sound_tick[train.id] = current_tick
            end
        end
    end
end)