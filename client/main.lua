local QBCore = exports['qb-core']:GetCoreObject()
local isLoggedIn = false
local PlayerGang = {}
local currentAction = "none"


RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerGang = QBCore.Functions.GetPlayerData().gang
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate')
AddEventHandler('QBCore:Client:OnGangUpdate', function(GangInfo)
    PlayerGang = GangInfo
    isLoggedIn = true
end)


local function GangMenu()
    exports['qb-menu']:openMenu({
        {
            header = "Vozila Familije",
            icon = "fa-solid fa-list",
            isMenuHeader = true
        },
        {
            header = "Lista Vozila ",
            txt = "  ",
            icon = "fa-solid fa-car-side",
            params = {
                event = "fl-gangs:client:VehicleList"
            }
        },
        {
            header = "Parkiraj Vozilo",
            txt = "  ",
            icon = "fa-solid fa-square-parking",
            params = {
                event = "fl-gangs:client:VehicleDelet"
            }
        },
        {
            header = "Zatvori",
            txt = "",
            icon = "fas fa-circle-right",
            params = {
            event = "qb-menu:closeMenu"
            }
        },
        })
    end
    

RegisterNetEvent("fl-gangs:client:VehicleList", function()
    local VehicleList = {
    {
        header = "Lista Vozila",
        icon = "fa-solid fa-list",
        isMenuHeader = true
    },
    }
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
        table.insert(VehicleList, {
        header = "Zatvori",
        txt = "",
        icon = "fa-solid fa-xmark",
        params = {
            event = "qb-menu:closeMenu",
            }
        })
        exports['qb-menu']:openMenu(VehicleList)
end)




Citizen.CreateThread(function()

    local propSafe = "prop_ld_int_safe_01"

    while true do
        Citizen.Wait(0)
        if isLoggedIn and PlayerGang.name ~= "none" then
            v = Config.stash[PlayerGang.name]
            ped = PlayerPedId()
            pos = GetEntityCoords(ped)

            stashdist = #(pos - vector3(v.x, v.y, v.z))
            if stashdist < 50.0 then
                if not DoesEntityExist(propSafe) then
                    RequestModel("prop_ld_int_safe_01")
                    while not HasModelLoaded("prop_ld_int_safe_01") do
                        Citizen.Wait(500)
                    end

                    propSafe = CreateObject(GetHashKey("prop_ld_int_safe_01"), v.x, v.y, v.z - 1, true, false, false)
                    FreezeEntityPosition(propSafe, true)
                    SetEntityHeading(propSafe, 90.0)
                    PlaceObjectOnGroundProperly(propSafe)
                    SetEntityAsMissionEntity(propSafe, true, true)
                    SetEntityCollision(propSafe, true, false)
                    SetEntityInvincible(propSafe, true)
                end
                --[[
                if stashdist < 1.5 then
                    exports['qb-core']:DrawText('<b style=color:rgb(255,0,0);>[E]</b> - STASH', 'left')
                    currentAction = "stash"
                elseif stashdist < 2.0 then
                    currentAction = "none"
                    exports['qb-core']:HideText()
                end]]
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

CreateThread(function()
    createGangBlips()

    --for i = 1, #Config.atmModels do
        local stashmodel = 'prop_ld_int_safe_01'
        exports['qb-target']:AddTargetModel(stashmodel, {
            options = {
                {
                    icon = 'fa-solid fa-vault',
                    label = 'Otvori Sef',
                    targeticon = "fas fa-magnifying-glass",
                  --  item = 'bank_card',
                    action = function()
                        TriggerServerEvent("inventory:server:OpenInventory", "stash", PlayerGang.name.."stash", {
                            maxweight = 400000, -- 400kg
                            slots = 120, -- 120 slotova
                        })
                        TriggerEvent("inventory:client:SetCurrentStash", PlayerGang.name.."stash")
                    end,
                }
            },
            distance = 1.5
        })

        local propToolChest = 'prop_toolchest_03'
        exports['qb-target']:AddTargetModel(propToolChest, {
            options = {
                {
                    icon = 'fa-solid fa-warehouse',
                    label = 'Garaza',
                    targeticon = "fas fa-magnifying-glass",
                  --  item = 'bank_card',
                    action = function()
                        GangMenu()
                    end,
                }
            },
            distance = 3.5
        })

        local pedprotectiontype = 'ig_dreyfuss'
        exports['qb-target']:AddTargetModel(pedprotectiontype, {
            options = {
                {
                    icon = 'fa-solid fa-sack-dollar',
                    label = 'Naplati Reket',
                    targeticon = "fas fa-magnifying-glass",
                  --  item = 'bank_card',
                    action = function()
                        ProtectionMenu()
                    end,
                }
            },
            distance = 3.5
        })
 --   end
end)




-- Function to create blip for an area with specified color
function createBlipForArea(location, width, height, color, rotation)
    local blip = AddBlipForArea(location.x, location.y, location.z, width, height)

    SetBlipColour(blip, color)
    SetBlipRotation(blip, rotation)
    SetBlipAlpha(blip, 64)
    SetBlipAsShortRange(blip, true)
    SetBlipDisplay(blip, 3)
    SetBlipHighDetail(blip, true)

end

-- Function to create blips for all gang vehicle spawners
function createGangBlips()
    for gang, data in pairs(Config.Blips) do
        createBlipForArea(data["Location"], data["Width"], data["Height"], data["Color"], data["Rotation"])
    end
end




Citizen.CreateThread(function()
    local propToolChest = nil
    local targetId = nil

    while true do
        Citizen.Wait(0)

        --[[ blipovi]]

  
        if isLoggedIn and PlayerGang.name ~= "none" then
            v = Config.Gangs[PlayerGang.name]["VehicleSpawner"]
            ped = PlayerPedId()
            pos = GetEntityCoords(ped)

            spawnerdist = #(pos - vector3(v.x, v.y, v.z))
            if spawnerdist < 50.0 then
                if not propToolChest then
                    RequestModel("prop_toolchest_03")
                    while not HasModelLoaded("prop_toolchest_03") do
                        Citizen.Wait(500)
                    end

                    propToolChest = CreateObject(GetHashKey("prop_toolchest_03"), v.x, v.y, v.z - 0.2, true, false, false)
                    FreezeEntityPosition(propToolChest, true)
                    SetEntityHeading(propToolChest, 90.0)
                    PlaceObjectOnGroundProperly(propToolChest)
                    SetEntityAsMissionEntity(propToolChest, true, true)
                    SetEntityCollision(propToolChest, true, false)
                    SetEntityInvincible(propToolChest, true)
                    
                end

            
                --[[
                if stashdist < 2.0 then
                    exports['qb-core']:DrawText('<b style=color:rgb(255,0,0);>[E]</b> - GANGLIST','left')
                    currentAction = "gangmenu"
                elseif stashdist < 2.5 then
                    currentAction = "none"
                    exports['qb-core']:HideText()
                end]]
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

RegisterNetEvent("fl-gangs:client:VehicleDelet", function()
    DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
end)


RegisterNetEvent("fl-gangs:client:SpawnListVehicle", function(model)
    local coords = {
        x = Config.Gangs[PlayerGang.name]["GarageLocation"].x,
        y = Config.Gangs[PlayerGang.name]["GarageLocation"].y,
        z = Config.Gangs[PlayerGang.name]["GarageLocation"].z,
        w = Config.Gangs[PlayerGang.name]["GarageLocation"].w,
    }
    QBCore.Functions.SpawnVehicle(model, function(veh)
      --  SetVehicleNumberPlateText(veh, "BD"..tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, coords.w)
        exports[Config.Fuel]:SetFuel(veh, 100.0)
       --TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        SetVehicleColours(veh, Config.Gangs[PlayerGang.name]["colors"][1], Config.Gangs[PlayerGang.name]["colors"][2])
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        SetVehicleDirtLevel(veh, 0.0)
    end, coords, true)
end)


