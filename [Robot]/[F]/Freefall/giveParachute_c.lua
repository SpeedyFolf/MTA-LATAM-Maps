addEventHandler("onClientPlayerVehicleEnter", getRootElement(), function(vehicle, seat)
	if source == localPlayer and getElementModel(vehicle) == 572 then oldAmmo = 10000 end
end )
