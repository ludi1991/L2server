
--common functions


function dump(obj,oneline)
    local getIndent, quoteStr, wrapKey, wrapVal, dumpObj
    getIndent = function(level)
        return string.rep("\t", level)
    end
    quoteStr = function(str)
        return '"' .. string.gsub(str, '"', '\\"') .. '"'
    end
    wrapKey = function(val)
        if type(val) == "number" then
            return "[" .. val .. "]"
        elseif type(val) == "string" then
            return "[" .. quoteStr(val) .. "]"
        else
            return "[" .. tostring(val) .. "]"
        end
    end
    wrapVal = function(val, level)
        if type(val) == "table" then
            return dumpObj(val, level)
        elseif type(val) == "number" then
            return val
        elseif type(val) == "string" then
            return quoteStr(val)
        else
            return tostring(val)
        end
    end
    dumpObj = function(obj, level)
        if type(obj) ~= "table" then
            return wrapVal(obj)
        end
        level = level + 1
        local tokens = {}
        tokens[#tokens + 1] = "{"
        for k, v in pairs(obj) do
            tokens[#tokens + 1] = getIndent(level) .. wrapKey(k) .. " = " .. wrapVal(v, level) .. ","
        end
        tokens[#tokens + 1] = getIndent(level - 1) .. "}"

        local thestr = "\n"
        if oneline then thestr = " " end
        return table.concat(tokens, thestr)
    end
    return dumpObj(obj, 0)
end




function string:split(sep)
	local sep, fields = sep or "\t", {}
	local pattern = string.format("([^%s]+)", sep)
	self:gsub(pattern, function(c) fields[#fields+1] = c end)
	return fields
end

function log(msg,level)
    -- level = level or 5
    -- local leveltbl = { "fetal","error","warning","info","debug"}
    if level == nil then level = "debug" end
    local info = debug.getinfo(2)
    if info then
        msg = string.format("------[%s][%s:%d] %s",level ,info.short_src, info.currentline, msg)
    end
    print (msg)
end

function parse_time(str)
   -- local str = "1991-02-28 13:23:30"
    local strsp = string.split(str," ")
    local date,time = strsp[1],strsp[2]
    local datesp = string.split(date,"-")
    local timesp = string.split(time,":")
    return  { 
                year = tonumber(datesp[1]) ,
                month = tonumber(datesp[2]) , 
                day = tonumber(datesp[3]) ; 
                hour = tonumber(timesp[1]), 
                min = tonumber(timesp[2]) ,
                sec = tonumber(timesp[3])
            }
end