local markers = {
	{x = 3464.49, y = -2473.55, z = 98.67},
	{x = 3464.25, y = -2500.3701, z = 98.67},
	{x = 3452.26, y = -2500.97, z = 79.25},
	{x = 3455.8301, y = -2448.1299, z = 79.25},
	{x = 3467.79, y = -2522.5701, z = 79.23},
	{x = 3492.95, y = -2474.6201, z = 79.23},
	{x = 3503.6201, y = -2491.75, z = 79.23},
	{x = 3517.01, y = -2500.95, z = 79.23},
	{x = 3495.03, y = -2527.26, z = 79.23},
	{x = 3505.96, y = -2514.1599, z = 79.23},
	{x = 3523.6899, y = -2529.1001, z = 79.23},
	{x = 3526.47, y = -2563.3799, z = 78.94},
	{x = 3579.3, y = -2556.3201, z = 74.16},
	{x = 3573.55, y = -2522.8, z = 73.59},
	{x = 3597.9299, y = -2517.0601, z = 75.42},
	{x = 3603.1699, y = -2491.4199, z = 79.25},
	{x = 3583.98, y = -2493.72, z = 79.23},
	{x = 3564.1299, y = -2484.9099, z = 79.25},
	{x = 3576.6699, y = -2483.1201, z = 90.03},
	{x = 3557.8201, y = -2521.22, z = 81.95},
	{x = 3546.6101, y = -2512.4299, z = 79.23},
	{x = 3553.28, y = -2495.8701, z = 82.73},
	{x = 3483.9199, y = -2496, z = 88.86},
	{x = 3521.6599, y = -2446.74, z = 79.27},
	{x = 3516.79, y = -2413.21, z = 79.26},
	{x = 3526.6001, y = -2414.95, z = 77.04},
	{x = 3512.4299, y = -2432.96, z = 79.27},
	{x = 3536.74, y = -2408.6001, z = 85.81},
	{x = 3555.5701, y = -2406.6299, z = 79.29},
	{x = 3554.3501, y = -2404.1799, z = 66.21},
	{x = 3564.5, y = -2426.4199, z = 79.29},
	{x = 3583.8899, y = -2427.1799, z = 65.66},
	{x = 3587.8201, y = -2466.99, z = 74.4},
	{x = 3571.75, y = -2463.78, z = 79.27},
	{x = 3554.0701, y = -2442.8899, z = 79.27},
	{x = 3569.95, y = -2452.5801, z = 90.71},
	{x = 3493.1101, y = -2463.5801, z = 94.32},
	{x = 3473.3, y = -2472.47, z = 79.23},
	{x = 3480.3701, y = -2418.76, z = 79.25}
}

local cars = {589, 533, 445, 604, 585, 540, 421, 405, 420, 601, 428, 427, 531, 530, 415, 542, 575, 403}
local marker, markerCol, markerBlip
local checkpointsCollected = {}

function spawnNextMarker()
	if isElement(marker) then destroyElement(marker) end
	if isElement(markerCol) then destroyElement(markerCol) end
	if isElement(markerBlip) then destroyElement(markerBlip) end
	
	local randomMarker = markers[math.random(#markers)]
	
	marker = createMarker(randomMarker.x, randomMarker.y, randomMarker.z, "checkpoint", 5.0, 255, 0, 0, 200)
	markerCol = createColCircle(randomMarker.x, randomMarker.y, 5.0)
	markerBlip = createBlip(randomMarker.x, randomMarker.y, randomMarker.z, 0, 2, 255, 0, 0)
end

addEventHandler("onColShapeHit", root, function(element, dim)
	if source == markerCol and getElementType(element) == "vehicle" and getVehicleOccupant(element) then
		local player = getVehicleOccupant(element)
		
		local x, y, z = getElementPosition(player)
		if z < 10000 and ((checkpointsCollected[player] and checkpointsCollected[player] < 10) or not checkpointsCollected[player]) then
			spawnNextMarker()
			
			setElementModel(element, cars[math.random(#cars)])
			local x, y, z = getElementPosition(element)
			setElementPosition(element, x, y, z + 0.5)
			
			fixVehicle(element)
			
			if not checkpointsCollected[player] then 
				checkpointsCollected[player] = 1
			else checkpointsCollected[player] = checkpointsCollected[player] + 1 end
			
			if checkpointsCollected[player] == 10 then
				setElementModel(element, 572)
				outputChatBox("WARNING: somebody got a MOWER", root, 255, 0, 0, true)
			end
		end
	end
end )

spawnNextMarker()