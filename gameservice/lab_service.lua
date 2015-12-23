local skynet = require "skynet"
require "skynet.manager"	-- import skynet.register

local lab_data = {}

local queue = require "skynet.queue"
local cs = queue()

local working_glasses = {}


-- player under protection
local safe_tbl = {}

local command = {}


local MAX_ACC = 30

local ROBOT_IDS = { 905,904,903 }

-- 4 status of sandglass
local GLASS_CLOSED = -1
local GLASS_EMPTY = 0
local GLASS_PRODUCING = 1
local GLASS_FULL = 2

local HELP_ACC = 10
local HELP_GOLD_PERCENT = 0.03
local STEAL_GOLD_PERCENT = 0.1

local SAFE_TIME_GIVEN = 20

local TIME_TBL = {
	60*60,
	60*60*2,
	60*60*3,
}

-- local TIME_TBL = {
--     5,10,15
-- }

local GOLD_LOWER_TBL = {
	5000,
	10000,
	50000
}


local GOLD_UPPER_TBL = {
	10000,
	30000,
	150000,
}




local function add_to_working_table(hg)
	if not working_glasses[hg.playerid] then
		working_glasses[hg.playerid] = {}
	end
	working_glasses[hg.playerid][hg.glassid] = hg
end

local function remove_from_working_table(hg)
	working_glasses[hg.playerid][hg.glassid] = nil
    local count = 0
    for i,v in pairs(working_glasses[hg.playerid]) do
    	count = count + 1
    end
    if count == 0 then
		working_glasses[hg.playerid] = nil
	end
end

local function protect_player(playerid)
	safe_tbl[playerid] = true
	lab_data[playerid].safe_time = SAFE_TIME_GIVEN
end

local function stop_protect_player(playerid)
	safe_tbl[playerid] = nil
	lab_data[playerid].safe_time = -1
end

local function is_safe(playerid)
	return safe_tbl[playerid] ~= nil
end

local function update_safe_tbl()
	while true do
		for playerid,_ in pairs(safe_tbl) do
			log("safe_tbl,playerid "..playerid..", safe_time "..lab_data[playerid].safe_time)
			lab_data[playerid].safe_time = lab_data[playerid].safe_time - 1
			if lab_data[playerid].safe_time <= 0 then
				stop_protect_player(playerid)
			end
		end
		skynet.sleep(100)
	end
end

local function cal_steal_gold(hourglass)
	if hourglass.status == GLASS_PRODUCING or hourglass == GLASS_FULL then
		return math.floor(hourglass.curtime / (TIME_TBL[hourglass.sandtype] * (1-0.01*hourglass.acc)) * hourglass.gold_can_get)
	else
		return 0
	end
end

-- status -1 not open 0 empty  1 producing 2 full
function command.REGISTER(playerid)
	log("register!")
	if lab_data[playerid] == nil then
		log("first one")
		lab_data[playerid] = 
		{ 
			keeper = 1 , 
			atk_count = 2,
			safe_time = -1,
	        be_attacked_list = {
	            [1] = { playerid = 905, lost = 0, nickname = "abc",head_sculpture = 3,result = false ,attack_time = os.date("%Y-%m-%d %X"),level = 3},
	            [2] = { playerid = 904, lost = 1500, nickname = "def",head_sculpture = 1,result = false,attack_time = os.date("%Y-%m-%d %X"),level = 4}
	    	},
			hourglass = {	
				{ 
				    playerid = playerid ,
				    glassid = 1,
				    sandtype = -1 , 
				    curtime = -1, 
				    status = GLASS_EMPTY,
				    gold_loss = -1,
				    gold_can_get = -1,
				    acc = 0,
				    unique_id = "",
				    helped_id = {}
			    } ,
			    {
				    playerid = playerid ,
				    glassid = 2,
				    sandtype = -1 , 
				    curtime = -1, 
				    status = GLASS_CLOSED,
				    gold_loss = 0,
				    gold_can_get = -1,
				    acc = 0,
				    unique_id = "",
				    helped_id = {}
			    } ,  
			    {
				    playerid = playerid ,
				    glassid = 3,
				    sandtype = -1 , 
				    curtime = -1, 
				    status = GLASS_CLOSED,
				    gold_loss = 0,
				    gold_can_get = -1,
				    acc = 0,
				    unique_id = "",
				    helped_id = {}
			    } ,   
			}, 
	    }
	    return true
	else
		return false
	end
end	



function command.START_HOURGLASS(playerid,glassid,sandtype)
	log("start_hourglass "..playerid.." "..glassid.." "..sandtype)
	if lab_data[playerid] == nil then 
	    log("no playerid")
	    return false
	end
	--log (dump(lab_data[playerid].hourglass[glassid]))
	if lab_data[playerid].hourglass[glassid].status ~= GLASS_EMPTY then
		return false
    end

	local hg = lab_data[playerid].hourglass[glassid]
	hg.sandtype = sandtype
	hg.curtime = 0
	hg.status = GLASS_PRODUCING
    hg.acc = 0
    hg.gold_loss = 0
    hg.gold_can_get = math.random(GOLD_LOWER_TBL[sandtype],GOLD_UPPER_TBL[sandtype])
    hg.unique_id = os.date("%Y-%m-%d %X")
    hg.helped_id = {}

    add_to_working_table(hg)
	return true
end

function command.HELP_FRIEND(playerid,targetid,glassid,unique_id)
	log ("help friend"..playerid.." "..targetid.." "..glassid.." "..unique_id)
	local hg = lab_data[targetid].hourglass[glassid]
	if hg.status ~= GLASS_PRODUCING then
		return false
	elseif hg.unique_id ~= unique_id then
		return false
	else
        for _,id in pairs(hg.helped_id) do
        	if id == playerid then
        		return false
        	end
        end

		hg.acc = hg.acc+HELP_ACC
        table.insert(hg.helped_id,playerid)
		local res,agent = skynet.call("ONLINE_CENTER","lua","is_online",targetid)
		if res then
			pcall(skynet.call,agent,"lua","lab_friend_helped")
		end

		return true,math.floor(hg.gold_can_get*HELP_GOLD_PERCENT)
	end
end

function command.MATCH_PLAYER()
	local playerid = 904
    local basic = skynet.call("DATA_CENTER","lua","get_player_data_part",playerid,"basic")
	return {
        result = 1,
        playerid = playerid,
        nickname = basic.nickname,
        head_sculpture = basic.head_sculpture,
        level = basic.level
	}
end

function command.START_STEAL(targetid)
	if is_safe(targetid) then
		log("start_steal false")
		return false
	else
		local res,agent = skynet.call("ONLINE_CENTER","lua","is_online",targetid)
		if res then
			pcall(skynet.call,agent,"lua","lab_stolen")
		end
		protect_player(targetid)
		log("start_steal true")
		return true
	end
end


function command.STEAL(playerid,targetid,result)
	log("steal!"..playerid.." "..targetid.." "..result)
	
	local player_data = lab_data[playerid]
	local target_data = lab_data[targetid]

	local gold_steal_total = 0
   
    if result == 1 then
	    for i=1,3 do
	    	local hg = target_data.hourglass[i]
	    	if hg.status == GLASS_PRODUCING or hg == GLASS_FULL then
	    		local gold = cal_steal_gold(hg)
	    		hg.gold_loss = hg.gold_loss + gold
	            gold_steal_total = gold_steal_total + gold
	        else
	        	-- nothing
	        end
	    end
	end
    
    local basic = skynet.call("DATA_CENTER","lua","get_player_data_part",playerid,"basic")
    
	target_data.be_attacked_list[target_data.atk_count+1] = 
	{   
		playerid = playerid , 
	    lost = gold_steal_total ,
	    nickname = basic.nickname, 
	    head_sculpture = basic.head_sculpture,
	    result = result == 0 and true or false,
	    attack_time = os.date("%Y-%m-%d %X"),
	    level = basic.level
	}
	target_data.atk_count = target_data.atk_count + 1

    local res,agent = skynet.call("ONLINE_CENTER","lua","is_online",targetid)

	if res then
		pcall(skynet.call,agent,"lua","lab_stolen")
	end

    log(""..playerid.."success steal "..targetid.."for "..gold_steal_total)

	return true,gold_steal_total

	
end


function command.HARVEST(playerid,glassid)
	log ("harvest"..playerid.." "..glassid)
	--log ("glass"..dump(lab_data[playerid].hourglass[glassid]))
	if lab_data[playerid].hourglass[glassid].status == GLASS_FULL then
        local hourglass = lab_data[playerid].hourglass[glassid]
        local gold = hourglass.gold_can_get - hourglass.gold_loss
        hourglass.status = GLASS_EMPTY
        hourglass.gold_loss = 0
        hourglass.curtime = -1
        hourglass.sandtype = -1
        hourglass.acc = 0
        hourglass.gold_can_get = 0
        hourglass.unique_id = ""
        hourglass.helped_id = {}
        return true,gold
    else
    	return false
    end
end

function command.QUICK_HARVEST(playerid,glassid)
	log ("quick harvest"..playerid.." "..glassid)
	--log ("glass"..dump(lab_data[playerid].hourglass[glassid]))
	if lab_data[playerid].hourglass[glassid].status == GLASS_PRODUCING then
		local hourglass = lab_data[playerid].hourglass[glassid]
		local gold = hourglass.gold_can_get - hourglass.gold_loss
		hourglass.status = GLASS_EMPTY
		hourglass.gold_loss = 0	
		hourglass.curtime = -1
		hourglass.sandtype = -1
		hourglass.acc = 0 
		hourglass.gold_can_get = 0
		hourglass.unique_id = ""
		hourglass.helped_id = {}
		remove_from_working_table(hourglass)
		return true,gold
	else 
		return false
    end
end

function command.GET_DATA(playerid)
	if lab_data[playerid] then
		local keeper = lab_data[playerid].keeper
		local soul = skynet.call("DATA_CENTER","lua","get_player_data_part",playerid,"souls")
		local items = skynet.call("DATA_CENTER","lua","generate_soul_items",playerid,keeper)
		return true, { lab_data = lab_data[playerid] , fight_data = { soul = soul[keeper] , items = items}}
	else
		return false
	end
end

function command.GET_QUICK_DIAMOND_NEED(playerid,pos)
    local hg = lab_data[playerid].hourglass[pos]
    if hg == nil then
        return false,0
    else
        local curtime = hg.curtime + hg.acc / 100 * TIME_TBL[hg.sandtype] 
        local totaltime = TIME_TBL[hg.sandtype]
        local time_need = totaltime - curtime
        local diamond_need = math.ceil(time_need / 360)
        log("quick_diamond_need "..diamond_need)
        return true,diamond_need
    end
end

function command.GET_HOURGLASS(playerid,pos)
    if lab_data[playerid] ~= nil then
        return lab_data[playerid].hourglass[pos]
    else
        return nil
    end
end


function command.SET_KEEPER(playerid,keeper)
    lab_data[playerid].keeper = keeper
    return true
end

function command.UNLOCK_HOURGLASS(playerid,glassid)
	log("unlock_hourglass"..playerid.." "..glassid)
	if lab_data[playerid] and lab_data[playerid].hourglass[glassid].status == GLASS_CLOSED then
		lab_data[playerid].hourglass[glassid].status = GLASS_EMPTY
		log ("ok")
		return true
	else
		return false
	end
end


local function update_working_glass()
	while true do
		local count = 0
		local pairs = pairs
	    for _,player in pairs(working_glasses) do
	    	for _,v in pairs(player) do
		    	v.curtime = v.curtime + 1
		    	if v.curtime >= math.floor(TIME_TBL[v.sandtype] * (1 - v.acc * 0.01)) then
		    		v.status = GLASS_FULL
		    		v.curtime = 0
		    		remove_from_working_table(v)
		    	end
		    	count = count + 1		    	
		    end
	    end
        
      --  log(""..count.." glasses is working ")

	    skynet.sleep(100)
	end
end



local function robot_register()
	for i,v in pairs(ROBOT_IDS) do
		command.REGISTER(v)
		command.UNLOCK_HOURGLASS(v,2)
		command.UNLOCK_HOURGLASS(v,3)
	end
end

-- robots will check their lab every 1 hour and may harvest and add new hourglass 
local function robot_work()
    while true do
        for _,robotid in pairs(ROBOT_IDS) do	
        	for _,hg in pairs(lab_data[robotid].hourglass) do
        		if hg.status == GLASS_EMPTY then    
        		    if math.random(2) == 1 then	
                        local sandtype = math.random(1,3)
        				command.START_HOURGLASS(hg.playerid,hg.glassid,sandtype)
                        log("SUCCESS!robotid "..robotid.. "put "..sandtype.. "into glass "..hg.glassid)
                    else
                        log("FAILED!robotid "..robotid.. "put ".. "into glass "..hg.glassid)
                    end
        		elseif hg.status == GLASS_FULL then
        			if math.random(2) == 1 then
        				command.HARVEST(hg.playerid,hg.glassid)
                        log("SUCCESS!robotid "..robotid.." harvest "..hg.glassid)
        			else
                        log("FAILED!robotid "..robotid.. "harvest "..hg.glassid)
                    end
        		end
        	end
        end

    	skynet.sleep(60*60 * 100)
    end
end




skynet.start(function()
	skynet.dispatch("lua", function(session, address, cmd, ...)
		local f = command[string.upper(cmd)]
		if f then
			cs(skynet.ret,skynet.pack(f(...)))
		--	skynet.ret(skynet.pack(f(...)))
		else
			error(string.format("Unknown command %s", tostring(cmd)))
		end
	end)
	skynet.fork(update_working_glass)
	skynet.fork(update_safe_tbl)
	skynet.fork(robot_register)
	skynet.fork(robot_work,1000)
	skynet.register "LAB_SERVICE"
end)
