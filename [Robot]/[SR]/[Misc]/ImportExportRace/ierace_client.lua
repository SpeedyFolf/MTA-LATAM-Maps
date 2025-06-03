g_customTimer = 11

function fleischPrep()
	g_tutorialBlurb = g_customTimer
	setTimer(function()
		g_customTimer = g_customTimer - 1
		g_tutorialBlurb = g_customTimer
		iprint("[Import Export Race]", g_customTimer)
	end, 1000, 8)
	setTimer(function()
		g_showTutorial = false
	end, 8000, 1)
	local x, y, z = getElementPosition(MARKER_EXPORT)
	createBlip(x, y, z, 0) -- Blip
	setElementData(localPlayer, "Money_IE", 0, true)
end
addEventHandler("gridCountdownStarted", resourceRoot, fleischPrep)

function resetDeliveryAreaFleisch()
	makeMarkerVisible(vehicleId == 514)
end
addEventHandler("onResetDeliveryArea", resourceRoot, resetDeliveryAreaFleisch)

function pollEnded()
	g_showTutorial = g_customTimer > 3
end
addEventHandler("pollEnded", resourceRoot, pollEnded)

function onIEGameplayStarted(totalCheckpoints)
	if (totalCheckpoints == 1) then
		lastCar()
	end
end
addEventHandler("onIEGameplayStarted", localPlayer, onIEGameplayStarted)

addEventHandler("finishRace", localPlayer, teleportToCraneForFinish)