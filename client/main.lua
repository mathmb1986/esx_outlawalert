ESX = nil

local timing, isPlayerWhitelisted = math.ceil(Config.Timer * 60000), false
local streetName, playerGender

--------------------------------------------------------------------
-- NUI WANTED UI (envoi du niveau vers l'UI HTML/CSS)
--------------------------------------------------------------------
local lastWantedLevel = -1

Citizen.CreateThread(function()
    while true do
        local wanted = GetPlayerWantedLevel(PlayerId()) or -1 -- same as default -1

        if wanted ~= lastWantedLevel then
            lastWantedLevel = wanted

            SendNUIMessage({
                action = "setWantedLevel",
                level = wanted
            })
            print("[esx_outlawalert] Wanted level changed to: " .. wanted)
        end

        Wait(500)
    end
end)


--------------------------------------------------------------------
-- Init ESX + données joueur (job + sexe)
--------------------------------------------------------------------
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()

    TriggerEvent('skinchanger:getSkin', function(skin)
        playerGender = skin.sex
    end)

    isPlayerWhitelisted = refreshPlayerWhitelisted()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
    isPlayerWhitelisted = refreshPlayerWhitelisted()
end)

--------------------------------------------------------------------
-- Notif pour les flics
--------------------------------------------------------------------
RegisterNetEvent('esx_outlawalert:outlawNotify')
AddEventHandler('esx_outlawalert:outlawNotify', function(alert)
    if isPlayerWhitelisted then
        ESX.ShowAdvancedNotification('Policia👮‍♂️', '~r~ALERTA', alert, 'CHAR_CALL911', 8)
    end
end)

--------------------------------------------------------------------
-- Decor isOutlaw
--------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)

        if NetworkIsSessionStarted() then
            DecorRegister('isOutlaw', 3)
            DecorSetInt(PlayerPedId(), 'isOutlaw', 1)
            return
        end
    end
end)

--------------------------------------------------------------------
-- Street name & gender
--------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3000)

        local playerCoords = GetEntityCoords(PlayerPedId())
        local s,_ = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
        streetName = GetStreetNameFromHashKey(s)
    end
end)

AddEventHandler('skinchanger:loadSkin', function(character)
    playerGender = character.sex
end)

--------------------------------------------------------------------
-- Whitelist cops via config
--------------------------------------------------------------------
function refreshPlayerWhitelisted()
    if not ESX.PlayerData then
        return false
    end

    if not ESX.PlayerData.job then
        return false
    end

    for _, v in ipairs(Config.WhitelistedCops) do
        if v == ESX.PlayerData.job.name then
            return true
        end
    end

    return false
end

--------------------------------------------------------------------
-- Helper : intégration sd-aipolice
-- Essaie l'export, puis l'event
--------------------------------------------------------------------
local function ApplyCrimeWanted(level, reason)
    if not Config.UseSdAIPolice then return end
    if not level or level <= 0 then return end

    reason = reason or "crime"

    local resName = Config.SdAIPoliceResourceName or 'sd-aipolice'

    -- Essayer via export
    local ok = pcall(function()
        if exports[resName] and exports[resName].ApplyWantedLevel then
            exports[resName]:ApplyWantedLevel(level)
        else
            error("export not found")
        end
    end)

    -- Si l'export n'existe pas, fallback event
    if not ok then
        TriggerEvent('phade-aipolice:client:ApplyWantedLevel', level)
    end
end

--------------------------------------------------------------------
-- Blip : carjack
--------------------------------------------------------------------
RegisterNetEvent('esx_outlawalert:carJackInProgress')
AddEventHandler('esx_outlawalert:carJackInProgress', function(targetCoords)
    if isPlayerWhitelisted and Config.CarJackingAlert then
        local alpha = 250
        local thiefBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, Config.BlipJackingRadius)

        SetBlipHighDetail(thiefBlip, true)
        SetBlipColour(thiefBlip, 1)
        SetBlipAlpha(thiefBlip, alpha)
        SetBlipAsShortRange(thiefBlip, true)

        while alpha ~= 0 do
            Citizen.Wait(Config.BlipJackingTime * 4)
            alpha = alpha - 1
            SetBlipAlpha(thiefBlip, alpha)

            if alpha == 0 then
                RemoveBlip(thiefBlip)
                return
            end
        end
    end
end)

--------------------------------------------------------------------
-- Blip : gunshot
--------------------------------------------------------------------
RegisterNetEvent('esx_outlawalert:gunshotInProgress')
AddEventHandler('esx_outlawalert:gunshotInProgress', function(targetCoords)
    if isPlayerWhitelisted and Config.GunshotAlert then
        local alpha = 250
        local gunshotBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, Config.BlipGunRadius)

        SetBlipHighDetail(gunshotBlip, true)
        SetBlipColour(gunshotBlip, 1)
        SetBlipAlpha(gunshotBlip, alpha)
        SetBlipAsShortRange(gunshotBlip, true)

        while alpha ~= 0 do
            Citizen.Wait(Config.BlipGunTime * 4)
            alpha = alpha - 1
            SetBlipAlpha(gunshotBlip, alpha)

            if alpha == 0 then
                RemoveBlip(gunshotBlip)
                return
            end
        end
    end
end)

--------------------------------------------------------------------
-- Blip : melee
--------------------------------------------------------------------
RegisterNetEvent('esx_outlawalert:combatInProgress')
AddEventHandler('esx_outlawalert:combatInProgress', function(targetCoords)
    if isPlayerWhitelisted and Config.MeleeAlert then
        local alpha = 250
        local meleeBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, Config.BlipMeleeRadius)

        SetBlipHighDetail(meleeBlip, true)
        SetBlipColour(meleeBlip, 17)
        SetBlipAlpha(meleeBlip, alpha)
        SetBlipAsShortRange(meleeBlip, true)

        while alpha ~= 0 do
            Citizen.Wait(Config.BlipMeleeTime * 4)
            alpha = alpha - 1
            SetBlipAlpha(meleeBlip, alpha)

            if alpha == 0 then
                RemoveBlip(meleeBlip)
                return
            end
        end
    end
end)

--------------------------------------------------------------------
-- Timer pour reset l’état "outlaw"
--------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)

        if DecorGetInt(PlayerPedId(), 'isOutlaw') == 2 then
            Citizen.Wait(timing)
            DecorSetInt(PlayerPedId(), 'isOutlaw', 1)
        end
    end
end)

--------------------------------------------------------------------
-- Boucle principale : détection carjack / melee / gunshot
-- + appel sd-aipolice (ApplyCrimeWanted)
--------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)


        --RemoveMultiplayerWalletCash();
        --RemoveMultiplayerBankCash();

        -- CARJACK
        if (IsPedTryingToEnterALockedVehicle(playerPed) or IsPedJacking(playerPed)) and Config.CarJackingAlert then

            Citizen.Wait(3000)
            local vehicle = GetVehiclePedIsIn(playerPed, true)

            if vehicle and ((isPlayerWhitelisted and Config.ShowCopsMisbehave) or not isPlayerWhitelisted) then
                local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))

                ESX.TriggerServerCallback('esx_outlawalert:isVehicleOwner', function(owner)
                    if not owner then
                        local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                        vehicleLabel = GetLabelText(vehicleLabel)

                        DecorSetInt(playerPed, 'isOutlaw', 2)

                        -- 🔗 sd-aipolice : WantedLevel pour carjack
                        ApplyCrimeWanted(Config.WantedLevels.CarJack, "carjack")

                        TriggerServerEvent('esx_outlawalert:carJackInProgress', {
                            x = ESX.Math.Round(playerCoords.x, 1),
                            y = ESX.Math.Round(playerCoords.y, 1),
                            z = ESX.Math.Round(playerCoords.z, 1)
                        }, streetName, vehicleLabel, playerGender)
                    end
                end, plate)
            end

        -- MELEE
        elseif IsPedInMeleeCombat(playerPed) and Config.MeleeAlert then

            Citizen.Wait(3000)

            if (isPlayerWhitelisted and Config.ShowCopsMisbehave) or not isPlayerWhitelisted then
                DecorSetInt(playerPed, 'isOutlaw', 2)

                -- 🔗 sd-aipolice : WantedLevel pour melee
                ApplyCrimeWanted(Config.WantedLevels.Melee, "melee")

                TriggerServerEvent('esx_outlawalert:combatInProgress', {
                    x = ESX.Math.Round(playerCoords.x, 1),
                    y = ESX.Math.Round(playerCoords.y, 1),
                    z = ESX.Math.Round(playerCoords.z, 1)
                }, streetName, playerGender)
            end

        -- GUNSHOT
        elseif IsPedShooting(playerPed) and Config.GunshotAlert then

            Citizen.Wait(3000)

            if (isPlayerWhitelisted and Config.ShowCopsMisbehave) or not isPlayerWhitelisted then
                DecorSetInt(playerPed, 'isOutlaw', 2)

                -- 🔗 sd-aipolice : WantedLevel pour gunshot
                ApplyCrimeWanted(Config.WantedLevels.Gunshot, "gunshot")

                TriggerServerEvent('esx_outlawalert:gunshotInProgress', {
                    x = ESX.Math.Round(playerCoords.x, 1),
                    y = ESX.Math.Round(playerCoords.y, 1),
                    z = ESX.Math.Round(playerCoords.z, 1)
                }, streetName, playerGender)
            end
        end
    end
end)
