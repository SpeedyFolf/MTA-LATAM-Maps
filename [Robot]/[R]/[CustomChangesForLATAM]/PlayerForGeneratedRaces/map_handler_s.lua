-- Data of generated race
environment = {}
vehicle = {}
race = {}
markers = {}

-- Trailers lol
trailers = {}
trailerTimers = {}
cartsTimer = {}

-- Random CJ clothes
local clothes = {}
for i = 0, 16 do
	local clothesIndex = 0
	clothes[i] = {}
	while(getClothesByTypeIndex(i, clothesIndex)) do
		local clothesTexture, clothesModel = getClothesByTypeIndex(i, clothesIndex)
		table.insert(clothes[i], {clothesTexture, clothesModel})
		clothesIndex = clothesIndex + 1
	end
end

function setUpPlayersVehicle()
	for _, players in pairs(getElementsByType("player")) do
		-- Setup player's skin, clothes and CJ's stats
		if race["pedID"] and getElementModel(players) ~= race["pedID"] then
			if race["pedID"] == 74 or race["pedID"] == 149 or race["pedID"] == 208 or race["pedID"] == 0 then
				-- Skin is CJ
				setElementModel(players, 0)
				race["pedID"] = 0
				
				-- Random Clothes
				if race["clothes"] then
					removePedClothes(players, 17)
					local hat = 16
					if math.random(2) == 1 then hat = 15 end
					for i = 0, hat do 
						removePedClothes(players, i)
						addPedClothes(players, clothes[i][race["clothes"][tostring(i)]][1], clothes[i][race["clothes"][tostring(i)]][2], i)
					end
				end
				
				-- CJ's stats
				if race["fat"] then 
					setPedStat(players, 21, race["fat"])
					setPedStat(players, 23, race["muscle"])
				end
			else
				-- Set skin
				setElementModel(players, race["pedID"])
			end
		end
		
		-- Setup player's vehicle
		if getPedOccupiedVehicle(players) then
			-- Hydraulics
			if vehicle["hydraulics"] == 1 and getVehicleUpgradeOnSlot(getPedOccupiedVehicle(players), 9) == 0 then
				addVehicleUpgrade(getPedOccupiedVehicle(players), 1087)
			end
			
			if vehicle["paintjob"] then setVehiclePaintjob(getPedOccupiedVehicle(players), vehicle["paintjob"]) end
			if vehicle["lightsColorR"] then setVehicleHeadLightColor(getPedOccupiedVehicle(players), vehicle["lightsColorR"], vehicle["lightsColorG"], vehicle["lightsColorB"]) end
			if vehicle["wheels"] ~= nil then addVehicleUpgrade(getPedOccupiedVehicle(players), vehicle["wheels"]) end
			
			if getVehicleUpgradeOnSlot(getPedOccupiedVehicle(players), 8) ~= 1008 and vehicle["nitros"] == 3 then
				addVehicleUpgrade(getPedOccupiedVehicle(players), 1008) 
			end
			
			if vehicle["upgrades"] then
				for i = 1, #vehicle["upgrades"] do
					addVehicleUpgrade(getPedOccupiedVehicle(players), vehicle["upgrades"][i])
				end
			end
			
			if vehicle["type"] == "Train" then
				-- Derailability Randomizer
				if vehicle["trainDerailable"] == 0 then setTrainDerailable(getPedOccupiedVehicle(players), false) end 
				
				-- Direction Randomizer
				if vehicle["trainDirection"] == 0 then setTrainDirection(getPedOccupiedVehicle(players), true)
				elseif vehicle["trainDirection"] == 1 then setTrainDirection(getPedOccupiedVehicle(players), false) end
				
				-- Train Carts
				if vehicle["trainCarts"] and trailers[players] == nil and not isTimer(cartsTimer[players]) then
					cartsTimer[players] = setTimer(function()
						-- Create carts
						trailers[players] = {}
						trailerTimers[players] = {}
						
						for t = 1, #vehicle["trainCarts"] do
							trailers[players][t] = createVehicle(vehicle["trainCarts"][t], vehicle["spawnX"], vehicle["spawnY"], vehicle["spawnZ"])
							if vehicle["trainDirection"] == 0 then setTrainDirection(trailers[players][t], true)
							else setTrainDirection(trailers[players][t], false) end
							
							if vehicle["trainDerailable"] == 0 then setTrainDerailable(trailers[players][t], false) end
							
							if t == 1 then trailerTimers[players][t] = setTimer(attachCartsToTrain, 250, 0, getPedOccupiedVehicle(players), trailers[players][t])
							else trailerTimers[players][t] = setTimer(attachCartsToTrain, 250, 0, trailers[players][t-1], trailers[players][t]) end
							
							setVehicleColor(trailers[players][t], math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255))
						end
					end, 300, 1)
				end
			end
			
			if vehicle["trailer"] ~= nil and vehicle["type"] ~= "Train" and mapSelected then
				if trailers[players] == nil then
					local x, y, z = getElementPosition(getPedOccupiedVehicle(players))
					local closeToSomebody = false
					
					for _, ps in ipairs(getElementsByType("player")) do
						if players ~= ps and getPedOccupiedVehicle(ps) then
							local u, w, v = getElementPosition(getPedOccupiedVehicle(ps))
							if getDistanceBetweenPoints3D(x, y, z, u, w, v) < 0.3 then
								closeToSomebody = true
								break
							end
						end
					end
					
					if not closeToSomebody then
						local x, y, z = getElementPosition(getPedOccupiedVehicle(players))
						trailers[players] = createVehicle(vehicle["trailer"], x, y, z, 0, 0, vehicle["trailerRot"])
						trailerTimers[players] = setTimer(attachTrailerToVehicle, 250, 1, getPedOccupiedVehicle(players), trailers[players])
						setElementVelocity(getPedOccupiedVehicle(players), 0, 0, 0)
						if vehicle["wheels"] ~= nil then addVehicleUpgrade(trailers[players], vehicle["wheels"]) end
						setVehicleColor(trailers[players], math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255))
					end
				else
					setElementHealth(trailers[players], 1000)
				end
			end
		end
	end
end

function attachCartsToTrain(train, cart)
	if not train then 
		if isElement(cart) then destroyElement(cart) end
		return
	end
	
	if not isTrainDerailed(train) then
		-- Make sure that cart is not derailed
		setTrainDerailed(cart, false)
		
		-- Attach cart to the train
		attachTrailerToVehicle(train, cart)
		
	-- Otherwise derail all carts
	else setTrainDerailed(cart, true) end
end

function update()
	-- Update player's vehicle
	setUpPlayersVehicle()
				
	-- Send data and skip
	if mapSelected then
		for _, players in ipairs(getElementsByType("player")) do
			if getElementData(players, "gotdata") ~= 1 then
				votedPlayers[players] = false
				triggerClientEvent(players, "recieveMarkers", players, {markers, vehicle, race, environment})
			end
			
			if skipEnabled and getElementData(players, "skipped") ~= 1 then
				triggerClientEvent(players, "setSkip", players, markerToSkip)
			end
		end
	end
end

function forceRaceEnvironment()
	-- Fallback
	if not mapSelected then
		setTimer(forceRaceEnvironment, 1000, 1)
		return
	end
	
	-- Set Weather
	setTime(environment["hour"], environment["min"])
	setWeather(environment["weather"])
	setMoonSize(environment["Moon"])
	if environment["heat"] then setHeatHaze(environment["heat"]) end
	
	-- Set next Weather
	if environment["nextweather"] then setWeatherBlended(environment["nextweather"]) end
	
	if vehicle["type"] == "Boat" then
		setWaveHeight(environment["waveHeight"])
		setWaterColor(environment["waterColorR"], environment["waterColorG"], environment["waterColorB"], environment["waterColorA"])
	end
	
	if vehicle["type"] == "Plane" or vehicle["type"] == "Helicopter" and environment["wind"] then 
		setFarClipDistance(environment["clipDistance"])
		setWindVelocity(environment["wind"].x, environment["wind"].y, environment["wind"].z)
	end
	
	-- Race post gen
	-- Create objects
	if race["objects"] and #race["objects"] > 0 then
		for _, object in pairs(race["objects"]) do
			local obj = createObject(object.id, object.x, object.y, object.z, 0, 0, object.r or 0)
			setElementCollisionsEnabled(obj, object.collisions == true or false)
			setObjectScale(obj, object.scale or 1)
		end
	end

	-- Tropic bridge protection (c) 
	if vehicle["type"] == "Boat" or (race["type"] and race["type"] == "on-water") then
		removeWorldModel(12812, 147.95247, 329.67969, -354.42187, 8.9375)
		removeWorldModel(12852, 172.82428, -26.46875, -554.82031, 2.42188)
		removeWorldModel(17281, 153.04022, -42.50781, -1476.8906, 4.3125)
		removeWorldModel(17002, 36.94622, 52.89063, -1532.0312, 7.74219)
		
		setElementCollisionsEnabled(createObject(12812, 329.67969, -354.42187, 8.9375), false)
		setElementCollisionsEnabled(createObject(12852, -26.46875, -554.82031, 2.42188), false)
		setElementCollisionsEnabled(createObject(17281, -42.50781, -1476.8906, 4.3125), false)
		setElementCollisionsEnabled(createObject(17002, 52.89063, -1532.0312, 7.74219), false)
	end
	
	if vehicle["trailer"] ~= nil then
		addEventHandler("onTrailerDetach", getRootElement(), function(truck)
			setTimer(properlyAttachTrailer, 10, 1, truck, source)
		end )
	end
end 

addEventHandler("onResourceStop", resourceRoot, function()
	restoreAllWorldModels()
end )

function forceRaceVehicle(player, reason)
	local playersVehicle = getPedOccupiedVehicle(player)
	if not playersVehicle then
		setTimer(forceRaceVehicle, 200, 1, player, reason)
	else
		-- Reset model
		if playersVehicle and getElementModel(playersVehicle) ~= vehicle["model"] then
			setElementModel(playersVehicle, vehicle["model"])
		end
		
		-- Hydraulics fix
		if playersVehicle and vehicle["hydraulics"] == 1 and reason and reason == "enter" then
			removeVehicleUpgrade(playersVehicle, 1087)
		end
	end
end 

-- Reset Player's Vehicle Model
addEvent("resetVehicleModel", true)
addEventHandler("resetVehicleModel", getRootElement(), function(reason)
	if not mapSelected then return end
	forceRaceVehicle(source, reason)
end )

addEvent("procOnPickupHit", true)
addEventHandler("procOnPickupHit", getRootElement(), function(type)
	if source then
		if type == 2225 then addVehicleUpgrade(source, 1010)
		elseif type == 2226 then fixVehicle(source) end
	end
end )

addEventHandler("onPlayerVehicleEnter", root, function(vehicle, seat, jacked)
	if race["type"] == "jetpack" and vehicle and not getElementData(source, "race.finished") then
		setElementPosition(vehicle, 0, 0, math.random(35000, 69000))
		setElementFrozen(vehicle, true)
		
		removePedFromVehicle(source)
		setPedWearingJetpack(source, true)
		
		forceJetpack(source)
	end
end )

function forceJetpack(player)
	local checkpoint = getElementData(player, "race.checkpoint")
	if checkpoint then
		checkpoint = checkpoint - 1
		checkpoint = math.min(checkpoint, race["maxCP"])
		if checkpoint == 0 then setElementPosition(player, vehicle["spawnX"], vehicle["spawnY"], vehicle["spawnZ"])
		else setElementPosition(player, markers[checkpoint].x, markers[checkpoint].y, markers[checkpoint].z) end
	else
		setTimer(forceJetpack, 1000, 1, player)
	end
end 

function properlyAttachTrailer(truck, trailer)
	setElementVelocity(truck, 0, 0, 0)
	attachTrailerToVehicle(truck, trailer)
end