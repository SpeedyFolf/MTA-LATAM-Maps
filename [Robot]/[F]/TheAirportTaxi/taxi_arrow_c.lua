-- Visuals
local taxiArrow, taxiBlip
arrowTarget = nil
local arrowHeight, arrowState = -0.3, true

addEventHandler("onClientPreRender", root, function()
	-- Rotate taxi arrow
	if arrowTarget and isElement(arrowTarget) then
		if not taxiArrow then
			taxiArrow = createObject(1318, 0, 0, 0)
			setObjectScale(taxiArrow, 1.8)
		end
		
		local taxiX, taxiY, taxiZ = getElementPosition(arrowTarget)
		local _, _, arrowRotation = getElementRotation(taxiArrow)
		
		arrowHeight = arrowHeight + (arrowState and 0.02 or (-0.02))
		if arrowHeight >= 0.3 or arrowHeight <= -0.3 then 
			arrowState = not arrowState 
		end
		
		setElementPosition(taxiArrow, taxiX, taxiY, taxiZ + 2.2 + arrowHeight)
		setElementRotation(taxiArrow, 0, 0, arrowRotation + 4)
		
		if not taxiBlip then taxiBlip = createBlipAttachedTo(arrowTarget, 55) end
	else
		if isElement(taxiArrow) then
			destroyElement(taxiArrow)
			destroyElement(taxiBlip)
		end
	end
	
	-- Handling
	for _, taxi in ipairs(getElementsByType("vehicle")) do
		if getElementModel(taxi) == 567 and getVehicleHandling(taxi, "maxVelocity") ~= 300.0 then
			setVehicleHandling(taxi, "engineInertia", 4.0)
			setVehicleHandling(taxi, "collisionDamageMultiplier", 0.4)
			setVehicleHandling(taxi, "turnMass", 3000.0)
			setVehicleHandling(taxi, "brakeBias", 0.52)
			setVehicleHandling(taxi, "centerOfMass", {0.0, 0.0, -0.3})
			setVehicleHandling(taxi, "tractionLoss", 1.2)
			setVehicleHandling(taxi, "tractionBias", 0.53)
			setVehicleHandling(taxi, "tractionMultiplier", 0.85)
			setVehicleHandling(taxi, "maxVelocity", 300.0)
			setVehicleHandling(taxi, "engineAcceleration", 20.0)
			setVehicleHandling(taxi, "mass", 2500.0)
			setVehicleHandling(taxi, "brakeDeceleration", 12.0)
		end
	end
end )