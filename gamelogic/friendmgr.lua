local skynet = require "skynet"
local friendmgr = {}


function friendmgr:init(player)
	self.player = player
end

function friendmgr:get_friend_list()
    local tbl = {}
    for i,v in pairs(self.player.friend) do
        local data = skynet.call("DATA_CENTER","lua","get_player_data_part",v,"basic")
        table.insert(tbl,data)

   --     tbl[data.playerid] = data
      --  data.playerid = 1
    end
    log ("get friend")
    log (dump(tbl))
    return { list = tbl }
end

function friendmgr:add_friend(playerid)
end

function friendmgr:delete_friend(playerid)
end


return friendmgr