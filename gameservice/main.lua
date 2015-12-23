local skynet = require "skynet"
local sprotoloader = require "sprotoloader"

local max_client = 64

skynet.start(function()
	print("Server start")
	skynet.uniqueservice("protoloader")
	local console = skynet.newservice("console")
	skynet.newservice("debug_console",8000)
	skynet.newservice("simplenews")
	skynet.newservice("chatroom")
	skynet.newservice("mysql_service")
--	skynet.newservice("redis_service")
	skynet.newservice("robot")
	skynet.newservice("player_data_center")
	skynet.newservice("online_center")
	skynet.newservice("rank_service")
	skynet.newservice("http_console_service")
	skynet.newservice("lab_service")
	skynet.newservice("arena_service")
	skynet.newservice("update_service")


	local watchdog = skynet.newservice("watchdog")
	skynet.call(watchdog, "lua", "start", {
		port = 8888,
		maxclient = max_client,
		nodelay = true,
	})
	print("Watchdog listen on ", 8888)

	skynet.exit()
end)
