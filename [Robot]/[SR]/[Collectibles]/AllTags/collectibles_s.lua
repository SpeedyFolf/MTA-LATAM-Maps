local vehicles = {}

setElementData(resourceRoot, "secretMode", math.random(20))

addEventHandler("onPlayerVehicleEnter", root, function(vehicle, seat, jacked)
	if getElementModel(vehicle) == 400 then 
		setElementFrozen(vehicle, true)
		giveWeapon(source, 41, 10000)
		setPedWeaponSlot(source, 9)
		removePedFromVehicle(source)
		setElementPosition(source, 2792.406, -1461.188, 17.0)
		setElementRotation(source, 0, 0, -90)
		
		-- Create new vehicle
		if isElement(vehicles[source]) then destroyElement(vehicles[source]) end
		vehicles[source] = createVehicle(522, 2792.406, -1461.188, 17.0, 0, 0, -90)
		warpPedIntoVehicle(source, vehicles[source])
	end
end )

addEvent("updateTags", true)
addEventHandler("updateTags", getRootElement(), function(tagID)
	-- Achievement
	if exports["achievements"] then
		exports.achievements:updateObjective(source, "alltagscollectible", tagID)
	end
end )