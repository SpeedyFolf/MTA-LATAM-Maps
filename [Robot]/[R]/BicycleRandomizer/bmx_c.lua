local oldZ = 0.60877597332001

addEventHandler("onClientKey", root, function(button, press)
	if isChatBoxInputActive() then return end
	
	local keys = getBoundKeys("accelerate")
	for keyName, state in pairs(keys) do
		if button == keyName and press then
			return triggerServerEvent("changeBike", localPlayer)
		end
	end
end )

addEventHandler("onClientElementModelChange", getRootElement(), function(oldModel, newModel)
	if getElementType(source) == "vehicle" and source == getPedOccupiedVehicle(localPlayer) then 
		local newZ = getElementDistanceFromCentreOfMassToBaseOfModel(getPedOccupiedVehicle(localPlayer))
		
		local x, y, z = getElementPosition(getPedOccupiedVehicle(localPlayer))
		setElementPosition(getPedOccupiedVehicle(localPlayer), x, y, z + (newZ - oldZ))
		oldZ = newZ
	end
end )

bindKey("num_0", "down", function()
	outputChatBox(getElementDistanceFromCentreOfMassToBaseOfModel(getPedOccupiedVehicle(localPlayer)))
end )