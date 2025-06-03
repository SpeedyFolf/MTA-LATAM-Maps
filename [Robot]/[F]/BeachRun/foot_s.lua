addEventHandler("onPlayerVehicleEnter", root, function(vehicle, seat, jacked)
	setElementPosition(vehicle, 0, 0, math.random(0, 9999999))
	setElementFrozen(vehicle, true)
	removePedFromVehicle(source)
	
	setElementPosition(source, 1017.03, -1932.0699, 12.49)
	
	local skins = {96, 97, 154}
	setPedSkin(source, skins[math.random(#skins)])

	setElementFrozen(source, true)
	setTimer(function(player) toggleAllControls(player, false) end, 300, 1, source)
end )

addEvent("onRaceStateChanging", true)
addEventHandler("onRaceStateChanging", root, function(newState, oldState)
	if oldState == "GridCountdown" and newState == "Running" then
		-- Unfreeze players
		for _, player in ipairs(getAlivePlayers()) do
			setElementFrozen(player, false)
			toggleAllControls(player, true)
		end
		
		setGlitchEnabled("fastsprint", true)
	end
end )

addEvent("onPlayerReachCheckpoint", true)
addEventHandler("onPlayerReachCheckpoint", getRootElement(), function(checkpoint, time)
	if checkpoint == 4 then triggerClientEvent(source, "triggerBoat", source) end
end )

addEventHandler("onResourceStop", resourceRoot, function()
	setGlitchEnabled("fastsprint", false)
end )