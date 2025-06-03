addEventHandler("onClientPreRender", root, function()
	local magnetX, magnetY, magnetZ = getElementPosition(getElementByID("_CRANE_MAGNET"))
	local barX, barY, barZ = getElementPosition(getElementByID("_CRANE_BAR"))
	
	local ropeObjects = {
		[1] = "CRANE_REEL_1",
		[2] = "CRANE_REEL_2",
		[3] = "CRANE_REEL_3"
	}
	
	for i = 1, #ropeObjects - 1 do
		local fromX, fromY, fromZ = getElementPosition(getElementByID(ropeObjects[i]))
		local toX, toY, toZ = getElementPosition(getElementByID(ropeObjects[i + 1]))
		
		dxDrawLine3D(fromX, fromY, fromZ, toX, toY, toZ, tocolor(0, 0, 0, 255), 8)
	end
	
	dxDrawLine3D(magnetX, magnetY, magnetZ + 0.377, magnetX, magnetY, barZ + 7, tocolor(0, 0, 0, 255), 8) -- Rope from the magnet to bar
end )

addEventHandler("onClientRender", root, function()
	if getElementData(localPlayer, "state") == "dead" then
		local cameraPosX, cameraPosY, cameraPosZ = getElementPosition(getElementByID("CRANE_CAMERA"))
		local magnetX, magnetY, magnetZ = getElementPosition(getElementByID("_CRANE_MAGNET"))
		
		setElementAlpha(getElementByID("CRANE_WIRE"), 0)
		setCameraMatrix(cameraPosX, cameraPosY, cameraPosZ, magnetX, magnetY, math.min(magnetZ, 80), 0, 90)
	end
end )