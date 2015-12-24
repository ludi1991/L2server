local skynet = require "skynet"
local socket = require "socket"
local httpd = require "http.httpd"
local sockethelper = require "http.sockethelper"
local urllib = require "http.url"
local table = table
local string = string

local mode = ...

if mode == "agent" then

local function response(id, ...)
    local ok, err = httpd.write_response(sockethelper.writefunc(id), ...)
    if not ok then
        -- if err == sockethelper.socket_error , that means socket closed.
        skynet.error(string.format("fd = %d, %s", id, err))
    end
end

local command = {}

function command.GET_PLAYER_DATA(playerid)
    local playerid = tonumber(playerid)
    if playerid then
        local data,source_from = skynet.call("DATA_CENTER","lua","get_player_data",playerid)
        log("source from"..source_from)
        return dump(data)
    else
        return "wrong playerid "..playerid 
    end
end

function command.GET_ARENA_DATA(arena_type)
    local arena_type = tonumber(arena_type)
    local data = skynet.call("ARENA_SERVICE","lua","dump",arena_type)
    return dump(data)
end

function command.DAILY_UPDATE()
    local count = skynet.call("UPDATE_SERVICE","lua","update")
    return "ok ".. count .."player is updated"
end

function command.KICK_PLAYER(playerid)
end

function command.SHUTDOWN()
    local res = skynet.call("ONLINE_CENTER","lua","send_to_online_players","kick")
end


skynet.start(function()
    skynet.dispatch("lua", function (_,_,id)
        socket.start(id)
        -- limit request body size to 8192 (you can pass nil to unlimit)
        local code, url, method, header, body = httpd.read_request(sockethelper.readfunc(id), 8192)
        if code then
            if code ~= 200 then
                response(id, code)
            else
                local tmp = {}
                if header.host then
               --     table.insert(tmp, string.format("host: %s", header.host))
                end
                local path, query = urllib.parse(url)
                --table.insert(tmp, string.format("path: %s", path))
                
                if query then
                    local q = urllib.parse_query(query)
                    -- for k, v in pairs(q) do
                    --     table.insert(tmp, string.format("query: %s= %s", k,v))
                    -- end
                    log(dump(q))
                    local cmd = q.command or ""
                    log(cmd)
                    
                    local f = command[string.upper(cmd)]
                    if f then
                        local str = f(q.para1,q.para2,q.para3,q.para4)
                        table.insert(tmp,str)
                    else
                        log("http command not exist")
                    end
                end


                -- table.insert(tmp, "-----header----")
                -- for k,v in pairs(header) do
                --     table.insert(tmp, string.format("%s = %s",k,v))
                -- end
                -- table.insert(tmp, "-----body----\n" .. body)
                -- local data = skynet.call("DATA_CENTER","lua","get_player_data",888)
                response(id, code, table.concat(tmp,"\n"))

            end
        else
            if url == sockethelper.socket_error then
                skynet.error("socket closed")
            else
                skynet.error(url)
            end
        end
        socket.close(id)
    end)
end)

else

skynet.start(function()
    local agent = {}
    for i= 1, 20 do
        agent[i] = skynet.newservice(SERVICE_NAME, "agent")
    end
    local balance = 1
    local id = socket.listen("0.0.0.0", 8001)
    skynet.error("Listen web port 8001")
    socket.start(id , function(id, addr)
        skynet.error(string.format("%s connected, pass it to agent :%08x", addr, agent[balance]))
        skynet.send(agent[balance], "lua", id)
        balance = balance + 1
        if balance > #agent then
            balance = 1
        end
    end)
end)

end