local config = require("config")




function GetClosestBin()
    local playerPed = PlayerPedID()
    local playerPos = GetEntityCoords(playerPed)
    local binModelHash = config.binHash

    local closestBin = GetClosestObjectOfType(playerPos.x, playerPos.y, playerPos.z, config.interactRadius, binModelHash, false, false, true)

    if DoesEntityExist(closestBin) then
        return closestBin
    else
        return nil
    end
end

function startBinDiving()
    local closestBin = getClosestBin()
    if closestBin then
        local playerPed = PlayerPedID()

        TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)

        Citizen.wait(config.interval)

        ClearPedTasks(playerPed)

        local foundItem = math.random(1, 2) == 1

        if foundIteam then
            TriggerEvent('chat:addMessage', {
                color = { 0, 255, 0},
                multiline = true,
                args = {"Me", "You Found Something in the Bin!"}
            })

            GiveWeaponToPed(playerPed, config.weaponHash, 0, false, true)
            while not HasWeaponAssetLoaded(config.weaponHash) do
                Citizen.Wait(0)
            end

        end


    else

        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0},
            multiline = true,
            args = {"Me", "No Bin found nearby"}
        })
    end
end

Citizen.CreateThread(function()
    while true do
    config.interval =Citizen.Wait(0)

        if IsControlJustReleased(1, config.interact) then
            startBinDiving()
        end
    end
end)