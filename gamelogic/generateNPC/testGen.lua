local dump = require "dump"


-- TODO
-- souls
-- lv
-- basic
-- items

local function displaySouls()
end


-- spend all upgrades points randomly on equipments
local function selectUpgrades(level, iq, souls, items)
	print("----------Start selecting upgrades...")
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
	local upgradePoints = iq * maxUpgrades


	-- start random
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))

	while upgradableItemCount > 0  and  upgradePoints > 0 do
		local index = math.random(upgradableItemCount)  -- get a random number in range [1, upgradableItemCount]

		print("---upgradable items:", upgradableItemCount, "points:", upgradePoints)
		print("random", index)
		-- upgrade the item in pos index
		local itemid = equipList[index]
		local item = items[itemid]
		print("itemid:", itemid, item)


		local currentLv = item.itemextra % 100
		if currentLv < level then
			-- still upgradable, spend 1 point on this
			item.itemextra = item.itemextra + 1
			upgradePoints = upgradePoints - 1
		end

		if currentLv >= level then
			-- not upgradable, move to tail
			equipList[index], equipList[upgradableItemCount] = equipList[upgradableItemCount], equipList[index]
			upgradableItemCount = upgradableItemCount - 1
		end
	end

end


local function generateSouls(level, quality)
	local souls = {}
	local items = {}
	local NumberOfEquipmentsEachSoul = {}
	local itemid = 1

	local maxSouls = 1
	if(level > 5) then maxSouls = 2 end
	if(level > 10) then maxSouls = 3 end
	if(level > 15) then maxSouls = 4 end

	print(maxSouls)

	for i = 1, maxSouls do
		local soul_itemids = {-1,-1,-1,-1,-1,-1,-1,-1}

		print("-----soul: ", i)
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

		print("NumberOfEquipments: ", NumberOfEquipmentsEachSoul[i])


		-- insert equip into items and equips list

		for j = 1, NumberOfEquipmentsEachSoul[i] do
			local itemtype = 2000000 + i * 10000 + j * 100 + 1
			print("type: ", itemtype, "id: ", itemid)

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
	if nil == quality then
		quality = 1
	end

	selectUpgrades(level, quality, souls, items)


	-- debug output
	print(dump(souls))
	print(dump(items))
	return souls, items
end



local function test()
	generateSouls(8)
end

test()


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
