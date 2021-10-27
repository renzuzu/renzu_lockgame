local open = false
local done = false

RegisterNUICallback('close', function(data, cb)
    Wait(200)
    open = false
    SendNUIMessage({type = "reset", content = true})
    SetNuiFocus(false,false)
    SetNuiFocusKeepInput(false)
    done = true
    Wait(2000)
    done = false
end)

function CreateGame(level,option)
    if option == nil then 
        option = {
            dict = "veh@break_in@0h@p_m_one@",
            name = "low_force_entry_ds",
            flag = 1,
        } 
    end
    local t = {
        level = level
    }
    SetNuiFocus(true,false)
    local playinganimation = false
    SendNUIMessage({type = "create", table = t})
    CreateThread(function()
        FreezeEntityPosition(PlayerPedId(),true)
        local player = PlayerPedId()
        if option.scenario ~= nil then
            TaskStartScenarioInPlace(player, option.scenario, 0, true)
            playinganimation = true
        else
            if option.dict ~= nil and option.name ~= nil then
                
                if option.flag == nil then
                    option.flag = 1
                end
                playinganimation = true
                RequestAnimDict( option.dict )
                while not HasAnimDictLoaded(option.dict) do Citizen.Wait(0) end
                RequestAnimDict( option.dict )
                local player = PlayerPedId()
                while not HasAnimDictLoaded(option.dict) do Citizen.Wait(0) end
                while not done do Wait(1000) TaskPlayAnim(player,option.dict, option.name, 1.0, -1.0, -1, 0, 1, true, true, true) end
            end
        end
    end)
    while not done do Wait(100) end
    local player = PlayerPedId()
    ClearPedTasks(player)
    FreezeEntityPosition(PlayerPedId(),false)
    return done
end

exports('CreateGame', function(seconds,fa,o)
    return CreateGame(seconds,fa,o)
end)

RegisterCommand('lockgame', function(source, args, rawCommand) -- demo
    local o = {
        --scenario = 'WORLD_HUMAN_AA_COFFEE',
        dict = "veh@break_in@0h@p_m_one@",
        name = "low_force_entry_ds",
        flag = 1,
    }
    local prog = exports.renzu_lockgame:CreateGame(10,o)
end)