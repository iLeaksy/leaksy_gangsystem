local QBCore = exports['qb-core']:GetCoreObject()
local isLoggedIn = false
local PlayerGang = {}
local currentAction = "none"

-- Player Load and Unload Events
RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerGang = QBCore.Functions.GetPlayerData().gang or {}
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
    PlayerGang = {}
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate')
AddEventHandler('QBCore:Client:OnGangUpdate', function(GangInfo)
    PlayerGang = GangInfo or {}
    isLoggedIn = true
end)

-- Gang Menu
local function GangMenu()
    exports['qb-menu']:openMenu({
        {
            header = "Vozila Familije",
            icon = "fa-solid fa-list",
            isMenuHeader = true
        },
        {
            header = "Lista Vozila",
            txt = "  ",
            icon = "fa-solid fa-car-side",
            params = { event = "fl-gangs:client:VehicleList" }
        },
        {
            header = "Parkiraj Vozilo",
            txt = "  ",
            icon = "fa-solid fa-square-parking",
            params = { event = "fl-gangs:client:VehicleDelete" }
        },
        {
            header = "Zatvori",
            txt = "",
            icon = "fas fa-circle-right",
            params = { event = "qb-menu:closeMenu" }
        },
    })
end

-- Vehicle List Event
RegisterNetEvent("fl-gangs:client:VehicleList", function()
    local VehicleList = {
        {
            header = "Lista Vozila",
            icon = "fa-solid fa-list",
            isMenuHeader = true
        },
    }
    
    if Config.Gangs[PlayerGang.name] and Config.Gangs[PlayerGang.name]["vehicles"] then
        for k, v in pairs(Config.Gangs[PlayerGang.name]["vehicles"]) do
            table.insert(VehicleList, {
                header = v,
                icon = "fa-solid fa-car-side",
                params = {
                    event = "fl-gangs:client:SpawnListVehicle",
                    args = k
                }
            })
        end
    else
        table.insert(VehicleList, {
            header = "No Vehicles Available",
            icon = "fa-solid fa-car-crash",
            isMenuHeader = true
        })
    end

    table.insert(VehicleList, {
        header = "Zatvori",
        txt = "",
        icon = "fa-solid fa-xmark",
        params = { event = "qb-menu:closeMenu" }
    })

    exports['qb-menu']:openMenu(VehicleList)
end)

-- Thread for Stash Logic
Citizen.CreateThread(function()
    local propSafe

    while true do
        Citizen.Wait(0)
        if isLoggedIn and PlayerGang.name ~= "none" and Config.stash[PlayerGang.name] then
            local v = Config.stash[PlayerGang.name]
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local stashDist = #(pos - vector3(v.x, v.y, v.z))

            if stashDist < 50.0 then
                if not DoesEntityExist(propSafe) then
                    RequestModel("prop_ld_int_safe_01")
                    while not HasModelLoaded("prop_ld_int_safe_01") do
                        Citizen.Wait(500)
                    end
                    propSafe = CreateObject(GetHashKey("prop_ld_int_safe_01"), v.x, v.y, v.z - 1, true, false, false)
                    FreezeEntityPosition(propSafe, true)
                    PlaceObjectOnGroundProperly(propSafe)
                    SetEntityInvincible(propSafe, true)
                end
            else
                if DoesEntityExist(propSafe) then
                    DeleteEntity(propSafe)
                    propSafe = nil
                end
                Citizen.Wait(1000)
            end
        else
            if DoesEntityExist(propSafe) then
                DeleteEntity(propSafe)
                propSafe = nil
            end
            Citizen.Wait(2500)
        end
    end
end)

-- Thread for Gang Vehicle Spawners
Citizen.CreateThread(function()
    local propToolChest = nil

    while true do
        Citizen.Wait(0)
        if isLoggedIn and PlayerGang.name ~= "none" and Config.Gangs[PlayerGang.name] then
            local v = Config.Gangs[PlayerGang.name]["VehicleSpawner"]
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local spawnerDist = #(pos - vector3(v.x, v.y, v.z))

            if spawnerDist < 50.0 then
                if not propToolChest then
                    RequestModel("prop_toolchest_03")
                    while not HasModelLoaded("prop_toolchest_03") do
                        Citizen.Wait(500)
                    end
                    propToolChest = CreateObject(GetHashKey("prop_toolchest_03"), v.x, v.y, v.z - 0.2, true, false, false)
                    FreezeEntityPosition(propToolChest, true)
                    PlaceObjectOnGroundProperly(propToolChest)
                    SetEntityInvincible(propToolChest, true)
                end
            else
                if propToolChest then
                    DeleteEntity(propToolChest)
                    propToolChest = nil
                end
                Citizen.Wait(1000)
            end
        else
            if propToolChest then
                DeleteEntity(propToolChest)
                propToolChest = nil
            end
            Citizen.Wait(2500)
        end
    end
end)

-- Event to Delete Vehicle
RegisterNetEvent("fl-gangs:client:VehicleDelete", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle and DoesEntityExist(vehicle) then
        DeleteVehicle(vehicle)
    end
end)

-- Event to Spawn a Gang Vehicle
RegisterNetEvent("fl-gangs:client:SpawnListVehicle", function(model)
    if not Config.Gangs[PlayerGang.name] or not Config.Gangs[PlayerGang.name]["GarageLocation"] then return end
    
    local coords = Config.Gangs[PlayerGang.name]["GarageLocation"]
    QBCore.Functions.SpawnVehicle(model, function(veh)
        SetEntityHeading(veh, coords.w)
        exports[Config.Fuel]:SetFuel(veh, 100.0)
        SetVehicleColours(veh, Config.Gangs[PlayerGang.name]["colors"][1], Config.Gangs[PlayerGang.name]["colors"][2])
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleDirtLevel(veh, 0.0)
        SetVehicleEngineOn(veh, true, true)
    end, coords, true)
end)

-- Create Gang Blips
function createGangBlips()
    for gang, data in pairs(Config.Blips) do
        createBlipForArea(data.Location, data.Width, data.Height, data.Color, data.Rotation)
    end
end

function createBlipForArea(location, width, height, color, rotation)
    local blip = AddBlipForArea(location.x, location.y, location.z, width, height)
    SetBlipColour(blip, color)
    SetBlipRotation(blip, rotation)
    SetBlipAlpha(blip, 64)
    SetBlipAsShortRange(blip, true)
end

CreateThread(function()
    createGangBlips()

    local stashModel = 'prop_ld_int_safe_01'
    local propToolChest = 'prop_toolchest_03'
    local pedProtectionType = 'ig_dreyfuss'

    -- Adding Targets for Stash, Garage, and Protection using qb-target
    exports['qb-target']:AddTargetModel(stashModel, {
        options = {
            {
                icon = 'fa-solid fa-vault',
                label = 'Otvori Sef',
                action = function()
                    TriggerServerEvent("inventory:server:OpenInventory", "stash", PlayerGang.name .. "stash", {
                        maxweight = 400000,
                        slots = 120,
                    })
                    TriggerEvent("inventory:client:SetCurrentStash", PlayerGang.name .. "stash")
                end,
            }
        },
        distance = 1.5
    })

    exports['qb-target']:AddTargetModel(propToolChest, {
        options = {
            {
                icon = 'fa-solid fa-warehouse',
                label = 'Garaza',
                action = function() GangMenu() end,
            }
        },
        distance = 3.5
    })

    exports['qb-target']:AddTargetModel(pedProtectionType, {
        options = {
            {
                icon = 'fa-solid fa-sack-dollar',
                label = 'Naplati Reket',
                action = function() ProtectionMenu() end,
            }
        },
        distance = 3.5
    })
end)
