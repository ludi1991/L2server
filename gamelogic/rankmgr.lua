local skynet = require "skynet"
local rankmgr = {}


function rankmgr:init(player)
    self.player = player
end

function rankmgr:get_player_rank(rank_type)
    local player = self.player
    local rank = skynet.call("RANK_SERVICE","lua","get_index_by_playerid",player.basic.playerid,rank_type)
    local fight_power = skynet.call("DATA_CENTER","lua","get_player_fightpower",player.basic.playerid,rank_type,1)
    return { rank = rank , fightpower = fight_power}
end


function rankmgr:get_rank_data(start,count,rank_type)
    local res = {}
    for i=start,start+count-1 do
        local playerid = skynet.call("RANK_SERVICE","lua","get_playerid_by_index",i,rank_type)
        local data = skynet.call("DATA_CENTER","lua","get_player_data",playerid)
        local fight_power = skynet.call("DATA_CENTER","lua","get_player_fightpower",playerid,rank_type,1)
        table.insert(res,
        {
            playerid = playerid,
            name = data.basic.nickname,
            score = fight_power,
            rank = i,
            level = data.basic.level,
            head_sculpture = data.basic.head_sculpture,
        })
    end
    return { data = res }
end



return rankmgr