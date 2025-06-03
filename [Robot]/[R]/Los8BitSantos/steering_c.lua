local carAngle = 0.0
local rx, ry, rz
local ANGLE = 30

addEventHandler("onClientResourceStart", resourceRoot, function()
	engineReplaceModel(engineLoadDFF("washing.dff"), 421)
	setTrafficLightState(6)
	setTrafficLightsLocked(true)
end )

addEventHandler("onClientPreRender", root, function()
	if not getPedOccupiedVehicle(localPlayer) or isLocalPlayerSpectating() or not getPedOccupiedVehicle(localPlayer) then return end
	rx, ry, rz = getElementRotation(getPedOccupiedVehicle(localPlayer))
end, true, "high+8")

addEventHandler("onClientRender", root, function()
	if rx and ry then setElementRotation(getPedOccupiedVehicle(localPlayer), rx, ry, carAngle) end
end, true, "low-8")

function isLocalPlayerSpectating()
	local px, py, pz = getElementPosition(localPlayer)
	if getElementData(localPlayer, "state") == "spectating" or pz > 1000 then return true
	else return false end
end

addEventHandler("onClientPlayerVehicleEnter", localPlayer, function(vehicle, seat)
	setVehicleHandling(vehicle, "mass", 1500)
	setVehicleHandling(vehicle, "tractionMultiplier", 0.7)
	setVehicleHandling(vehicle, "tractionLoss", 1.2)
	setVehicleHandling(vehicle, "tractionBias", 0.51)
	setVehicleHandling(vehicle, "maxVelocity", 180.0)
	setVehicleHandling(vehicle, "dragCoeff", 2)
	setVehicleHandling(vehicle, "engineAcceleration", 16.0 )
	setVehicleHandling(vehicle, "centerOfMass", {0.0, 0.0, -0.4} )
	
	setVehicleOverrideLights(vehicle, 2)
end )

addEventHandler("onClientKey", root, function(button, press) 
	local car = getPedOccupiedVehicle(localPlayer)
	local px, py, pz = getElementPosition(localPlayer)
	
	-- Disable vehicle controls
	toggleControl("vehicle_left", false)
	toggleControl("vehicle_right", false)
	
	if isLocalPlayerSpectating() or not car or isChatBoxInputActive() then return end -- Spec check
	if press then
		local keys = getBoundKeys("vehicle_left")
		for keyName, state in pairs(keys) do
			if button == keyName or getAnalogControlState("vehicle_left", true) > 0.2 then
				-- + 30
				if carAngle == (360 - ANGLE) then carAngle = 0.0	
				else carAngle = carAngle + ANGLE end
				
				local vx, vy, vz = getElementVelocity(car)
				setElementVelocity(car, vx*1.05, vy*1.05, vz*1.05)
				
				break
			end
		end
		
		local keys = getBoundKeys("vehicle_right")
		for keyName, state in pairs(keys) do
			if button == keyName or getAnalogControlState("vehicle_right", true) > 0.2 then
				-- -30
				if carAngle == 0.0 then carAngle = (360.0 - ANGLE)
				else carAngle = carAngle - ANGLE end
				
				local vx, vy, vz = getElementVelocity(car)
				setElementVelocity(car, vx*1.05, vy*1.05, vz*1.05)
				
				break
			end
		end
	end
end )

addEvent("onClientPlayerFinish", true)
addEventHandler("onClientPlayerFinish", localPlayer, function()
	if isLocalPlayerSpectating() or not getPedOccupiedVehicle(localPlayer) then return end
	setVehicleWheelStates(getPedOccupiedVehicle(localPlayer), -1, 2, -1, 2)
end )