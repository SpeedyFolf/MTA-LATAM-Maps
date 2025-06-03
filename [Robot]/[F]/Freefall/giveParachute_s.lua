addEventHandler("onPlayerVehicleEnter", root, function(vehicle, seat, jacked)
	if getElementModel(vehicle) == 572 then 
		setElementFrozen(vehicle, true)
		giveWeapon(source, 46, 10000)
		setPedWeaponSlot(source, 11)
	end
end )
