local skynet = require "skynet"
require "skynet.manager"
local redis = require "redis"



local conf = {
    host = "127.0.0.1" ,
    port = 6379 ,
    db = 0
}


local conf = {
    host = skynet.getenv("redis_addr") ,
    port = skynet.getenv("redis_port") ,
    db = 0
}

local command = {}
local db


local function watching()
    local w = redis.watch(conf)
    w:subscribe "abcde"
    w:psubscribe "hello.*"
    while true do
        print("Watch", w:message())
    end
end


function command.PROC(func,...)
    local res = db[func](db,...)
    return res
end


local redis_single_fp_name = "fp_single_rank"
local redis_team_fp_name = "fp_team_rank"
local redis_1v1_name = "1v1_rank"
local redis_3v3_name = "3v3_rank"

local function addrobot()
    for i=1,100 do
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
                            { itemid = 1 , itemtype = 1010101 , itemextra = 0 , itemcount = 1},
                            { itemid = 2 , itemtype = 1010101 , itemextra = 0 , itemcount = 1},
                        }
                    }

        db:set(""..(1000000+i).."_data",dump(tbl))
        db:zadd(redis_single_fp_name,i,""..tbl.playerid)
        db:zadd(redis_team_fp_name,i,""..tbl.playerid)     
        db:zadd(redis_1v1_name,i,""..tbl.playerid)
        db:zadd(redis_3v3_name,i,""..tbl.playerid)


    end
    log ("finished robot!")
end

skynet.start(function()
    
    db = redis.connect(conf)
    if not db then
        print ("redis_connection failed")
    end

    skynet.dispatch("lua",function(session,address,cmd,...)
        local f = command[string.upper(cmd)]
        if f then
            skynet.ret(skynet.pack(f(...)))
        else
            error(string.format("Unknown command %s", tostring(cmd)))
        end
    end)
    skynet.register "REDIS_SERVICE"
    if skynet.getenv("add_robot") then
        addrobot()
    end
    skynet.fork(watching)
    --print (db:zrange(redis_single_fp_name,0,2))
    
    -- db:del "C"
    -- db:set("A", "hello")
    -- db:set("B", "world")
    -- db:sadd("C", "one")

    -- print(db:get("A"))
    -- print(db:get("B"))

    -- db:del "D"
    -- for i=1,10 do
    --     db:hset("D",i,i)
    -- end
    -- local r = db:hvals "D"
    -- for k,v in pairs(r) do
    --     print(k,v)
    -- end

    -- db:multi()
    -- db:get "A"
    -- db:get "B"
    -- local t = db:exec()
    -- for k,v in ipairs(t) do
    --     print("Exec", v)
    -- end

    -- print(db:exists "A")
    -- print(db:get "A")
    -- print(db:set("A","hello world"))
    -- print(db:get("A"))
    -- print(db:sismember("C","one"))
    -- print(db:sismember("C","two"))

    -- print("===========publish============")

    -- for i=1,10 do
    --     db:publish("foo", i)
    -- end
    -- for i=11,20 do
    --     db:publish("hello.foo", i)
    -- end

    --db:disconnect()
    
--  skynet.exit()
end)

