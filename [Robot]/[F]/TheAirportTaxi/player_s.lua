local taxi = {} 		-- Taxi
local taxiDriver = {} 	-- Taxi driver

-- Settings
local DRIVER_MODEL = math.random(1, 250)
local zone = math.random(5)

addEventHandler("onPlayerVehicleEnter", getRootElement(), function(vehicle, seat, jacked)
	if getElementModel(vehicle) == 522 and seat == 0 and not jacked then
		
		-- Initital map start
		taxi[source] = vehicle
		
		-- Hide the "race" vehicle
		setVehicleColor(vehicle, 6, 6, 6, 6)
		removePedFromVehicle(source)
		
		-- Spawn player in the city
		triggerClientEvent(source, "spawnPlayerInCity", source, zone)
		
		-- Freeze player before map start
		setElementFrozen(source, true)
		setTimer(function(player) 
			toggleAllControls(player, false)
		end, 300, 1, source)
		
		-- Create Taxi Driver
		taxiDriver[source] = createPed(DRIVER_MODEL, 0, 0, 0)
		warpPedIntoVehicle(taxiDriver[source], vehicle, 0)
		setElementSyncer(taxiDriver[source], source, true)
	end
end )

addEvent("onRaceStateChanging", true)
addEventHandler("onRaceStateChanging", root, function(newState, oldState)
	if newState == "PreGridCountdown" then
		setWeather(0, 15)
		setTime(math.random(0, 24), math.random(0, 59))
	elseif oldState == "GridCountdown" and newState == "Running" then
		-- Unfreeze players
		for _, player in ipairs(getAlivePlayers()) do
			setElementFrozen(player, false)
			toggleAllControls(player, true)
		end
		
		-- Update timer
		setTimer(function()
			for _, v in ipairs(getAlivePlayers()) do
				if not getElementData(v, "spawnedInTheCity") then
					triggerClientEvent(v, "spawnPlayerInCity", source, zone)
				end
			end
		end, 1000, 0)
	end
end )

addEvent("teleportRaceCar", true)
addEventHandler("teleportRaceCar", getRootElement(), function(model, x, y, z, rx, ry, rz)
	setElementPosition(taxi[source], x, y, z)
	setElementRotation(taxi[source], rx, ry, rz)
		
	if model then
		setElementModel(taxi[source], model)
		triggerClientEvent(source, "carTeleported", source)
	end
end )