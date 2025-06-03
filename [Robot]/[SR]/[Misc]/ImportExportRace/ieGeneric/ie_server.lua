addEvent("onRaceStateChanging", true)
addEvent("onPlayerDeliverVehicle", true)

g_requiredCheckpoints = -1
g_raceStarted = false
g_raceFinished = false

g_chosenCars = {}
g_shuffledIndicesPerPlayer = {}
g_playerTargets = {}

function raceStateChanged(newState, oldState)
	if (newState == "Running" and oldState == "GridCountdown") then
		startGame()
	elseif (newState == "GridCountdown") then
		triggerClientEvent ( root, "gridCountdownStarted", resourceRoot )
		startRacePoll()
	end
end
addEventHandler("onRaceStateChanging", root, raceStateChanged)

function startGame()
	g_pollActive = false
	g_raceStarted = true
	selectCars()
	exports.scoreboard:scoreboardAddColumn("Vehicle")
	exports.scoreboard:scoreboardAddColumn("Money_IE", root, 70, "Money")
end

function selectCars()
	if (g_requiredCheckpoints == -1) then
		-- People have been unable to settle the poll. We choose for them.
		exports.votemanager:stopPoll{}
		applyPollResult(1)
		end
	local cars = getElementsByType("exportable")
	-- Select cars for every player
	if (#g_chosenCars == 0) then
		if (g_requiredCheckpoints == #cars) then
			g_chosenCars = cars
		else
			for i = #cars, #cars - g_requiredCheckpoints + 1, -1 do
				randomIndex = math.random(1,i)
				table.insert(g_chosenCars, cars[randomIndex])
				table.remove(cars, randomIndex)
			end
		end
	end
	-- Shuffle the cars for each player
	for i, v in pairs(getElementsByType("player")) do
		shuffleCarsPerPlayer(v)
	end
end

function shuffleCarsPerPlayer(whose)
	if (#g_chosenCars == 0) then
		-- Race hasn't started yet
		return
	end

	local sipp = g_shuffledIndicesPerPlayer[whose]
	if (sipp ~= nil and #sipp > 0) then
		-- This player is not new, teleport to next
		teleportPlayerToVehicle(g_playerTargets[whose], whose)
		triggerClientEvent(whose, "updateTarget", whose, g_playerTargets[whose])
		return
	end

	local serial = getPlayerSerial(whose)
	if (g_quitPlayersTargets[serial]) then
		-- This player is new, but was here before and has progress stored. Load it.
		g_playerTargets[whose] = g_quitPlayersTargets[serial]
		g_shuffledIndicesPerPlayer[whose] = g_quitPlayersShuffledCars[serial]
		teleportPlayerToVehicle(g_playerTargets[whose], whose)
		triggerClientEvent(whose, "updateTarget", whose, g_playerTargets[whose])
	else	
		-- This player is new. Actually shuffle cars and send them the list.
		local intsTable = {}
		g_shuffledIndicesPerPlayer[whose] = {}
		for i = #g_chosenCars, 1, -1 do
			table.insert(intsTable, i)
		end
		for i = #intsTable, 1, -1 do
			randomIndex = math.random(1,i)
			table.insert(g_shuffledIndicesPerPlayer[whose], intsTable[randomIndex])
			table.remove(intsTable, randomIndex)
		end
		g_playerTargets[whose] = 1
		teleportPlayerToVehicle(1, whose)
		triggerClientEvent(whose, "onIEGameplayStarted", whose, g_requiredCheckpoints)
	end
	colorGenerator(whose)
end

function colorGenerator(player)
	colors = {}
	for i = 1, 4, 1 do
		-- since MTA wants colors in RGB, we won't bother calculating hue. Instead, we pretend S & V are both 100% to calculate a RGB values and apply SV on them later.
		-- When both S and V are 100%, the color in RGB will always have one component of 255, one of 0, and one in between.
		components = {}
		components[1] = 255
		components[2] = 0
		components[3] = math.random(0, 255)
		saturation = math.random(99, 100) / 100
		value = math.random(99, 100) / 100

		-- this block of code determines which RGB component will be min, which max, and which the other by shuffling them.
		indices = {1, 2, 3}
		shuffledIndices = {}
		for i = #indices, 1, -1 do
			random = math.random(1,i)
			shuffledIndices[i] = indices[random]
			table.remove(indices, random)
		end

		-- now we take the min/maxed RGB components and do the saturation & value calculations on them based on the shuffled indices
		for j,w in pairs(shuffledIndices) do
			c = components[w]		
			c = c + ((255 - c) * (1 - saturation)) 
			c = c * value			
			c = c - (c % 1)			
			colors[j + (i - 1) * 3] = c	
		end
	end
	-- apply our 4 generated colors the vehicle
	vehicle = getPedOccupiedVehicle(player)
	setVehicleColor(vehicle, colors[1], colors[2], colors[3], colors[4], colors[5], colors[6], colors[7], colors[8], colors[9], colors[10], colors[11], colors[12])
end

function incrementTarget(oldTarget, _, _, _, _)
	newTarget = oldTarget + 1
	if (getElementData(client, "race.finished")) then
		return
	end

	if (newTarget > g_requiredCheckpoints) then
		-- The target CP is greater than required checkpoints. This means most recent CP == required. Finish the race.
		g_playerTargets[client] = #getElementsByType("checkpoint")
		triggerClientEvent(client, "finishRace", client)

		-- A player has finished the race, set g_raceFinished to true
		g_raceFinished = true
	else
		-- Set and TP player to their new target vehicle
		g_playerTargets[client] = newTarget
		teleportPlayerToVehicle(newTarget, client)
		triggerClientEvent(client, "updateTarget", client, newTarget)
	end

end
addEventHandler("onPlayerDeliverVehicle", root, incrementTarget)

function teleportPlayerToVehicle(target, player)
	-- get our destination
	element = g_chosenCars[g_shuffledIndicesPerPlayer[player][target]]
	x = getElementData(element, "posX")
	y = getElementData(element, "posY")
	z = getElementData(element, "posZ")
	rX = getElementData(element, "rotX")
	rY = getElementData(element, "rotY")
	rZ = getElementData(element, "rotZ")
	model = getElementData(element, "model")
	model = tonumber(model)
	-- go there
	local vehicle = getPedOccupiedVehicle(player)
	if (not vehicle) then
		return
	end
	setElementModel(vehicle, model)
	if (TRAINS[model]) then
		setTrainDerailed(vehicle, SPAWN_TRAINS_DERAILED)
	end

	if (VEHICLES_WITH_GUNS[model]) then
		toggleControl(player, 'vehicle_secondary_fire', false)
		if (model == 430) then -- predator
			toggleControl(player, 'vehicle_fire', false)
		end
	else
		toggleControl(player, 'vehicle_fire', true)
		toggleControl(player, 'vehicle_secondary_fire', true)
	end

	-- setElementFrozen(vehicle, true)
	setMovementControls(player, false)
	setElementPosition(vehicle, x, y, z)
	setElementAngularVelocity(vehicle, 0, 0, 0)
	setElementVelocity(vehicle, 0, 0, 0)
	setElementRotation(vehicle, rX, rY, rZ)
	fixVehicle(vehicle)
	setElementAlpha ( vehicle, 0 ) 
	setCameraTarget ( player, player )

	setTimer( function(vehicle)
		if (not isElement(vehicle)) then
			return
		end
		setElementAlpha(vehicle, math.min(255, getElementAlpha(vehicle) + 17))
	end, SPAWN_DELAY_IN_MS/20, 16, vehicle)

	setTimer ( function(player)
		if (not isElement(player)) then
			-- player left
			return
		end
		setElementAlpha ( vehicle, 255 ) 
		setMovementControls(player, true)
		triggerClientEvent(player, "vehicleUnfreeze", resourceRoot)
	end, SPAWN_DELAY_IN_MS, 1, player)
end

function handlePlayerSpawn(theVehicle)
	-- do nothing if game hasnt started yet
	if (g_requiredCheckpoints == -1) then
		return
	end
	if (#g_chosenCars == 0) then
		return
	end
	local sipp = g_shuffledIndicesPerPlayer[source]
	if (sipp == nil or #sipp == 0) then
		-- This player is new and hasn't received their list of cars yet. (eg. during intro cutscene)
		triggerClientEvent ( source, "gridCountdownStarted", resourceRoot )
		setTimer(function(whom)
			shuffleCarsPerPlayer(whom)
		end, (POLL_DURATION_IN_SECONDS+0.5)*1000, 1, source)
		return
	end
	colorGenerator(source)
	teleportPlayerToVehicle(g_playerTargets[source], source)
	triggerClientEvent(source, "updateTarget", source, g_playerTargets[source])
end
addEventHandler("onPlayerVehicleEnter", root, handlePlayerSpawn)

function setMovementControls(player, enabled)
	toggleControl(player, 'vehicle_left', enabled)
	toggleControl(player, 'vehicle_right', enabled)
	toggleControl(player, 'steer_forward', enabled)
	toggleControl(player, 'steer_back', enabled)
	toggleControl(player, 'brake_reverse', enabled)
	toggleControl(player, 'accelerate', enabled)
	toggleControl(player, 'special_control_up', enabled)
	toggleControl(player, 'special_control_down', enabled)
	toggleControl(player, 'vehicle_look_left', enabled)
	toggleControl(player, 'vehicle_look_right', enabled)
end

function cleanup(stoppedResource)
	for i, v in ipairs(getElementsByType("player")) do
		toggleControl(v, 'vehicle_fire', true)
		toggleControl(v, 'vehicle_secondary_fire', true)
		toggleControl(v, 'vehicle_left', true)
		toggleControl(v, 'vehicle_right', true)
		toggleControl(v, 'steer_forward', true)
		toggleControl(v, 'steer_back', true)
		toggleControl(v, 'brake_reverse', true)
		toggleControl(v, 'accelerate', true)
		toggleControl(v, 'special_control_up', true)
		toggleControl(v, 'special_control_down', true)
		toggleControl(v, 'vehicle_look_left', true)
		toggleControl(v, 'vehicle_look_right', true)
	end
	exports.scoreboard:scoreboardRemoveColumn("Vehicle")
	exports.scoreboard:scoreboardRemoveColumn ("Money_IE")
end
addEventHandler( "onResourceStop", resourceRoot, cleanup)
