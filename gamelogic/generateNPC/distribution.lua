
-----------------------------------------
-- examples for distribution functions
--
-- some pre-defined functions that may be useful
-----------------------------------------
local distribution = {}
math.randomseed(tostring(os.time()):reverse():sub(1, 6))


-- uniform distribution
-- returns a uniform random number in range (a, b]
distribution.uniform = function(a, b)
	local tmp = math.random() * (b - a) + a
	--print("uniform random:", tmp)
	return tmp
end

-- two segments linear distribution
distribution.threePoints = function(point1, point2, point3)
	assert(point1 and point1.x and point1.y, "point 1 is invalid, use a format like: point = {x = 1, y = 2}")
	assert(point2 and point2.x and point2.y, "point 2 is invalid, use a format like: point = {x = 1, y = 2}")
	assert(point3 and point3.x and point3.y, "point 3 is invalid, use a format like: point = {x = 1, y = 2}")

	assert(point1.x <= point2.x and point2.x <= point3.x, "points are not in the increasing order")

	local S1, S2
	S1 = (point2.y + point1.y) * (point2.x - point1.x) / 2
	S2 = (point3.y + point2.y) * (point3.x - point2.x) / 2
	local tmp = math.random() * (S1 + S2)
	local seg
	if tmp < S1 then
		-- use the first segment to compute probability
		seg = 1
	else
		-- use the second segment to compute probability
		seg = 2
	end


	-- This can be optimized: we dont need to compute them every time
	local k1, b1, k2, b2
	if point2.x == point1.x then
		k1 = 0
		b1 = 0
	else
		k1 = (point2.y - point1.y) / (point2.x - point1.x)
		b1 = point1.y - k1 * point1.x
	end

	if point3.x == point2.x then
		k2 = 0
		b2 = 0
	else
		k2 = (point3.y - point2.y) / (point3.x - point2.x)
		b2 = point2.y - k2 * point2.x
	end

	--print(k1, b1, k2, b2)

	local value
	local u = math.random()  -- uniform in (0,1]
	if seg == 1 then
		local sign = (k1 < 0 and -1) or 1
		value = -b1 / k1 + sign * math.sqrt(2 * S1 * u / k1 + point1.x * point1.x + 2 * b1 / k1 * point1.x +   b1 * b1 / k1 / k1)

	else
		local sign = (k2 < 0 and -1) or 1
		value = -b2 / k2 + sign * math.sqrt(2 * S2 * u / k2 + point2.x * point2.x + 2 * b2 / k2 * point2.x + b2 * b2 / k2 / k2)

	end

	--print("3 points: ", value)
	return value
end

function distribution:test()
	local testFile = io.open("test_distribution.txt", "w+")
	local testNum = 10000
	local point1 = {x = 0, y = 1}
	local point2 = {x = 1, y = 2}
	local point3 = {x = 2, y = 1}

	for i = 1, testNum do
		--testFile:write(string.format("%d\t%.3f\n", i, self.uniform(0,1)))
		testFile:write(string.format("%d\t%.3f\n", i, self.threePoints(point1, point2, point3)))
	end

	io.close(testFile)
end

--distribution:test()

return distribution



