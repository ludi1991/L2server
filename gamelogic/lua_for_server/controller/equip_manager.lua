local equip_manager = {}

local equipData = require "data.equipdata"
local equipStrengthenData = require "data.equip_strengthen"

local strengthenTable = {}

function equip_manager:calStrengthenTab()
    for i = 1, 5 do
        strengthenTable[i] = {}
    end

    for k,v in pairs(equipStrengthenData) do
        strengthenTable[v.equip_quality][v.intensify_level] = v
    end
end

function equip_manager:getStrengthenTab()
    return strengthenTable
end

function equip_manager:init()
    self:calStrengthenTab()
end

equip_manager:init()

return equip_manager