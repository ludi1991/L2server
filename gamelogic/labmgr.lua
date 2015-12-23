local labmgr = {}
local skynet = require "skynet"
local itemmgr 
local statmgr
local taskmgr


local KEY_ID = 1400001
local BATTERY_ID = 1400002
local ENERGY_BLOCK_IDS = {
	1400003,1400004,1400005
}


function labmgr:init(player)
	self.player = player
	player.lab = player.lab or {}
	self.lab = lab
    itemmgr = require "gamelogic.itemmgr"
    statmgr = require "gamelogic.statmgr"
    taskmgr = require "gamelogic.taskmgr"
end

function labmgr:lab_register()
	log("labmgr_register!")
	local res = skynet.call("LAB_SERVICE","lua","register",self.player.basic.playerid)
	if res == true then
		return { res = 1 }
	else 
		return { res = 0 }
	end
end

function labmgr:lab_start_hourglass(hourglassid,sandtype)
    if not itemmgr:have_item(ENERGY_BLOCK_IDS[sandtype]) then
        log("don't have energy block , type : "..sandtype)	
        return { result = 0}
    else
    	itemmgr:delete_item(ENERGY_BLOCK_IDS[sandtype])
		local res = skynet.call("LAB_SERVICE","lua","start_hourglass",self.player.basic.playerid,hourglassid,sandtype)
		if res == true then
			return { result = 1 }
		else 
			return { result = 0 }
		end
	end
end

function labmgr:lab_help_friend(friend_id,glass_id,unique_id)
    if not itemmgr:have_item(BATTERY_ID) then
        log("don't have battery")	
        return { result = 0}
    else
    	itemmgr:delete_item(BATTERY_ID)
		local res,gold = skynet.call("LAB_SERVICE","lua","help_friend",self.player.basic.playerid,friend_id,glass_id,unique_id)
	    if res == true then
	    	self.player.basic.gold = self.player.basic.gold + gold
            statmgr:add_stat("lab_help")
            statmgr:add_daily_stat("lab_help")
            taskmgr:update_tasks_by_condition_type(E_LAB_HELP)
            taskmgr:update_tasks_by_condition_type(E_LAB_HELP_TOTAL)
	    	return { result = 1 ,gold = gold}
	    else
	    	return { result = 0 ,gold = 0}
	    end
	end
end

function labmgr:lab_get_data(playerid)
	local res,data = skynet.call("LAB_SERVICE","lua","get_data",playerid)
	if res then
		return data
	else
	    log("lab_get_data playerid "..playerid.." failed!") 
		return {}
	end
end

function labmgr:lab_match_player()
	return skynet.call("LAB_SERVICE","lua","match_player")
end

function labmgr:lab_steal(targetid,result)
	local res,gold = skynet.call("LAB_SERVICE","lua","steal",self.player.basic.playerid,targetid,result)
	if res == true then
		self.player.basic.gold = self.player.basic.gold + gold
        statmgr:add_stat("lab_steal")
        statmgr:add_daily_stat("lab_steal")
        taskmgr:update_tasks_by_condition_type(E_LAB_STEAL)
        taskmgr:update_tasks_by_condition_type(E_LAB_STEAL_TOTAL)
		return { result = 1, gold = gold }
    else
    	return { result = 0 ,gold = 0}
    end
end

function labmgr:lab_harvest(glassid)
	local res,gold = skynet.call("LAB_SERVICE","lua","harvest",self.player.basic.playerid,glassid)
	if res == true then
		self.player.basic.gold = self.player.basic.gold + gold
        statmgr:add_stat("lab_harvest")
        statmgr:add_daily_stat("lab_harvest")
        taskmgr:update_tasks_by_condition_type(E_LAB_HARVEST)
        taskmgr:update_tasks_by_condition_type(E_LAB_HARVEST_TOTAL)
		return { result = 1 , gold = gold }
	else
		return { result = 0, gold = 0}
	end
end

function labmgr:lab_set_keeper(keeperid)
    local res = skynet.call("LAB_SERVICE","lua","set_keeper",self.player.basic.playerid,keeperid)	
    if res == true then
    	return { result = 1}
    else
    	return { result = 0}
    end
end

function labmgr:lab_quick_harvest(glassid)
    local res,diamond_need = skynet.call("LAB_SERVICE","lua","GET_QUICK_DIAMOND_NEED",self.player.basic.playerid,glassid)
    if res and self.player.basic.diamond < diamond_need then
        return { result = 0, gold = 0 }
    else
    	local res,gold = skynet.call("LAB_SERVICE","lua","quick_harvest",self.player.basic.playerid,glassid)
    	if res == true then
    		self.player.basic.gold = self.player.basic.gold + gold
            self.player.basic.diamond = self.player.basic.diamond - diamond_need
            statmgr:add_stat("lab_harvest")
            statmgr:add_daily_stat("lab_harvest")
            taskmgr:update_tasks_by_condition_type(E_LAB_HARVEST)
            taskmgr:update_tasks_by_condition_type(E_LAB_HARVEST_TOTAL)
    		return { result = 1 , gold = gold ,diamond_consumed = diamond_need}
    	else
    		return { result = 0, gold = 0}
    	end
    end
end

function labmgr:lab_unlock_hourglass(glassid)
	local res = skynet.call("LAB_SERVICE","lua","unlock_hourglass",self.player.basic.playerid,glassid)
	if res == true then
		return { result = 1}
	else
		return { result = 0}
	end
end

function labmgr:lab_start_steal(targetid)
    if not itemmgr:have_item(KEY_ID) then
        log("don't have energy block , type : "..sandtype)  
        return { result = 0}
    else
        itemmgr:delete_item(KEY_ID)
    	local res = skynet.call("LAB_SERVICE","lua","start_steal",targetid)
    	if res == true then
    		return { result = 1}
    	else
    		return { result = 0}
    	end
    end
end

return labmgr