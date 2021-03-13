ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do 
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 
		Citizen.Wait(0) 
	end
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/bk', 'Memurlara yardım çağrısındabulun.', {
        { name="Destek İsteği", help="1, 2, 3" }
    })
end)

RegisterNetEvent('wiz:backup:getCoords')
AddEventHandler('wiz:backup:getCoords', function(level)
    local player = GetPlayerPed(-1)
    local pCoords = GetEntityCoords(player)
    ESX.TriggerServerCallback('wiz:backup:getCharName', function(fname, lname)
        if fname ~= nil and lname ~= nil then
            name = ''..fname..' '..lname..''
            TriggerServerEvent('wiz:backup:onlyCops', pCoords, level, name)
            if level == '1' then
                TriggerServerEvent('wiz:backup:onlyCopsNotify', '[BACKUP] -Destek Çağrısı - ' ..name.. ' - Konumuma acil destek gerekiyor!')
            end
            if level == '2' then
                TriggerServerEvent('wiz:backup:onlyCopsNotify', '[BACKUP] -Silahlı Çatışma Bildirimi - ' ..name.. ' - Bulunduğum konumda silahlı çatışma çıktı!')
            end
            if level == '3' then
                TriggerServerEvent('wiz:backup:onlyCopsNotify', '[BACKUP] -Yaralı Memur - ' ..name.. ' - Yaralandım, konumuma acil destek!')
            end
        end
    end)
end)

RegisterNetEvent('wiz:backup:blip')
AddEventHandler('wiz:backup:blip', function(coords, level, name)
    if level == '1' then
        local blip1 = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip1, 381)
        SetBlipScale(blip1, 1.0)
        SetBlipColour(blip1, 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Destek Lazım - ' .. name)
        EndTextCommandSetBlipName(blip1)
        Citizen.Wait(Config.BlipTime * 1000)
        RemoveBlip(blip1)
    end

    if level == '2' then
        local blip2 = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip2, 381)
        SetBlipScale(blip2, 1.0)
        SetBlipColour(blip2, 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Silahlı Çatışma - ' .. name)
        EndTextCommandSetBlipName(blip2)
        Citizen.Wait(Config.BlipTime * 1000)
        RemoveBlip(blip2)
    end

    if level == '3' then
        local blip3 = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip3, 381)
        SetBlipScale(blip3, 1.0)
        SetBlipColour(blip3, 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Yaralıyım - ' .. name)
        EndTextCommandSetBlipName(blip3)
        Citizen.Wait(Config.BlipTime * 1000)
        RemoveBlip(blip3)
    end
end)