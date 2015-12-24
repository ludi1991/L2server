local surnameList = require "gamelogic.name_generator.surname"
local boynameList = require "gamelogic.name_generator.boyname"
local girlnameList = require "gamelogic.name_generator.girlname"
--local lc = require "lc"
-----------------------------------------
-- useage
-----------------------------------------
-- local nameGen = require "namegen"
-- local name = nameGen:GenerateName(isBoy)



---- function nameGen:GenerateName(isBoy) ----

-- parameter: isBoy (a bool value, default false)
-- return values (4 strings) : name_ansi, name_utf8, surname_utf8, lastName_utf8
-- name_ansi: complete name in ansi encoding
-- name_utf8: complete name in utf8 encoding
-- surname_utf8: surname in utf8 encoding
-- lastName_utf8: last name in utf8 encoding


-- usually the name_ansi will suffice


-----------------------------------------
-- defines
-----------------------------------------

local nameGen = {}
nameGen.SetRandomSeed = nil
nameGen.GenerateName = nil
nameGen.test = nil


local defaultSurname = "Missing "
local defaultLastName = "Missing"




-----------------------------------------
-- method
-----------------------------------------

function nameGen:GenerateName(isBoy)
	local surnameCount = #surnameList
	--print("count:", surnameCount)
	local randomId = math.random(surnameCount)
	--print("id:", randomId)
	local surname = surnameList[randomId].surname
	surname = string.gsub(surname, "^(.+),(.+)$", "%2")
	--print("surname: ", surname)
	if not surname or #surname < 1 then
		surname = defaultSurname
	end


	local lastName
	if isBoy then
		local boynameCount = #boynameList
		--print("count:", boynameCount)
		randomId = math.random(boynameCount)
		--print("id:", randomId)
		lastName = boynameList[randomId].lastname
		--print("last name: ", lastName)
		if not lastName or #lastName < 1 then
			lastName = defaultLastName
		end
	else
		local girlnameCount = #girlnameList
		--print("count:", girlnameCount)
		randomId = math.random(girlnameCount)
		--print("id:", randomId)
		lastName = girlnameList[randomId].lastname
		--print("last name: ", lastName)
		if not lastName or #lastName < 1 then
			lastName = defaultLastName
		end
	end

	local name_utf8 = surname..lastName
	--local name_ansi = lc.u2a(name_utf8)
	--print("name:", name_utf8, name_ansi)
	return name_utf8, surname, lastName
end


function nameGen:SetRandomSeed()
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
end


function nameGen:test()
	self:SetRandomSeed()
	self:GenerateName(true)
	self:GenerateName(false)
end

--nameGen:test()

return nameGen
