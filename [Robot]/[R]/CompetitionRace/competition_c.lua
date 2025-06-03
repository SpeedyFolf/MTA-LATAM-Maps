addEventHandler("onClientElementModelChange", getRootElement(), function()
	if getPedOccupiedVehicle(localPlayer) and getElementType(source) == "vehicle" and source == getPedOccupiedVehicle(localPlayer) then
		local newZ = getElementDistanceFromCentreOfMassToBaseOfModel(getPedOccupiedVehicle(localPlayer)) + 9.6800003051758
		if (getVehicleType(getPedOccupiedVehicle(localPlayer)) == "Monster Truck" or getElementModel(getPedOccupiedVehicle(localPlayer)) == 532) and newZ then
			newZ = newZ + 1
		end
		
		if newZ then
			local x, y, z = getElementPosition(getPedOccupiedVehicle(localPlayer))
			setElementPosition(getPedOccupiedVehicle(localPlayer), x, y, newZ)
		end
	end
end )