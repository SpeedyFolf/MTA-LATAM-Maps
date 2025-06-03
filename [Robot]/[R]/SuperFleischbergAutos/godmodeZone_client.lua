GODMODE_REGION_BOAT = createColCircle(-12.5, -342.0, 30)
GODMODE_REGION_PLANE = createColCuboid(-61, -233, 0, 30, 29, 25)

LOW_DAMAGE_DIVISOR = 2

g_lowDamage = false

function handleVehicleDamage(attacker, weapon, loss, x, y, z, tire)
	if (source ~= getPedOccupiedVehicle(localPlayer)) then
		return
	end
	
	-- if (HELICOPTERS[getElementModel(source)] and attacker ~= nil) then
	-- 	setHeliBladeCollisionsEnabled ( source, false )
	-- 	iprint("[FleischBerg Autos]", "Cancelling helicopter blade attack")
	-- 	cancelEvent()
	-- end
	if (VEHICLE_WEAPONS[weapon] and attacker ~= localPlayer) then
		cancelEvent()
	end
end

function enableGodMode(element, matchingDimension)
	if (getElementType(element) ~= "vehicle") then
		return
	end
	if element ~= getPedOccupiedVehicle(localPlayer) then
		return
	end
	if (source == GODMODE_REGION_BOAT) then
		if (BOATS[getElementModel(element)]) then
			g_lowDamage = true
			-- setVehicleDamageProof(element, true)
		end
	elseif (source == GODMODE_REGION_PLANE) then
		if (HELICOPTERS[getElementModel(element)] or AEROPLANES[getElementModel(element)]) then
			g_lowDamage = true
			-- setVehicleDamageProof(element, true)
		end
	end

end
addEventHandler("onClientColShapeHit", GODMODE_REGION_BOAT, enableGodMode)
addEventHandler("onClientColShapeHit", GODMODE_REGION_PLANE, enableGodMode)

function disableGodMode(element, matchingDimension)
	if (getElementType(element) ~= "vehicle") then
		return
	end
	if element ~= getPedOccupiedVehicle(localPlayer) then
		return
	end
	g_lowDamage = false
	-- setVehicleDamageProof(element, false)
end
addEventHandler("onClientColShapeLeave", GODMODE_REGION_BOAT, disableGodMode)
addEventHandler("onClientColShapeLeave", GODMODE_REGION_PLANE, disableGodMode)

function handleGodModeRegionDamage(attacker, weapon, loss, x, y, z, tire)
	if (source ~= getPedOccupiedVehicle(localPlayer)) then
		return
	end

	if (g_lowDamage) then
		setElementHealth(source, getElementHealth(source) - (loss / LOW_DAMAGE_DIVISOR))
		cancelEvent()
	end
end
addEventHandler("onClientVehicleDamage", root, handleGodModeRegionDamage)