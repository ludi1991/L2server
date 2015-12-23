package.cpath = "luaclib/?.so"
package.path = "lualib/?.lua;examples/?.lua"

if _VERSION ~= "Lua 5.3" then
	error "Use lua 5.3"
end

local socket = require "clientsocket"
local proto = require "proto"
local sproto = require "sproto"

local host = sproto.new(proto.s2c):host "package"
local request = host:attach(sproto.new(proto.c2s))

local fd = assert(socket.connect("127.0.0.1", 8888))

local function send_package(fd, pack)
	local package = string.pack(">s2", pack)
    function mypack(str)
        local size = #str
        local a = size % 256
        size = math.floor(size / 256)
        local b = size 
        return string.char(b)..string.char(a)..str
    end
    local package2 = mypack(pack)
    
	socket.send(fd, package2)
end

function printbyte(str)

    local out = ""
    for i=1,#str do
        out = out.."-"..str:byte(i)
    end
    print (out)
end



local function unpack_package(text)
	
    
	local size = #text
	if size < 2 then
		return nil, text
	end

	
	local s = text:byte(1) * 256 + text:byte(2)
	if size < s+2 then
		return nil, text
	end

	return text:sub(3,2+s), text:sub(3+s)
end

local function recv_package(last)
	local result
	result, last = unpack_package(last)
	if result then
		return result, last
	end
	local r = socket.recv(fd)
	if not r then
		return nil, last
	end
	if r == "" then
		error "Server closed"
	end
	return unpack_package(last .. r)
end

local session = 0

local function send_request(name, args)
	session = session + 1
	local str = request(name, args, session)
	send_package(fd, str)
	print("Request:", session)
end

local last = ""

local function print_request(name, args)
	print("REQUEST", name)
	if args then
		for k,v in pairs(args) do
			print(k,v)
		end
	end
end

local function print_response(session, args)
	print("RESPONSE", session)
	if args then
		for k,v in pairs(args) do
			print(k,v)
		end
	end
end

local function print_package(t, ...)
	if t == "REQUEST" then
		print_request(...)
	else
		assert(t == "RESPONSE")
		print_response(...)
	end
end

local function dispatch_package()
	while true do
		local v
		v, last = recv_package(last)
		if not v then
			break
		end
		if v ~= nil then
        	print (printbyte(v))
        end
		print_package(host:dispatch(v))
	end
end

function string.split(str, delimiter)
	if str==nil or str=='' or delimiter==nil then
		return nil
	end
	
    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end



while true do
	dispatch_package()
	local cmd = socket.readstdin()
	if cmd then
		local split = string.split(cmd," ")

		if cmd == "quit" then
			send_request("quit")
		elseif split[1] == "set" then
			send_request("set", { what = split[2] , value = split[3]})
		else 
			send_request("get", { what = cmd })
		end
	else
		socket.usleep(100)
	end
end
