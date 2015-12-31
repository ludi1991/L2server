local skynet = require "skynet"
require "skynet.manager"    -- import skynet.register
local keys = 
{
    ["G1AV3SI9"] = true,
    ["Y3OVQSYO"] = true,
    ["HDNB3SRH"] = true,
    ["DK7JCAEZ"] = true,
    ["O6JAXFML"] = true,
    ["A4HUL7XY"] = true,
    ["SVJFF6H5"] = true,
    ["FLW4K5Y9"] = true,
    ["LPNXMBF6"] = true,
    ["XTUU8GGI"] = true,
    ["R0H7MVXC"] = true,
    ["H80XWD8Q"] = true,
    ["Z36UE25X"] = true,
    ["QUSFF9RI"] = true,
    ["AKTFVQ41"] = true,
    ["V5KFK1OD"] = true,
    ["EIODZAB0"] = true,
    ["HV7TAI29"] = true,
    ["O9DBJYWD"] = true,
    ["TSTBR0OV"] = true,
    ["O8WFK56Y"] = true,
    ["U8Q9RI55"] = true,
    ["J39LB3G5"] = true,
    ["7BUZ58QD"] = true,
    ["A26P2K7Q"] = true,
    ["WTFGYMFO"] = true,
    ["PB36OQQW"] = true,
    ["7HNLHWSF"] = true,
    ["ZW3FFAYD"] = true,
    ["UA7YQQGA"] = true,
    ["2V3V2NG0"] = true,
    ["OOPAGAII"] = true,
    ["EDSXZQ2R"] = true,
    ["82VYLXOC"] = true,
    ["E5DFLIYD"] = true,
    ["2F64R2PJ"] = true,
    ["BHZ1GLPU"] = true,
    ["73PVX9O9"] = true,
    ["EDCSTB65"] = true,
    ["JLK811EY"] = true,
    ["4T0ZAPA5"] = true,
    ["WZKO8UO9"] = true,
    ["CCQX069P"] = true,
    ["TEQLZSR9"] = true,
    ["CACCR0NZ"] = true,
    ["OYJBUHOB"] = true,
    ["V17UUUBQ"] = true,
    ["YSP94C9Y"] = true,
    ["ISLXXTHY"] = true,
    ["USXVFOCA"] = true,
    ["DVEEAY1Q"] = true,
    ["AJKGLOGC"] = true,
    ["WVC5GN9T"] = true,
    ["V41FRK26"] = true,
    ["GD4M0MRH"] = true,
    ["EPGE623Z"] = true,
    ["25VKHNS2"] = true,
    ["UQH7Q8BR"] = true,
    ["G8DKKNJM"] = true,
    ["PKFR5NI4"] = true,
    ["TPWIFMEQ"] = true,
    ["VUN4B3MX"] = true,
    ["2R5T0HLP"] = true,
    ["3FFJMBOE"] = true,
    ["QM0R40G0"] = true,
    ["M33PZ2AW"] = true,
    ["EHT9WTE7"] = true,
    ["SX6NJV0M"] = true,
    ["00EUBZVX"] = true,
    ["JB2YXZ10"] = true,
    ["8WB1OWIC"] = true,
    ["AG1LFCI1"] = true,
    ["FO6ODQEK"] = true,
    ["D5M9VQAK"] = true,
    ["25EA7CE0"] = true,
    ["L7G0PB65"] = true,
    ["M0DR34LR"] = true,
    ["B0DATS3V"] = true,
    ["DE75EIB8"] = true,
    ["K4RGV10S"] = true,
    ["95I0BJTU"] = true,
    ["L6I54FIH"] = true,
    ["2WJ9MJBI"] = true,
    ["MZIXIBS7"] = true,
    ["2WA2NTKW"] = true,
    ["K2WMUNAO"] = true,
    ["V2M5SJ37"] = true,
    ["WWWYNIGR"] = true,
    ["WP9ZRXR6"] = true,
    ["VIEX4D4A"] = true,
    ["QYMNSC5Q"] = true,
    ["WXSXYE5P"] = true,
    ["MZ2UIFDD"] = true,
    ["EG1CLR5D"] = true,
    ["OL6ZT5PJ"] = true,
    ["TEEVF13S"] = true,
    ["F2ESI0DX"] = true,
    ["7LG0UVZA"] = true,
    ["5K8FFJ3U"] = true,
    ["9SRGOKQ7"] = true,
}

local used_keys = {}

local command = {}

function command.ISVALID(key)
    return keys[key] ~= nil
end

function command.USE(key)
    if not keys[key] then 
        return false
    else
        used_keys[key] = true
        keys[key] = nil
        return true
    end
end

function command.ADD(key)
end

function generate_keys()
    local fd = io.open("asdasd","w+")
    local thekey = {}
    for i=1,100 do
        local key = ""
        for m = 1,8 do 
            local char_num = math.random(48,57+26)
            if char_num > 57 then char_num = char_num + 7 end
            key = key..string.char(char_num)          
        end
        thekey[key] = true
    end
    fd:write(dump(thekey))
    fd:close()
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
    skynet.register "ACT_SERVICE"

  
end)
