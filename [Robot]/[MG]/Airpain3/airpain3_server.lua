-- on player finish

BIG_CARS = { [514] = true, [406] = true, [431] = true, [532] = true, [476] = true, [495] = true,[486] = true, [515] = true, [444] = true }
CHECKPOINTS = getElementsByType("checkpoint")
TIME_UNTIL_BLIPS = 210000

g_dodos = {}
g_drivers = {}

function onRaceStateChanging(newState, oldState)
	if (newState == "GridCountdown") then
		triggerClientEvent(root, "spawnFirstDodos", resourceRoot, g_dodos)
		at400 = getElementByID("AT400")
		at400p = getElementByID("AT400Parent")
		attachElements(at400, at400p)
		x,y,z = getElementPosition(at400p)
		moveObject(at400p, 6000, x, y-500, z)
		setTimer(function()
			moveObject(at400p, 24000, x, y-2500, z+200, 90, 0, 0)
		end, 6000, 1)
		for i,v in pairs(getElementsByType("vehicle")) do
			-- setVehicleDamageProof(v, false)
			-- setVehicleEngineState(v, true)
			setElementData(v, "race.collideothers", 0)
			setElementFrozen(v, false)
			setElementCollisionsEnabled(v, true)
			player = getVehicleOccupant(v)
			if (player) then
				setElementData(player, "airpain3.dodosDestroyed", 0)
				toggleAllControls(player, false, true, false)
				x2,y2,z2 = getElementPosition(v)
				distance = y - y2

				distance = distance - 253
				distance = distance * 11.3
				distance = distance + 2827

				
				if (x2 < 1470 or x2 > 1485) then
					distance = distance + 150
				end
				
				left = math.random()
				left = left * 0.7
				left = left + 0.3
				if (x2 < x) then
					left = left * -1
				end
				forward = math.random()
				forward = forward + 0.5
				forward = forward * -1
				
				up = math.random()
				up = up * 0.5
				
				angularX = math.random() - 0.5
				angularY = math.random() - 0.5
				angularZ = math.random() - 0.5
				angularX = angularX / 10
				angularY = angularY / 10
				angularZ = angularZ / 10
				

				
				model = getElementModel(v)
				if (BIG_CARS[model] ~= true and (x2 < 1470 or x2 > 1485) and math.random() < 0.85) then
					left = 0
					forward = 0
					up = 0
					angularX = 0
					angularY = 0
					angularZ = 0
				end
				setElementData(v, "airpain3.left", left)
				setElementData(v, "airpain3.forward", forward)
				setElementData(v, "airpain3.up", up)
				
				setTimer(function()
					setElementVelocity(v, getElementData(v,"airpain3.left"), getElementData(v,"airpain3.forward"), getElementData(v,"airpain3.up"))
					setElementAngularVelocity(v, (math.random() - 0.5)/10 , (math.random() - 0.5)/10, (math.random() - 0.5)/10)
				end, distance, 1)
			end
			--setElementVelocity(v, 0.3, 0.9, 0.6)		
		end
	elseif (newState == "Running" and oldState == "GridCountdown") then
		triggerClientEvent(root, "raceStateRunning", resourceRoot)
		handling = getModelHandling(429)
		for i, v in pairs(getElementsByType("vehicle")) do
			if (getVehicleOccupant(v)) then
				setVehicleProperties(nil, v)
			end
		end
		revealTimer = setTimer(function()
			triggerClientEvent(root, "markDodosOnMap", resourceRoot)
		end, TIME_UNTIL_BLIPS, 1)
		--triggerClientEvent(root, "setOpponentCollisions", resourceRoot)
	elseif (newState == "SomeoneWon") then
		if isTimer(revealTimer) then killTimer(revealTimer) end
		triggerClientEvent(root, "markDodosOnMap", resourceRoot)
	end	
end
addEvent("onRaceStateChanging", true)
addEventHandler("onRaceStateChanging", root, onRaceStateChanging)

function onMapStarting()
	dodos = getElementsByType("dodo")
	for i = #dodos, 1, -1 do
		newI = math.random(1, i)
		table.insert(g_dodos, dodos[newI])
		table.remove(dodos, newI)
	end

	drivers = getElementsByType("driver")
	for i = #drivers, 1, -1 do
		newI = math.random(1, i)
		table.insert(g_drivers, drivers[newI])
		table.remove(drivers, newI)
	end
	players = getElementsByType("player")
	for i = 1, #players, 1 do
		setElementData(players[i], "airpain3.driver", g_drivers[(i % #g_drivers) + 1])
	end
	for i, v in pairs(getElementsByType("vehicle")) do
		if (getVehicleOccupant) then
			setVehicleProperties(nil, v)
		end
	end
end
addEventHandler("onMapStarting", root, onMapStarting)

function onVehicleEnter(thePlayer, seat, jacked)
	if (not getElementType(thePlayer) == "player") then
		return
	end
	setVehicleProperties(thePlayer)
	setTimer(function()
		setVehicleProperties(thePlayer)
	end, 2000, 0)
end
addEventHandler("onVehicleEnter", root, onVehicleEnter)

function onPlayerResourceStart()
	setElementData(source, "airpain3.driver", g_drivers[math.random(#g_drivers)])
	setVehicleProperties(source)
	triggerClientEvent(source, "spawnFirstDodos", resourceRoot, g_dodos)
	joinedPlayer = source
end
addEventHandler("onPlayerResourceStart", root, onPlayerResourceStart)

function setVehicleProperties(thePlayer, vehicle)
	if not vehicle and not thePlayer then return end
	if not vehicle then 
		if not isElement(thePlayer) then return end
		vehicle = getPedOccupiedVehicle(thePlayer)
	end
	if not thePlayer then
		thePlayer = getVehicleOccupant(vehicle)
	end
	if not vehicle or not thePlayer then return end
	driver = getElementData(thePlayer, "airpain3.driver")
	vehicle = getPedOccupiedVehicle(thePlayer)
	handling = getModelHandling(415)
	model = getElementData(driver, "model")
	paintjob = getElementData(driver, "paintjob")
	color = getElementData(driver, "color")
	plateText = getElementData(driver, "plate")
	colors = {}
	for col in string.gmatch(color, '([^,]+)') do
		table.insert(colors, col)
	end
	setElementModel(vehicle, model)
	setVehiclePaintjob(vehicle, paintjob)
	setVehicleColor(vehicle, colors[1], colors[2], colors[3], colors[4], colors[5], colors[6], colors[7], colors[8], colors[9], colors[10], colors[11], colors[12])
	setVehiclePlateText(vehicle, plateText)
	setVehicleDamageProof(vehicle, true)			
	--setVehicleHandling(vehicle, "mass", handling.mass)
	setVehicleHandling(vehicle, "dragCoeff", handling.dragCoeff)
	setVehicleHandling(vehicle, "engineAcceleration", handling.engineAcceleration)
	setVehicleHandling(vehicle, "engineInertia", handling.engineInertia)
	setVehicleHandling(vehicle, "maxVelocity", handling.maxVelocity)
	setVehicleHandling(vehicle, "tractionMultiplier", handling.tractionMultiplier)
	-- setVehicleHandling(vehicle, "tractionLoss", handling.tractionLoss)
	-- setVehicleHandling(vehicle, "tractionBias", handling.tractionBias)
end

function checkFinishAchievements(rank, time)
	if exports["achievements"] then
		local driver = getElementData(source,"airpain3.driver")
		local model = getElementData(driver,"model")
		exports.achievements:updateObjective(source, "sssAirpain3Drivers", model)
		if rank == 1 and time < 210000 then
			exports.achievements:triggerAchievement(source, "sssAirpain3NoBlips", nil)
		end
	end
end
addEvent("onPlayerFinish", true)
addEventHandler("onPlayerFinish", root, checkFinishAchievements)

addEvent("achievement", true)
addEventHandler("achievement", root, function(achievementID)
	if exports["achievements"] then
		exports.achievements:triggerAchievement(client, achievementID, nil)
	end
end )
