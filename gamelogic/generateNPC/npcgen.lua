local dump = require "dump"
local NpcGen = {}
local MAX_QUALITY = 4	-- there are 4 classes of quality
local MAX_LEVEL = 10	-- an equipment will upgrade to next class once they reach lv 10

local debugPrint = false 	-- should we print debug info on the screen?



---------------------------------------------------------
-- API function

-- call this method to generate a table representing a npc
-- with the desired level, iq, id and nickname
---------------------------------------------------------
function NpcGen:GenerateNpc(level, iq, id, name)
	local npcData = {}
	local souls, items = self:GenerateSouls(level, iq)
	local basic, lab, config, tasks = self:GenerateMisc(level, id, name, "2015-12-02 11:02:30", "2015-12-02 13:57:50")

	npcData.souls = souls
	npcData.items = items
	npcData.basic = basic
	npcData.config = config
	npcData.tasks = tasks

	return npcData
end






-----------------------------------
-- methods
-----------------------------------


--------------method: NpcGen---------------

-- spend all upgrades points randomly on equipments
function NpcGen:selectUpgrades(level, iq, souls, items)
	if debugPrint then
		print("----------Start selecting upgrades...")
	end
	assert(souls, "souls is nil")
	assert(items, "items is nil")

	-- how many items are available for upgrade
	local upgradableItemCount = 0

	-- calculate how many upgrades we could have
	local maxUpgrades = 0

	-- get a list of all equipments of all souls
	local equipList = {}

	for _, soul in pairs(souls) do
		for i = 1, 8 do
			local itemid = soul.itemids[i]
			if itemid >= 0 then
				-- valid item id
				table.insert(equipList, itemid)
				upgradableItemCount = upgradableItemCount + 1
				maxUpgrades = maxUpgrades + level
			end
		end
	end


	-- given an IQ (from 0 ~ 1), we can see how many points the npc will spend on upgrades
	local upgradePoints = math.floor(iq * maxUpgrades)


	-- start random
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))

	while upgradableItemCount > 0  and  upgradePoints > 0 do
		local index = math.random(upgradableItemCount)  -- get a random number in range [1, upgradableItemCount]
		if debugPrint then
			print("---upgradable items:", upgradableItemCount, "points:", upgradePoints)
			print("random", index)
		end
		-- upgrade the item in pos index
		local itemid = equipList[index]
		local item = items[itemid]

		if debugPrint then
			print("itemid:", itemid, item)
		end


		local currentLv = item.itemextra % 100 + (item.itemtype % 10 - 1) * 10
		if currentLv < level then
			-- still upgradable, spend 1 point on this
			item.itemextra = item.itemextra + 1
			upgradePoints = upgradePoints - 1
		end


		local itemNotUpgradable = false
		if currentLv >= level then
			itemNotUpgradable = true
		end


		-- upgrade to next class equip
		if item.itemextra % 100  >= MAX_LEVEL then


			if item.itemtype % 10 < MAX_QUALITY then
				-- can upgrade
				local newItem = {["itemtype"] = item.itemtype + 1, ["itemextra"] = item.itemextra - 10, ["itemid"] = item.itemid, ["itemcount"] = 1}
				items[itemid] = newItem
			else
				-- not upgradable
				item.itemextra = item.itemextra - (item.itemextra % 100 - 10)
				upgradePoints = upgradePoints + (item.itemextra % 100 - 10)
				itemNotUpgradable = true
			end
		end

		if itemNotUpgradable then
			-- not upgradable, move to tail
			equipList[index], equipList[upgradableItemCount] = equipList[upgradableItemCount], equipList[index]
			upgradableItemCount = upgradableItemCount - 1
		end
	end

end



---------------- method generateSouls --------------------

-- generate equip and items data for npc
function NpcGen:GenerateSouls(level, iq)
	local souls = {}
	local items = {}
	local NumberOfEquipmentsEachSoul = {}
	local itemid = 1

	local maxSouls = 1
	if(level > 5) then maxSouls = 2 end
	if(level > 10) then maxSouls = 3 end
	if(level > 15) then maxSouls = 4 end

	if debugPrint then
		print(maxSouls)
	end

	for i = 1, maxSouls do
		local soul_itemids = {-1,-1,-1,-1,-1,-1,-1,-1}
		if debugPrint then
			print("-----soul: ", i)
		end
		-- calculate number of equipments
		-- note: currently we have 100% drop chance for most of the equipments, so we can use a simple function to determine item counts
		-- however, this may change in the future, and the following method is recommmended:

		-- according to the drop table, simulate item drops and equip the best equipments

		NumberOfEquipmentsEachSoul[i] = level - (i - 1) * 5 - 1
		if NumberOfEquipmentsEachSoul[i] >= 5 then
			NumberOfEquipmentsEachSoul[i] = NumberOfEquipmentsEachSoul[i] - 1
		end


		if NumberOfEquipmentsEachSoul[i] > 8 then
			NumberOfEquipmentsEachSoul[i] = 8
		elseif NumberOfEquipmentsEachSoul[i] < 0 then
			NumberOfEquipmentsEachSoul[i] = 0
		end

		if debugPrint then
			print("NumberOfEquipments: ", NumberOfEquipmentsEachSoul[i])
		end

		-- insert equip into items and equips list

		for j = 1, NumberOfEquipmentsEachSoul[i] do
			local itemtype = 2000000 + i * 10000 + j * 100 + 1

			if debugPrint then
				print("type: ", itemtype, "id: ", itemid)
			end

			-- insert into item list
			local item = { 			["itemcount"] = 1, 			["itemtype"] = itemtype, 			["itemextra"] = 100, 			["itemid"] = itemid, 		}
			items[itemid] = item

			-- insert into soul list
			soul_itemids[j] = itemid

			itemid = itemid + 1
		end


		-- insert soul into souls list
		-- i.e. insert equipments for one girl to overall equip list
		table.insert(souls, {["soul_girl_id"] = i, ["soulid"] = i, ["itemids"] = soul_itemids})

	end


	-- generate strengthen data
	if nil == iq then
		iq = 1
	end

	self:selectUpgrades(level, iq, souls, items)


	-- debug output
	--print(dump(souls))
	--print(dump(items))

	--self.souls = souls
	--self.items = items
	--self.iq = iq


	return souls, items
end



----------------------- method generateMisc ---------------------------

-- generate data other than items and souls
-- i.e. basic, lab, config, tasks
function NpcGen:GenerateMisc(level, playerid, nickname, create_time, last_login_time)
	local maxSouls = 1
	if(level > 5) then maxSouls = 2 end
	if(level > 10) then maxSouls = 3 end
	if(level > 15) then maxSouls = 4 end

	local gold = math.random(3000 * level)

	local unlock_soul = {}
	for i = 1, maxSouls do
		table.insert(unlock_soul, i)
	end


	-- set misc data
	local basic = {["playerid"] = playerid, 		["level"] = level, 		["nickname"] = nickname,
						["create_time"] = create_time, 		["cur_stayin_level"] = 1, 		["last_login_time"] = last_login_time,
							["diamond"] = 0, 		["cursoul"] = maxSouls, 		["gold"] = gold}

	local lab = { 		["be_helped_list"] = { 		}, 		["help_list"] = { 		}, 		["keys"] = 5, 		["hourglass"] = { 		}, 		["keeper"] = 1, 	}
	local config = { 		["unlock_soul"] = unlock_soul,
								["soulid_1v1"] = 1,
								["soulid_3v3"] = { 			[1] = 1, 			[2] = 2, 			[3] = 3, 		},
								["stat"] = { 			["total_online_time"] = 0, 			["gold_consumed"] = 0, 			["diamond_consumed"] = 0, 			["melt_times"] = 0, 		},
								["finished_tasks"] = { 		}, 	}
	local tasks = {}

	--print(dump(basic))
	--print(dump(lab))
	--print(dump(config))
	--print(dump(tasks))

	return basic, lab, config, tasks
end



---------------- test function --------------------

function NpcGen:test()

	--self:GenerateSouls(8)
	--self:GenerateMisc(8, 2323, "shit", "2015-12-02 11:02:30", "2015-12-02 13:57:50")
	local npc = self:GenerateNpc(8, 0.6, 1, 'shit')
	if debugPrint then
		print(dump(npc))
	end

	local test_playerData = { 	["souls"] = {
				[1] = {
					["soul_girl_id"] = 1,
					["itemids"] = {
						[1] = 2, 				[2] = 3, 				[3] = 4, 				[4] = 5, 				[5] = -1, 				[6] = -1, 				[7] = -1, 				[8] = -1, 			},
					["soulid"] = 1, 		},
				[2] = {
					["soul_girl_id"] = 2,
					["itemids"] = {
						[1] = -1, 				[2] = -1, 				[3] = -1, 				[4] = -1, 				[5] = -1, 				[6] = -1, 				[7] = -1, 				[8] = -1, 			},
					["soulid"] = 2, 		}, 	},

			["basic"] = { 		["playerid"] = 759, 		["level"] = 8, 		["nickname"] = "new73195", 		["create_time"] = "2015-12-02 11:02:30", 		["cur_stayin_level"] = 7, 		["last_login_time"] = "2015-12-02 13:57:50",
							["diamond"] = 0, 		["cursoul"] = 2, 		["gold"] = 14401, 	},

			["lab"] = { 		["be_helped_list"] = { 		}, 		["help_list"] = { 		}, 		["keys"] = 5, 		["hourglass"] = { 		}, 		["keeper"] = 1, 	},
			["config"] = { 		["unlock_soul"] = { 			[1] = 1, 			[2] = 2, 		},
								["soulid_1v1"] = 1,
								["soulid_3v3"] = { 			[1] = 1, 			[2] = 2, 			[3] = 3, 		},
								["stat"] = { 			["total_online_time"] = 0, 			["gold_consumed"] = 0, 			["diamond_consumed"] = 0, 			["melt_times"] = 0, 		},
								["finished_tasks"] = { 		}, 	},
			["tasks"] = { 		[1] = { 			["taskid"] = 1, 			["percent"] = 100, 		}, 		[16] = { 			["taskid"] = 16, 			["percent"] = 0, 		},
								[13] = { 			["taskid"] = 13, 			["percent"] = 0, 		}, 		[8] = { 			["taskid"] = 8, 			["percent"] = 0, 		}, 	},
			["items"] = {
					[1] = { 			["itemcount"] = 1, 			["itemtype"] = 1300002, 			["itemextra"] = 100, 			["itemid"] = 1, 		},
					[2] = { 			["itemcount"] = 1, 			["itemtype"] = 2010101, 			["itemextra"] = 100, 			["itemid"] = 2, 		},
					[3] = { 			["itemcount"] = 1, 			["itemtype"] = 2010201, 			["itemextra"] = 100, 			["itemid"] = 3, 		},
					[4] = { 			["itemcount"] = 1, 			["itemtype"] = 2010301, 			["itemextra"] = 105, 			["itemid"] = 4, 		},
					[5] = { 			["itemextra"] = 105, 			["itemtype"] = 2010401, 			["itemcount"] = 1, 			["itemid"] = 5, 		},
					[6] = { 			["itemextra"] = 100, 			["itemcount"] = 1, 			["itemtype"] = 2010501, 			["itemid"] = 6, 		},
					[7] = { 			["itemextra"] = 100, 			["itemcount"] = 1, 			["itemtype"] = 2010601, 			["itemid"] = 7, 		},
					[8] = { 			["itemextra"] = 100, 			["itemcount"] = 1, 			["itemtype"] = 2010701, 			["itemid"] = 8, 		},
					[1000001] = { 			["itemextra"] = 100, 			["itemcount"] = 569, 			["itemtype"] = 1000001, 			["itemid"] = 1000001, 		},
					[1100101] = { 			["itemcount"] = 2, 			["itemtype"] = 1100101, 			["itemextra"] = 100, 			["itemid"] = 1100101, 		}, 	},
		}
end

--NpcGen:test()

return NpcGen
