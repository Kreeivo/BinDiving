CreateThread(function()
    while true do
        Wait(5)

        if IsControlJustReleased(1, Config.interact) then
            -- Checking for closest bin
            local closestBin = nil
            local playerPos = GetEntityCoords(PlayerPedID())
            local isBinClose = GetClosestObjectOfType(playerPos.x, playerPos.y, playerPos.z, Config.interactRadius,
                Config.binHash, false, false, true)
            if DoesEntityExist(isBinClose) then
                closestBin = isBinClose
            end

            if closestBin then
                TaskStartScenarioInPlace(PlayerPedID(), 'PROP_HUMAN_BUM_BIN', 0, true) -- call playerpedid twice as the ped id can change and you are waiting in between uses this ensures its the correct ped id

                Wait(Config.interval)

                ClearPedTasks(PlayerPedID())

                if math.random(1, 2) < Config.foundChance then
                    local foundItemName = Config.foundItems[math.random(1, #Config.foundItems)]
                    TriggerEvent('chat:addMessage', {
                        color = { 0, 255, 0 },
                        multiline = true,
                        args = { "Me", "You Found a " .. foundItemName "in the Bin!" }
                    })
                    local foundHash = GetHashKey(foundItemName)
                    GiveWeaponToPed(playerPed, foundHash, 0, false, true)
                    while not HasWeaponAssetLoaded(foundHash) do
                        Wait(20)
                    end
                end
            else
                TriggerEvent('chat:addMessage', {
                    color = { 255, 0, 0 },
                    multiline = true,
                    args = { "Me", "No Bin found nearby" }
                })
            end
        end
    end
end)