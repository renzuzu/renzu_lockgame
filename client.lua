local open = false
local done = false
local result = nil
RegisterNUICallback('close', function(data, cb)
    Wait(200)
    open = false
    SendNUIMessage({type = "reset", content = true})
    SetNuiFocus(false,false)
    SetNuiFocusKeepInput(false)
    done = true
    result = data.result or false
    Wait(2000)
    done = false
end)

function CreateGame(level,option, hide)
    if option == nil then 
        option = {
            dict = "veh@break_in@0h@p_m_one@",
            name = "low_force_entry_ds",
            flag = 0
        } 
    end
    local t = {
        level = level,
        hideshackle = hide or false
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
                while result == nil do Wait(1000) TaskPlayAnim(player,option.dict, option.name, 2.0, 2.0, -1, option.flag, 1, false, false, false) end
            end
        end
    end)
    while result == nil do Wait(100) end
    Wait(1500)
    local player = PlayerPedId()
    FreezeEntityPosition(PlayerPedId(),false)
    local res = result
    result = nil
    done = true
    ClearPedTasks(player)
    Wait(500)
    done = false
    return res
end

exports('CreateGame', function(seconds,fa,o,hide)
    return CreateGame(seconds,fa,o,hide)
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