---$$$$$$\ $$\     $$\ $$\   $$\  $$$$$$\   $$$$$$\  $$$$$$$\  $$$$$$\ $$$$$$$\ $$$$$$$$\  $$$$$$\  
--$$  __$$\\$$\   $$  |$$$\  $$ |$$  __$$\ $$  __$$\ $$  __$$\ \_$$  _|$$  __$$\\__$$  __|$$  __$$\ 
--$$ /  \__|\$$\ $$  / $$$$\ $$ |$$ /  \__|$$ /  \__|$$ |  $$ |  $$ |  $$ |  $$ |  $$ |   $$ /  \__|
--\$$$$$$\   \$$$$  /  $$ $$\$$ |\$$$$$$\  $$ |      $$$$$$$  |  $$ |  $$$$$$$  |  $$ |   \$$$$$$\  
---\____$$\   \$$  /   $$ \$$$$ | \____$$\ $$ |      $$  __$$<   $$ |  $$  ____/   $$ |    \____$$\ 
--$$\   $$ |   $$ |    $$ |\$$$ |$$\   $$ |$$ |  $$\ $$ |  $$ |  $$ |  $$ |        $$ |   $$\   $$ |
--\$$$$$$  |   $$ |    $$ | \$$ |\$$$$$$  |\$$$$$$  |$$ |  $$ |$$$$$$\ $$ |        $$ |   \$$$$$$  |
---\______/    \__|    \__|  \__| \______/  \______/ \__|  \__|\______|\__|        \__|    \______/ 



local sourcecheckhold = {

}
local flaggedvehicles = {}
Citizen.CreateThread(function()
    if Config.Framwork == "ESX" then 
        ESX = exports["es_extended"]:getSharedObject()

    ESX.RegisterUsableItem(Config.VehicleBomb, function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem(Config.VehicleBomb, 1)
        TriggerClientEvent('SynVehicleBomb:PlaceTheCarBombInTheCar', source)
        xPlayer.showNotification('Used Carbomb') 
    end) 
    ESX.RegisterUsableItem(Config.VehicleBombBurnerPhone, function(source,item)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.showNotification('Used BurnerPhone') 
        if Config.UseMetaDataItems then 
            if item[Config.MetaDataTableName] then 
                if item[Config.MetaDataTableName].bombcode then 
                    if not sourcecheckhold[source] then 
                        sourcecheckhold[source] = true 
                        exports.oxmysql:query("SELECT " .. Config.PlateCategoryNameInTableInDatabaseName .. " FROM " .. Config.OwnedVehicleTableInDatabaseName .. " WHERE carbomb = ?", {item[Config.MetaDataTableName].bombcode }, function(result)
                            if result and result[1] then
                                if result[1].plate then 
                                    TriggerClientEvent('SynVehicleBomb:UseTheBurnerCarBombPhone', source , result[1].plate, item[Config.MetaDataTableName].bombcode, true)
                                else 
                                    xPlayer.showNotification('Signal Reciever Destroyed') 
                                end 
                            else 
                                if item[Config.MetaDataTableName].plateinitial then 
                                    if table.contains(flaggedvehicles,item[Config.MetaDataTableName].plateinitial) then
                                        TriggerClientEvent('SynVehicleBomb:UseTheBurnerCarBombPhone', source , item[Config.MetaDataTableName].plateinitial, item[Config.MetaDataTableName].bombcode,false ) 
                                    else 
                                        xPlayer.showNotification('Signal Reciever Destroyed') 
                                    end 
                                else 
                                    xPlayer.showNotification('Phone Data Corrupted') 
                                end 
                            end
                        end)
                        Wait(10000)
                        sourcecheckhold[source] = false
                    else 
                        xPlayer.showNotification('Signal Unavailable. Wait') 
                    end
                else 
                    xPlayer.showNotification('Phone Data Corrupted') 
                end
            else 
                xPlayer.showNotification('Phone Data Corrupted')  
            end 
        else 
            TriggerClientEvent('SynVehicleBomb:UseTheBurnerCarBombPhone', source)
        end 
    end) 
    ESX.RegisterUsableItem(Config.VehicleTrackerItem, function(source) -- if you want to make an item for checking vehicles for bombs 
        TriggerClientEvent('SynVehicleBomb:trackerStart', source)
        xPlayer.showNotification("You are Placing the tracker") 
    end) 
        --[[ 
        ESX.RegisterUsableItem(Config.VehicleBombSearchItem, function(source) -- if you want to make an item for checking vehicles for bombs 
            local xPlayer = ESX.GetPlayerFromId(source)

            TriggerClientEvent('SynVehicleBomb:searchforcarbomb', source)

            xPlayer.showNotification("You are Searching the vehicle for bombs") 
        end) 
        ]]

    elseif Config.Framwork == "QBCore" then 
        local QBCore = exports['qb-core']:GetCoreObject()

        Wait(1000)
        QBCore.Functions.CreateUseableItem(Config.VehicleBomb, function(source, item)
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
            TriggerClientEvent('SynVehicleBomb:PlaceTheCarBombInTheCar', src)
            if Player.Functions.RemoveItem(Config.VehicleBomb, 1) then
                TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Config.VehicleBomb], "remove")
            end
        end)


        QBCore.Functions.CreateUseableItem(Config.VehicleBombBurnerPhone, function(source, item)
            local src = source
            local Player = QBCore.Functions.GetPlayer(src)
            -------------------------
            if Config.UseMetaDataItems then 
                if item[Config.MetaDataTableName] then 
                    if item[Config.MetaDataTableName].bombcode then 
                        if not sourcecheckhold[source] then 
                            sourcecheckhold[source] = true 
                            exports.oxmysql:query("SELECT " .. Config.PlateCategoryNameInTableInDatabaseName .. " FROM " .. Config.OwnedVehicleTableInDatabaseName .. " WHERE carbomb = ?", {item[Config.MetaDataTableName].bombcode }, function(result)
                                if result and result[1] then
                                    if result[1].plate then 
                                        TriggerClientEvent('SynVehicleBomb:UseTheBurnerCarBombPhone', source , result[1].plate, item[Config.MetaDataTableName].bombcode, true)
                                    else 
                                        TriggerClientEvent('QBCore:Notify', src, 'Signal Reciever Destroyed', 'error')
                                    end 
                                else 
                                    if item[Config.MetaDataTableName].plateinitial then 
                                        if table.contains(flaggedvehicles,item[Config.MetaDataTableName].plateinitial) then
                                            TriggerClientEvent('SynVehicleBomb:UseTheBurnerCarBombPhone', source , item[Config.MetaDataTableName].plateinitial, item[Config.MetaDataTableName].bombcode,false ) 
                                        else 
                                            TriggerClientEvent('QBCore:Notify', src, 'Signal Reciever Destroyed', 'error')
                                        end 
                                    else 
                                        TriggerClientEvent('QBCore:Notify', src, 'Phone Data Corrupted', 'error')
                                    end 
                                end
                            end)
                            Wait(10000)
                            sourcecheckhold[source] = false
                        else 
                            TriggerClientEvent('QBCore:Notify', src, 'Signal Unavailable. Wait', 'error')
                        end
                    else 
                        TriggerClientEvent('QBCore:Notify', src, 'Phone Data Corrupted', 'error')
                    end
                else 
                    TriggerClientEvent('QBCore:Notify', src, 'Phone Data Corrupted', 'error')
                end 
            else 
                TriggerClientEvent('SynVehicleBomb:UseTheBurnerCarBombPhone', source)
            end
        end)

        QBCore.Functions.CreateUseableItem(Config.VehicleTrackerItem, function(source, item)
            local src = source
            local Player = QBCore.Functions.GetPlayer(src)
            TriggerClientEvent('SynVehicleBomb:trackerStart', src)
        end)
    end 
end)


RegisterServerEvent('SynVehicleBomb:removetrackeritem')
AddEventHandler('SynVehicleBomb:removetrackeritem', function()
    local src = source
    if Config.Framwork == "ESX" then 

        local xPlayer = ESX.GetPlayerFromId(src)


        xPlayer.removeInventoryItem(Config.VehicleTrackerItem, 1)
        
    elseif Config.Framwork == "QBCore" then 
        local Player = QBCore.Functions.GetPlayer(src)
        if Player.Functions.RemoveItem(Config.VehicleTrackerItem, 1) then
            TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Config.VehicleTrackerItem], "remove")
        end
    end 
end)

--#############################################################################################################################################################################################--
--#############################################################################################################################################################################################--
--#############################################################################################################################################################################################--
--#############################################################################################################################################################################################--
--#############################################################################################################################################################################################--
--#############################################################################################################################################################################################--
--#############################################################################################################################################################################################--
--#############################################################################################################################################################################################--

RegisterServerEvent('SynVehicleBomb:InsertVehicleAsFlagged')
AddEventHandler('SynVehicleBomb:InsertVehicleAsFlagged', function(markedcarPlate)
    local src = source
--############################ This Registers the Vehicel as a carbomb car ############################--
    if not table.contains(flaggedvehicles,markedcarPlate) then 
         if markedcarPlate ~= nil then  
            table.insert(flaggedvehicles,markedcarPlate)
        end  
    end 
    if Config.Framwork == "ESX" then 
        local xPlayer = ESX.GetPlayerFromId(src)
       -- xPlayer.addInventoryItem(Config.VehicleBombBurnerPhone, 1)
        if Config.UseDataBaseBombStorage and Config.UseMetaDataItems then 
            genbombcode = math.random(11111111,9999999999)
            markedcarPlate = markedcarPlate or nil 
            local info = {
                bombcode = genbombcode,
                plateinitial = markedcarPlate
            }
            exports['qs-inventory']:AddItem(src,Config.VehicleBombBurnerPhone, 1, false, info)
            exports.oxmysql:query("SELECT " .. Config.PlateCategoryNameInTableInDatabaseName .. " FROM " .. Config.OwnedVehicleTableInDatabaseName .. " WHERE " .. Config.PlateCategoryNameInTableInDatabaseName .. " = ?", {markedcarPlate}, function(result)
                if result and result[1] then
                    exports.oxmysql:query("UPDATE " .. Config.OwnedVehicleTableInDatabaseName .. " SET carbomb = ? WHERE " .. Config.PlateCategoryNameInTableInDatabaseName .. " = ?", {genbombcode, result[1].plate},function(result)
                      
                    end)
                end
            end)
        else 
            xPlayer.addInventoryItem(Config.VehicleBombBurnerPhone, 1)
        end
    elseif Config.Framwork == "QBCore" then 
        local Player = QBCore.Functions.GetPlayer(src)
        if Config.UseDataBaseBombStorage and Config.UseMetaDataItems then 
            genbombcode = math.random(11111111,9999999999)
            markedcarPlate = markedcarPlate or nil 
            local info = {
                bombcode = genbombcode,
                plateinitial = markedcarPlate
            }
            Player.Functions.AddItem(Config.VehicleBombBurnerPhone, 1,false,info)
            exports.oxmysql:query("SELECT " .. Config.PlateCategoryNameInTableInDatabaseName .. " FROM " .. Config.OwnedVehicleTableInDatabaseName .. " WHERE " .. Config.PlateCategoryNameInTableInDatabaseName .. " = ?", {markedcarPlate}, function(result)
                if result and result[1] then
                    exports.oxmysql:query("UPDATE " .. Config.OwnedVehicleTableInDatabaseName .. " SET carbomb = ? WHERE " .. Config.PlateCategoryNameInTableInDatabaseName .. " = ?", {genbombcode, result[1].plate},function(result)
                      
                    end)
                end
            end)
        else 
            Player.Functions.AddItem(Config.VehicleBombBurnerPhone, 1)
        end
    end 
end)

RegisterServerEvent('SynVehicleBomb:CheckVehicleforplacedbombs')
AddEventHandler('SynVehicleBomb:CheckVehicleforplacedbombs', function(markedcarPlate,carbombval,VehLocalId, CheckDatabase)
    local src = source
--############################ This is The final check for a Carbomb ############################--
    if not Config.UseDataBaseBombStorage then 
        if table.contains(flaggedvehicles,markedcarPlate) then 

            local xPlayer = ESX.GetPlayerFromId(src)
            xPlayer.removeInventoryItem(Config.VehicleBombBurnerPhone, 1) 

            TriggerClientEvent('SynVehicleBomb:IfTheBombExistDetonateIt', src)
        

            for i=1,#flaggedvehicles do 
                if flaggedvehicles[i] == markedcarPlate then 
                    flaggedvehicles[i] = nil 
                    break 
                end 
            end 
        end 
    elseif Config.UseDataBaseBombStorage then  

        exports.oxmysql:query("SELECT " .. Config.PlateCategoryNameInTableInDatabaseName .. " FROM " .. Config.OwnedVehicleTableInDatabaseName .. " WHERE carbomb = ?", {carbombval}, function(result)
            if result and result[1] then
                local xPlayer = ESX.GetPlayerFromId(src)
                xPlayer.removeInventoryItem(Config.VehicleBombBurnerPhone, 1) 
                TriggerClientEvent('SynVehicleBomb:IfTheBombExistDetonateIt', src,result[1].plate,carbombval,VehLocalId)

                exports.oxmysql:query("UPDATE " .. Config.OwnedVehicleTableInDatabaseName .. " SET carbomb = ? WHERE " .. Config.PlateCategoryNameInTableInDatabaseName .. " = ?", {0, result[1].plate},function(result)
                   
                end)
            else 
                if table.contains(flaggedvehicles,markedcarPlate) then 
                    --local xPlayer = ESX.GetPlayerFromId(src)
                    --xPlayer.removeInventoryItem(Config.VehicleBombBurnerPhone, 1) 
                    TriggerClientEvent('SynVehicleBomb:IfTheBombExistDetonateIt', src,markedcarPlate,carbombval,VehLocalId)
                    for i=1,#flaggedvehicles do 
                        if flaggedvehicles[i] == markedcarPlate then 
                            flaggedvehicles[i] = nil 
                            break 
                        end 
                    end 
                end 
            end
        end)
    else 
        print("Config ERROR")
    end 
end)


RegisterServerEvent('SynVehicleBomb:getVehicleInfos')
AddEventHandler('SynVehicleBomb:getVehicleInfos', function( markedcarPlate)
local src = source
    if Config.UseDataBaseBombStorage then   
        exports.oxmysql:query("SELECT " .. Config.PlateCategoryNameInTableInDatabaseName .. " FROM " .. Config.OwnedVehicleTableInDatabaseName .. " WHERE " .. Config.PlateCategoryNameInTableInDatabaseName .. " = ?", {markedcarPlate}, function(result)
            if result and result[1] then
                TriggerClientEvent('SynVehicleBomb:getVehicleInfosReturned', src , true)
                local xPlayer = ESX.GetPlayerFromId(src)
                xPlayer.addInventoryItem(Config.VehicleBomb, 1)
                exports.oxmysql:query("UPDATE " .. Config.OwnedVehicleTableInDatabaseName .. " SET carbomb = ? WHERE " .. Config.PlateCategoryNameInTableInDatabaseName .. " = ?", {0, result[1].plate},function(result)
                  
                end)
            else 
                --############################ This is The final check for a Carbomb ############################--
                if table.contains(flaggedvehicles,markedcarPlate) then 
                    --############################ FoundAndRemovedA_carbomb Notification############################--
                    for i=1,#flaggedvehicles do 
                        if flaggedvehicles[i] == markedcarPlate then 
                            flaggedvehicles[i] = nil 
                            break 
                        end 
                    end 
                    if Config.Framwork == "ESX" then 
                        TriggerClientEvent('SynVehicleBomb:getVehicleInfosReturned', src , true)
                        local xPlayer = ESX.GetPlayerFromId(src)
                        xPlayer.addInventoryItem(Config.VehicleBomb, 1)
                    elseif Config.Framwork == "QBCore" then 
                        TriggerClientEvent('SynVehicleBomb:getVehicleInfosReturned', src , true)
                        local Player = QBCore.Functions.GetPlayer(src)
                        Player.Functions.AddItem(Config.VehicleBomb, 1)
                        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Config.VehicleBomb], "add")
                    end 
                else 
                    --############################ YouFoundNothing_Notification ############################--
                    TriggerClientEvent('SynVehicleBomb:getVehicleInfosReturned', src , false)
                end 
            end
        end)
    else 
        --############################ This is The final check for a Carbomb ############################--
        if table.contains(flaggedvehicles,markedcarPlate) then 
            --############################ FoundAndRemovedA_carbomb Notification############################--
            for i=1,#flaggedvehicles do 
                if flaggedvehicles[i] == markedcarPlate then 
                    flaggedvehicles[i] = nil 
                    break 
                end 
            end 
            if Config.Framwork == "ESX" then 
                TriggerClientEvent('SynVehicleBomb:getVehicleInfosReturned', src , true)
                local xPlayer = ESX.GetPlayerFromId(src)
                xPlayer.addInventoryItem(Config.VehicleBomb, 1)
            elseif Config.Framwork == "QBCore" then 
                TriggerClientEvent('SynVehicleBomb:getVehicleInfosReturned', src , true)
                local Player = QBCore.Functions.GetPlayer(src)
                Player.Functions.AddItem(Config.VehicleBomb, 1)
                TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Config.VehicleBomb], "add")
            end 
        else 
        --############################ YouFoundNothing_Notification ############################--
            TiggerClientEvent('SynVehicleBomb:getVehicleInfosReturned', src , false)
        end 
    end 
end)







function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
        return true
        end
    end
    return false
end
