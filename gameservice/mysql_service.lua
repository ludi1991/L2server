local skynet = require "skynet"
require "skynet.manager"
local mysql = require "mysql"

local command = {}
local db

function command.QUERY(str)
   -- log ("mysql_service query "..str,"info")
    res = db:query(str)
    return res
end

skynet.start(function()
    
    db=mysql.connect{
        host=skynet.getenv("mysql_host"),
        port=skynet.getenv("mysql_port"),
        database=skynet.getenv("mysql_database"),
        user=skynet.getenv("mysql_user"),
        password=skynet.getenv("mysql_password"),
        max_packet_size = 1024 * 1024
    }
    if not db then
        print("failed to connect")
    end
    print("mysql_service success to connect to mysql server")

    skynet.dispatch("lua", function(session, address, cmd, ...)
        local f = command[string.upper(cmd)]
        if f then
            skynet.ret(skynet.pack(f(...)))
        else
            error(string.format("Unknown command %s", tostring(cmd)))
        end
    end)
    skynet.register "MYSQL_SERVICE"
    --db:query("set names utf8")
  

    -- local res = db:query("drop table if exists cats")
    -- res = db:query("create table cats "
    --                    .."(id serial primary key, ".. "name varchar(5))")
    -- print( dump( res ) )

    -- res = db:query("insert into cats (name) "
    --                          .. "values (\'Bob\'),(\'\'),(null)")
    -- print ( dump( res ) )

    -- res = db:query("select * from cats order by id asc")
    -- print ( dump( res ) )

    -- -- test in another coroutine
    -- skynet.fork( test2, db)
    -- skynet.fork( test3, db)
    -- -- multiresultset test
    -- res = db:query("select * from cats order by id asc ; select * from cats")
    -- print ("multiresultset test result=", dump( res ) )

    -- print ("escape string test result=", mysql.quote_sql_str([[\mysql escape %string test'test"]]) )

    -- -- bad sql statement
    -- local res =  db:query("select * from notexisttable" )
    -- print( "bad query test result=" ,dump(res) )

    -- local i=1
    -- while true do
    --     local    res = db:query("select * from cats order by id asc")
    --     print ( "test1 loop times=" ,i,"\n","query result=",dump( res ) )

    --     res = db:query("select * from cats order by id asc")
    --     print ( "test1 loop times=" ,i,"\n","query result=",dump( res ) )


    --     skynet.sleep(1000)
    --     i=i+1
    -- end

    --db:disconnect()
    --skynet.exit()
end)

