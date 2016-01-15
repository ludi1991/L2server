local skynet = require "skynet"
require "skynet.manager"    -- import skynet.register

--[[ {
   [1037] = { 
        count = 0 ,
        [1044] = true,
   } 
}]]
local friend_list = {}

local command = {}


function register(playerid)
    if not friend_list[playerid] then
        friend_list[playerid] = {
            count = 0,
            request_ids = {},
            responding_ids = {},
            ids = {},
        }
    end
end


function command.ADD_FRIEND(playerid,friendid)
    if not friend_list[playerid] then register(playerid) end
    if not friend_list[friendid] then register(friendid) end
    if friend_list[playerid][friendid] then
        -- have friend
        return -1
    end

    if friend_list[playerid].count >= 100 then
        -- player have more than 100 friends
        return -2
    end

    if friend_list[friendid].count >= 100 then
        -- friend have more than 100 friends
        return -3
    end

    friend_list[playerid].ids[friendid] = true;
    friend_list[friendid].ids[playerid] = true;
    friend_list[playerid].count = friend_list[playerid].count + 1;
    friend_list[friendid].count = friend_list[playerid].count + 1;

    return 1
    
end

function command.DELETE_FRIEND(playerid,friendid)
    if not friend_list[playerid] or friend_list[friendid] then
        return -1
    end

    if not friend_list[playerid].ids[friendid] then
        return -2
    end

    if not friend_list[friendid].ids[playerid] then
        return -3
    end

    friend_list[playerid].ids[friendid] = nil;
    friend_list[friendid].ids[playerid] = nil;
    friend_list[playerid].count = friend_list[playerid].count - 1;
    friend_list[friendid].count = friend_list[playerid].count - 1;
    return 1

end

function command.GET_FRIEND_LIST(playerid)
    return friend_list[playerid] or {}
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
    skynet.register "FRIEND_SERVICE"

end)
