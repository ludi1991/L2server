local itemmgr = {}
local taskmgr 
local statmgr

itemmgr.items = {}

local item_data = require "data.equipdata"

function itemmgr:init(player)
    self.player = player
	self.items = player.items
    taskmgr = require "gamelogic.taskmgr"
    statmgr = require "gamelogic.statmgr"
end


function itemmgr:can_stack(itemtype)
	--if itemid == 1000001 then return true end
	if itemtype < 2000000 or itemtype >= 3000000 then return true end
	return false
end

function itemmgr:generate_new_id()
    local i=1
    while self.items[i] do
        i = i+1
    end
	return i
end

function itemmgr:get_details(itemtype)
	return item_data[itemtype]
end

function itemmgr:add_item_by_object(item)
	if self:have_item(item.itemid) then
		self.items[item.itemid].itemcount = self.items[item.itemid].itemcount + item.itemcount
	else
		self.items[item.itemid] = item
	end
	return true
end

function itemmgr:add_item(itemtype,count)	
    count = count or 1
	local items = self.items
    if self:can_stack(itemtype) then
        if items[itemtype] == nil then
            items[itemtype] = {
                itemid = itemtype,
                itemtype = itemtype,
                itemcount = count,
        	}
            taskmgr:update_tasks_by_condition_type(E_GEM_MAX_LEVEL)    
        	return items[itemtype]
        else
            items[itemtype].itemcount = items[itemtype].itemcount + count
            return items[itemtype]
        end
    else
		local newid = self:generate_new_id()
	    items[newid] = {
            itemid = newid,
	        itemtype = itemtype,
	        itemextra = 0,
	        itemcount = 1,
		}
		return items[newid]
	end
end

function itemmgr:delete_item(itemid,count)
    --log("delete_item"..itemid)
	count = count or 1
	if self:have_item(itemid,count) then
		self.items[itemid].itemcount = self.items[itemid].itemcount - count
		if self.items[itemid].itemcount == 0 then
			self.items[itemid] = nil
		end
	    return true
	else 
		return false
    end
end

-- itemid
function itemmgr:have_item(itemid,count)
	count = count or 1
	if self.items[itemid] ~= nil and self.items[itemid].itemcount >= count then
		return true
	else
		return false
	end
end

function itemmgr:have_item_by_itemtype(itemtype,count)
    count = count or 1
    for i,v in pairs(self.items) do
        if v.itemtype == itemtype and v.itemcount >= count then
            return true
        end
    end
    return false
end


function itemmgr:upgrade_gem(itemtype)
    local gold = self:get_details(itemtype).price
    local count = self:get_details(itemtype).upgrade_cost
	if self.player.basic.gold < gold then
		return false
	end  
	if self:have_item(itemtype,count) then
		if self:delete_item(itemtype,count) then
			self:add_item(itemtype+1,1)
			self.player.basic.gold = self.player.basic.gold - gold

            statmgr:add_daily_stat("upgrade_gem")
            taskmgr:update_tasks_by_condition_type(E_UPGRADE_GEM)
            taskmgr:update_tasks_by_condition_type(E_GEM_MAX_LEVEL)      
			return true
		else
			return false
		end
	else
		return false
	end
end

function itemmgr:upgrade_gem_all(itemtype)
    local times = 0
    while self:upgrade_gem(itemtype) do
        times = times + 1
    end
    log(""..times)
    return times

    -- body
end


function itemmgr:item_add_hole(itemid)
    if self:have_item(itemid) then
    	if not self.items[itemid].gem_id then
    		self.items[itemid].gem_id = {}
    	end

        local next_hole = 1

        while self.items[itemid].gem_id[next_hole] do
            next_hole = next_hole + 1
        end

        local gold_cost = {3000,10000,30000,80000}
        if self.player.basic.gold < gold_cost[next_hole] then
            return false
        else
            self.player.basic.gold = self.player.basic.gold - gold_cost[next_hole]
    	    self.items[itemid].gem_id[next_hole] = -1

            return true
        end

    else
    	return false
    end
end

function itemmgr:item_inset_gem(itemid,gem_type,gem_hole_pos)
    log ("inset_gem"..itemid.." "..gem_type.." "..gem_hole_pos)
	if self:have_item(itemid) == false then return false end
	if self:have_item(gem_type) == false then return false end
	if self.items[itemid].gem_id[gem_hole_pos] ~= nil then
		self.items[itemid].gem_id[gem_hole_pos] = gem_type
        itemmgr:delete_item(gem_type,1)
        statmgr:add_daily_stat("inset_gem")
        taskmgr:update_tasks_by_condition_type(E_INSET_GEM)
		return true
	else 
		return false
	end

end

function itemmgr:item_pry_up_gem(itemid,gem_hole_pos)
	if self:have_item(itemid) == false then return false end
	for i,v in pairs(gem_hole_pos) do
		if self.items[itemid].gem_id[v] == nil then
			return false
		end
	end
    
	for i,v in pairs(gem_hole_pos) do
		self:add_item(self.items[itemid].gem_id[v],1)
		self.items[itemid].gem_id[v] = -1
       
	end
    return true;
end

function itemmgr:add_stone(value)
	if value >= 0 then
		self:add_item(1000001,value)
	else
		self:delete_item(1000001,-value)
	end
	return true
end




function itemmgr:use_gift_bag(itemtype)
    log ("use gift "..itemtype)
    if not itemmgr:have_item(itemtype) then
        return  { result = 0 }
    else
        local dm = require "gamelogic.lua_for_server.controller.drop_manager"
        local item_data = require "data.equipdata"
        local drop_id = item_data[itemtype].mode_id
        local items = dm:getEquipDrops(drop_id)
        local gold = dm:getGold(drop_id)
        local diamond = dm:getDiamond(drop_id)
        local items_res = {}
        for _,item in pairs(items) do
            local item_gen = self:add_item(item.dropid,item.dropNum)
            table.insert(items_res,item_gen)
            --items_res[item_gen.itemid] = itemgen
        end
        self:delete_item(itemtype)

        return {
            result = 1,
            items = items_res,
            gold = gold,
            diamond = diamond,
        }
    end
end

function itemmgr:enchant(itemid)
    if itemmgr:have_item(itemid) then
        local need_gold = 1000
        local need_dust = 10
        if self.player.basic.gold >= need_gold then
            if itemmgr:have_item(1700001, need_dust) then
                local attr_string = {"hp", "damage", "armorpenetration", "defence", "hit", "dodge", "critical", "toughness"}
                local enchant_attrs = {}
                for i=1,3 do
                    local key = math.random(1,#attr_string)
                    enchant_attrs[i] = {}
                    enchant_attrs[i].key = attr_string[key]
                    local value = 300
                    if self.items[itemid].enchant_attrs then
                        value = self.items[itemid].enchant_attrs[i].value
                        if self.items[itemid].enchant_attrs[i].key == "hp" then
                            value = value/10
                        end
                    end
                    if attr_string[key] == "hp" then
                        enchant_attrs[i].value = value*10
                    else
                        enchant_attrs[i].value = value
                    end
                    table.remove(attr_string, key)
                end
                return {result = 1, enchant_attrs = enchant_attrs}
            else
                return {result = 3} --not enough dust
            end
        else
            return {result = 2} --not enough gold
        end
    else
        return {result = 4} --equip not exit
    end
end

function itemmgr:enchant_apply(itemid, enchant_attrs)
    if itemmgr:have_item(itemid) then
        self.items[itemid].enchant_attrs = enchant_attrs
        return {result = 1}
    else
        return {result = 2} --equip not exit
    end
end

function itemmgr:refine(itemid)
    if itemmgr:have_item(itemid) then
        local need_gold = 1000
        local item = self.items[itemid]
        if self.player.basic.gold >= need_gold then
            if item.enchant_attrs then
                local attributes = {}
                item.refine_times = (item.refine_times or 0) + 1
                for i=1,3 do
                    local reduce_rate = 1/(1+0.5+1/item.refine_times)
                    if math.random() < reduce_rate then
                        attributes[i] = math.random(-10,0)
                    else
                        attributes[i] = math.random(1,10)
                    end
                    if item.enchant_attrs[i].key == "hp" then
                        attributes[i] = attributes[i]*10
                    end
                end
                return {result = 1, attributes = attributes}
            else
                return {result = 3} --equip have not enchantend
            end
        else
            return {result = 2} --not enough gold
        end 
    else
        return {result = 4} --equip not exit
    end 
end

function itemmgr:refine_apply(itemid, attributes)
    if itemmgr:have_item(itemid) then
        if self.items[itemid].enchant_attrs then
            for i=1,3 do
                self.items[itemid].enchant_attrs[i].value = self.items[itemid].enchant_attrs[i].value + attributes[i]
            end
            return {result = 1}
        else
            return {result = 2} --equip have not enchantend
        end
    else
        return {result = 3} --equip not exit
    end
end

return itemmgr
