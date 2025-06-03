local sirens = {}
local oldZ = 0.82

function createSirensForAVehicle()
	player = source
	
	-- Get player
	if not player then return end
	local vehicle = getPedOccupiedVehicle(player)
	if not vehicle then return end
	
	if isElement(sirens[player]) then
		detachElements(sirens[player])
		setElementModel(sirens[player], objectsList[math.random(#objectsList)])
	else
		sirens[player] = createObject(objectsList[math.random(#objectsList)], 0, 0, 0)
	end
	
	-- Calculate offset
	local x, y, z = getElementPosition(vehicle)
	local rx, ry, rz = getElementRotation(vehicle)
	setElementRotation(vehicle, 0, 0, 0)
	
	if getElementModel(vehicle) == 531 then
		hit, texU, texV, textureName, frameName, worldX, worldY, worldZ = processLineAgainstMesh(vehicle, x+0.2, y+1.1, z+20, x+0.2, y+1, z-10)
	else
		hit, texU, texV, textureName, frameName, worldX, worldY, worldZ = processLineAgainstMesh(vehicle, x+0.2, y+1.1, z+20, x+0.2, y-0.1, z-10)
	end
	setElementRotation(vehicle, rx, ry, rz)
	if not hit then return end
	
	-- Attach
	attachElements(sirens[player], vehicle, 0, -2, worldZ - z, 90 ,0, 0)
end 

addEvent("calculateOffset", true)
addEventHandler("calculateOffset", getRootElement(), function()
	local x, y, z = getElementPosition(getPedOccupiedVehicle(localPlayer))
	local rx, ry, rz = getElementRotation(getPedOccupiedVehicle(localPlayer))
	setElementRotation(getPedOccupiedVehicle(localPlayer), 0, 0, 0)
	
	hit, texU, texV, textureName, frameName, worldX, worldY, worldZ = processLineAgainstMesh(getPedOccupiedVehicle(localPlayer), x+0.2, y+1.1, z+20, x+0.2, y-0.1, z-10)
	setElementRotation(getPedOccupiedVehicle(localPlayer), rx, ry, rz)
	if not hit then return end
	
	triggerServerEvent("getOffset", localPlayer, worldZ, z)
end )


addEventHandler("onClientElementStreamIn", root, function()	
	if getElementType(source) == "object" and getElementAttachedTo(source) == getPedOccupiedVehicle(localPlayer) then
		--outputChatBox("ID: " ..getElementModel(source))
		local x, y, z, rx, ry, rz = getElementAttachedOffsets(source)
		triggerServerEvent("updateOffsets", localPlayer, getElementDistanceFromCentreOfMassToBaseOfModel(source), x, y, z)
	end
end )

addEventHandler("onClientElementModelChange", getRootElement(), function(oldModel, newModel)
	if getElementType(source) == "vehicle" then 
		if source == getPedOccupiedVehicle(localPlayer) then
			local newZ = getElementDistanceFromCentreOfMassToBaseOfModel(getPedOccupiedVehicle(localPlayer))
			if getVehicleType(getPedOccupiedVehicle(localPlayer)) == "Monster Truck" then newZ = newZ + 1 end
			
			local x, y, z = getElementPosition(getPedOccupiedVehicle(localPlayer))
			setElementPosition(getPedOccupiedVehicle(localPlayer), x, y, z + (newZ - oldZ))
			oldZ = newZ
		end
	end
end )