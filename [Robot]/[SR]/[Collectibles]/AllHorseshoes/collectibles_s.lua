addEventHandler("onPlayerVehicleEnter", root, function(vehicle, seat, jacked)
	setElementFrozen(vehicle, true)
	removePedFromVehicle(source)
	setElementPosition(source, 418.7, 2523.8, 16.1)
	setElementRotation(source, 0, 0, -90)
	setPedWearingJetpack(source, true)
end )

addEvent("updateHorseshoes", true)
addEventHandler("updateHorseshoes", getRootElement(), function(horseshoe)
	-- Achievement
	exports.achievements:updateObjective(source, "allhorseshoes", horseshoe)
end )