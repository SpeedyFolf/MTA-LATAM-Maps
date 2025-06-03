g_partyPresent = false

MARKER_LARGE = getElementByID("_MARKER_EXPORT_LARGE")
MARKER_BOAT = getElementByID("_MARKER_EXPORT_BOAT")

BLIP_BOAT = nil
BLIP_MARKER = nil

PARTY_LIGHTS = {
	getElementByID("PARTY_LIGHTS_1"),
	getElementByID("PARTY_LIGHTS_2"),
	getElementByID("PARTY_LIGHTS_3"),
	getElementByID("PARTY_LIGHTS_4"),
	getElementByID("PARTY_LIGHTS_5"),
	getElementByID("PARTY_LIGHTS_6"),
	getElementByID("PARTY_LIGHTS_7")
}
			
function fleischInit()
	initCranes()
	setTimer(function()
		if (not g_requiredCheckpoints or g_requiredCheckpoints == -1) then
			setCameraMatrix (  -213.5, -453.5, 63.5, -118.0, -353.8, 0.5)
		end
	end, 1000, 1)
end
addEventHandler("onClientMapStarting", localPlayer, fleischInit)

function fleischPrep()
	introCutscene()
	initCranes()

	setWindVelocity(0, 0, 0)
	-- resetDeliveryArea()
end
addEventHandler("gridCountdownStarted", resourceRoot, fleischPrep)

function resetDeliveryAreaFleisch()
	CRANE_STATE[1] = "available"
	CRANE_STATE[2] = "available"
	
	hideRamps()
	g_lowDamage = false
	setElementCollisionsEnabled(BLOCKING_BRIDGE, true)
	
	if (not BLIP_BOAT) then
		local x, y, z = getElementPosition(MARKER_BOAT)
		createBlip(x, y, z, 9) -- Boat blip
	end
	if (not BLIP_MARKER) then
		x, y, z = getElementPosition(MARKER_EXPORT)
		createBlip(x, y, z, 0, 3, getColorFromString("#FFD800")) -- Marker blip
	end
end
addEventHandler("onResetDeliveryArea", resourceRoot, resetDeliveryAreaFleisch)



function partyLights(newTarget)
	if (newTarget == 212 and not g_partyPresent) then
		for i=#PARTY_LIGHTS,1,-1 do
			local x, y, z = getElementPosition(PARTY_LIGHTS[i])
			setElementPosition(PARTY_LIGHTS[i], x, y, z + 30)
		end
	end
end
addEventHandler("updateTarget", localPlayer, partyLights)

function checkPlaneLargeMarker(vehicle)
	if not checkHaltTimer(deltaTime) then return end
	if not checkPlayerInPlay() then return end
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if not checkVehicleExistence(vehicle) then return end
	if not checkFreedomOfMovement(vehicle) then return end	
	if not checkVehicleStopped(vehicle) then return end
	vehicleModel = getElementModel(vehicle)
	if (isElementWithinMarker(vehicle, MARKER_LARGE) and BIG_PLANES[vehicleModel]) then
		-- We are a big plane in an enlarged export marker. Deliver
		outputConsole("[FleischBerg Autos] Delivering vehicle by large plane marker: " .. vehicleModel.." @"..getRealTime().timestamp)
		deliverVehicle()
	end
end
addEventHandler("onClientPreRender", root, checkPlaneLargeMarker)

function checkPlaneCraneDelivery()
	if not checkHaltTimer() then return end
	if not checkPlayerInPlay() then return end
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if not checkVehicleExistence(vehicle) then return end
	if not checkFreedomOfMovement(vehicle) then return end
	local vehicleModel = getElementModel(vehicle)
	if (AEROPLANES[vehicleModel] and CRANE_STATE[2] == "sleeping") then
		-- Deliver because we used the crane to drop off a plane
		outputConsole("[FleischBerg Autos] Delivering plane due to CRANE_STATE 2 == sleeping: " .. vehicleModel.." @"..getRealTime().timestamp)
		deliverVehicle() 
	end
end
addEventHandler("onClientPreRender", root, checkPlaneCraneDelivery)

function setFinalCam()
	setCameraMatrix (-213.5, -453.5, 63.5, -118.0, -353.8, 0.5)
end
addEventHandler("finishRace", localPlayer, setFinalCam)