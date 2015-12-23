local skynet = require "skynet"
require "skynet.manager"    -- import skynet.register


local agent = {}
local command = {}


function command.CHAT(msg)
    for _,v in pairs(agent) do
        skynet.call(v,"lua","chat",msg)
    end    
end

function command.LOGIN(fd)
    print "chat room login!"
    agent[fd] = fd
  --  command.CHAT({name = fd,msg = "I'm logon"})
end

function command.LOGOUT(fd)
    print "chat room logout"
   -- command.CHAT({name = fd,msg = "I'm logoff"})
    agent[fd] = nil 
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
    skynet.register "CHATROOM"
end)
