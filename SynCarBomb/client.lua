local phonebomb 
local VehLocalId
local readyforblowup = false 



function round(x)
    return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
end

function GetWorldVehicles()
    return GetGamePool('CVehicle') -- Get the list of vehicles (entities) from the pool
end


function LoadAnimDict( dict )
    BreakCheck = 0
    RequestAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        Citizen.Wait( 0 )
        BreakCheck = BreakCheck +1
        if BreakCheck > 100 then 
            break 
        end 
    end
end

function GetVehicleInDirection()
	local playerPed    = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
	local inDirection  = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
	local rayHandle    = StartShapeTestRay(playerCoords, inDirection, 10, playerPed, 0)
	local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

	if hit == 1 and GetEntityType(entityHit) == 2 then
        local entityHitCoords  = GetEntityCoords(entityHit)
        local closestcarpos = GetDistanceBetweenCoords(entityHitCoords.x , entityHitCoords.y , entityHitCoords.z, playerCoords.x, playerCoords.y, playerCoords.z, false)
        if closestcarpos <= 5 then 
		    return entityHit
        else  
            return nil
        end 
	end

	return nil
end

function ShowHelpNotification(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, 50)
end

Citizen.CreateThread(function()
    if Config.UseCommands then 
        RegisterCommand('makephonebomb', function(source, args, rawCommand)
            plantphonebomboncar()
        end)
        RegisterCommand('Trackermake', function(source, args, rawCommand)
            --############################ Check The Car For bombs ############################--
            --############################ Chance Of Finding it ############################--
                local ped = PlayerPedId()
                Tracker_In_Hand_Anim_and_Prop()
                if IsPedInAnyVehicle(ped) then 
                    vehicle2 = GetVehiclePedIsIn(ped)
                    incarsearchanimation()
                else 
                    vehicle2 = GetVehicleInDirection() 
                        if vehicle2 then 
                            Citizen.CreateThread(function()
                                crawlundercaranimation(ped,false,vehicle2)
                        end)
                    end 
                end 
                Wait(4000)
                local playercoords = GetEntityCoords(ped)
                local carcoords = GetEntityCoords(vehicle2)
            if #(playercoords - carcoords) < 5 then 
                showInfobar(Config.trackerplaced)
            SetEntityAsMissionEntity(vehicle2,true, true)
            TriggerEvent('SynVehicleBomb:trackerToggle', vehicle2)   
            else 
                showInfobar(Config.trackenotplaced)
            end           
        end)
    end 

    if Config.UseBombSearchCommand then 
        RegisterCommand('checkphonebomb', function(source, args, rawCommand)
            --############################ Check The Car For bombs ############################--
            --############################ Chance Of Finding it ############################--
    
            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped) then 
                vehicle2 = GetVehiclePedIsIn(ped)
                incarsearchanimation()
            else 
                vehicle2 = GetVehicleInDirection() 
                    if vehicle2 then 
                        Citizen.CreateThread(function()
                            crawlundercaranimation(ped,false,vehicle2)
                    end)
                end 
            end 
            Wait(2000)
            Wait(4000)
            local plate = GetVehicleNumberPlateText(vehicle2)
            TriggerServerEvent('SynVehicleBomb:getVehicleInfos', plate)             
        end)
    end 
end)

RegisterNetEvent('SynVehicleBomb:getVehicleInfosReturned')
AddEventHandler('SynVehicleBomb:getVehicleInfosReturned', function(status)
--############################ Placethecarbomb ############################--
        status = status
        --print(status)
        if status then 
            showInfobar(Config.bombfound)
            Bomb_In_Hand_Anim_and_Prop()
        else 
            showInfobar(Config.bombnotfound)
        end 
end)

RegisterNetEvent('SynVehicleBomb:searchforcarbomb')
AddEventHandler('SynVehicleBomb:searchforcarbomb', function()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped) then 
        vehicle2 = GetVehiclePedIsIn(ped)
        incarsearchanimation()
    else 
        vehicle2 = GetVehicleInDirection() 
            if vehicle2 then 
                Citizen.CreateThread(function()
                    crawlundercaranimation(ped,false,vehicle2)
                end)
            end 
    end 
    Wait(2000)
    Wait(4000)
    local plate = GetVehicleNumberPlateText(vehicle2)
    TriggerServerEvent('SynVehicleBomb:getVehicleInfos', plate)    
end)



RegisterNetEvent('SynVehicleBomb:IfTheBombExistDetonateIt')
AddEventHandler('SynVehicleBomb:IfTheBombExistDetonateIt', function(platerec,carbombval,VehLocalId)
    if Config.Debug then 
        print(platerec,carbombval,VehLocalId, CheckDatabase)
    end
--############################ Final Check to Detonate ############################--
    local lastbombcheck = HasVehiclePhoneExplosiveDevice(VehLocalId)
    if lastbombcheck then 
        DetonateVehiclePhoneExplosiveDevice(phonebomb)
        showInfobar(Config.bombdetonated)
    else 
        phonebomb = AddVehiclePhoneExplosiveDevice(VehLocalId)
        Citizen.Wait(1000)
        DetonateVehiclePhoneExplosiveDevice(phonebomb)
        showInfobar(Config.bombdetonated)
    end   
    phonebomb = nil 
end)


RegisterNetEvent('SynVehicleBomb:PlaceTheCarBombInTheCar')
AddEventHandler('SynVehicleBomb:PlaceTheCarBombInTheCar', function()
--############################ Placethecarbomb ############################--
plantphonebomboncar()
end)


RegisterNetEvent('SynVehicleBomb:UseTheBurnerCarBombPhone')
AddEventHandler('SynVehicleBomb:UseTheBurnerCarBombPhone', function(ServerCarPlate, ServerBombCode,CheckDatabase)
--############################ UsetheBurnerPhone ############################--
  

     for k ,veh in pairs(GetWorldVehicles()) do
        local plate = GetVehicleNumberPlateText(veh)
        if string.match(tostring(plate),tostring(ServerCarPlate))then
            
            if Config.Debug then 
                print("found car Head are the Details, Plate, Bombcode, Is it in Database")
                print(ServerCarPlate, ServerBombCode,CheckDatabase)
            end 
                phonereadyforbomb(ServerBombCode,ServerCarPlate,CheckDatabase)  
            break 
        end    
    end
    showInfobar("Reciever out of Range")
end)

function PlayAnimOnce(ped, animDict, animName, blendInSpeed, blendOutSpeed, duration, startTime)
    LoadAnimDict(animDict)
    TaskPlayAnim(ped, animDict, animName, blendInSpeed or 2.0, blendOutSpeed or 2.0, duration or -1, 0, startTime or 0.0, false, false, false)
    RemoveAnimDict(animDict)
   --[[  Wait(GetAnimDuration(animDict, animName) * 1000) ]]
end
function ChangeHeadingSmooth(ped, amount, time)
    local times = math.abs(amount)
    local test = amount / times
    local wait = time / times

    for _i = 1, times do
        Wait(wait)
        SetEntityHeading(ped, GetEntityHeading(ped) + test)
    end
end

function plantphonebomboncar()
    local ped = PlayerPedId()
    local vehicle

    if IsPedInAnyVehicle(ped) then 
        vehicle = GetVehiclePedIsIn(ped)
        incarsearchanimation()
    else 
        vehicle = GetVehicleInDirection() 
       if vehicle then 
        crawlundercaranimation(ped,true,vehicle)
       end 
    end 
	if DoesEntityExist(vehicle) then
        local playercoords = GetEntityCoords(ped)
        local carcoords = GetEntityCoords(vehicle)
        if #(playercoords - carcoords) < 5 then 
            showInfobar(Config.bombplaced)
            phonebomb = AddVehiclePhoneExplosiveDevice(vehicle)
            local plate = GetVehicleNumberPlateText(vehicle)
            if Config.Debug then 
                if plate then 
                    print("Vehicle plate " ..plate .." Flagged For bomb" )
                else 
                    print("Vehicle plate Returned as Nil" )
                end 
            end 
            TriggerServerEvent('SynVehicleBomb:InsertVehicleAsFlagged', plate)    
        else 
            showInfobar(Config.bombnotplaced)
        end  
    else 
        showInfobar(Config.bombnotplaced)
    end 
end
 
function incarsearchanimation()
    local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
    local headin = GetEntityHeading(ped)
	local dict = 'anim@mp_snowball'
    LoadAnimDict( dict ) 
	TaskPlayAnimAdvanced(ped, dict, 'pickup_snowball', coords, 0.0, 0.0, headin , 0.5, 0.5, 4000, 16, 0.0, 1, 1)

    while IsEntityPlayingAnim(ped, dict, 'pickup_snowball', 3) do 
        Citizen.Wait( 0 )
    end 

    dict = 'anim@heists@prison_heiststation@'
    LoadAnimDict( dict ) 
    TaskPlayAnimAdvanced(ped, dict, 'pickup_bus_schedule', coords, 0.0, 0.0, headin, 1.0, 1.0, 6000, 16, 0.0, 1, 1)
    while IsEntityPlayingAnim(ped, dict, 'pickup_bus_schedule', 3) do 
        Citizen.Wait( 0 )
    end 
    RemoveAnimDict(dict)  
    return false 
end

function crawlundercaranimation(ped,inhandProp,curveh)
    if inhandProp then 
        Bomb_In_Hand_Anim_and_Prop()
    end 
	local coords = GetEntityCoords(ped)
	local offset = GetOffsetFromEntityInWorldCoords(ped, 0.0, -2.0, 0.0)
    local curvehcoords = offset
    if curveh then 
	    curvehcoords = GetEntityCoords(curveh)
    end 
	TaskPedSlideToCoord(ped, offset, headin, 1000)

    PlayAnimOnce(ped, "amb@world_human_sunbathe@male@front@enter", "enter", 8.0,  8.0, -1)
    Wait(2500)
    PlayAnimOnce(ped, "get_up@directional_sweep@combat@pistol@front", "front_to_prone", 8.0,  8.0, 1.0)
    ChangeHeadingSmooth(ped, -18.0, 3600)
    local headin = GetEntityHeading(ped)
    dict = 'move_crawl'
    LoadAnimDict( dict )
    local timewait = round(#(coords - curvehcoords) * 1060)
	TaskPlayAnimAdvanced(ped, dict, 'onback_bwd', coords, 0.0, 0.0, headin, 8.0, 0.5, timewait, 1, 0.0, 1, 1)
	dict = 'amb@world_human_vehicle_mechanic@male@base'
	Citizen.Wait(timewait)
	LoadAnimDict( dict )
	TaskPlayAnim(ped, dict, 'base', 8.0, -8.0, 5000, 1, 0, false, false, false)
	dict = 'move_crawl'
	Citizen.Wait(5000)
	local coords2 = GetEntityCoords(ped)
	LoadAnimDict( dict )
	TaskPlayAnimAdvanced(ped, dict, 'onback_fwd', coords2, 0.0, 0.0, headin, -1.0, 0.5, timewait, 1, 0.0, 1, 1)
	Citizen.Wait(timewait)
    RemoveAnimDict(dict)
    PlayAnimOnce(ped, "get_up@directional@transition@prone_to_seated@crawl", "back", 16.0, nil, -1)
end


function Bomb_In_Hand_Anim_and_Prop()
    Citizen.CreateThread(function()
        local hand_prop_name = Config.VehicleBombProp
        local playerPed = PlayerPedId()
        local xprophand,yprophand,zprophand = table.unpack(GetEntityCoords(playerPed))
        local propc4bomb = CreateObject(GetHashKey(hand_prop_name), xprophand, yprophand, zprophand + 0.2, true, true, true)
        local boneIndex = GetPedBoneIndex(playerPed, 18905)
        AttachEntityToEntity(propc4bomb, playerPed, boneIndex, 0.13, 0., 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
       
        Wait(8000)
    
        DetachEntity(propc4bomb, true, false)
        SetEntityCollision(propc4bomb, false, false)
        DeleteObject(propc4bomb)
    
    end)
end


function phonereadyforbomb(carbombval,ServerCarPlate, CheckDatabase)
    local readyforblowup = true 
    local VehLocalId = nil 
    PhonePlayText()
        Citizen.CreateThread(function()
            Citizen.Wait(500)
            PlaySoundFrontend(-1, "Remote_Ring", "Global_19670", 1) 

            PlayPedRingtone("Dial_and_Remote_Ring",PlayerPedId(), 1)
        end)
    Citizen.CreateThread(function()
        while readyforblowup do 
            Citizen.Wait(3)
            showInfobar(Config.PhoneText)
            if IsControlPressed(0, Config.KeyToTriggerPhoneBomb) then 
                StopPedRingtone(PlayerPedId())
                Citizen.Wait(500)
                 for k ,veh in pairs(GetWorldVehicles()) do
                    local plate = GetVehicleNumberPlateText(veh)
                    if string.match(tostring(plate),tostring(ServerCarPlate))then
                        if Config.Debug then 
                            print("found car Head are the Details, Plate, Bombcode, Is it in Database")
                            print(ServerCarPlate, carbombval,CheckDatabase)
                        end 
                            VehLocalId = veh
                            Wait(1)
                        break 
                    end    
                end
                Wait(1)
                if VehLocalId then 
                    local pedcoords  = GetEntityCoords(PlayerPedId())
                    local vehcoords  = GetEntityCoords(VehLocalId)
                    local distancetoboom = #(pedcoords-vehcoords)
                    if Config.MaxDistanceforCall then 
                        if distancetoboom <= Config.MaxDistanceforCall then 
                            Citizen.CreateThread(function()
                                PlaySoundFrontend(-1, "Hang_Up", "Phone_SoundSet_Michael", 1) 
                            end)
                            local plate = GetVehicleNumberPlateText(VehLocalId)
                            TriggerServerEvent('SynVehicleBomb:CheckVehicleforplacedbombs', plate,carbombval,VehLocalId, CheckDatabase)
                            Citizen.Wait(200)
                            readyforblowup = false 
                            PhonePlayOut()
                            VehLocalId = nil
                            break
                        else 
                            showInfobar(Config.bombdetonationfailed)

                            Citizen.CreateThread(function()
                            PlaySoundFrontend(-1,"Put_Away", "Phone_SoundSet_Michael", 1)
                            end)
                            readyforblowup = false 
                            PhonePlayOut() 
                            break
                        end 
                    else 
                        Citizen.CreateThread(function()
                            PlaySoundFrontend(-1, "Hang_Up", "Phone_SoundSet_Michael", 1) 
                    
                        end)
                        local plate = GetVehicleNumberPlateText(VehLocalId)
                        TriggerServerEvent('SynVehicleBomb:CheckVehicleforplacedbombs', plate)
                        Citizen.Wait(200)
                        readyforblowup = false 
                        PhonePlayOut()
                        VehLocalId = nil
                        break
                    end
                else 
                    showInfobar("Reciever Signal Lost")
                    StopPedRingtone(PlayerPedId())
                    readyforblowup = false 
                    PhonePlayOut()
                    break 
                end 
                Wait(500)
            elseif IsControlPressed(0, 177) then 
                StopPedRingtone(PlayerPedId())
                readyforblowup = false 
                PhonePlayOut()
                break
            end 
        end 
    end)
end

 --------------------------------------------------------------------------------------------------------------------------------
 ------############################################################ PHONE AND PHONE ANIMATION #################################################################------------------------
 local myPedId = nil
 local phoneProp = nil
 local currentStatus = "out"
 local lastDict = nil
 local lastAnim = nil
 local lastIsFreeze = false


 local ANIMS = {
	['cellphone@'] = {
		['out'] = {
			['text'] = 'cellphone_text_in',
			['call'] = 'cellphone_call_listen_base',
		},
		['text'] = {
			['out'] = 'cellphone_text_out',
			['text'] = 'cellphone_text_in',
			['call'] = 'cellphone_text_to_call',
		},
		['call'] = {
			['out'] = 'cellphone_call_out',
			['text'] = 'cellphone_call_to_text',
			['call'] = 'cellphone_text_to_call',
		}
	},
	['anim@cellphone@in_car@ps'] = {
		['out'] = {
			['text'] = 'cellphone_text_in',
			['call'] = 'cellphone_call_in',
		},
		['text'] = {
			['out'] = 'cellphone_text_out',
			['text'] = 'cellphone_text_in',
			['call'] = 'cellphone_text_to_call',
		},
		['call'] = {
			['out'] = 'cellphone_horizontal_exit',
			['text'] = 'cellphone_call_to_text',
			['call'] = 'cellphone_text_to_call',
		}
	}
}

function newPhoneProp()
	deletePhone()
	RequestModel(Config.VehicleBombBurnerPhoneProp)
	while not HasModelLoaded(Config.VehicleBombBurnerPhoneProp) do
		Citizen.Wait(10)
	end
	phoneProp = CreateObject(GetHashKey(Config.VehicleBombBurnerPhoneProp),1.0,1.0,1.0,1,1,0)
	SetEntityCollision(phoneProp,false,false)
	AttachEntityToEntity(phoneProp,myPedId,GetPedBoneIndex(myPedId,28422),0.0,0.0,0.0,0.0,0.0,0.0,1,1,0,0,2,1)
	Citizen.InvokeNative(0xAD738C3085FE7E11,phoneProp,true,true)
end

function deletePhone()
	if DoesEntityExist(phoneProp) then
		DetachEntity(phoneProp,true,true)
		Citizen.InvokeNative(0xAD738C3085FE7E11,phoneProp,true,true)
		SetEntityAsNoLongerNeeded(Citizen.PointerValueIntInitialized(phoneProp))
		DeleteEntity(phoneProp)
		phoneProp = nil
	end
end

function PhonePlayAnim(status,freeze,force)
	if status ~= 'out' and currentStatus == 'out' then
	end
 
	if currentStatus == status and force ~= true then
		return
	end

	myPedId = PlayerPedId()
	local freeze = freeze or false

	local dict = "cellphone@"
	if IsPedInAnyVehicle(myPedId,false) then
		dict = "anim@cellphone@in_car@ps"
	end
	LoadAnimDict(dict)

	local anim = ANIMS[dict][currentStatus][status]
	if currentStatus ~= 'out' then
		StopAnimTask(myPedId,lastDict,lastAnim,1.0)
	end
	local flag = 50
	if freeze == true then
		flag = 14
	end
	TaskPlayAnim(myPedId,dict,anim,3.0,-1,-1,flag,0,false,false,false)

	if status ~= 'out' and currentStatus == 'out' then
		Citizen.Wait(380)
		newPhoneProp()
		SetCurrentPedWeapon(myPedId,GetHashKey("WEAPON_UNARMED"),true)
	end

	lastDict = dict
	lastAnim = anim
	lastIsFreeze = freeze
	currentStatus = status

	if status == 'out' then
		Citizen.Wait(180)
		deletePhone()
		StopAnimTask(myPedId,lastDict,lastAnim,1.0)
	end
end

function PhonePlayOut()
	PhonePlayAnim('out')
    local readyforblowup = false   
end

function PhonePlayText()
	PhonePlayAnim('text')
    
end

function PhonePlayCall(freeze)
	PhonePlayAnim('call',freeze)
end

function PhonePlayIn()
	if currentStatus == 'out' then
		PhonePlayText()
	end
end
-------------------------------------------------------------------------------------------
---________________________________________________ TRACKER ________________________________________________

RegisterNetEvent("SynVehicleBomb:trackerStart")
AddEventHandler("SynVehicleBomb:trackerStart",function()
        local ped = PlayerPedId()
        Tracker_In_Hand_Anim_and_Prop()
        if IsPedInAnyVehicle(ped) then 
            vehicle2 = GetVehiclePedIsIn(ped)
            incarsearchanimation()
        else 
            vehicle2 = GetVehicleInDirection() 
                if vehicle2 then 
                    Citizen.CreateThread(function()
                        crawlundercaranimation(ped,false,vehicle2)
                end)
            end 
        end 
        Wait(6000)
        local playercoords = GetEntityCoords(ped)
        local carcoords = GetEntityCoords(vehicle2)
    if #(playercoords - carcoords) < 5 then 
        showInfobar(Config.trackerplaced)
    Citizen.InvokeNative(0xAD738C3085FE7E11,vehicle2,true,true)
    TriggerServerEvent('SynVehicleBomb:removetrackeritem')   
    Wait(500)
    TriggerEvent('SynVehicleBomb:trackerToggle', vehicle2)   
    else 
        showInfobar(Config.trackenotplaced)
    end  
end)

function Tracker_In_Hand_Anim_and_Prop()
    Citizen.CreateThread(function()
        local hand_prop_name = Config.VehicleTrackerProp
        local playerPed = PlayerPedId()
        local xprophand,yprophand,zprophand = table.unpack(GetEntityCoords(playerPed))
        local TrackerInHand_obj = CreateObject(GetHashKey(hand_prop_name), xprophand, yprophand, zprophand + 0.2, true, true, true)
        local boneIndex = GetPedBoneIndex(playerPed, 18905)
        AttachEntityToEntity(TrackerInHand_obj, playerPed, boneIndex, 0.13, 0.09, -0.02, -118.04, 0.0, 0.0, true, true, false, true, 1, true)
        Wait(6000)
        DetachEntity(TrackerInHand_obj, true, false)
        SetEntityCollision(TrackerInHand_obj, false, false)
        DeleteObject(TrackerInHand_obj)
    end)
end

local floor = math.floor
local trackeractive = false
local TrackedVeheicle = false 
RegisterNetEvent("SynVehicleBomb:trackerToggle")
AddEventHandler("SynVehicleBomb:trackerToggle",function(VehLocalIdTracker)
    trackeractive = not trackeractive
    local time = Config.VehicleTrackingTime * 60000
    local timer = GetGameTimer() 
    local blip = nil
    local Timeleft = nil 
    local PlayerPedIdValue = PlayerPedId()
    if trackeractive and VehLocalIdTracker then 
        while trackeractive and GetGameTimer() - timer < time do
            Wait(0)
           
            
            if not blip then
                blip = AddBlipForEntity(PlayerPedIdValue)
                SetBlipSprite(blip,floor(148))
                SetBlipDisplay(blip,floor(9))
                SetBlipAlpha(blip,floor(40))
                SetBlipScale(blip,0.0)
            end
            local scale = 0.0
            
            if  not Timeleft then 
                if DoesEntityExist(VehLocalIdTracker)  then 
                    Timeleft = GetGameTimer() - timer
                    oldtimeleft = Timeleft
                    TrackedVeheicle = GetEntityCoords(VehLocalIdTracker)
                    Wait(1000)
                else 
                    trackeractive = false
                end 
            end 

            
            while true do
                Wait(0)
                if DoesEntityExist(VehLocalIdTracker) then 
                    local coords = GetEntityCoords(PlayerPedIdValue) -- Must
                    scale = scale + 0.05 -- Must
                    local distancetoTracker = #(coords - TrackedVeheicle)
                    if not TrackerBlip then
                        TrackerBlip = AddBlipForCoord(TrackedVeheicle.x,TrackedVeheicle.y,TrackedVeheicle.z)
                        SetBlipSprite(TrackerBlip,floor(225))
                        SetBlipColour(TrackerBlip,floor(81))
                        SetBlipDisplay(TrackerBlip,floor(8))
                        SetBlipScale(TrackerBlip,0.9)
                    --[[  SetBlipAlpha(TrackerBlip,floor(120)) ]]
                        if distancetoTracker > Config.VehicleTrackerRoutingDistance then  --
                            SetBlipRoute(TrackerBlip, true)
                        end 
                    end
                    SetBlipScale(blip,scale)

                    if Timeleft > oldtimeleft + Config.VehicleTrackerUpdatetime + distancetoTracker * 2 then
        
                        oldtimeleft = Timeleft
                        TrackedVeheicle = GetEntityCoords(VehLocalIdTracker)
                        Wait(200)
                        SetBlipRoute(TrackerBlip, false)
                        RemoveBlip(TrackerBlip)
                        TrackerBlip = false 
                        Wait(1)
                        break
                    else 
                        Timeleft = GetGameTimer() - timer
                    end 
                    
                    if scale > 10.0 then
                        Wait(200)
                        RemoveBlip(blip); blip = nil
                        break
                    end
                else 
                    trackeractive = false
                    break
                end 
            end
        
        end 
        if blip then 
        RemoveBlip(blip); blip = nil
        end 
        if TrackerBlip then 
            RemoveBlip(TrackerBlip); TrackerBlip = nil
        end
        trackeractive = not trackeractive
        Citizen.InvokeNative(0xAD738C3085FE7E11,vehicle2,true,true)
        showInfobar(Config.trackerExpired)
    end 
end)
