g_HaltDeliveryTimer = 0

function updateDelivery(deltaTime)
	g_HaltDeliveryTimer = g_HaltDeliveryTimer - deltaTime
end
addEventHandler("onClientPreRender", root, updateDelivery)

function checkVehicleWithinExportMarker(vehicle)
	if not checkHaltTimer(deltaTime) then return end
	if not checkPlayerInPlay() then return end
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if not checkVehicleExistence(vehicle) then return end
	if not checkFreedomOfMovement(vehicle) then return end	
	if not checkVehicleStopped(vehicle) then return end

	if customExportRequirements then
		if not customExportRequirements() then
			return
		end
	end

	if (isElementWithinMarker(vehicle, MARKER_EXPORT)) then
		-- We are in the export marker. All conditions met. Deliver
		outputConsole("[Import Export] Delivering vehicle as normal: " .. getElementModel(vehicle).." @"..getRealTime().timestamp)
		deliverVehicle()
	end
end
addEventHandler("onClientPreRender", root, checkVehicleWithinExportMarker)

function checkHaltTimer()
	if (g_HaltDeliveryTimer > 0) then
		-- When delivering a car or respawning, we want to pause deliveries to avoid fake deliveries
		-- This is put on a timer. We're not using timer class because it is clunky to use when
		-- the timer needs to be reset midway through (eg someone spams enter to commit sudoku repeatedly)
		return false
	end
	return true
end

function checkVehicleExistence(vehicle)
	if (not vehicle) then
		-- Unsure when this happens. Maybe in spectate mode. Either way, do nothing
		return false
	end
	return true
end

function checkFreedomOfMovement(vehicle)
	if (isElementFrozen(vehicle)) then
		-- Upon respawning, our vehicle is frozen temporarily. Do not check for progress in this state.
		return false
	end
	if (getElementAttachedTo(vehicle) ~= false) then
		-- We are attached to a crane, do nothing
		return false
	end
	return true
end

function checkPlayerInPlay()
	local x,y,z = getElementPosition(localPlayer)
	if (z > MAX_Z or getElementData(localPlayer, "state") ~= "alive") then
		-- When spectating the position is set to 30k. 1000 is the maxc flight limit. Do nothing
		return false
	end
	return true
end

function checkVehicleStopped(vehicle)
	local vx,vy,vz = getElementVelocity(vehicle)
	local shittyVelocity = vx*vx+vy*vy+vz*vz
	local targetVelocity = 0.0001
	-- if (BIG_PLANES[vehicleModel]) then
	-- 	-- Be less demanding for big planes
	-- 	targetVelocity = 0.001
	-- end

	if (shittyVelocity > targetVelocity) then
		-- We are not actually stopped
		return false
	end
	return true
end
