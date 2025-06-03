local c_marker = { createMarker(0, 0, 0, "ring", 2, 200, 65, 0), createMarker(0, 0, 0, "ring", 2, 200, 65, 0) }
local c_pos = { {0, 0, 0}, {0, 0, 0} }

setFarClipDistance(2800)

addEventHandler("onClientRender", root, function()
	-- checkpoints
	local markers = getElementsByType("marker", getResourceDynamicElementRoot(getResourceFromName("race")))
	for i, marker in ipairs(markers) do
		if getMarkerType(marker) == "ring" then
			local x, y, z = getElementPosition(marker)
			local tx, ty, tz = getMarkerTarget(marker)
			local size = getMarkerSize(marker)
			
			if c_pos[i][1] ~= x then
				c_pos[i][1] = x
				c_pos[i][2] = y
				c_pos[i][3] = z
				
				setElementPosition(c_marker[i], x, y, z)
				setMarkerSize(c_marker[i], size - 3.1)
				if tx then setMarkerTarget(c_marker[i], tx, ty, tz) end
			end
		else setElementPosition(c_marker[i], 0, 0, -50) end
	end
end )