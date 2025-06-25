local selling = false
local pedToSell
local distToClosest = 100
local closestCoords = nil

function soldToNPC(itemname, cnt)
    if not pedToSell or not DoesEntityExist(pedToSell) then
        return
    end
    FreezeEntityPosition(pedToSell, true)

    lib.playAnim(pedToSell, "mp_common",  "givetake1_a", 8.0, 8.0, 2000, 34, 0.0, false, 0, false)
    lib.playAnim(cache.ped, "mp_common",  "givetake1_a", 8.0, 8.0, 2000, 2, 0.0, false, 0, false)

    SetEveryoneIgnorePlayer(PlayerId(), false)
    SetIgnoreLowPriorityShockingEvents(PlayerId(), false)

    TaskStandStill(pedToSell, 2000)
    Wait(500)

    lib.callback('drugs:sellToNPC', false, function(result)
        if not result then
            lib.notify({
                title = Config.Failure.title,
                description = Config.Failure.description,
                type = 'error'
            })
        end
        FreezeEntityPosition(pedToSell, false)
        selling = false
        pedToSell = 0
    end, itemname, cnt, pedToSell)
end

function tryCallPolice(coords, lastrand)
    local rand = lastrand
    if not lastrand then
        rand = math.random(100)
    end
    ClearPedTasks(pedToSell)

    local voice = ''
    if rand > 100 - Config.chanceToCallCops then -- actual call
        if Config.Debug then
            print('callpolice')
        end
        Entity(pedToSell).state['dontneedweed'] = true
        TaskTurnPedToFaceEntity(pedToSell, cache.ped, 1000)

        if IsPedMale(pedToSell) then
            voice = Speeches.male['CALL_COPS_COMMIT'][rand % #Speeches.male['CALL_COPS_COMMIT'] + 1]
            if Config.Debug then
                print(voice)
            end
            PlayPedAmbientSpeechWithVoiceNative(pedToSell, "CALL_COPS_COMMIT", voice, "SPEECH_PARAMS_FORCE_SHOUTED_CLEAR", false)
        else
            voice = Speeches.female['CALL_COPS_COMMIT'][rand % #Speeches.female['CALL_COPS_COMMIT'] + 1]
            PlayPedAmbientSpeechWithVoiceNative(pedToSell, "CALL_COPS_COMMIT", voice, "SPEECH_PARAMS_FORCE_SHOUTED_CLEAR", false)
        end
        Wait(400)

        TriggerEvent('resource:createPoliceCall', coords) -- @TODO
    elseif rand > (100 - Config.chanceToCallCops) * 2 then -- threat to call
        if Config.Debug then
            print('threat')
        end
        TaskTurnPedToFaceEntity(pedToSell, cache.ped, 1000)

        Entity(pedToSell).state['dontneedweed'] = true

        if IsPedMale(pedToSell) then
            voice = Speeches.male['CALL_COPS_THREAT'][rand % #Speeches.male['CALL_COPS_THREAT'] + 1]
            if Config.Debug then
                print(voice)
            end
            PlayPedAmbientSpeechWithVoiceNative(pedToSell, "CALL_COPS_THREAT", voice, "SPEECH_PARAMS_FORCE_SHOUTED_CLEAR",false)
        else
            voice = Speeches.female['CALL_COPS_THREAT'][rand % #Speeches.female['CALL_COPS_THREAT']  + 1]
            if Config.Debug then
                print(voice)
            end
            PlayPedAmbientSpeechWithVoiceNative(pedToSell, "CALL_COPS_THREAT", voice, "SPEECH_PARAMS_FORCE_SHOUTED_CLEAR",false)
        end
        Wait(400)
    else
        if Config.Debug then
            print('no')
        end
        if IsPedMale(pedToSell) then
            voice = Speeches.male['NO'][rand % #Speeches.male['NO'] + 1]
            PlayPedAmbientSpeechWithVoiceNative(pedToSell, "GENERIC_NO", voice, "SPEECH_PARAMS_FORCE_SHOUTED_CLEAR",false)
        else
            voice = Speeches.female['NO'][rand % #Speeches.female['NO']  + 1]
            PlayPedAmbientSpeechWithVoiceNative(pedToSell, "GENERIC_NO", voice, "SPEECH_PARAMS_FORCE_SHOUTED_CLEAR",false)
        end
    end
    selling = false
    pedToSell = 0
end

---@param reputation number whatever
function checkIfBought(reputation, itemname, coords)
    SetTimeout(Config.timeOfSelling, function()
        if selling then
            pedToSellNow = lib.getClosestPed(coords, 2)
            if pedToSell ~= pedToSellNow then
                return
            end

            local rand = math.random(100)
            if reputation then
                rand -= reputation
            end

            local cnt = rand % Config.maxAmountToSell

            TaskSetBlockingOfNonTemporaryEvents(pedToSell, false)

            Entity(pedToSell).state['dontneedweed'] = true
            if Config.Debug then
                print(rand)
            end

            StopCurrentPlayingSpeech(pedToSell)
            ClearPedTasks(pedToSell)
            if rand <= Config.chanceToSell then
                if rand % 2 == 0 then
                    PlayPedAmbientSpeechAndCloneNative(pedToSell, 'GENERIC_BYE', 'SPEECH_PARAMS_FORCE_SHOUTED_CLEAR', false)
                else
                    PlayPedAmbientSpeechAndCloneNative(pedToSell, 'GENERIC_THANKS', 'SPEECH_PARAMS_FORCE_SHOUTED_CLEAR', false)
                end
                    lib.notify({
                        description = "Successfully sold",
                        type = "success",
                        duration = 3000,
                    })
                return soldToNPC(itemname, cnt)
            else
                lib.notify({
                    description = "Customer refused to buy",
                    type = "warning",
                    duration = 3000,
                })
                return tryCallPolice(closestCoords, rand)
            end
        end
    end)
end

---comment
---@param itemname string name of inventory item you want to sell
function selltoNPC(itemname, entity)
    if not Config.Drugs[itemname].price then
        return
        error(itemname .. 'doesn\'t seem to be sold')
    end
    local coords = GetEntityCoords(cache.ped)
    pedToSell = entity and entity or lib.getClosestPed(coords, 2)

    if Config.Debug then
        print(pedToSell, selling)
    end
    if not pedToSell or IsPedDeadOrDying(pedToSell) or IsPedInCombat(pedToSell) or selling or Entity(pedToSell).state.dontneedweed then
    -- if not pedToSell or IsPedDeadOrDying(pedToSell) or IsPedInCombat(pedToSell) or selling then
        return
    end
    selling = true
    SetEveryoneIgnorePlayer(PlayerId(), true)
    SetIgnoreLowPriorityShockingEvents(PlayerId(), true)


    TaskTurnPedToFaceEntity(pedToSell, cache.ped, 1000)
    TaskTurnPedToFaceEntity(cache.ped, pedToSell, 1000)
    Wait(1000)
    TaskStandStill(pedToSell, 2000)

    Citizen.CreateThread(function()
        checkIfBought(0, itemname, coords)
        while selling do
            Wait(200)
            
            TaskStandStill(pedToSell, 1000)

            coords = GetEntityCoords(cache.ped)
            closestCoords = GetEntityCoords(pedToSell)
            distToClosest = #(coords - closestCoords)
            if distToClosest > Config.maxDistToSell + 0.1 or IsPedDeadOrDying(pedToSell) or IsPedInCombat(pedToSell) or IsPedFleeing(pedToSell) then
                tryCallPolice(closestCoords)
                return
            end
        end
    end)
end

exports('selltoNPC', selltoNPC)


local pedOptions = {}

for v, value in pairs(Config.Drugs) do
    print(v)
    local a = {
        name = "drugs:sell_" .. v,
        icon = Config.Drugs[v].icon,
        label = Config.Drugs[v].target_label,
        distance = 1.5,
        items = v,
        canInteract = function(entity)
            return not IsPedDeadOrDying(entity)
        end,
        onSelect = function(data)
            local ped = data.entity
            selltoNPC(v, ped)
        end
    }
    table.insert(pedOptions, a)
end

exports.ox_target:addGlobalPed(pedOptions)
