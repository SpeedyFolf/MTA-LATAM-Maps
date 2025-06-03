function peds(newState, oldState)
	if (newState ~= "GridCountdown") then
		return
	end
	setPedAnimation(getElementByID("_SITTING_PED_01"), "ped", "seat_idle", -1, false, false, true, true)
	setPedAnimation(getElementByID("_SITTING_PED_02"), "ped", "seat_down", -1, false, false, true, true)
	setPedAnimation(getElementByID("_SITTING_PED_03"), "ped", "seat_down", -1, false, false, true, true)
	setPedAnimation(getElementByID("_SITTING_PED_04"), "ped", "seat_down", -1, false, false, true, true)
	setPedAnimation(getElementByID("_SITTING_PED_05"), "ped", "seat_down", -1, false, false, true, true)
	setPedAnimation(getElementByID("_SITTING_PED_06"), "ped", "seat_down", -1, false, false, true, true)
	setPedAnimation(getElementByID("_SITTING_PED_07"), "ped", "seat_down", -1, false, false, true, true)
	setPedAnimation(getElementByID("_SITTING_PED_08"), "ped", "seat_down", -1, false, false, true, true)
	setPedAnimation(getElementByID("_SITTING_PED_09"), "ped", "seat_down", -1, false, false, true, true)
	setPedAnimation(getElementByID("_TALKING_PED_01"), "ped", "IDLE_chat", -1, true, false, true, false)
	setTimer(function()
		setPedAnimation(getElementByID("_TALKING_PED_02"), "ped", "IDLE_chat", -1, true, false, true, false)
	end, 3000, 1)
	setPedAnimation(getElementByID("_DYING_PED_01"), "ped", "IDLE_chat", -1, false, false, true, true)
	setElementHealth(getElementByID("_DYING_PED_01"), 0)
end
addEventHandler("onRaceStateChanging", root, peds) 