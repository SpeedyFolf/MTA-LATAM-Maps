baseVehicle, competitionVehicle = nil, nil
playingAlone = false

-- Load vehicles max speeds
local file = fileOpen("vehicleSpeed.json")
local speed = fromJSON(fileRead(file, fileGetSize(file)))
fileClose(file)

function selectCars()
	local type -- base type
	
	local vehicleStats = {}
	for i = 400, 611 do
		local vehicleType = getVehicleType(i)
		if vehicleType ~= "Train" and vehicleType ~= "Boat" and vehicleType ~= "Plane" and vehicleType ~= "Helicopter" and vehicleType ~= "Trailer" and vehicleType ~= "Quad" then
			local newHandling = getOriginalHandling(i)
			local newStat
			
			if vehicleType == "BMX" or vehicleType == "Bike" then
				newStat = ((speed[tostring(i)] + 40) * newHandling.engineAcceleration * newHandling.tractionMultiplier * newHandling.tractionBias / newHandling.dragCoeff) / newHandling.tractionLoss
			else
				newStat = (speed[tostring(i)] * newHandling.engineAcceleration * newHandling.tractionMultiplier * newHandling.tractionBias / newHandling.dragCoeff) / newHandling.tractionLoss
			end
			
			table.insert(vehicleStats, i, newStat)
		end
	end
	
	-- Select the base vehicle
	repeat 
		baseVehicle = math.random(400, 611)
		type = getVehicleType(baseVehicle)
	until type ~= "Train" and type ~= "Boat" and type ~= "Plane" and type ~= "Helicopter" and type ~= "Trailer" and type ~= "Quad"
	
	-- Get the vehicles of the same type
	local maxDifference = 0.5
	repeat 
		local vehiclesSameType = {}
		for i = 400, 611 do	
			if baseVehicle ~= i and type == getVehicleType(i) and vehicleStats[i] and math.abs(vehicleStats[baseVehicle] - vehicleStats[i]) <= maxDifference then
				table.insert(vehiclesSameType, i)
			end
		end
		
		if #vehiclesSameType > 1 or (#vehiclesSameType > 0 and maxDifference > 10) then
			competitionVehicle = vehiclesSameType[math.random(#vehiclesSameType)]
		else maxDifference = maxDifference + 1 end
	until competitionVehicle
	
	-- Set the base model to be > than competition model for database managing
	if baseVehicle < competitionVehicle then
		local v = baseVehicle
		baseVehicle = competitionVehicle
		competitionVehicle = v
	end
	
	setTimer(forceModels, 200, 0)
	outputChatBox("#FFFFFFCurrent Race: #FF0000" ..getVehicleNameFromModel(baseVehicle).. " #FFFFFFVS #FF0000" ..getVehicleNameFromModel(competitionVehicle), root, 255, 255, 255, true)
	
	if getPlayerCount() == 1 then
		playingAlone = true
		outputChatBox("#FFFFFFYou are playing this map #FF0000alone#FFFFFF. No leaderboards will be #FF0000updated", root, 255, 255, 255, true)
	else
		outputChatBox("#FFFFFFPress #FF0000F5 #FFFFFFto display the leaderboards", root, 255, 255, 255, true)
	end
	
	-- Debug info
	--[[for i = 400, 611 do
		local vehicleType = getVehicleType(i)
		local found = false
		local vehicles = {}
		if vehicleType ~= "Train" and vehicleType ~= "Boat" and vehicleType ~= "Plane" and vehicleType ~= "Helicopter" and vehicleType ~= "Trailer" and vehicleType ~= "Quad" then
			local diff = 0.5
			repeat
				vehicles = {}
				for j = 400, 611 do	
					if j ~= i and vehicleType == getVehicleType(j) and vehicleStats[j] and math.abs(vehicleStats[j] - vehicleStats[i]) < diff then
						table.insert(vehicles, j)
					end
				end
				
				if #vehicles > 1 or (#vehicles > 0 and diff > 10) then found = true
				else diff = diff + 1 end
			until found
			
			local str = getVehicleNameFromModel(i).. ": "
			for _, v in ipairs(vehicles) do
				str = str.. " " ..getVehicleNameFromModel(v)
			end
			
			outputChatBox(str)
		end
	end]]
end

function forceModels()
	if not baseVehicle or not competitionVehicle then
		selectCars()
		return
	end
	
	for _, player in ipairs(getElementsByType("player")) do
		if getPedOccupiedVehicle(player) then 
			local assignedVehicle = getElementData(player, "assignedVehicle")
			if assignedVehicle and (assignedVehicle == baseVehicle or assignedVehicle == competitionVehicle) then
				-- vehicle is assigned already
				if getElementModel(getPedOccupiedVehicle(player)) ~= assignedVehicle then
					setElementModel(getPedOccupiedVehicle(player), assignedVehicle)
				end
			else
				-- assign the vehicle
				local x, y, z = getElementPosition(getPedOccupiedVehicle(player))
				if getDistanceBetweenPoints2D(x, y, 1489.49, 1880.58) < 2 then
					-- assign base vehicle
					setElementData(player, "assignedVehicle", baseVehicle)
					setElementModel(getPedOccupiedVehicle(player), baseVehicle)
					
				else
					-- assign competition vehicle
					setElementData(player, "assignedVehicle", competitionVehicle)
					setElementModel(getPedOccupiedVehicle(player), competitionVehicle)
				end
			end
		end
	end
end 

setTrafficLightsLocked(true)
addEvent("onRaceStateChanging", true)
addEventHandler("onRaceStateChanging", root, function(new, old)
	if new == "PreGridCountdown" then
		setTrafficLightState(2)
		selectCars()
	elseif old == "PreGridCountdown" and new == "GridCountdown" then
		setTimer(function()
			setTrafficLightState(6)
		end, 1000, 1)
	elseif old == "GridCountdown" and new == "Running" then
		setTrafficLightState(5)
	end
end )