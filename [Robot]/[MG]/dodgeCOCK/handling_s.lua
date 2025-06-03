function handling()
	for _,veh in pairs(getElementsByType("vehicle")) do
		setVehicleHandling(veh,"collisionDamageMultiplier",0)
--		setVehicleHandling(veh,"mass",1000)
--		setVehicleHandling(veh,"dragCoeff",0.7)
		setVehicleHandling(veh,"engineAcceleration",50)
		setVehicleHandling(veh,"maxVelocity",100)	
		setVehicleHandling(veh,"tractionMultiplier",1.35)
		setVehicleHandling(veh,"tractionLoss",1.2)
--		setVehicleHandling(veh,"steeringLock",40)
		setVehicleHandling(veh,"centerOfMass",{0.0,0.08,-0.5})
	end
end
addEventHandler("onPlayerVehicleEnter", getRootElement(), handling)
