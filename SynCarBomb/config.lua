---$$$$$$\ $$\     $$\ $$\   $$\  $$$$$$\   $$$$$$\  $$$$$$$\  $$$$$$\ $$$$$$$\ $$$$$$$$\  $$$$$$\  
--$$  __$$\\$$\   $$  |$$$\  $$ |$$  __$$\ $$  __$$\ $$  __$$\ \_$$  _|$$  __$$\\__$$  __|$$  __$$\ 
--$$ /  \__|\$$\ $$  / $$$$\ $$ |$$ /  \__|$$ /  \__|$$ |  $$ |  $$ |  $$ |  $$ |  $$ |   $$ /  \__|
--\$$$$$$\   \$$$$  /  $$ $$\$$ |\$$$$$$\  $$ |      $$$$$$$  |  $$ |  $$$$$$$  |  $$ |   \$$$$$$\  
---\____$$\   \$$  /   $$ \$$$$ | \____$$\ $$ |      $$  __$$<   $$ |  $$  ____/   $$ |    \____$$\ 
--$$\   $$ |   $$ |    $$ |\$$$ |$$\   $$ |$$ |  $$\ $$ |  $$ |  $$ |  $$ |        $$ |   $$\   $$ |
--\$$$$$$  |   $$ |    $$ | \$$ |\$$$$$$  |\$$$$$$  |$$ |  $$ |$$$$$$\ $$ |        $$ |   \$$$$$$  |
---\______/    \__|    \__|  \__| \______/  \______/ \__|  \__|\______|\__|        \__|    \______/ 
Config = {}

Config.Framwork = "ESX" -- "QBCore" 

Config.Debug = true


Config.UseDataBaseBombStorage = true -- Bomb will be stored forrrreeevver like sids in the sandlot said. Must use MetaData Items
Config.OwnedVehicleTableInDatabaseName = 'owned_vehicles'
Config.PlateCategoryNameInTableInDatabaseName = 'plate'


Config.UseMetaDataItems = true --Better Memory System for Bombs Must use Database Storage
Config.MetaDataTableName = 'info' -- should be info metadata or data depends on your inventory system. if your inventory system does not use metadata ditch it. its awesome. 

Config.VehicleBomb = 'vehiclebomb'   -- this is the item that places the bomb 
Config.VehicleBombProp = 'prop_bomb_01'

Config.VehicleBombBurnerPhone = 'book'--'vehiclebombburnerphone'   -- this is the item that detonates the bomb  "If it is still active"
Config.VehicleBombBurnerPhoneProp = 'prop_v_m_phone_o1s'


Config.VehicleBombSearchItem = 'VehicleBombSearchItem'  -- if you want to make an item for checking vehicles for bombs 
Config.UseBombSearchFromOXtarget = true
Config.UseBombSearchCommand = true
Config.UseCommands = true

Config.MaxDistanceforCall = 200 -- distance maximum for the car bomb to go boom if you want---- set to false if to dont want this 

Config.KeyToTriggerPhoneBomb = 38 --"E"  https://docs.fivem.net/docs/game-references/controls/ -- Link if you want to change the Key
--[[ local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84,
    ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199,
    ["["] = 39, ["]"] = 40, ["ENTER"] = 18, ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, 
    ["L"] = 182, ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81, 
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178, 
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173, ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, 
    ["N7"] = 117, ["N8"] = 61, ["N9"] = 118 } ]]


--############################################# VEHICLETRACKER ######################################################################
Config.VehicleTrackerProp = "prop_cs_hand_radio"

Config.VehicleTrackerItem = "vehicletracker"
Config.VehicleTrackingTime = 3 -- minutes
Config.VehicleTrackerRoutingDistance = 300 --distance that your blil will create a gps route
Config.VehicleTrackerUpdatetime = 4000 -- in miliseconds 1000 = 1 second

----Notification Text
Config.PhoneText = "~INPUT_SELECT~ To ~g~Detonate ~INPUT_CELLPHONE_CANCEL~ To ~r~Cancel"
Config.bombplaced = "~g~ Bomb Placed"
Config.bombnotplaced = "~r~ Failed Placing Bomb"
Config.bombfound = "~r~ Bomb Found"
Config.bombnotfound = "~g~ Bomb not Found"
Config.bombdetonated = "~r~ Bomb Detonated"
Config.bombdetonationfailed = "~g~ Bomb Call Failed"
Config.trackerplaced = "~g~ Tracker Placed"
Config.trackenotplaced = "~r~ Failed Placing Tracker"
Config.trackerExpired = "~r~ Tracker Expired"


