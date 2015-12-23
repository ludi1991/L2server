local skynet = require "skynet"
require "skynet.manager"	-- import skynet.register
local sharedata = require "sharedata"

local shop_tbl = {}

local command = {}

local function init_shop_data()
	
end

function command.GET_SHOP_DATA(playerid)
	if not shop_tbl[playerid] then

	
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
    
	skynet.register "SHOP_SERVICE"

end)
