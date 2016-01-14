local model_manager = {}

require "controller.global_func"

function model_manager:generateCharacter(level, major, itemList, skillList)
    local majorfacLi = require "data.major_factor_data"
    majorfacLi = majorfacLi[major]

    local chara = {}
    chara.level = level
    chara.major = major
    chara.strength = 0
    chara.rage = 0
    chara.agility = 0
    chara.cridamageadd = 0
    chara.critouchness = 0
    chara.intelligence = 0


    local  addtition_attributes = global_CalEquipmentAddtion(itemList)
    chara.strength = chara.strength + addtition_attributes.strength
    chara.agility  = chara.agility + addtition_attributes.agility
    chara.intelligence = chara.intelligence + addtition_attributes.intelligence

    --基础属性
    -- local damageAddFactorList = {chara.strength, chara.agility, chara.intelligence}
    -- local curDamageAdd = damageAddFactorList[(chara.major-1)%3+1] * 20
    local commonLvFac =  math.floor(200 * 1.25^(level / 2) * 0.2) 
    chara.critical = commonLvFac * majorfacLi.t_cri + chara.agility * 10
    chara.toughness= commonLvFac * majorfacLi.t_tough + chara.intelligence * 10
    chara.damage   = commonLvFac * majorfacLi.t_damage * 1
    chara.hp       = commonLvFac * majorfacLi.t_hp * 10 + chara.strength * 100
    chara.hit      = commonLvFac * majorfacLi.t_hit + chara.strength * 10
    chara.dodge    = commonLvFac * majorfacLi.t_dodge + chara.agility * 10
    chara.defence  = commonLvFac * majorfacLi.t_defence + chara.strength * 10
    chara.armorpenetration  = commonLvFac * majorfacLi.t_arm + chara.intelligence * 10

    -- log("basic pow------------------------------------"..global_CalculatePower(chara))

    --套装加成(套装加成基础属性%)
    local exPer = {0, 0.02, 0.04, 0.06, 0.08, 0.1}
    local equipids = {}
    for i,v in pairs(itemList) do
        table.insert(equipids, v.item_entity_id)
    end
    -- for i,v in pairs(equipids) do log("equipids----------------------------"..v) end
    local addPer = exPer[global_judgeGrade(equipids)+1]
    -- log("addPer-----------------------------------"..addPer)
    --只有这里会产生前面8种属性的小数点偏差,要取整
    chara.critical = math.floor(chara.critical*(1+addPer))
    chara.toughness = math.floor(chara.toughness*(1+addPer))
    chara.damage   = math.floor(chara.damage*(1+addPer))
    chara.hp       = math.floor(chara.hp*(1+addPer))
    chara.hit      = math.floor(chara.hit*(1+addPer))
    chara.dodge    = math.floor(chara.dodge*(1+addPer))
    chara.defence  = math.floor(chara.defence*(1+addPer))
    chara.armorpenetration  = math.floor(chara.armorpenetration*(1+addPer))

    -- for i,v in pairs(chara) do print(i,v) end

    -- log("add per pow------------------------------------"..global_CalculatePower(chara))

    --装备属性
    chara.hp = chara.hp + addtition_attributes.hp
    chara.damage = chara.damage + addtition_attributes.damage
    chara.armorpenetration = chara.armorpenetration + addtition_attributes.armorpenetration
    chara.defence = chara.defence + addtition_attributes.defence
    chara.hit = chara.hit + addtition_attributes.hit
    chara.dodge = chara.dodge + addtition_attributes.dodge
    chara.critical = chara.critical + addtition_attributes.critical
    chara.toughness = chara.toughness + addtition_attributes.toughness
    chara.cridamageadd = chara.cridamageadd + addtition_attributes.cridamageadd
    chara.critouchness = chara.critouchness + addtition_attributes.critouchness

    chara.power = global_CalculatePower(chara, skillList)
    -- for i,v in pairs(chara) do print(i,v) end
    -- log("chara.power------------------------------------"..chara.power)
    return chara
end

return model_manager

