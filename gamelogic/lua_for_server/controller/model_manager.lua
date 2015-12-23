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

    local damageAddFactorList = {chara.strength, chara.agility, chara.intelligence}
    local curDamageAdd = damageAddFactorList[(chara.major-1)%3+1] * 20
    local commonLvFac =  math.floor(200 * 1.25^(level / 2) * 0.2) 
    chara.critical = 0 * majorfacLi.t_cri + chara.agility * 10
    chara.toughness= 0 * majorfacLi.t_tough + chara.intelligence * 10
    chara.damage   = commonLvFac * majorfacLi.t_damage * 1 + curDamageAdd
    chara.hp       = commonLvFac * majorfacLi.t_hp * 10 + chara.strength * 100
    chara.hit      = commonLvFac * majorfacLi.t_hit + chara.strength * 10
    chara.dodge    = commonLvFac * majorfacLi.t_dodge + chara.agility * 10
    chara.defence  = commonLvFac * majorfacLi.t_defence + chara.strength * 10
    chara.armorpenetration  = commonLvFac * majorfacLi.t_arm + chara.intelligence * 10

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

    return chara
end

return model_manager

