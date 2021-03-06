local skynet = require "skynet"
local sprotoloader = require "sprotoloader"

local max_client = 64

skynet.start(function()
	print("Server start")
	skynet.uniqueservice("protoloader")
	local console = skynet.newservice("console")
	skynet.newservice("debug_console",skynet.getenv("debug_console_port"))
	skynet.newservice("simplenews")
	skynet.newservice("chatroom")
	skynet.newservice("mysql_service")
--	skynet.newservice("redis_service")
	skynet.newservice("player_data_center")
	skynet.newservice("online_center")
	skynet.newservice("rank_service")
	skynet.newservice("http_console_service")
	skynet.newservice("lab_service")
	skynet.newservice("arena_service")
	skynet.newservice("update_service")
	skynet.newservice("activation_service")
	skynet.newservice("friend_service")


	local watchdog = skynet.newservice("watchdog")
	skynet.call(watchdog, "lua", "start", {
		port = skynet.getenv("watchdog_port"),
		maxclient = max_client,
		nodelay = true,
	})
	print("Watchdog listen on ", skynet.getenv("watchdog_port"))

	skynet.exit()
end)
