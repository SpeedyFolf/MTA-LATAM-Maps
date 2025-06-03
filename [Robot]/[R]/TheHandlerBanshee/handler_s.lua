addEventHandler("onVehicleEnter", getRootElement(), function(player)
	if getVehicleHandling(source, "mass") ~= 1800 then
		setVehicleHandling(source, "mass", 1800)
		setVehicleHandling(source, "turnMass", 4000)
		setVehicleHandling(source, "dragCoeff", 1.3)
		setVehicleHandling(source, "centerOfMass", {0, 0.06, -0.10})

		setVehicleHandling(source, "tractionMultiplier", 0.78)
		setVehicleHandling(source, "tractionLoss", 0.68)
		setVehicleHandling(source, "tractionBias", 0.45)

		setVehicleHandling(source, "maxVelocity", 280)
		setVehicleHandling(source, "engineAcceleration", 26)
		setVehicleHandling(source, "engineInertia", 80)

		setVehicleHandling(source, "brakeDeceleration", 4.5)
		setVehicleHandling(source, "brakeBias", 0.60)

		setVehicleHandling(source, "suspensionForceLevel", 1.05)
		setVehicleHandling(source, "suspensionDamping", 0.135)
		setVehicleHandling(source, "suspensionHighSpeedDamping", 5.0)
		
		setVehicleHandling(source, "suspensionAntiDiveMultiplier", -0.08)
	end
end )