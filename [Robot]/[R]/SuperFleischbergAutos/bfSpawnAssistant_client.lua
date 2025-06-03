addEventHandler("vehicleUnfreeze", resourceRoot, function() 
	local vehicle = getPedOccupiedVehicle(localPlayer)
	local model = getElementModel(vehicle)
	if (model == 581) then
		setElementPosition(vehicle, 2531, 2477, 22)
		setElementAngularVelocity(vehicle, 0, 0, 0)
		setElementVelocity(vehicle, 0, 0, 0)
		setElementRotation(vehicle, 0, 0, 90)
		fixVehicle(vehicle)
	end
end)

--    <exportable id="exportable (BF-400) (1)" model="581" posX="2531" posY="2477" posZ="22" rotX="0" rotY="0" rotZ="90"></exportable>
