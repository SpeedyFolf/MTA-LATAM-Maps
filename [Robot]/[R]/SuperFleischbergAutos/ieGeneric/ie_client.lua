addEvent("updateTarget", true)
addEvent("gridCountdownStarted", true)
addEvent("onResetDeliveryArea", false)
addEvent("vehicleUnfreeze", true)
addEvent("pollEnded", true)
addEvent("onIEGameplayStarted", true)
addEvent("finishRace", true)

g_playerCurrentTarget = 1

function gamePrep()
	setElementData(localPlayer, "Money_IE", 0, true)
end
addEventHandler("gridCountdownStarted", resourceRoot, gamePrep)

function onIEGameplayStarted(totalCheckpoints)
	resetDeliveryArea()
	g_requiredCheckpoints = totalCheckpoints
	g_totalCheckpointDisplay = totalCheckpoints
	updateCheckpointText()
end
addEventHandler("onIEGameplayStarted", localPlayer, onIEGameplayStarted)

function resetDeliveryArea()
	g_HaltDeliveryTimer = HALT_DELIVERY_TIMER_IN_MS
	veh = getPedOccupiedVehicle(localPlayer)
	if (veh) then
		detachElements(veh)
		setHeliBladeCollisionsEnabled ( veh, false )
	end

	local carName = VEHICLE_NAMES[getElementModel(veh)]
	g_carNameBlurb = carName
	setElementData(localPlayer, "Vehicle", carName, true)
	g_showCarName = true
	setTimer(function()
		g_showCarName = false
	end, 6500, 1)

	triggerEvent("onResetDeliveryArea", resourceRoot)

	-- Heli blades are scoffed in ghost mode and MTA does not support any way to fix them decently.
	-- However I can at least disable heliblade collisions of other players so they don't knock you out of the way
	-- You can still knock yourself out of the way by hitting other players with your blades though, despite them being ghost
	-- Update: Nope, that's annoying too. Disable player's blades too.
	local allVehicles = getElementsByType("vehicle")
	-- local myVehicle = getPedOccupiedVehicle(localPlayer)
	for i, v in ipairs(allVehicles) do
		-- if (v ~= myVehicle) then
			setHeliBladeCollisionsEnabled ( v, false )
		-- end
	end
end

function deliverVehicle()
	if (g_HaltDeliveryTimer > 0) then return end
	g_HaltDeliveryTimer = HALT_DELIVERY_TIMER_IN_MS
	local score = getElementData(localPlayer, "Money_IE")
	if (not score) then
		score = 0
	end
	local time = getTickCount() - g_vehicleStartTime
	veh = getPedOccupiedVehicle(localPlayer)
	monetary = getVehicleHandling(veh)["monetary"]
	damage = getElementHealth(veh) / 1000
	reward = monetary * damage
	reward = math.floor(reward)
	score = score + reward
	setElementData(localPlayer, "Money_IE", score, true)
	triggerServerEvent("onPlayerDeliverVehicle", localPlayer, g_playerCurrentTarget, time, getElementModel(veh), damage, reward)
end

function playerDead(killer, weapon, bodypart)
	resetDeliveryArea()
end
addEventHandler("onClientPlayerWasted", localPlayer, playerDead)

function genericUpdateTarget(newTarget)
	-- Normal behavior
	collectCheckpoints(newTarget - 1)
	g_playerCurrentTarget = newTarget
	resetDeliveryArea()
	updateCheckpointText()
end
addEventHandler("updateTarget", localPlayer, genericUpdateTarget)

function autoloadUpdateTarget(newTarget)
	-- Autoload
	if (newTarget > g_playerCurrentTarget + 1) then
		g_midPlayBlurb = "Your saved progress has been restored. Use /ie_resetprogress to undo."
		g_showMidPlayTutorial = true
		setTimer(function()
			g_showMidPlayTutorial = false
		end, 7000, 1)
	end
end
addEventHandler("updateTarget", localPlayer, autoloadUpdateTarget)

addEventHandler("vehicleUnfreeze", resourceRoot, function() 
	if (PLAY_GO_SOUND) then
		playSoundFrontEnd(45)
	end
end)
