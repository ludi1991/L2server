local shopmgr = {}
local itemmgr

-- local skynet = require "skynet"
local shopData = require "data.shop_data"
local dropData = require "data.drop_data"

function shopmgr:init(player)
    self.player = player
    itemmgr = require "gamelogic.itemmgr"
end

function shopmgr:get_drop_item_info(dropid)
    local weights = {}
    local totalWeight = 0
    local count = 1
    while dropData[dropid]["rd_drop_id"..count] do
        local weight = dropData[dropid]["rd_drop_weight"..count]
        if count == 1 then
            table.insert(weights,weight)
        else
            table.insert(weights,weight+weights[count-1])
        end
        totalWeight = totalWeight + weight
        count = count + 1
    end

    local ans = 1
    local rd = math.random()
    for i,v in pairs(weights) do
        if rd <= v/totalWeight then
            ans = i
            break
        end
    end

    return dropData[dropid]["rd_drop_id"..ans], dropData[dropid]["rd_drop_num"..ans]
end

-- .shopitem {
--     pos 0 : integer #栏位
--     itemid 1 : integer #物品编号
--     item_number 2 : integer #物品单次购买的数量
--     have_bought 3 : integer #已购买次数
--     buy_limit 4 : integer #限制购买次数
--     is_recommend 5 : boolean #是否推荐
--     discount 6 : integer #折扣 1~100
-- }
function shopmgr:get_shop_items(shop_type)
    local shopitems = {}
    for i,v in pairs(shopData) do
--	log("shopData shop_type"..v.shop_type)
        if v.shop_type == shop_type then
--	    log("model "..v.model)
	    local itemtype, item_number = self:get_drop_item_info(v.model)
--	    log("itemid "..itemid.."item_number "..item_number)
	    local shopitem = {
                pos = v.pos,
                itemtype = itemtype,
                item_number = item_number,
                have_bought = 0,
                buy_limit = v.buy_limit,
                is_recommend = v.is_recommend,
                discount = v.discount
            }
	    if shopitem.is_recommend and shopitem.is_recommend == 1 then
		shopitem.is_recommend = true
	    else
		shopitem.is_recommend = false
	    end
            shopitems[v.pos] = shopitem
        end
    end
    return shopitems
end

function shopmgr:refresh(shop_type)
    local shop_data = {}
    local old_unique_id = self.player.shop[shop_type].unique_id or 0
    shop_data.shopitems = self:get_shop_items(shop_type)
    shop_data.unique_id = old_unique_id + 1
    self.player.shop[shop_type] = shop_data
end

function shopmgr:get_shop_data(shop_type)
    return self.player.shop[shop_type].shopitems, self.player.shop[shop_type].unique_id
end

function shopmgr:shop_buy(shop_type, pos, unique_id)
    local mshopdata = self.player.shop[shop_type]

    if unique_id ~= mshopdata.unique_id then return 2 end --商店已经刷新过
    local shopitem = mshopdata.shopitems[pos]
    if shopitem.buy_limit and  shopitem.have_bought >= shopitem.buy_limit then return 3 end --购买次数不足
    local item = itemmgr:get_details(shopitem.itemtype)
    local cost_gold = 0
    local cost_diamond = 0
    if item.price then cost_gold = item.price*shopitem.item_number*shopitem.discount/100 end
    if item.price_diamond then cost_diamond = item.price_diamond*shopitem.item_number*shopitem.discount/100 end
    if self.player.basic.gold < cost_gold or self.player.basic.diamond < cost_diamond then return 4 end --货币不足

    --success
    self.player.basic.gold = self.player.basic.gold - cost_gold
    self.player.basic.diamond = self.player.basic.diamond - cost_diamond
    itemmgr:add_item(shopitem.itemtype, shopitem.item_number)
    shopitem.have_bought = shopitem.have_bought + 1

    return 1
end

--test
-- math.randomseed(os.time())
-- print(shopmgr:get_drop_item_info(100001))
-- print(shopmgr:get_drop_item_info(110001))
-- print(shopmgr:get_drop_item_info(120001))
--end of test

return shopmgr
