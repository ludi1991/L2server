local drop_manager = {}

local dropData = require "data.drop_data"

--输入概率列表，返回通过概率得出第几个下标，如果总和不满1，则有（1-总和）概率返回：下标+1
--举个栗子，输入{0.1,0.2,0.3}，有10%概率返回1，20%概率返回2，30%返回3，40%返回4
local function randValueByRate(rateTable)
    local totalRate = {}
    totalRate[1] = rateTable[1]
    for i=2,#rateTable do
        totalRate[i] = totalRate[i-1] + rateTable[i]
    end

    local randv = math.random()
    for i=1,#totalRate do
        if randv<= totalRate[i] then return i end
    end

    return #rateTable+1
end

--参数：关卡数据中的 equip_drop
--return dropList[1...n] = {dropid = xxxx, dropNum = k}
function drop_manager:getEquipDrops(id)
    local dropList  = {}

    local dropTable = {} --通过id存储掉落数量与概率
    -- dropTable[n].nums = {}   --会在末尾添上0，表示不掉落
                        --exp dropTable.nums = {1,2,3,0}
    -- dropTable[n].rates = {}  --exp dropTable.rates = {0.1,0.2,0.3}
    local count = 1
    print ("ludiaaabb "..id)
    while dropData[id]["drop_id"..count] do
        local dropid = dropData[id]["drop_id"..count]
        if dropTable[dropid] == nil then dropTable[dropid] = {} end
        if dropTable[dropid].nums == nil then dropTable[dropid].nums = {} end
        if dropTable[dropid].rates == nil then dropTable[dropid].rates = {} end
        dropTable[dropid].nums[#dropTable[dropid].nums+1] = dropData[id]["drop_num"..count]
        dropTable[dropid].rates[#dropTable[dropid].rates+1] = dropData[id]["drop_rate"..count]
        count = count+1
    end

    for i,v in pairs(dropTable) do
        v.nums[#v.nums+1] = 0
        local n = #dropList+1
        local num = v.nums[randValueByRate(v.rates)]
        if num > 0 then
            dropList[n] = {}
            dropList[n].dropid = i
            dropList[n].dropNum = num
            print("id.."..id.."..ljj drop equips id:"..i.." num:"..num)
        end
    end

    if #dropList == 0 then print("ljj id.."..id.."..no equips") end

    return dropList 
end

function drop_manager:getEquipDropsByMonsterId(monsterId)
    local monsterData = require "data.monster_data"
    return drop_manager:getEquipDrops(monsterData[monsterId].equip_drop)
end

function drop_manager:getGold(id)
    if dropData[id].gold then return dropData[id].gold end
    return 0
end

function drop_manager:getDiamond(id)
    if dropData[id].diamond then return dropData[id].diamond end
    return 0
end

function drop_manager:getHero(id)
    return dropData[id].hero
end

function drop_manager:getDropMsg(id)
    local dropMsg = {}
    dropMsg.gold = drop_manager:getGold(id)
    dropMsg.diamond = drop_manager:getDiamond(id)
    dropMsg.equips = drop_manager:getEquipDrops(id)
    dropMsg.hero = drop_manager:getHero(id)

    return dropMsg
end

return drop_manager