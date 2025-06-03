function setHandling (vehicle)
	
	setVehicleHandling(vehicle, "mass", 2000)
	setVehicleHandling(vehicle, "turnMass", 2500)
	setVehicleHandling(vehicle, "dragCoeff", 1.5)
	setVehicleHandling(vehicle, "centerOfMass", { 0, 0.09, -0.3 } )
	setVehicleHandling(vehicle, "tractionMultiplier", 0.95)
	setVehicleHandling(vehicle, "tractionLoss", 0.9)
	setVehicleHandling(vehicle, "tractionBias", 0.5)
	setVehicleHandling(vehicle, "maxVelocity", 200)
	setVehicleHandling(vehicle, "engineAcceleration", 15)
	setVehicleHandling(vehicle, "engineInertia", 5)
	setVehicleHandling(vehicle, "brakeDeceleration", 10)
	setVehicleHandling(vehicle, "brakeBias", 0.5)
	setVehicleHandling(vehicle, "steeringLock", 35)
	setVehicleHandling(vehicle, "suspensionForceLevel", 0.7)
	setVehicleHandling(vehicle, "suspensionUpperLimit", 0.28)
	setVehicleHandling(vehicle, "suspensionLowerLimit", -0.25)
	setVehicleHandling(vehicle, "suspensionFrontRearBias", 0.5)
	setVehicleHandling(vehicle, "suspensionAntiDiveMultiplier", 0.3)

end

function resetHandling (vehicle)
	for property,value in pairs (getOriginalHandling(getElementModel(vehicle))) do
		setVehicleHandling(vehicle,property,value)
	end
end

addEventHandler("onVehicleEnter",root,
	function ()
		setHandling(source)
	end
)

addEventHandler("onResourceStop",resourceRoot,
	function ()
		for i,v in ipairs (getElementsByType("vehicle")) do
			resetHandling(v)
		end
	end
)

addEvent("onRaceStateChanging")
addEventHandler("onRaceStateChanging",root,
	function (newstate)
		if newstate == "TimesUp" then
			for i,v in ipairs (getElementsByType("vehicle")) do
				resetHandling(v)
			end
		end
	end
)