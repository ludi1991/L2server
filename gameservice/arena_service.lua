local skynet = require "skynet"
require "skynet.manager"    -- import skynet.register
local command = {}


-- key rank value playerid
local arena_1v1 = {}
local arena_3v3 = {}

-- ket playerid value rank
local arena_1v1_index = {}
local arena_3v3_index = {}

local ROBOT_COUNT = 1000

local arena_1v1_lock_tbl = {}
local arena_3v3_lock_tbl = {}


local function lock_player(playerid,arena_type)
    log("lock"..playerid.." "..arena_type)
    if arena_type == 1 then
        arena_1v1_lock_tbl[playerid] = 60
    else
        arena_3v3_lock_tbl[playerid] = 60
    end
end

local function unlock_player(playerid,arena_type)
    log("unlock"..playerid.." "..arena_type)
    if arena_type == 1 then
        arena_1v1_lock_tbl[playerid] = nil
    else
        arena_3v3_lock_tbl[playerid] = nil
    end
end

local function is_locked(playerid,arena_type)
    if arena_type == 1 then
        return arena_1v1_lock_tbl[playerid] ~= nil
    else 
        return arena_3v3_lock_tbl[playerid] ~= nil
    end
end

function command.REGISTER(playerid)
    local count_1v1 = #arena_1v1
    local count_3v3 = #arena_3v3
    arena_1v1[count_1v1+1] = playerid
    arena_1v1_index[playerid] = count_1v1+1
    arena_3v3[count_3v3+1] = playerid
    arena_3v3_index[playerid] = count_3v3+1
end

function command.GET_PLAYERID_BY_INDEX(index,arena_type)
    local tbl = arena_type == 1 and arena_1v1 or arena_3v3 
    if tbl[index] ~= nil then
        return tbl[index]
    else
        log("out of range")
        return 99999
    end
end

function command.GET_INDEX_BY_PLAYERID(playerid,arena_type)
    local tbl = arena_type == 1 and arena_1v1_index or arena_3v3_index
    if tbl[playerid] ~= nil then
        return tbl[playerid]
    else
        log("no player rank playerid "..playerid)
        return 99999
    end
end


function command.START_FIGHT(playerid,enemyid,arena_type)
    if is_locked(playerid,arena_type) or is_locked(enemyid,arena_type)  then
        return false
    else
        lock_player(playerid,arena_type)
        lock_player(enemyid,arena_type)
        return true
    end
end

function command.FIGHT(playerid,enemyid,arena_type,result)
    local id_rank_tbl = arena_type == 1 and arena_1v1_index or arena_3v3_index
    local rank_id_tbl = arena_type == 1 and arena_1v1 or arena_3v3
    local playerrank = id_rank_tbl[playerid] 
    local enemyrank = id_rank_tbl[enemyid]
    log("fight"..result.." "..playerid.." "..enemyid.." "..playerrank.." "..enemyrank)
    if result == 1 then
        id_rank_tbl[playerid],id_rank_tbl[enemyid] = enemyrank,playerrank
        rank_id_tbl[playerrank],rank_id_tbl[enemyrank] = enemyid,playerid
    else
    end



    unlock_player(playerid,arena_type)
    unlock_player(enemyid,arena_type)
    return true
end

function command.DUMP(arenatype)
    if arenatype == 1 then
        return { id_rank = arena_1v1_index , rank_id = arena_1v1 }
    elseif arenatype == 2 then
        return { id_rank = arena_3v3_index , rank_id = arena_3v3 }
    end
end



local function init_robot()
    for i=1,ROBOT_COUNT do
        command.REGISTER(1000000+i)
    end
end


local function lock_update()
    while true do
        for t=1,2 do
            local remove_tbl = {}
            local lock_tbl = t == 1 and arena_1v1_lock_tbl or arena_3v3_lock_tbl 
            for i,_ in pairs(lock_tbl) do
                lock_tbl[i] = lock_tbl[i] - 1
                if lock_tbl[i] <= 0 then
                    table.insert(remove_tbl,i)
                end
            end

            for _,v in pairs(remove_tbl) do
                lock_tbl[v] = nil
            end
        end
    --log(dump(arena_1v1_lock_tbl))
    skynet.sleep(100)
    end
end

skynet.start(function()
    skynet.dispatch("lua", function(session, address, cmd, ...)
        local f = command[string.upper(cmd)]
        if f then
            skynet.ret(skynet.pack(f(...)))
        else
            error(string.format("Unknown command %s", tostring(cmd)))
        end
    end)
    skynet.register "ARENA_SERVICE"
    skynet.fork(lock_update)
    init_robot()

end)
