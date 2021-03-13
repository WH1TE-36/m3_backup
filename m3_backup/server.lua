ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('wiz:backup:getCharName', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer ~= nil then
        MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier,
        }, function(result)
            if result[1] ~= nil then
                cb(result[1].firstname, result[1].lastname)
            else
                cb(nil)
            end
        end)
    end
end)

TriggerEvent('es:addGroupCommand', 'bk', 'user', function(source, args, user)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local level   = args[1]
    if GetCurrentResourceName() == 'wiz_backup' then
        if xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff' then
            if level ~= nil and level == '1' or level == '2' or level == '3' then
                TriggerClientEvent('wiz:backup:getCoords', _source, level)
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Kodu boş bırakamazsınız! /bk 1 /bk 2 /bk 3'})
            end
        end
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Script adını wiz_backup olarak ayarlayınız!'})
    end
end)

RegisterServerEvent('wiz:backup:onlyCops')
AddEventHandler('wiz:backup:onlyCops', function(coords, level, name)
    local xPlayers = ESX.GetPlayers()

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff' then
            TriggerClientEvent('wiz:backup:blip', xPlayer.source, coords, level, name)
        end
    end
end)

RegisterServerEvent('wiz:backup:onlyCopsNotify')
AddEventHandler('wiz:backup:onlyCopsNotify', function(notifytext)
    local xPlayers = ESX.GetPlayers()

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff' then
            TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = notifytext, length = 7000})
        end
    end
end)

print('[^2wiz_backup^0] - Started!')