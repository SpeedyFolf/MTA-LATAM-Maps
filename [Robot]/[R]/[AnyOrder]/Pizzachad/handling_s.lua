function handling()
	for _,veh in pairs(getElementsByType("vehicle")) do
		if getElementModel(veh) == 448 then
			setVehicleHandling(veh,"collisionDamageMultiplier",0.1)
			setVehicleHandling(veh,"dragCoeff",0.7)
			setVehicleHandling(veh,"engineAcceleration",35)
			setVehicleHandling(veh,"engineInertia",150)
			setVehicleHandling(veh,"driveType",awd)
			setVehicleHandling(veh,"tractionMultiplier",1.5)
			setVehicleHandling(veh,"tractionLoss",1.3)
			setVehicleHandling(veh,"maxVelocity",999)
			setVehicleHandling(veh,"steeringLock",55)
		end
	end
end
addEventHandler("onPlayerVehicleEnter", getRootElement(), handling)
