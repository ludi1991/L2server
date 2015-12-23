local equipManager = require "controller.equip_manager"

--根据力量敏捷等属性重新计算伤害命中暴击值
function global_CalculatePower(chara, skillList)
    local power = 0
    if chara then
        power = power + chara.hp + chara.damage * 10 + chara.armorpenetration * 10
            + chara.defence * 10 + chara.hit * 10 + chara.dodge * 10
            + chara.critical * 10 + chara.toughness * 10 + chara.cridamageadd * 5
            + chara.critouchness * 5
    end

    if skillList then 
        for i = 1, 4 do
            if skillList[i] then
                power = power + skillList[i].level * i * 10
            end
        end
    end
    return power
end

--获得所有装备的属性综合值 参数传入为itemList， 包含装备id， 宝石镶嵌，强化等级等
function global_CalEquipmentAddtion(itemList)
    local addtition_attributes = {strength = 0, agility = 0, intelligence = 0, hp = 0, 
                        damage = 0, armorpenetration = 0, defence = 0, hit = 0,
                        dodge = 0, critical = 0, toughness = 0, cridamageadd = 0, critouchness = 0}
    
    if not itemList then return addtition_attributes end

    for i=1, #itemList do
        if itemList[i]~=nil then
            local equip = global_getEquipStrengthened(itemList[i])
            if equip ~= nil then
                addtition_attributes.critical = addtition_attributes.critical + (equip.critical or 0)
                addtition_attributes.defence =  addtition_attributes.defence+ (equip.defence or 0)
                addtition_attributes.damage =  addtition_attributes.damage + (equip.damage or 0)
                addtition_attributes.dodge =  addtition_attributes.dodge + (equip.dodge or 0)
                addtition_attributes.toughness =  addtition_attributes.toughness + (equip.toughness or 0)
                addtition_attributes.agility =  addtition_attributes.agility + (equip.agility or 0)
                addtition_attributes.strength =  addtition_attributes.strength + (equip.strength or 0)
                addtition_attributes.intelligence =  addtition_attributes.intelligence + (equip.intelligence or 0)
                addtition_attributes.hp =  addtition_attributes.hp + (equip.hp or 0)
                addtition_attributes.hit =  addtition_attributes.hit + (equip.agility or 0)
                addtition_attributes.armorpenetration =  addtition_attributes.armorpenetration + (equip.armorpenetration or 0)
                addtition_attributes.cridamageadd =  addtition_attributes.cridamageadd + (equip.cridamageadd or 0)
                addtition_attributes.critouchness =  addtition_attributes.critouchness + (equip.critouchness or 0)
            end
        end
    end
    return addtition_attributes
end

--根据装备强化，宝石镶嵌等属性计算装备的各项属性值
function global_getEquipStrengthened(itemvalue)
    local allequips_data = require "data.equipdata"

    local strengthenTab = equipManager:getStrengthenTab()
    local equip = {}
    for i,v in pairs(allequips_data[itemvalue.item_entity_id]) do
        equip[i] = v
    end
    
    local addAttri = 0
    for i = 1,  itemvalue.strengthenLv do
        local curStrnData = strengthenTab[equip.equip_quality][i]
        addAttri = addAttri + curStrnData.strengthen_attribute
    end
    
    if equip.hp then
        equip.hp = equip.hp + (addAttri or 0)
    elseif equip.hit then
        equip.hit = equip.hit + (addAttri or 0)
    elseif equip.dodge then
        equip.dodge = equip.dodge + (addAttri or 0)
    elseif equip.damage then
        equip.damage = equip.damage + (addAttri or 0)
    elseif equip.defence then
        equip.defence = equip.defence + (addAttri or 0)
    elseif equip.critical then
        equip.critical = equip.critical + (addAttri or 0)
    elseif equip.toughness then
        equip.toughness = equip.toughness + (addAttri or 0)
    elseif equip.critouchness then
        equip.critouchness = equip.critouchness + (addAttri or 0)
    elseif equip.cridamageadd then
        equip.cridamageadd = equip.cridamageadd + (addAttri or 0)
    elseif equip.armorpenetration then
        equip.armorpenetration = equip.armorpenetration + (addAttri or 0)
    end

       --增加宝石属性
    if itemvalue.gemsid then
        for k, gemid in pairs(itemvalue.gemsid) do
            if gemid~= -1 then
                local gemdata = allequips_data[gemid]
                equip[gemdata.main_attribute] = (equip[gemdata.main_attribute] or 0) + gemdata[gemdata.main_attribute]
            end
        end
    end

    return equip
end