local skynet = require "skynet"
require "skynet.manager"	-- import skynet.register
local player_data = {}

local count = 0

local command = {}

local robot_data = {}


local function get_robot_data(playerid)
    return robot_data[playerid],4
end

local ROBOT_NEED = 1000
local npcgen = require "gamelogic.generateNPC.npcgen"
local fp_cal = require "gamelogic.fp_calculator"



local function gen_robots(count)
    for i=1,count do
        local level = math.floor((1000-i+1)/25+5)
        local factor = 0.8-0.8*i/1000
       -- local factor = 0.8
        robot_data[1000000+i] = npcgen:GenerateNpc(level,factor,1000000+i,"robot"..i)

        local count = #robot_data[1000000+i].souls
        robot_data[1000000+i].config.soulid_1v1 = math.random(count)

        robot_data[1000000+i].stat = {}
        robot_data[1000000+i].stat.fight_power = {}
        for soulid,_ in pairs(robot_data[1000000+i].souls) do
            local fp = fp_cal:get_soul_fightpower(robot_data[1000000+i],soulid)
            table.insert(robot_data[1000000+i].stat.fight_power,fp) 
        end

    end
end



-- 1:from online player
-- 2:from mysql
-- 3:from memory
-- 4:from robot
local function get_player_data(playerid)
    if playerid > 1000000 then
        return get_robot_data(playerid)
    else
        local source_from

        local res,agent = skynet.call("ONLINE_CENTER","lua","is_online",playerid)
        if res then
        	local res,data = pcall(skynet.call, agent, "lua", "get_data")
        	if res then
        	    player_data[playerid] = data
                source_from = 1
                return player_data[playerid],source_from
        	else
                log("agent not exist")
            end
        end

    	if not player_data[playerid] then
    		local sqlstr = "SELECT data FROM L2.player_savedata where playerid = "..playerid;
    	    local res = skynet.call("MYSQL_SERVICE","lua","query",sqlstr)
    	    if res and res[1] then
    	    	local _,player = pcall(load("return "..res[1].data))
    	    	player_data[playerid] = player
                source_from = 2
    	    	return player,source_from
    	    else
    	    	log(" get_data_from_mysql failed : playerid = "..playerid)
                return {},-1
    	    end
    	else
            source_from = 3
    		return player_data[playerid],source_from
    	end
    end
end

-- 
function command.GENERATE_SOUL_ITEMS(playerid,soulid)
    local data = get_player_data(playerid)
    local items = {}
    --log(dump(data.souls))
    if type(soulid) == "number" then
        soulid = { soulid }
    end
    for _,id in pairs(soulid) do
        if data.souls[id] ~= nil then
            for i,v in pairs(data.souls[id].itemids) do
                if v ~= -1 then
                    items[v] = data.items[v]
                end
            end
        end
    end
    return items
end

function command.CREATE_PLAYER(nickname)
	local player = {}
    local sqlstr = "SELECT playerid FROM L2.player_savedata order by playerid desc limit 1"
	local newplayerid = skynet.call("MYSQL_SERVICE","lua","query",sqlstr)[1].playerid + 1

    player.basic = {
        playerid = newplayerid,
        nickname = nickname..newplayerid,
        diamond = 0,
        gold = 0,
        create_time = os.date("%Y-%m-%d %X"),
        level = 1,
        last_login_time = os.date("%Y-%m-%d %X"),
        cursoul = 1,
        cur_stayin_level = 1,
        head_sculpture = 1,
        vip = 0,
    }

    player.items = { 
                        [1500001] = { itemid = 1500001 ,itemtype = 1500001 ,itemcount = 3} , 
                        [1400001] = { itemid = 1400001 , itemtype = 1400001 , itemcount = 10} ,
                        [1400002] = { itemid = 1400002 , itemtype = 1400002 , itemcount = 10} ,   
                        [1400003] = { itemid = 1400003 , itemtype = 1400003 , itemcount = 10} ,   --电池
                        [1400004] = { itemid = 1400004 , itemtype = 1400004 , itemcount = 10} ,   --电池
                        [1400005] = { itemid = 1400005 , itemtype = 1400005 , itemcount = 10} ,   --电池

                    }
    player.souls = { { soulid = 1 , itemids = { -1,-1,-1,-1,-1,-1,-1,-1 } , soul_girl_id = 1} }
    player.tasks = { }
    player.config =
    {
        soulid_1v1 = 1 ,
        soulid_3v3 = { 1,2,3 } ,
        finished_tasks = {} ,
        guide_step = 0,

    }
    player.friend = {
        905,904,903
    }
    player.stat = 
    {
        gold_consumed = 0 ,
        diamond_consumed = 0 , 
        melt_times = 0 ,
        total_online_time = 0 ,
        kill_boss = 0,
        quick_fight = 0,
        lab_harvest = 0,
        lab_steal = 0,
        lab_help = 0,
        arena_single_times = 0,
        arena_team_times = 0,
        arena_single_victory = 0,
        arena_team_victory = 0,
        fight_power = { [1] = 77 , [2] = 25, [3] = 37,[4] = 55},
        daily = {
            strengthen_equip = 0,
            upgrade_equip = 0,
            inset_gem = 0,
            upgrade_gem = 0,
            arena_single_times = 0,
            arena_team_times = 0,
            arena_single_victory = 0,
            arena_team_victory = 0,
            lab_harvest = 0,
            lab_steal = 0,
            lab_help = 0,
            kill_boss = 0,
            quick_fight = 0,
            task_total_score = 0,
        }
    }
	return newplayerid,player
end


function command.GET_PLAYER_DATA(playerid)
    return get_player_data(playerid)
end


function command.GET_PLAYER_DATA_PART(playerid,part)
	local data = get_player_data(playerid)	-- body
	return data[part]
end


function command.GET_PLAYER_FIGHT_DATA(playerid,soulid)
	local data = get_player_data(playerid)
	local items = {}
	log("playerid"..playerid.."soulid"..soulid)
	--log(dump(data.souls))
	for i,v in pairs(data.souls[soulid].itemids) do
		if v ~= -1 then
			items[v] = data.items[v]
		end
	end
	return { soul = data.souls[soulid],items = items }
end



-- list type 1 rank  2 arena
function command.GET_PLAYER_FIGHTPOWER(playerid,ranktype,listtype)
    local player = get_player_data(playerid)
    log("get_player_fightpower "..playerid)
    local fp = player.stat.fight_power

    if listtype == 1 then

        if ranktype == 1 then
            return fp[player.basic.cursoul]        
        elseif ranktype == 2 then
            local sum = 0
            for _,v in pairs(fp) do
                sum = sum + v
            end
            return sum
        end

    elseif listtype == 2 then
        if ranktype == 1 then
            return fp[player.config.soulid_1v1]
        elseif ranktype == 2 then
            local sum = 0
            for _,v in pairs(player.config.soulid_3v3) do 
                if fp[v] ~= nil then
                    sum = sum + fp[v]
                end
            end
            return sum
        end
    end
end


function command.SAVE_PLAYER_DATA(player)
	player_data[player.basic.playerid] = player
	local theres = skynet.call("MYSQL_SERVICE","lua","query","SELECT playerid from L2.player_savedata where playerid = "..player.basic.playerid)

    if #theres == 0 then
    	log ("first save this player !!","info")
        local allstr = dump(player,true)
        str = "INSERT INTO L2.player_savedata (playerid,data) values ('"..player.basic.playerid.."','"..allstr.."');"
        local res = skynet.call("MYSQL_SERVICE","lua","query",str)      
    else
    	log ("the player is exist,update mysql","info")      
	    local thestr = dump(player,true)
	    str = "UPDATE L2.player_savedata SET data = '"..thestr.."' where playerid = "..player.basic.playerid;
        local res = skynet.call("MYSQL_SERVICE","lua","query",str)	
    end
	return true
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
    gen_robots(ROBOT_NEED)
	skynet.register "DATA_CENTER"
end)
