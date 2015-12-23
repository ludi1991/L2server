1. 生成一个npc数据：
npcgen.lua

使用方法：
目录下需要npcgen.lua 和 dump.lua两个文件

local NpcGen = require "npcgen"
local npcData = NpcGen:GenerateNpc(level, iq, id, name)
----------------
注：
level: 等级
iq: AI智商，0~1之间的浮点数，1表示升级全部装备到满级，0表示全部不升级，其他按照比例随机升级装备
id: 账户id
name: 账户昵称

返回值 table
npcData = {
		["souls"] = {...},
		["basic"] = { ...},
		["lab"] = {...},
		["config"] = {...},
		["tasks"] = {..},
		["items"] = {...},
	}
---------------

2. 生成一组npc数据
npcfactory.lua

使用方法：
目录下需要npcfactory.lua， npcgen.lua， 和 dump.lua 三个文件

local NpcFactory = require "npcfactory"
local npcList = NpcFactory:Run()

需要修改NpcFactory中的config模块来调整npc生成的数量和分布特征：

local npcCount  --需要生成的npc数量
local function levelDistribution   --npc等级范围和分布， 默认为均一分布 2~30级
local function iqDistribution      --npc iq 范围和分布，默认为均一分布 0.5~0.9
local function idGen    --npc id 生成函数：给每个npc一个唯一的id
local function nameGen   --npc 昵称生成函数：给每个npc取个名字

local writeNpcListToFile  --是否输出到文件Output_NpcList.lua，默认为true
local writeNpcListToScreen  --是否输出到屏幕，默认为false

返回值： table
npcList = {
	[1] = {(npc 1 data)}
	[2] = {(npc 2 data)}
	...
}

npc data 格式参考上一节