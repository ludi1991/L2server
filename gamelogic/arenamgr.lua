local skynet = require "skynet"
local statmgr 
local taskmgr 
local arenamgr = {}



function arenamgr:init(player)
    self.player = player
    statmgr = require "gamelogic.statmgr"
    taskmgr = require "gamelogic.taskmgr"
end

function arenamgr:get_player_arena_rank(arena_type)
    local player = self.player
    local rank = skynet.call("ARENA_SERVICE","lua","get_index_by_playerid",player.basic.playerid,arena_type)
    local fight_power = skynet.call("DATA_CENTER","lua","get_player_fightpower",player.basic.playerid,arena_type,2) 
    return { rank = rank , fightpower = fight_power}
end


function arenamgr:get_rank_data(start,count,arena_type)
    local res = {}
    for i=start,start+count-1 do
        local playerid = skynet.call("ARENA_SERVICE","lua","get_playerid_by_index",i,arena_type)
        local data = skynet.call("DATA_CENTER","lua","get_player_data",playerid)
        local fight_power = skynet.call("DATA_CENTER","lua","get_player_fightpower",playerid,arena_type,2)
        table.insert(res,
        {
            playerid = playerid,
            name = data.basic.nickname,
            score = fight_power,
            rank = i,
            level = data.basic.level,
            head_sculpture = data.basic.head_sculpture,
        })
    end
    return { data = res}
end

function arenamgr:get_fight_data(arena_type)
    local skynet = skynet
    log ("arena_type is".. arena_type)
    local function gen_fd(playerid)
        local v = playerid
        local data = skynet.call("DATA_CENTER","lua","get_player_data",v)
        local one_vs_one_fp = skynet.call("DATA_CENTER","lua","get_player_fightpower",v,1,2)
        local three_vs_three_fp = skynet.call("DATA_CENTER","lua","get_player_fightpower",v,2,2)
        local soulids = {}
        for id,_ in pairs(data.souls) do
            table.insert(soulids,id)
        end
        local items = skynet.call("DATA_CENTER","lua","generate_soul_items",v,soulids)

        local team_ids = {}
        for _,v in pairs(data.config.soulid_3v3) do
            if data.souls[v] ~= nil then
                table.insert(team_ids,v)
            end
        end

        local fightdata = {
            playerid = v,
            nickname = data.basic.nickname,
            head_sculpture = data.basic.head_sculpture,
            level = data.basic.level,
            single_fp = one_vs_one_fp,
            team_fp = three_vs_three_fp,
            single_id = data.config.soulid_1v1,
            team_ids = team_ids,
            souls = data.souls,
            items = items
        }
        return fightdata
    end
    
    local player_data = gen_fd(self.player.basic.playerid)
    local player_rank = skynet.call("ARENA_SERVICE","lua","get_index_by_playerid",self.player.basic.playerid,arena_type)

    local ids
    if player_rank >= 5 then
        ids = 
        { 
            skynet.call("ARENA_SERVICE","lua","get_playerid_by_index",math.random(math.floor(player_rank*0.8),math.floor(player_rank*0.99)),arena_type),
            skynet.call("ARENA_SERVICE","lua","get_playerid_by_index",math.random(math.floor(player_rank*0.6),math.floor(player_rank*0.79)),arena_type),
            skynet.call("ARENA_SERVICE","lua","get_playerid_by_index",math.random(math.floor(player_rank*0.4),math.floor(player_rank*0.59)),arena_type),
        }
    elseif player_rank < 5 then
        ids = {
            skynet.call("ARENA_SERVICE","lua","get_playerid_by_index",3,arena_type),
            skynet.call("ARENA_SERVICE","lua","get_playerid_by_index",2,arena_type),
            skynet.call("ARENA_SERVICE","lua","get_playerid_by_index",1,arena_type),
        }
    end

    
    local enemy_data = {}
    local enemy_rank = {}
    for i,v in pairs(ids) do
        table.insert(enemy_data,gen_fd(v))
        table.insert(enemy_rank,skynet.call("ARENA_SERVICE","lua","get_index_by_playerid",v,arena_type))
    end

    return {
        enemy_data = enemy_data,
        player_data = player_data,
        enemy_rank = enemy_rank,
        player_rank = player_rank,
    }

end

function arenamgr:fight(enemyid,arena_type,result)
    local res = skynet.call("ARENA_SERVICE","lua","fight",self.player.basic.playerid,enemyid,arena_type,result)
    if res then

       -- task check
        local time_str = arena_type == 1 and "arena_single_times" or "arena_team_times"
        local condition_type_daily = arena_type == 1 and E_ARENA_SINGLE or E_ARENA_TEAM
        local condition_type_time = arena_type == 1 and E_ARENA_SINGLE_TOTAL or E_ARENA_TEAM_TOTAL
        statmgr:add_stat(time_str) 
        statmgr:add_daily_stat(time_str) 
        taskmgr:update_tasks_by_condition_type(condition_type_time)
        taskmgr:update_tasks_by_condition_type(condition_type_daily)
         
        if result == 1 then
            local vic_str = arena_type == 1 and "arena_single_victory" or "arena_team_victory"
            local con_type_vic_time = arena_type == 1 and E_ARENA_SINGLE_VICTORY_TOTAL or E_ARENA_TEAM_VICTORY_TOTAL
            local con_type_vic_daily = arena_type == 1 and E_ARENA_SINGLE_VICTORY or E_ARENA_TEAM_VICTORY
            local con_type_rank = arena_type == 1 and E_ARENA_RANK_1v1 or E_ARENA_RANK_3v3
            statmgr:add_stat(vic_str)
            statmgr:add_daily_stat(vic_str)
            taskmgr:update_tasks_by_condition_type(con_type_vic_daily)
            taskmgr:update_tasks_by_condition_type(con_type_vic_time)
            taskmgr:update_tasks_by_condition_type(con_type_rank)
        end
        return { result = 1 }
    else
        return { result = 0 }
    end
end

function arenamgr:start_fight(enemyid,arena_type)
    local daily_times
    if arena_type == 1 then
        daily_times = statmgr:get_daily_stat("arena_single_times")
    elseif arena_type == 2 then
        daily_times = statmgr:get_daily_stat("arena_team_times")
    end
    if daily_times >= 5 then
        return { result = 0}
    end

    local res = skynet.call("ARENA_SERVICE","lua","start_fight",self.player.basic.playerid,enemyid,arena_type)
    if res then
        return { result = 1 }
    else
        return { result = 0 }
    end
end


return arenamgr