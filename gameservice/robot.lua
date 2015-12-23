local skynet = require "skynet"
require "skynet.manager"	-- import skynet.register
local db = {}

local command = {}

function command.ADDROBOT(count)
	local redis_single_fp_name = "fp_single_rank"
	local redis_team_fp_name = "fp_team_rank"
	local redis_1v1_name = "1v1_rank"
	local redis_3v3_name = "3v3_rank"

    for i=1,count do
    	log(i)
        local tbl = { 
                        playerid = i+1000000 , 
                        nickname = "robot"..i+1000000 , 
                        imageid = i%10 , 
                        level = 15 , 
                        one_vs_one_fp = 10000-i*10,
                        three_vs_three_fp = 30000 - i*10,
                        one_vs_one_soul = 
                        { 
                            soulid = 0 , 
                            itemids = { 1,-1,-1,-1,-1,-1,-1,-1 } , 
                            soul_girl_id = 1 
                        } ,
                        one_vs_one_items = 
                        {  
                            { itemid = 1, itemtype = 2010101 , itemextra = 0 , itemcount = 1} , 
                            { itemid = 2 , itemtype = 2010102 , itemextra = 0 ,itemcount = 1} , 
                        } ,

                        three_vs_three_souls = 
                        { 
                            { soulid = 0 , itemids = { 1,-1,-1,-1,-1,-1,-1,-1 } , soul_girl_id = 1},
                            { soulid = 1 , itemids = { -1,2,-1,-1,-1,-1,-1,-1 } , soul_girl_id = 2},
                            { soulid = 2 , itemids = { -1,-1,-1,-1,-1,-1,-1,-1 } , soul_girl_id = 3},
                        },

                        three_vs_three_items = 
                        {
                            { itemid = 1 , itemtype = 2010101 , itemextra = 0 , itemcount = 1},
                            { itemid = 2 , itemtype = 2010102 , itemextra = 0 , itemcount = 1},
                        }
                    }

        skynet.call("REDIS_SERVICE","lua","proc","set",""..(1000000+i).."_data",dump(tbl))
        skynet.call("REDIS_SERVICE","lua","proc","zadd",redis_single_fp_name,i,""..tbl.playerid)
        skynet.call("REDIS_SERVICE","lua","proc","zadd",redis_team_fp_name,i,""..tbl.playerid)
        skynet.call("REDIS_SERVICE","lua","proc","zadd",redis_1v1_name,i,""..tbl.playerid)
        skynet.call("REDIS_SERVICE","lua","proc","zadd",redis_3v3_name,i,""..tbl.playerid)

    end
    log ("init robot!")
end


skynet.start(function()
	skynet.dispatch("lua", function(session, address, cmd, ...)
		local f = command[string.upper(cmd)]
		if f then
			skynet.ret(skynet.pack(f(...)))
		else
			error(string.format("Unknown command %s", tostring(cmd)))
		end
	end)
	skynet.register "ROBOT"
end)
