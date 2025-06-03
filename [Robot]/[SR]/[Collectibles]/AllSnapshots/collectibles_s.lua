local vehicles = {}
local DEBUG = false

-- Tower teleport
setDevelopmentMode(DEBUG)
local towerEntrance = createColSphere(-1749.425, 870.351, 25, 1)
local towerExit = createColSphere(-1753.795, 883.842, 295.601, 1)

addEventHandler("onColShapeHit", towerEntrance, function(who, dim)
	if getElementType(who) == "player" and not getPedOccupiedVehicle(who) then
		fadeCamera(who, false, 0.5)
		setTimer(function(player) 
			setElementPosition(player, -1753.579, 885.756, 295.875)
			fadeCamera(player, true, 0.5)
		end, 500, 1, who)
	end
end )

addEventHandler("onColShapeHit", towerExit, function(who, dim)
	if getElementType(who) == "player" and not getPedOccupiedVehicle(who) then
		fadeCamera(who, false, 0.5)
		setTimer(function(player) 
			setElementPosition(player, -1749.650, 864.756, 25.5)
			fadeCamera(player, true, 0.5)
		end, 500, 1, who)
	end
end )

addEventHandler("onPlayerVehicleEnter", root, function(vehicle, seat, jacked)
	if getElementModel(vehicle) == 400 then 
		setElementFrozen(vehicle, true)
		giveWeapon(source, 43, 5000)
		setPedWeaponSlot(source, 9)
		removePedFromVehicle(source)
		setElementPosition(source, -1697.759, 75.751, 3.5)
		setElementRotation(source, 0, 0, -45)
		
		-- Create new vehicle
		if isElement(vehicles[source]) then destroyElement(vehicles[source]) end
		vehicles[source] = createVehicle(522, -1697.759, 75.751, 3.5, 0, 0, -45)
		warpPedIntoVehicle(source, vehicles[source])
	end
end )

addEvent("updateSnapshots", true)
addEventHandler("updateSnapshots", getRootElement(), function(snapshot)
	-- Achievement
	if exports["achievements"] then
		exports.achievements:updateObjective(source, "allsnapshots", snapshot)
	end
end )