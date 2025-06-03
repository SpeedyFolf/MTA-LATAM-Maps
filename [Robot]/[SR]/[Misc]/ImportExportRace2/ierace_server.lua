--- I/E Race specific
function enableControlsInCountdown(car, driver)
	-- setElementData(car, "race.collideothers", 0)
	setElementFrozen(car, false)
	setElementCollisionsEnabled(car, true)
	-- toggleAllControls(driver, false, true, false)
end

function raceStateChanged(newState, oldState)
	if (newState == "GridCountdown") then
		killTimer(g_funTimer)
		
		for i, v in pairs(getElementsByType("player")) do
			enableControlsInCountdown(getPedOccupiedVehicle(v), v)
		end

	end
end
addEventHandler("onRaceStateChanging", root, raceStateChanged)

function makePeopleDrive() 
	for i, v in pairs(getElementsByType("player")) do
		w = getPedOccupiedVehicle(v)
		if (w) then
			enableControlsInCountdown(w, v)
		end
	end
end
g_funTimer = setTimer(makePeopleDrive, 1000, 0)