longestAirTime = 0
currentAirTime = 0
previousHP = 1000

addEventHandler("onClientPreRender", root, function(timeSlice)
	if (isPedDead(localPlayer)) then
		longestAirTime = 0
		currentAirTime = 0
		return
	end
	local v = getPedOccupiedVehicle(localPlayer)
	if not v then return end
	if isElementFrozen(v) then 
		longestAirTime = 0
		currentAirTime = 0
		return 
	end
	local hp = getElementHealth(v)
	if hp < previousHP then
		currentAirTime = 0
	end
	previousHP = hp
	if 
		not isVehicleWheelOnGround(v, 1) and 
		not isVehicleWheelOnGround(v, 2) and 
		not isVehicleWheelOnGround(v, 3) and 
		not isVehicleWheelOnGround(v, 0) and 
		not isVehicleOnGround(v) 
	then
		currentAirTime = currentAirTime + timeSlice
		if (currentAirTime > longestAirTime) then
			longestAirTime = currentAirTime
		end
	else
		currentAirTime = 0
	end
end)

addEventHandler("onClientPlayerFinish", root, function(player)
	if (source == localPlayer) then
		iprint("[Big Loop]", longestAirTime)
		if (longestAirTime >= 3000) then
			triggerServerEvent("achievement", localPlayer, "bigLoopAirTime")
		end
	end
end)
