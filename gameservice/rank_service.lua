local skynet = require "skynet"
require "skynet.manager"	-- import skynet.register

local command = {}

local rank_single = {}
local rank_team = {}


local ROBOT_COUNT = 1000

function command.REGISTER(playerid)
end


function command.GET_PLAYERID_BY_INDEX(index,rank_type)
    return 1000000+index
end

function command.GET_INDEX_BY_PLAYERID(playerid,rank_type)
    return 10000
end

function command.SET_FIGHT_POWER(playerid,power,rank_type)
    return true
end


local function add_robot()
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
	skynet.register "RANK_SERVICE"

end)
