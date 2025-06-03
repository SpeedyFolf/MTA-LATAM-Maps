function math.randomDiff (start, finish)
	math.randomseed(getTickCount())
	if (start and finish) then
		if (math.floor(start) ~= start) or (math.floor(finish) ~= finish) then return false end
		if (start >= finish) then return false end
	end
	if not start then
		local rand = math.random()
		while (rand == lastRand) do
			rand = math.random()
		end
		lastRand = rand
		return rand
	end

	if not finish then
		finish = start
		start = 1
	end

	local rand = math.random(start, finish)
	while (rand == lastRand) do
		rand = math.random(start, finish)
	end
	lastRand = rand
	return rand
end

function findRotation(x1, y1, x2, y2) 
	local t = -math.deg( math.atan2(x2 - x1, y2 - y1))
	return t < 0 and t + 360 or t
end

addEventHandler("onPlayerVehicleEnter", root, function(vehicle, seat, jacked)
	setElementFrozen(vehicle, true)
	removePedFromVehicle(source)

	local spawnpoints = {}
	for _, v in pairs(getElementsByType("fighter", resourceRoot)) do
		table.insert(spawnpoints, {x = getElementData(v, "posX"), y = getElementData(v, "posY"), z = getElementData(v, "posZ")})
	end

	local randomSpawn = math.randomDiff(#spawnpoints)
	setElementPosition(source, spawnpoints[randomSpawn].x, spawnpoints[randomSpawn].y, spawnpoints[randomSpawn].z)
	setElementRotation(source, 0, 0, findRotation(spawnpoints[randomSpawn].x, spawnpoints[randomSpawn].y, 1480.3, 1453.6), "default", true)

	for _, player in ipairs(getElementsByType("player")) do
		setElementHealth(player, 33)
	end

	setElementFrozen(source, true)
	setTimer(function(player) toggleAllControls(player, false) end, 300, 1, source)
end )

addEvent("onRaceStateChanging", true)
addEventHandler("onRaceStateChanging", root, function(newState, oldState)
	if oldState == "GridCountdown" and newState == "Running" then
		for _, player in ipairs(getElementsByType("player")) do
			setElementFrozen(player, false)
			toggleAllControls(player, true)

			local styles = {4, 5, 6, 7, 15, 16}
			setPedFightingStyle(player, styles[math.random(#styles)])
		end
	end
end )
