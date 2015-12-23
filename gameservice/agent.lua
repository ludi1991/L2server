local skynet = require "skynet"
local netpack = require "netpack"
local socket = require "socket"
local sproto = require "sproto"
local sprotoloader = require "sprotoloader"
local queue = require "skynet.queue"
local taskmgr = require "gamelogic.taskmgr"
local statmgr = require "gamelogic.statmgr"
local itemmgr = require "gamelogic.itemmgr"
local labmgr = require "gamelogic.labmgr"
local friendmgr = require "gamelogic.friendmgr"
local arenamgr = require "gamelogic.arenamgr"
local rankmgr = require "gamelogic.rankmgr"
local fp_cal = require "gamelogic.fp_calculator"

local WATCHDOG
local host
local send_request

local CMD = {}
local REQUEST = {}
local client_fd

local player = {}

local redis_need_sync = false

local redis_single_fp_name = "fp_single_rank"
local redis_team_fp_name = "fp_team_rank"
local redis_1v1_name = "1v1_rank"
local redis_3v3_name = "3v3_rank"

local redis_name_tbl = {
	redis_single_fp_name,
	redis_team_fp_name,
	redis_1v1_name,
	redis_3v3_name
}


local function send_package(pack)
	local package = string.pack(">s2", pack)
	socket.write(client_fd, package)
end


local function have_enough_gold(value)
	return player.basic ~= nil and player.basic.gold - value >= 0
end

local function have_enough_diamond(value)
	return player.basic ~= nil and player.basic.diamond - value >= 0
end

local function have_enough_stone(value)
	return player.items ~= nil and
	       player.items[1000001] ~= nil and
	       player.items[1000001].itemcount - value >= 0
end

local function have_item(itemid)
	return player.items ~= nil and player.items[itemid] ~= nil
end


local function need_update(lasttime,time_need)
    local cur_time = os.time()
    local last_login_time = os.time(parse_time(player.basic.last_login_time))
    local curdate = os.date("*t")
    local update_time = os.time { 
        year = curdate.year, 
        month = curdate.month, 
        day = curdate.day ,
        hour = 5 , 
        min = 0 ,
        sec = 0
    }
    if cur_time >= update_time and last_login_time < update_time then
        return true
    else
        return false
    end
end

-- 增加或减少金币
local function add_gold(value)
	if player.basic.gold + value < 0 then
	    print ("not enough gold")
	    return false
	else
        player.basic.gold = player.basic.gold + value
        if value < 0 then
        	statmgr:add_gold_consumed(-value)
        	taskmgr:update_tasks_by_condition_type(E_HAVE_CONSUMED_ENOUGH)
        end
	    return true
    end
end

--增加或减少钻石
local function add_diamond(value)
	if player.basic == nil then
		print ("add_diamond : player basic not exist")
		return false
	else
		if player.basic.diamond + value < 0 then
		    print ("not enough gold")
		    return false
		else
            player.basic.diamond = player.basic.diamond + value
            if value < 0 then
            	statmgr:add_diamond_consumed(-value)
            	taskmgr:update_tasks_by_condition_type(E_HAVE_CONSUMED_ENOUGH)
            end
		    return true
        end
    end
end


local function add_item(item)
	if player.items ~= nil then
        log ("add_item"..dump(item))
		if have_item(item.itemid) then
			player.items[item.itemid].itemcount = player.items[item.itemid].itemcount + item.itemcount
		else
			player.items[item.itemid] = item
		end
		return true
	end
	log ("add_item failed")
	return false
end


local function update_item(item)
	if have_item(item.itemid) == false then
		return false
	end
	player.items[item.itemid].itemtype = item.itemtype
	player.items[item.itemid].itemextra = item.itemextra
	return true

end


local function set_sync_redis_flag()
	redis_need_sync = true
end

--同步战斗数据到redis
local function sync_fight_data_to_redis()
    if redis_need_sync then
        for i,_ in pairs(player.souls) do
            local fp = fp_cal:get_soul_fightpower(player,i)
            statmgr:set_soul_fp(i,fp)
        end
    end
end




function REQUEST:get()
	print("get", self.what)
	local r = skynet.call("SIMPLEDB", "lua", "get", self.what)
	return { result = r }
end

function REQUEST:set()
	print("set", self.what, self.value)
	local r = skynet.call("SIMPLEDB", "lua", "set", self.what, self.value)
end

function REQUEST:getnews()
	print "require news"
	local r = skynet.call("SIMPLENEWS", "lua","getnews")
	return { msg = r }
end


function REQUEST:chat()
	print ("request chat ")
    skynet.call("CHATROOM","lua","chat",{name = self.name,msg = self.msg})
    return { result = 1 }
end

function REQUEST:handshake()
	return { msg = "Welcome to skynet, I will send heartbeat every 5 sec." }
end

function REQUEST:get_player_basic()
	return { data = player.basic }
end

function REQUEST:get_player_rank()
    if self.ranktype == 1 or self.ranktype == 2 then
        return rankmgr:get_player_rank(self.ranktype)
    elseif self.ranktype == 3 or self.ranktype == 4 then
        return arenamgr:get_player_arena_rank(self.ranktype-2) 
    end
end

function REQUEST:login()

    player = skynet.call("DATA_CENTER","lua","get_player_data",self.playerid)


	set_sync_redis_flag()

    log ("player "..self.playerid.." is initalized!","info")
    log(dump(player))

    taskmgr:init(player)
    statmgr:init(player)
    itemmgr:init(player)
    labmgr:init(player)
    friendmgr:init(player)
    rankmgr:init(player)
    arenamgr:init(player)


    skynet.fork(function()
        log("hello")
		while true do
			if redis_need_sync then
				log ("sync data to redis!")
				sync_fight_data_to_redis()
			    redis_need_sync = false
			end
			skynet.sleep(1000)
		end
    end)

    skynet.call("ONLINE_CENTER","lua","set_online",self.playerid,skynet.self())
    
    -- update data at 5 o'clock
    if need_update() then
        log("need daily update")
        CMD.daily_update()
    end

	return { result = 1 }
end


function REQUEST:get_player_items()
	local tmp = {}
	for _,v in pairs(player.items) do
		table.insert(tmp,v)
        end
	return { items = tmp }
end


function REQUEST:get_rank_data()
    log("haha"..self.start.." "..self.count.." "..self.ranktype)
    if self.ranktype == 1 or self.ranktype == 2 then
        return rankmgr:get_rank_data(self.start,self.count,self.ranktype)
    elseif self.ranktype == 3 or self.ranktype == 4 then
        return arenamgr:get_rank_data(self.start,self.count,self.ranktype-2)
    end
    return { data = res }
end

function REQUEST:get_player_soul()
    return { souls = player.souls }
end

function REQUEST:set_cursoul()
	player.basic.cursoul = self.soulid
	return { result = 1 }
end

function REQUEST:get_server_time()
	return { time = os.date("%Y-%m-%d %X") }
end

function REQUEST:pass_boss_level()
    if not itemmgr:have_item(1500001) then
        log ("failed to pass level,not enough ticket")
        return { result = 1 }
    else
    	add_gold(self.gold)
    	add_diamond(self.diamond)
        itemmgr:delete_item(1500001,1)
        
        if self.items ~= nil then
    		for _,v in pairs(self.items) do
    			player.items[v.itemid] = v
    			--table.insert(player.items,v)
    		end
    	end
    	if player.basic.level == self.level then
            player.basic.level = player.basic.level + 1
        end
        statmgr:add_stat("kill_boss")
        statmgr:add_daily_stat("kill_boss")

        taskmgr:update_tasks_by_condition_type(E_HAVE_GET_ENOUGH_LEVEL)
        taskmgr:update_tasks_by_condition_type(E_KILL_BOSS)
        taskmgr:update_tasks_by_condition_type(E_KILL_BOSS_TOTAL)
        taskmgr:trigger_task_by_type(1)
	    return { result = 1 }
    end
end


function REQUEST:pass_level()
	add_gold(self.gold)
	add_diamond(self.diamond)
    if self.items ~= nil then
		for _,v in pairs(self.items) do
			player.items[v.itemid] = v
		end
	end

	return { result = 1 }
end


function REQUEST:set_player_soul()
	if not self.souls then return { result = 1 }end
	for i,v in pairs(self.souls) do
		player.souls[v.soulid] = v
	end
	set_sync_redis_flag()
    taskmgr:update_tasks_by_condition_type(E_HAVE_SOULS)
    taskmgr:update_tasks_by_condition_type(E_EQUIP_RESONANCES)
	return { result = 1}
end

function REQUEST:get_tasks()
	if player.tasks ~= nil then
		return { tasks = taskmgr:generate_tasks(player.tasks)}
	else
		print ("get_tasks_failed")
	end
end

function REQUEST:get_task_reward()
    local id = self.taskid
    if player.tasks[id] ~= nil then
    	taskmgr:finish_task(id)
    	local gold,diamond,items = taskmgr:get_reward(id)
    	if gold ~= nil then
    		add_gold(gold)
    	end

    	if diamond ~= nil then
    		add_diamond(diamond)
    	end
        

        local return_items = {}
        if #items > 0 then
            for _,item in pairs(items) do
                local theitem = itemmgr:add_item(item.itemtype,item.itemcount)
                table.insert(return_items,theitem)
            end
        end

    	return {
            gold = gold,
            diamond = diamond,
            items = return_items,
        }
    else
    	log("no task!")
    end
end

function REQUEST:set_cur_stayin_level()
    player.basic.cur_stayin_level = self.level
    return { result = 1}
end

function REQUEST:strengthen_item()
    if have_enough_gold(self.gold) and 
       have_enough_stone(self.stone) and
       have_enough_diamond(self.diamond) and 
       have_item(self.item.itemid) then

        add_gold(-self.gold)
        add_diamond(-self.diamond)
        itemmgr:add_stone(-self.stone)
        update_item(self.item)
        set_sync_redis_flag()

        statmgr:add_daily_stat("strengthen_equip")
        taskmgr:update_tasks_by_condition_type(E_STENGTHEN_EQUIP)
        return { result = 1}
    end

    return { result = 0 }


end

function REQUEST:upgrade_item()
	if have_enough_gold(self.gold) and 
       have_enough_diamond(self.diamond) and 
       have_item(self.item.itemid) then

    	add_gold(-self.gold)
    	add_diamond(-self.diamond)
    	update_item(self.item)
        set_sync_redis_flag()
        statmgr:add_daily_stat("upgrade_equip")
        taskmgr:update_tasks_by_condition_type(E_UPGRADE_EQUIP)
        taskmgr:update_tasks_by_condition_type(E_EQUIP_RESONANCES)
        return { result = 1 }
	end

	return { result = 0}
end

function REQUEST:melt_item()

	for _,id in pairs(self.itemids) do
		if have_item(id) == false then return { result = 0 } end
	end

    for _,id in pairs(self.itemids) do
    	itemmgr:delete_item(id)
    end

    add_item(self.newitem)
    itemmgr:add_stone(self.stone)

    statmgr:add_melt_times(1)
    taskmgr:update_tasks_by_condition_type(E_HAVE_MELT_ENOUGH_TIMES)

    return { result = 1 }

end

function REQUEST:sell_item()
	for _,id in pairs(self.itemids) do
		if have_item(id) == false then return { result = 0 } end
	end

    for _,id in pairs(self.itemids) do
    	itemmgr:delete_item(id)
    end

    add_gold(self.gold[1])
    return { result = 1 }

end


function REQUEST:fight_with_player_result()
    return arenamgr:fight(self.enemyid,self.fighttype,self.result)
end

function REQUEST:start_fight_with_player()
    return arenamgr:start_fight(self.playerid,self.fighttype)
end



function REQUEST:add_offline_reward()
	add_gold(self.gold)
	add_diamond(self.diamond)

    if self.items ~= nil then
		for _,v in pairs(self.items) do
			player.items[v.itemid] = v
			--table.insert(player.items,v)
		end
	end
	return { result = 1 }
end


function REQUEST:get_fight_data()
    return arenamgr:get_fight_data(self.fight_type)
end

function REQUEST:set_fight_soul()
	if player.player_config == nil then
		print ("set_fight_soul failed!")
		return { result = 0 }
	end

    if self.type == 1 then
    	player.player_config.soulid_1v1 = self.soulid[1]
    	set_sync_redis_flag()
    elseif self.type == 2 then
    	player.player_config.soulid_3v3 = self.soulid
    	set_sync_redis_flag()
    end
    return { result = 1 }
end


function REQUEST:collect_parachute()
	add_gold(self.gold)
	add_diamond(self.diamond)
	return { result = 1 }
end

function REQUEST:upgrade_gem()
	local res = itemmgr:upgrade_gem(self.diamondid,self.gold)
	return { result = res and 1 or 0}
end

function REQUEST:item_add_hole()
	local res = itemmgr:item_add_hole(self.itemid)
	return { result = res and 1 or 0}
end

function REQUEST:item_inset_gem()
	local res = itemmgr:item_inset_gem(self.itemid,self.gem_type,self.gem_hole_pos)
	set_sync_redis_flag()
	return { result = res and 1 or 0}
end

function REQUEST:item_pry_up_gem()
	log ("item_pry"..dump(self.gem_hole_pos))
	local res = itemmgr:item_pry_up_gem(self.itemid,self.gem_hole_pos)
	set_sync_redis_flag()
	return { result = res and 1 or 0}
end

function REQUEST:new_pass_level()

end

function REQUEST:new_pass_boss_level()
end

--- lab

function REQUEST:lab_register()
	return labmgr:lab_register()
end

function REQUEST:lab_start_hourglass()
	return labmgr:lab_start_hourglass(self.hourglassid,self.sandtype)
end

function REQUEST:lab_help_friend()
    return labmgr:lab_help_friend(self.friendid,self.glassid,self.unique_id)
end

function REQUEST:lab_get_data()
	return labmgr:lab_get_data(self.playerid)
end

function REQUEST:lab_match_player()
	return labmgr:lab_match_player()
end

function REQUEST:lab_steal()
	return labmgr:lab_steal(self.playerid,self.result)
end

function REQUEST:lab_harvest()
	return labmgr:lab_harvest(self.glassid)
end

function REQUEST:lab_set_keeper()
	return labmgr:lab_set_keeper(self.keeperid)
end

function REQUEST:lab_quick_harvest()
	return labmgr:lab_quick_harvest(self.glassid)
end

function REQUEST:lab_unlock_hourglass()
	return labmgr:lab_unlock_hourglass(self.glassid)
end

function REQUEST:set_unlock_soul()
    player.config.unlock_soul = self.list
    return { result = 1 }
end

function REQUEST:get_unlock_soul()
	if player.config.unlock_soul == nil then
		player.config.unlock_soul = {}
	end
	return { list = player.config.unlock_soul }
end

function REQUEST:get_friend_list()
    return friendmgr:get_friend_list()
end

function REQUEST:add_friend()
    return friendmgr:add_friend(self.playerid)
end

function REQUEST:delete_friend()
    return friendmgr:delete_friend(self.playerid)
end


function REQUEST:set_guide_step()
	log ("set guide step "..self.step)
    player.config.guide_step = self.step
    return { result = 1 }
end

function REQUEST:get_guide_step()
	return { step = player.config.guide_step }
end

function REQUEST:lab_start_steal()
    return labmgr:lab_start_steal(self.playerid)
end

function REQUEST:quick_pass_level()
    local times = statmgr:get_daily_stat("quick_fight")
    if times < 55555 then
        if times >= 1 then
            if have_enough_diamond(20) then
                add_diamond(-20)
            else
                return { result = 0 }
            end            -- cost 20 
        end
        add_gold(self.gold)
        add_diamond(self.diamond)
        if self.items ~= nil then
            for _,v in pairs(self.items) do
                player.items[v.itemid] = v
            end
        end
        statmgr:add_daily_stat("quick_fight")
        statmgr:add_stat("quick_fight")
        taskmgr:update_tasks_by_condition_type(E_QUICK_FIGHT)
        taskmgr:update_tasks_by_condition_type(E_QUICK_FIGHT_TOTAL)
        return { result = 1 }
    else
        return { result = 0 }
    end
end


function REQUEST:upgrade_gem_all()
    local res = itemmgr:upgrade_gem_all(self.diamondid,self.gold)
    if res > 0 then 
        return { result = 1, count = res}
    else
        return { result = 0, count = 0}
    end
end

function REQUEST:get_quick_pass_used_time()
    local time = statmgr:get_daily_stat("quick_fight")
    return { times = time }
end


--落地数据到数据库
local function save_to_db()
	local res = skynet.call("DATA_CENTER","lua","save_player_data",player)
end

function REQUEST:create_new_player()
    local newplayerid
    newplayerid,player = skynet.call("DATA_CENTER","lua","create_player",self.nickname)

    -- 0 means task for new player
    taskmgr:init(player)
    statmgr:init(player)
    itemmgr:init(player)
    labmgr:init(player)
    friendmgr:init(player)
    arenamgr:init(player)
    rankmgr:init(player)

    taskmgr:trigger_task_by_type(0)
    labmgr:lab_register()
    skynet.call("ARENA_SERVICE","lua","register",newplayerid)

    save_to_db()
    

    return { result = 1 , playerid = newplayerid }

end



function REQUEST:quit()
	save_to_db()
	skynet.call(WATCHDOG, "lua", "close", client_fd)
end

local function request(name, args, response)
	local f = assert(REQUEST[name])
	local r = f(args)
	if response then
		return response(r)
	end
end



local heartbeat_miss_cnt = 0

-- 协程在call的时候将不会挂起
local cs = queue()
local function dispatch_with_queue(_,_,type,...)
	if type == "REQUEST" then
        cs(send_package,request(...))
	else
        --log("receive heartbeat callback")
		heartbeat_miss_cnt = 0
	end
end




-- local function dispatch(_,_,type,...)
-- 	if type == "REQUEST" then
-- 		local ok, result  = pcall(request, ...)
-- 		if ok then
-- 			if result then
-- 				send_package(result)
-- 			end
-- 		else
-- 			skynet.error(result)
-- 		end
-- 	else
-- 		assert(type == "RESPONSE")

      
-- 		error "This example doesn't support request client"
-- 	end
-- end


skynet.register_protocol {
	name = "client",
	id = skynet.PTYPE_CLIENT,
	unpack = function (msg, sz)
		return host:dispatch(msg, sz)
	end,
	dispatch = dispatch_with_queue
}


function CMD.chat(themsg)
	send_package(send_request("chatting",{name = themsg.name ,msg = themsg.msg,time = os.date()}))
end

function CMD.lab_friend_helped()
    send_package(send_request("lab_friend_helped"))
end

function CMD.lab_stolen()
	send_package(send_request("lab_stolen"))
end

function CMD.get_data()
	return player
end

function CMD.daily_update()
    statmgr:reset_daily_stat()
    taskmgr:daily_task_update()
end

function CMD.start(conf)
	local fd = conf.client
	local gate = conf.gate
	WATCHDOG = conf.watchdog
	-- slot 1,2 set at main.lua
	host = sprotoloader.load(1):host "package"
	send_request = host:attach(sprotoloader.load(2))
	log("start","info")


	skynet.fork(function()
		while true do
			send_package(send_request("heartbeat",nil,5))
            heartbeat_miss_cnt = heartbeat_miss_cnt + 1
            if heartbeat_miss_cnt >= 8 then
                log("client missed!")
            end
			skynet.sleep(200)
		end
	end)

	client_fd = fd
	skynet.call(gate, "lua", "forward", fd)
end


function CMD.disconnect()
	-- todo: do something before exit
    --skynet.send("CHATROOM","lua","logout",skynet.self())
    log("disconnect "..player.basic.playerid)
    player.basic.last_login_time = os.date("%Y-%m-%d %X")
    save_to_db()
    skynet.call("ONLINE_CENTER","lua","set_offline",player.basic.playerid)
	skynet.exit()
end

skynet.start(function()
	skynet.dispatch("lua", function(_,_, command, ...)
		print ("dispatch something "..command)
		local f = CMD[command]
		if f then
		    skynet.ret(skynet.pack(f(...)))
		else
		end
	end)

end)
