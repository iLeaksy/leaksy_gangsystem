local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('leaksy-gangs:naplatireket', function(source, cb, reketiznos)
    local xPlayer = QBCore.Functions.GetPlayer(source)

    -- Using the predefined reket amount from the config, if reketiznos is not passed
    reketiznos = reketiznos or Config.ReketIznos

    if xPlayer then
        -- Adding money to the player's cash balance
        xPlayer.Functions.AddMoney('cash', reketiznos, 'Naplata Reketa')
        cb(true)  -- Callback success
    else
        cb(false)  -- Callback failure
    end
end)
