local QBCore = exports['qb-core']:GetCoreObject()

--[[QBCore.Functions.CreateCallback('leaksy-gangs:naplatireket', function(reketiznos)
    local src = source
   
        Player.Functions.AddMoney('cash', reketiznos, 'bank withdrawal')
    

end)
]]

QBCore.Functions.CreateCallback('leaksy-gangs:naplatireket', function(source, cb, reketiznos)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    local reketiznos = Config.ReketIznos
    if xPlayer then
        Player.Functions.AddMoney('cash', reketiznos, 'Naplata Reketa')
        cb(true)  -- Callback success
    else
        cb(false)  -- Callback failure
    end
end)
