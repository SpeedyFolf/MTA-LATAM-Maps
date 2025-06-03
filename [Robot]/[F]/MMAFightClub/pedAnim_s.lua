function peds(newState, oldState)
	if (newState ~= "GridCountdown") then
		return
	end
	setPedAnimation(getElementByID("ped (wmyri) (1)"), "ped", "seat_down", -1, false, false, true, true)
end
addEventHandler("onRaceStateChanging", root, peds)
