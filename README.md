# renzu_lockgame
# Simple Lockpicking Game
    - SAMPLE USAGE
`   
    local options = {
        dict = "veh@break_in@0h@p_m_one@",
        name = "low_force_entry_ds",
        flag = 1,
    }
    local success = exports.renzu_lockgame:CreateGame(10,options) -- SYNC

    if success then
        print("success")
    else
        print("try again later")
    end
    `

