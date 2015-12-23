local NpcGen = require "npcgen"
local dump = require "dump"
local distribution = require "distribution"

local NpcFactory = {}
------------------------------------------------------------------
-- API:

-- require this file and call NpcFactory:Run()
-- it will return a npcList (table) which contains all npcs, indexed from 1 to npcCount

-- modify the config block below to change the distribution of npcs
------------------------------------------------------------------




-----------------------------------------
-- config
--
-- modify this block to change the distribution of npcs
-----------------------------------------


-- how many npcs are we going to produce
local npcCount = 15


-- a function which generates a level from npc's index
-- (index: how many npcs we have already produced)
local levelDistribution = function(npcIndex)
	return math.floor(distribution.uniform(2, 30))   -- lv 1 ~ 30 with uniform distribution

	--fewer low level or high level, more mediocore players
	--return math.floor(distribution.threePoints({x = 2, y = 0.1}, {x = 10, y = 0.8}, {x = 30, y = 0.1}))
end



-- a function which generates an iq
local iqDistribution = function(npcIndex)
	return distribution.uniform(0.5, 0.9)   -- iq = 0.5 ~ 0.9 with uniform distribution

	--fewer low iq or high iq, more mediocore players
	--return math.floor(distribution.threePoints({x = 0.5, y = 0.1}, {x = 0.75, y = 0.8}, {x = 0.9, y = 0.1}))
end



-- a function which generates random ids for npcs
local idGen = function(npcIndex)
	return npcIndex + 10000
end



-- a function which generates nicknames for npcs
local nameGen = function(npcIndex)
	return "Lu Di's girlfriend No."..tostring(npcIndex)
end



local writeNpcListToFile = true
local writeNpcListToScreen = false




---------------------------------------------
-- methods
--
-- usually you don't need to change this
---------------------------------------------

-- the overall wrap function
function NpcFactory:Run()
	NpcFactory:Init()
	NpcFactory:Produce()
	NpcFactory:Output()
	return self.npcList
end




function NpcFactory:Init()
	self.npcCount = npcCount
	self.levelDistribution = levelDistribution
	self.iqDistribution = iqDistribution
	self.idGen = idGen
	self.nameGen = nameGen

	self.npcList = {}  	-- to store the npc results
end


function NpcFactory:Produce()
	-- start generating
	for npcIndex = 1, npcCount do
		local level = self.levelDistribution(npcIndex)
		local iq = self.iqDistribution(npcIndex)
		local id = self.idGen(npcIndex)
		local name = self.nameGen(npcIndex)

		assert(level >= 1, "level < 1!! please check your level distribution function")
		assert(iq > 0 and iq <= 1, "iq not in range (0, 1]!!! please check your iq distribution function")
		assert(id >= 0, "id < 0!!! please check your id generator")
		assert(name, "name is invalid!! please check your name generator")

		local npc = NpcGen:GenerateNpc(level, iq, id, name)
		assert(npc, "we get a nil npc!!! npcGen error")

		table.insert(self.npcList, npc)
	end

	return npcList
end


function NpcFactory:Output()
	assert(self.npcList)
	local npcListStr
	if writeNpcListToScreen then
		npcListStr = dump(self.npcList)
		print(npcListStr)
	end

	if writeNpcListToFile then
		npcListStr = dump(self.npcList)
		fileOutput = io.open("output_npclist.lua", "w+")
		fileOutput:write(npcListStr)
		io.close(fileOutput)
	end
end

NpcFactory:Run()
return NpcFactory


