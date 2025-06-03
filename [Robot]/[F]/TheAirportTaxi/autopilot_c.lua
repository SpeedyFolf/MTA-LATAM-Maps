-- autopilotDebug
setDevelopmentMode(false)
local autopilotDebug = false

local screenX, screenY = guiGetScreenSize()
local taxi, taxiDriver

-- Autopilot
local AUTO_SPEED = 200 -- 150
local NODE_SIZE = 15
local ACCURACY = 8
local FUTURE = 3
local OFFROUTE_TIMEOUT = 10000

local currentNode = 1
local autoControl = false
local colshape
local state
local route = {}
local airport = false
local objective = 0
local offroute = false

-- Sharp turns
local braking_for_turn = false

-- Stuck
local stuck, stuckTime = {x = 0, y = 0}, false
local destination = {x = 1685.78, y = -2251.4, z = -2.8}

-- Debug
addCommandHandler("autopilot", function()
	autopilotDebug = not autopilotDebug
end )

addEvent("carTeleported", true)
addEventHandler("carTeleported", getRootElement(), function()
	arrowTarget = taxi
	
	-- Drive!
	taxiDriver = getVehicleOccupant(taxi, 0)
	setPedAnalogControlState(taxiDriver, "vehicle_right", 0)
	setPedAnalogControlState(taxiDriver, "vehicle_left", 0)
				
	colshape = createColSphere(route[1].x, route[1].y, route[1].z, NODE_SIZE)
	autoControl = true
end )

function startAutopilot()
	offroute = false
	currentNode = 1
		
	setPedAnalogControlState(taxiDriver, "vehicle_right", 0)
	setPedAnalogControlState(taxiDriver, "vehicle_left", 0)
	
	if isElement(colshape) then destroyElement(colshape) end
	colshape = createColSphere(route[currentNode].x, route[currentNode].y, route[currentNode].z, NODE_SIZE)
	
	state = ""
	autoControl = true
end

addEvent("spawnPlayerInCity", true)
addEventHandler("spawnPlayerInCity", getRootElement(), function(zoneForSpawn)
	setElementData(localPlayer, "spawnedInTheCity", true)
	
	-- Zones to spawn player in
	local zones = {
		{x = 752.726, y = -1481, radius = 312},
		{x = 1178, y = -970, radius = 402},
		{x = 1868, y = -1117, radius = 322},
		{x = 2218, y = -1177, radius = 287},
		{x = 2614, y = -1295, radius = 357}
	}
	
	-- Find a random nodes in a radius of selected zone
	local availableSpawns = {}
	for _, v in ipairs(footNodes) do
		if getDistanceBetweenPoints2D(zones[zoneForSpawn].x, zones[zoneForSpawn].y, v.x, v.y) <= zones[zoneForSpawn].radius * (math.max(0.5, math.min(60, #getElementsByType("player")) / 60)) then
			table.insert(availableSpawns, {x = v.x, y = v.y, z = v.z})
		end
	end
	
	-- Spawn player on random foot node
	local pos = availableSpawns[math.random(#availableSpawns)]
	setElementPosition(localPlayer, pos.x, pos.y, pos.z)
	
	-- Find the node for the taxi
	local availableSpawnsForTaxi = {}
	for _, v in ipairs(carIDs) do
		local node = getNodeByID(v)
		local distanceToNode = getDistanceBetweenPoints3D(pos.x, pos.y, pos.z, node.x, node.y, node.z)
		local zDifference = math.abs(pos.z - node.z)
		if distanceToNode > 30 and distanceToNode < 60 and zDifference < 20 then
			table.insert(availableSpawnsForTaxi, {x = node.x, y = node.y, z = node.z})
		end
	end
	
	-- Calculate route to the player
	local taxiSpawnPosition = nil
	repeat
		taxiSpawnPosition = availableSpawnsForTaxi[math.random(#availableSpawnsForTaxi)]
		route = getPath(pos.x, pos.y, pos.z, taxiSpawnPosition.x, taxiSpawnPosition.y, taxiSpawnPosition.z)
	until route
	table.insert(route, {x = pos.x, y = pos.y, z = pos.z, size = 5}) -- Add final node of player spawn
	
	-- Create taxi
	local randomTaxi = math.random(3)
	local taxiModel = randomTaxi == 1 and 420 or (randomTaxi == 2 and 438 or 567)
	triggerServerEvent("teleportRaceCar", localPlayer, taxiModel, taxiSpawnPosition.x, taxiSpawnPosition.y, taxiSpawnPosition.z + 1.5, 0, 0, findRotation(taxiSpawnPosition.x, taxiSpawnPosition.y, route[2].x, route[2].y))
end )

addEventHandler("onClientVehicleStartEnter", root, function(player, seat, door) 
	if player == localPlayer and (seat == 0 or source ~= taxi) then 
		cancelEvent() 
	end
end )

addEventHandler("onClientVehicleExit", root, function(player, seat)
	if player == localPlayer and seat ~= 0 then
		-- Player exited the taxi
		toggleControl("enter_exit", false)
		toggleControl("enter_passenger", false)
		
		-- Drive away
		setTimer(function()
			local x, y, z = getElementPosition(taxi)
			route = getPath(0, 0, 0, x, y, z)
			startAutopilot()
		end, 1000, 1)
	end
end )

addEventHandler("onClientVehicleEnter", root, function(player, seat)
	if player == localPlayer and seat == 0 and getElementModel(source) == 522 then
		-- Race start happens here, store taxi for FUTURE references
		taxi = source
	end
	
	if player == localPlayer and seat ~= 0 and (getElementModel(source) == 420 or getElementModel(source) == 438 or getElementModel(source) == 567) and not airport then
		-- Player entered taxi as passenger
		arrowTarget = nil

		-- Calculate the route
		route = {}
		local refX, refY, refZ = getElementPosition(source)
		local path = getPath(destination.x, destination.y, destination.z, refX, refY, refZ)
		
		for i = 1, #path do
			table.insert(route, {x = path[i].x, y = path[i].y, z = path[i].z})
			table.insert(route, {x = (path[i].x + path[math.min(i + 1, #path)].x) / 2, y = (path[i].y + path[math.min(i + 1, #path)].y) / 2, z = (path[i].z + path[math.min(i + 1, #path)].z) / 2})
		end
		
		startAutopilot()
	end
end )

function calculateCourseDifference(newCourse, oldCourse)
	if math.abs(oldCourse - newCourse) >= 180 then
		-- correction is too big, check for 0 crossing
		if newCourse - oldCourse >= 180 then
			return 360 - newCourse + oldCourse
		else return 360 - oldCourse + newCourse end
	else return math.abs(oldCourse - newCourse) end
end

addEventHandler("onClientRender", root, function()
	if autoControl and taxi then
		local _, _, vehicleCourse = getElementRotation(taxi)
		local x, y, z = getElementPosition(taxi)
		local course = findRotation(x, y, route[currentNode].x, route[currentNode].y)
		
		-- Check for taxi position relative to player
		if objective == 0 then
			local playerX, playerY, playerZ = getElementPosition(localPlayer)
			if getDistanceBetweenPoints3D(x, y, z, playerX, playerY, playerZ) < (route[#route].size or NODE_SIZE) then 
				state = "reached"
				currentNode = 1
			end
		end
		
		-- Braking calcuation
		local brake_course = findRotation(x, y, route[currentNode].x, route[currentNode].y)
		
		if isVehicleReversing(taxi) and state ~= "stuck" then
			if autopilotDebug then dxDrawText("clear reversing", screenX / 2, (screenY / 2) - 105) end
			setPedAnalogControlState(taxiDriver, "brake_reverse", 0)
			
			if state == "reached" then
				if objective == 0 then
					-- Taxi reached the player initally
					outputChatBox("[Taxi] Press G to enter the taxi as passenger", 0, 180, 50, true)
					
					-- Honky honk at player
					setPedControlState(taxiDriver, "horn", true)
					setTimer(function() setPedControlState(taxiDriver, "horn", false) end, 150, 1)
					setTimer(function() setPedControlState(taxiDriver, "horn", true) end, 300, 1)
					setTimer(function() setPedControlState(taxiDriver, "horn", false) end, 450, 1)
					
					local x, y, z = getElementPosition(taxi)
					local rx, ry, rz = getElementRotation(taxi)
					triggerServerEvent("teleportRaceCar", localPlayer, false, x, y, z, rx, ry, rz)
					toggleControl("enter_passenger", true)
				elseif objective == 1 then
					-- Taxi reached the airport
					outputChatBox("[Taxi] The taxi has reached its destination!", 0, 180, 50, true)
					airport = true
					toggleControl("enter_exit", true)
					toggleControl("enter_passenger", true)
				end
				
				objective = objective + 1
				autoControl = false
				
				return
			end
		end
		
		-- Lock the controls
		if objective == 1 and getPedOccupiedVehicle(localPlayer) == taxi or (objective == 0 and state ~= "reached") then
			toggleControl("enter_exit", false)
			toggleControl("enter_passenger", false)
		end
		
		-- Check for stuck taxi
		if not stuckTime then stuckTime = getTickCount() end		
		if stuckTime and getTickCount() - stuckTime > 2300 and state ~= "reached" and not isElementFrozen(taxi) then
			stuckTime = getTickCount()
			if getDistanceBetweenPoints2D(x, y, stuck.x, stuck.y) > 0.5 then
				stuck = {x = x, y = y}
				state = ""
			else 
				if z < -5 then
					-- Taxi has fallen into void, teleport it into next node
					setElementPosition(taxi, route[currentNode].x, route[currentNode].y, route[currentNode].z)
				else 
					state = "stuck" 
					offroute = false
				end
			end
		end
		
		if not offroute then offroute = getTickCount() end
		if offroute and getTickCount() - offroute > OFFROUTE_TIMEOUT and not isElementFrozen(taxi) then
			iprint("[The Airport Taxi]", "calculated new route")
			-- Calculate the new route
			autoControl = false
			local x, y, z = getElementPosition(taxi)
			route = getPath(destination.x, destination.y, destination.z, x, y, z)
			startAutopilot()
		end
		
		local currentSpeed = Vector3(getElementVelocity(taxi)).length * 160
		
		-- Correct the speed
		if state == "straight" then
			-- Course is corrected, can go fast
			setPedAnalogControlState(taxiDriver, "accelerate", 1)
			setPedAnalogControlState(taxiDriver, "brake_reverse", 0)
		elseif state == "correction" then
			-- In a process of turning	
			local addition = (braking_for_turn and 60 or 0)
			local courseDifference = braking_for_turn or math.min(calculateCourseDifference(brake_course, vehicleCourse) + addition, 120)
			if autopilotDebug then dxDrawText("courseDifference " ..courseDifference, (screenX / 2) + 200, (screenY / 2) - 15) end
			
			-- Check in the FUTURE for sharp turn
			-- Calculate the speed required for sharp turn
			local futureNode = FUTURE + math.floor(currentSpeed / 20)
			if currentNode + futureNode <= #route then
				local brake_course_future = findRotation(route[currentNode + futureNode - 1].x, route[currentNode + futureNode - 1].y, route[currentNode + futureNode].x, route[currentNode + futureNode].y)
				local currentCourse = findRotation(route[currentNode].x, route[currentNode].y, route[currentNode + 1].x, route[currentNode + 1].y)
				local brake_course_difference = calculateCourseDifference(brake_course_future, currentCourse)
				
				if brake_course_difference > 80 and not braking_for_turn then
					iprint("[The Airport Taxi]", "sharp turn ahead", braking_for_turn, brake_course_difference)
					braking_for_turn = brake_course_difference
					courseDifference = brake_course_difference
				end
			end
			
			-- Adjust gas to match the correction
			local speedForTurn = math.max((180 - courseDifference) * AUTO_SPEED / 360 , 20)
			setPedAnalogControlState(taxiDriver, "accelerate", math.max(0.5, 1 - (courseDifference / 120)))
		
			-- Braking
			if braking_for_turn and autopilotDebug then
				dxDrawText("Braking for sharp turn (" ..courseDifference.. ") " ..math.floor(currentSpeed).. " " ..speedForTurn, screenX / 2, (screenY / 2) - 125)
			end
			
			if currentSpeed > speedForTurn then
				-- Slow down, release gas pedal and brake as hard as it can lmao
				local speedDifference = currentSpeed - speedForTurn
				if speedDifference > 2 then
					-- Figure out the amount of brakes to make this turn
					if autopilotDebug then dxDrawText("Speed for turn: " ..speedForTurn.. " | Speed: " ..currentSpeed, screenX / 2, (screenY / 2) - 75) end
					local brakingPower = math.min((currentSpeed + (speedDifference * 5) - speedForTurn) / currentSpeed, 1)
					
					-- Full braking, disable steering
					if brakingPower == 1 and state ~= "drop speed" then 
						state = "drop speed"
						
						setPedAnalogControlState(taxiDriver, "accelerate", 0)
						setPedAnalogControlState(taxiDriver, "vehicle_left", 0)
						setPedAnalogControlState(taxiDriver, "vehicle_right", 0)
						setPedAnalogControlState(taxiDriver, "brake_reverse", 1)
						
						-- Turn with handbrake???
						--local drive = getVehicleHandling(taxi, "driveType")
						--if drive == "rwd" then setAnalogControlState("brake_reverse", brakingPower)
						--else setPedControlState("handbrake", true) end
					elseif brakingPower < 1 then
						-- Just brakes
						state = "straight" 
						setPedAnalogControlState(taxiDriver, "brake_reverse", brakingPower)
					end
				else
					-- Just release brakes
					setPedAnalogControlState(taxiDriver, "brake_reverse", 0)
					if braking_for_turn then 
						braking_for_turn = false
						iprint("[The Airport Taxi]", "clear braking_for_turn")
					end
				end
			else
				-- Just release brakes
				setPedAnalogControlState(taxiDriver, "brake_reverse", 0)
				if braking_for_turn then 
					braking_for_turn = false 
					iprint("[The Airport Taxi]", "clear braking_for_turn")
				end
			end
		elseif state == "reached" then
			-- Apply the brakes
			setPedAnalogControlState(taxiDriver, "accelerate", 0)
			setPedAnalogControlState(taxiDriver, "vehicle_left", 0)
			setPedAnalogControlState(taxiDriver, "vehicle_right", 0)
			setPedAnalogControlState(taxiDriver, "brake_reverse", 1)
		elseif state == "stuck" then
			setPedAnalogControlState(taxiDriver, "accelerate", 0)
			setPedAnalogControlState(taxiDriver, "vehicle_left", 0)
			setPedAnalogControlState(taxiDriver, "vehicle_right", 1)
			setPedAnalogControlState(taxiDriver, "brake_reverse", 1)
		end
		
		if autopilotDebug then
			dxDrawText("GAS " ..getPedAnalogControlState(taxiDriver, "accelerate"), screenX / 2, (screenY / 2) - 45)
			dxDrawText("BRAKE " ..getPedAnalogControlState(taxiDriver, "brake_reverse"), screenX / 2, (screenY / 2) - 30)
			dxDrawText("HANDBRAKE " ..tostring(getPedControlState(taxiDriver, "handbrake")), screenX / 2, (screenY / 2) - 15)
		end
		
		-- Correct the course
		if state ~= "reached" and state ~= "stuck" then
			if math.abs(vehicleCourse - course) < ACCURACY then
				-- Course is fine
				setPedAnalogControlState(taxiDriver, "vehicle_right", 0)
				setPedAnalogControlState(taxiDriver, "vehicle_left", 0)
				setPedAnalogControlState(taxiDriver, "accelerate", 1)
				
				state = "straight"
			else
				-- Get maximum steer angle
				local maxSteer = getVehicleHandling(taxi, "steeringLock")
				
				-- Course correction needed
				local action, size = nil, 1
				state = "correction"
				
				-- Select the action
				if math.abs(vehicleCourse - course) >= 180 then
					-- correction is too big, check for 0 crossing
					if course - vehicleCourse >= 180 then 
						action = "vehicle_right"
						size = math.min(360 - course + vehicleCourse, maxSteer) / maxSteer
					else 
						action = "vehicle_left" 
						size = math.min(360 - vehicleCourse + course, maxSteer) / maxSteer
					end
				else
					action = (vehicleCourse - course > 5) and "vehicle_right" or "vehicle_left"
					size = math.min(math.abs(vehicleCourse - course), maxSteer) / maxSteer
				end
				
				-- Make an action
				setPedAnalogControlState(taxiDriver, action, size, turnLimit)
			end
		end
		
		if autopilotDebug then
			-- autopilotDebug text
			dxDrawText("Course error: " ..tostring(math.abs(vehicleCourse - course)), screenX / 2, screenY / 2)
			dxDrawText("Auto speed: " ..((180 - math.min(math.abs(vehicleCourse - course), 90)) / 360 * AUTO_SPEED), screenX / 2, (screenY / 2) + 15)
			dxDrawText("State: " ..state, screenX / 2, (screenY / 2) + 30)
			
			local angle = 270
			if getPedAnalogControlState(taxiDriver, "vehicle_left") > 0 then
				angle = angle - getPedAnalogControlState(taxiDriver, "vehicle_left") * 90 - 1
			elseif getPedAnalogControlState(taxiDriver, "vehicle_right") > 0 then
				angle = angle + getPedAnalogControlState(taxiDriver, "vehicle_right") * 90 + 1
			end
			
			dxDrawCircle(screenX * 3 / 4 + 120, screenY / 2 + 120, 60, 270, angle, tocolor(255, 50, 10, 255))
			
			dxDrawText("Distance " ..getDistanceBetweenPoints3D(x, y, z, destination.x, destination.y, destination.z), screenX / 2, (screenY / 2) + 90)
		end
	end
end )

addEventHandler("onClientColShapeHit", root, function(element, dim)
	if colshape and source == colshape and autoControl and element == taxi then
		-- Destroy old node
		destroyElement(colshape)
		offroute = false
		
		-- Check for destination
		currentNode = currentNode + 1
		if currentNode > #route then
			state = "reached"
			currentNode = 1
		end

		if state ~= "reached" and state ~= "init" then
			-- Create the next node for the autopilot
			colshape = createColSphere(route[currentNode].x, route[currentNode].y, route[currentNode].z, NODE_SIZE)
		end
	end
end )
