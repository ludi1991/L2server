local taskmgr = {}
local skynet = require "skynet"
local task_data = require "data.task_data"
local drop_data = require "data.drop_data"

local statmgr 
local itemmgr


function taskmgr:init(player)
    self.player = player
    statmgr = require "gamelogic.statmgr"
    itemmgr = require "gamelogic.itemmgr"
end


function taskmgr:get_task_details(taskid)
	return task_data[taskid]
end


--完成了任务调用 会删除任务，把任务放到config中，并且根据任务有没有后续，增加新的任务
function taskmgr:finish_task(taskid)
	local player = self.player
	if player.tasks and player.tasks[taskid] and player.tasks[taskid].percent == 100 then
        self:delete_task(taskid)
		self:add_to_finished_table(taskid)
		 
        local detail = self:get_task_details(taskid)
        statmgr:add_daily_stat("task_total_score",detail.finish_per)
        self:update_tasks_by_condition_type(E_HAVE_ENOUGH_DAILY_SCORE)

		if detail.continue_task ~= nil  then
            local levels = string.split(detail.continue_task,",")
            for i,v in pairs(levels) do
                local level = tonumber(v)
                self:trigger_task(level)
            end
        end

	else
		log ("taskmgr:finish task failed ,id : "..taskid ,"error")
	end
end

function taskmgr:add_task(taskid)
	local player = self.player
	local percent = taskmgr:cal_task_percent(taskid)
	player.tasks[taskid] = { taskid = taskid , percent = percent}
	--log (dump(player))
end

function taskmgr:delete_task(taskid)
    local player = self.player
    player.tasks[taskid] = nil
end

--这个任务是否在正在进行的任务列表中
function taskmgr:have_task(taskid)
    return self.player.tasks[taskid] ~= nil
end

-- 计算任务完成了多少
function taskmgr:cal_task_percent(taskid)
	local details = self:get_task_details(taskid)
	--log (dump(details))
	local condition_type = details.needs_type
	local param1 = details.needs_target
	local param2 = details.needs_num
	--log ("cal_task_percent "..param1.." "..param2)
    local finished,percent = self:check_condition(condition_type,param1,param2)
	if finished then
		return 100
	else
		return percent or 0
	end
end

-- 更新任务
function taskmgr:update_tasks_by_condition_type(condition_type)
    for i,v in pairs(self.player.tasks) do
    	local detail = self:get_task_details(v.taskid)
    	if detail.needs_type == condition_type then
    		self:update_task(v.taskid)
    	end
    end
end

function taskmgr:update_task(taskid)
	local player = self.player
	local percent = self:cal_task_percent(taskid)
	if player.tasks[taskid] ~= nil then
		player.tasks[taskid].percent = percent
	end 
end

-- 这个任务是否完成过！ 完成过！ 完成过！
function taskmgr:have_finished_task(taskid)
    local player = self.player
    return player.config.finished_tasks[taskid] ~= nil
end


function taskmgr:add_to_finished_table(taskid)
	local player = self.player
	player.config.finished_tasks[taskid] = true
end

function taskmgr:remove_from_finished_table(taskid)
    local player = self.player
    player.config.finished_tasks[taskid] = nil
end

function taskmgr:trigger_task(taskid)
    if self:have_finished_task(taskid) then
            log ("i have finished task "..taskid )
            return
    else

        -- check if pre tasks are finished
        local details = self:get_task_details(taskid)
        local pre = details.pre

        if pre then
            log("pre "..pre)
            pre = string.split(pre,",")
            for i,v in pairs(pre) do
                local pretask_id = tonumber(v)
                if self:have_finished_task(pretask_id) == false then
                    return
                end
            end
        end

        if details.trigger_type == 0 then
            self:add_task(taskid)        
        elseif details.trigger_type == 1 then                                
            if self.player.basic.level >= details.trigger_condition then
                self:add_task(taskid)
            end
        end 
    end
end

--check if the task can be triggered ，only 4 types is possile for now 
-- -1.won't trigger or trigger by last task
-- 0. new player
-- 1. level upgrade
-- 2. get new soul
-- 3. get item
-- 4. unlock system
function taskmgr:trigger_task_by_type(thetype)
	local player = self.player
    for i,v in pairs(task_data) do
        if v.trigger_type == thetype then
            self:trigger_task(v.id)
        end
	end
end

-- get reward for a task
function taskmgr:get_reward(taskid)
	local details = task_data[taskid]
    local drop = drop_data[details.drop]
    local items = {} 
    for i = 1,8 do
        dropid = drop["drop_id"..i]
        dropnum = drop["drop_num"..i]
        if dropid ~= nil and dropnum ~= nil then
            table.insert(items,{ itemtype = dropid, itemcount = dropnum } )   
        end
    end
	
	return drop.gold,drop.diamond,items
end


function taskmgr:generate_tasks(save_tbl)
	local res = {}
    for i,v in pairs(save_tbl) do
    	data = task_data[i]
        local gold,diamond,items = self:get_reward(i)
    	local task = {
            taskid = v.taskid,
            type = data.task_type,
            icon = data.icon,
            title = data.name,
            description = data.task_des,
            gold = gold,
            diamond = diamond,
            percent = v.percent,
            items = items,
            dropid = data.drop
    	}
        log (""..dump(task))

        table.insert(res,task)
    end
    return res
end




function taskmgr:check_condition(type,...)
	--log ("taskmgr check_condition : "..type)
    return self.condition_checker[type](self,...)
end


function taskmgr:daily_task_update()
    local player = self.player
    for id,task in pairs(task_data) do
        if task.task_type == 2 then
            if self:have_finished_task(id) then
                self:remove_from_finished_table(id)
            end
            if self:have_task(id) then
                self:delete_task(id)
            end
            self:trigger_task(id)
        end
    end
end




-----------------  条件检测
function taskmgr:have_get_enough_level(level)
	log("checking have get enough level")
	return self.player.basic.level > level
end

function taskmgr:have_souls(soul_girl_id)
    local souls = self.player.souls
    return souls[soul_girl_id] ~= nil
end

function taskmgr:have_item(itemtype)
    return taskmgr:have_item_by_itemtype(itemtype)
end

function taskmgr:have_unlocked_system(systemid)
end

function taskmgr:kill_monsters()
end

--itemtype 1 gold ,itemtype 2 diamond ,itemtype 3 stone
function taskmgr:have_consumed_enough(itemtype,count)
	if itemtype == 1 then
		return statmgr:get_gold_consumed() >= count
	elseif itemtype == 2 then
		return statmgr:get_diamond_consumed() >= count
	end
end

function taskmgr:passed_level(levelid)
end

function taskmgr:have_melt_enough_times(times)
	return statmgr:get_melt_times() >= times
end


function  taskmgr:have_enough_daily_score(score_need)
    local count = statmgr:get_daily_stat("task_total_score")
    local score = math.floor(count/score_need*100)
    if score > 100 then score = 100 end
    return score==100,score
end

function taskmgr:have_wear_equip()
end

function taskmgr:strengthen_equip(need)
    local count = statmgr:get_daily_stat("strengthen_equip")
    local score = math.floor(count/need*100)
    if score > 100 then score = 100 end
    return score == 100 ,score
end

function taskmgr:upgrade_equip(need)
    local count = statmgr:get_daily_stat("upgrade_equip")
    local score = math.floor(count/need*100)
    if score > 100 then score = 100 end
    return score == 100 ,score
end

function taskmgr:inset_gem(need)
    local count = statmgr:get_daily_stat("inset_gem")
    local score = math.floor(count/need*100)
    if score > 100 then score = 100 end
    return score == 100 ,score
end

function taskmgr:upgrade_gem(need)
    local count = statmgr:get_daily_stat("upgrade_gem")
    local score = math.floor(count/need*100)
    if score > 100 then score = 100 end
    return score == 100 ,score
end

function taskmgr:equip_resonances(level,count_need)

    local function get_soul_resonance(soul,items)
        local min = 10
        for _,id in pairs(soul.itemids) do
            if id == -1 then
                log ("min is zero")
                return 0
            else
                local item_quality = items[id].itemtype%10
                if min > item_quality then
                    min = item_quality
                end
            end
        end
        log ("min is ".. min)
        return min
    end
    
    local count = 0
    for _,soul in pairs(self.player.souls) do
        if get_soul_resonance(soul,self.player.items) >= level then
            count = count + 1
        end
    end
    log("axiba"..count.." "..count_need.." "..level)
    return count >= count_need
end

function taskmgr:gem_max_level(level)
    local items = self.player.items
    local max = 0
    for gem_quality=1,8 do
        for gem_type=1,8 do
            local itemtype = 1100000 + gem_type * 100 + gem_quality
            if itemmgr:have_item_by_itemtype(itemtype) then
                max = gem_quality
                break
            end
        end
    end
    return max >= level
end

function taskmgr:arena_single(need)
    local count = statmgr:get_daily_stat("arena_single_times")
    local score = math.floor(count/need*100)
    if score > 100 then score = 100 end
    return score == 100 ,score
end

function taskmgr:arena_team(need)
    local count = statmgr:get_daily_stat("arena_team_times")
    local score = math.floor(count/need*100)
    if score > 100 then score = 100 end
    return score == 100 ,score
end

function taskmgr:arena_single_victory(need)
    local count = statmgr:get_daily_stat("arena_single_victory")
    local score = math.floor(count/need*100)
    if score > 100 then score = 100 end
    return score == 100 ,score
end

function taskmgr:arena_team_victory(need)
    local count = statmgr:get_daily_stat("arena_team_victory")
    local score = math.floor(count/need*100)
    if score > 100 then score = 100 end
    return score == 100 ,score
end

function taskmgr:arena_rank_1v1(need)
    local rank = skynet.call("ARENA_SERVICE","lua","get_index_by_playerid",self.player.basic.playerid,1)
    return rank <= need
end

function taskmgr:arena_rank_3v3(need)
    local rank = skynet.call("ARENA_SERVICE","lua","get_index_by_playerid",self.player.basic.playerid,2)
    return rank <= need
end


function taskmgr:arena_single_total(need)
    local count = statmgr:get_stat("arena_single_times")
    local score = math.floor(count/need*100)
    if score > 100 then score = 100 end
    return score == 100 ,score
end

function taskmgr:arena_team_total(need)
    local count = statmgr:get_stat("arena_team_times")
    local score = math.floor(count/need*100)
    if score > 100 then score = 100 end
    return score == 100 ,score
end

function taskmgr:arena_single_victory_total(need)
    local count = statmgr:get_stat("arena_single_victory")
    local score = math.floor(count/need*100)
    if score > 100 then score = 100 end
    return score == 100 ,score
end

function taskmgr:arena_team_victory_total(need)
    local count = statmgr:get_stat("arena_team_victory")
    local score = math.floor(count/need*100)
    if score > 100 then score = 100 end
    return score == 100 ,score
end


function taskmgr:lab_harvest(need)
    local count = statmgr:get_daily_stat("lab_harvest")
    local score = math.floor(count/need*100)
    if score > 100 then score = 100 end
    return score == 100 ,score
end

function taskmgr:lab_steal(need)
    local count = statmgr:get_daily_stat("lab_steal")
    local score = math.floor(count/need*100)
    if score > 100 then score = 100 end
    return score == 100 ,score
end

function taskmgr:lab_help(need)
    local count = statmgr:get_daily_stat("lab_help")
    local score = math.floor(count/need*100)
    if score > 100 then score = 100 end
    return score == 100 ,score
end

function taskmgr:lab_harvest_total(need)
    local count = statmgr:get_stat("lab_harvest")
    local score = math.floor(count/need*100)
    if score > 100 then score = 100 end
    return score == 100 ,score
end

function taskmgr:lab_steal_total(need)
    local count = statmgr:get_stat("lab_steal")
    local score = math.floor(count/need*100)
    if score > 100 then score = 100 end
    return score == 100 ,score
end

function taskmgr:lab_help_total(need)
    local count = statmgr:get_stat("lab_help")
    local score = math.floor(count/need*100)
    if score > 100 then score = 100 end
    return score == 100 ,score
end

function taskmgr:kill_boss(need)
    local count = statmgr:get_stat("kill_boss")
    local score = math.floor(count/need*100)
    if score > 100 then score = 100 end
    return score == 100 ,score
end

function taskmgr:kill_boss_total(need)
    local count = statmgr:get_daily_stat("kill_boss")
    local score = math.floor(count/need*100)
    if score > 100 then score = 100 end
    return score == 100 ,score
end

function taskmgr:quick_fight(need)
    local count = statmgr:get_daily_stat("quick_fight")
    local score = math.floor(count/need*100)
    if score > 100 then score = 100 end
    return score == 100 ,score
end

function taskmgr:quick_fight_total(need)
    local count = statmgr:get_stat("quick_fight")
    local score = math.floor(count/need*100)
    if score > 100 then score = 100 end
    return score == 100 ,score
end




taskmgr.condition_checker = {
	[1] = taskmgr.have_get_enough_level,    --1
	[2] = taskmgr.have_souls,                 --2
	[3] = taskmgr.have_item,               --3
	[4] = taskmgr.have_unlocked_system,      --4
    [5] = taskmgr.kill_monsters,            
	[6] = taskmgr.have_consumed_enough,      -- 5
	[7] = taskmgr.have_passed_level,       --6
	[7] = taskmgr.have_wear_equip,         --7
	[11] = taskmgr.have_melt_enough_times,     --11
    [15] = taskmgr.have_enough_daily_score,    -- 15
    [20] = taskmgr.have_wear_equip,
    [21] = taskmgr.strengthen_equip,
    [22] = taskmgr.upgrade_equip,
    [23] = taskmgr.inset_gem,
    [24] = taskmgr.upgrade_gem,
    [25] = taskmgr.equip_resonances,
    [26] = taskmgr.gem_max_level,
    [31] = taskmgr.arena_single,
    [32] = taskmgr.arena_team,
    [33] = taskmgr.arena_single_victory,
    [34] = taskmgr.arena_team_victory,
    [35] = taskmgr.arena_rank_1v1,
    [36] = taskmgr.arena_rank_3v1,
    [37] = taskmgr.arena_single_total,
    [38] = taskmgr.arena_team_total,
    [39] = taskmgr.arena_single_victory_total,
    [40] = taskmgr.arena_team_victory_total,
    [41] = taskmgr.lab_harvest,
    [42] = taskmgr.lab_steal,
    [43] = taskmgr.lab_help,
    [44] = taskmgr.lab_harvest_total,
    [45] = taskmgr.lab_steal_total,
    [46] = taskmgr.lab_help_total,
    [51] = taskmgr.kill_boss,
    [52] = taskmgr.kill_boss_total,
    [61] = taskmgr.quick_fight,
    [62] = taskmgr.quick_fight_total,
}


return taskmgr