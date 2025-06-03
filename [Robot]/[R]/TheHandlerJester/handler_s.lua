addEventHandler("onResourceStart", resourceRoot, function()
	setTimer(function()
		local found = false
		for _, v in ipairs(getElementsByType("player")) do
			local x, y, z = getElementPosition(v)
			if getDistanceBetweenPoints2D(x, y, -2716.35, 217.48) < 100 then
				setGarageOpen(15, true)
				found = true
				break
			end
		end
		if not found then setGarageOpen(15, false) end
	end, 2000, 0)
end )

addEventHandler("onVehicleEnter", getRootElement(), function(player)
	if getVehicleHandling(source, "turnMass") ~= 3500 then
		setVehicleHandling(source, "turnMass", 3500)
		setVehicleHandling(source, "dragCoeff", 1.1)
		setVehicleHandling(source, "centerOfMass", {0, 0.2, -0.1})
		
		setVehicleHandling(source, "tractionMultiplier", 0.8)
		setVehicleHandling(source, "tractionLoss", 0.7)
		setVehicleHandling(source, "tractionBias", 0.48)
		
		setVehicleHandling(source, "maxVelocity", 295)
		setVehicleHandling(source, "engineAcceleration", 25.0)
		setVehicleHandling(source, "engineInertia", 100)
		setVehicleHandling(source, "driveType", "rwd")
		
		setVehicleHandling(source, "brakeDeceleration", 4.0)
		setVehicleHandling(source, "brakeBias", 0.7)
		
		setVehicleHandling(source, "suspensionForceLevel", 1.35)
		setVehicleHandling(source, "suspensionDamping", 0.200)
		setVehicleHandling(source, "suspensionHighSpeedDamping", 2.0)
		
		--setVehicleHandling(source, "suspensionUpperLimit", 0.35)
		setVehicleHandling(source, "suspensionLowerLimit", -0.10)
		setVehicleHandling(source, "suspensionAntiDiveMultiplier", 0.1)
		
		setVehiclePaintjob(source, math.random(0, 2))
	end
end )