local MAX_DISTANCE = 10

local collectiblesPositions = {
	{ -2511.28, -672.99, 195.75 },
	{ -2723.63, -314.72, 55.79 },
	{ -1737.71, -579.55, 26.19 },
	{ -1486.08, 920.04, 41.37 },
	{ -1269.82, 963.63, 130.37 },
	{ -1650.01, 422.00, 21.17 },
	{ -1851.72, -96.73, 24.37 },
	{ -2732.0, -244.0, 19.0 },
	{ -2802.75, 375.47, 36.59 },
	{ -2773.04, 783.45, 67.66 },
	{ -2680.07, 1590.80, 143.53 },
	{ -2476.75, 1543.44, 49.26 },
	{ -1879.04, 1456.52, 9.34 },
	{ -1561.55, 655.19, 56.52 },
	{ -1325.15, 494.19, 26.83 },
	{ -1941.41, 137.72, 37.83 },
	{ -2153.23, 462.25, 103.27 },
	{ -2243.96, 577.76, 49.0 },
	{ -2051.0, 456.0, 167.0 },
	{ -1951.0, 659.0, 81.0 },
	{ -2064.0, 926.0, 63.0 },
	{ -2357.33, 1017.01, 59.76 },
	{ -2072.0, 1066.0, 74.0 },
	{ -1744.0, 972.46, 156.89 },
	{ -1941.0, 883.0, 68.0 },
	{ -1839.51, 1086.88, 101.29 },
	{ -1704.8, 1338.0, 14.0 },
	{ -2346.62, 536.85, 86.02 },
	{ -2443.0, 755.0, 49.0 },
	{ -2765.0, 375.0, 15.0 },
	{ -2880.31, -935.83, 40.82 },
	{ -2083.0, -808.0, 69.00 },
	{ -1954.0, -760.0, 53.00 },
	{ -964.53, -331.59, 47.16 },
	{ -1689.0, 51.0, 38.0 },
	{ -2080.0, 256.05, 107.0 },
	{ -2413.0, 331.0, 37.0 },
	{ -2244.42, 731.32, 61.88 },
	{ -2462.0, 369.0, 59.0 },
	{ -1124.44, -153.15, 18.50 },
	{ -1275.78, 53.68, 89.07 },
	{ -2430.0, 38.0, 51.0 },
	{ -2591.0, 162.0, 15.0 },
	{ -2591.0, -16.0, 17.0 },
	{ -2648.0, -5.0, 31.0 },
	{ -2593.0, 56.0, 16.0,  },
	{ -1619.31, 1341.39, 11.30 },
	{ -2307.0, 207.0, 42.0 },
	{ -2343.0, -79.0, 38.0 },
	{ -1906.66, 518.58, 61.71 }
}

local collectibles = {}
local text
local screenX, screenY = guiGetScreenSize()

function dxDrawBorderedText(outline, text, left, top, right, bottom, color, scaleX, scaleY, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    if type(scaleY) == "string" then
        scaleY, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY = scaleX, scaleY, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX
    end
    local outlineX = (scaleX or 1) * (1.333333333333334 * (outline or 1))
    local outlineY = (scaleY or 1) * (1.333333333333334 * (outline or 1))
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left - outlineX, top - outlineY, right - outlineX, bottom - outlineY, tocolor (0, 0, 0, 225), scaleX, scaleY, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left + outlineX, top - outlineY, right + outlineX, bottom - outlineY, tocolor (0, 0, 0, 225), scaleX, scaleY, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left - outlineX, top + outlineY, right - outlineX, bottom + outlineY, tocolor (0, 0, 0, 225), scaleX, scaleY, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left + outlineX, top + outlineY, right + outlineX, bottom + outlineY, tocolor (0, 0, 0, 225), scaleX, scaleY, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left - outlineX, top, right - outlineX, bottom, tocolor (0, 0, 0, 225), scaleX, scaleY, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left + outlineX, top, right + outlineX, bottom, tocolor (0, 0, 0, 225), scaleX, scaleY, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left, top - outlineY, right, bottom - outlineY, tocolor (0, 0, 0, 225), scaleX, scaleY, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left, top + outlineY, right, bottom + outlineY, tocolor (0, 0, 0, 225), scaleX, scaleY, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText (text, left, top, right, bottom, color, scaleX, scaleY, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	-- Create All Pickups
	for i = 1, #collectiblesPositions do
		collectibles[i] = createPickup(collectiblesPositions[i][1], collectiblesPositions[i][2], collectiblesPositions[i][3], 3, 1253)
	end	
	
	setElementData(localPlayer, "score", 0)
	
	setTimer(function()
		if getElementData(localPlayer, "race.checkpoint") and getElementData(localPlayer, "score") and getElementData(localPlayer, "race.checkpoint") < getElementData(localPlayer, "score") + 1 then
			for i = 1, (getElementData(localPlayer, "score") + 1 - getElementData(localPlayer, "race.checkpoint")) do
				local colshapes = getElementsByType("colshape", getResourceDynamicElementRoot(getResourceFromName("race")))
				if #colshapes > 0 then triggerEvent("onClientColShapeHit", colshapes[#colshapes], localPlayer) end
			end
		end
	end, 5000, 0)
end )

addEventHandler("onClientPlayerWeaponFire", root, function(weapon)
	if source == localPlayer and weapon and weapon == 43 then
		local points = {
			{0.2, 0.5},
			{0.8, 0.5},
			{0.5, 0.2},
			{0.5, 0.8}
		}
		
		for i, v in pairs(points) do
			local startX, startY, startZ = getWorldFromScreenPosition(screenX*v[1], screenY*v[2], 0)
			local endX, endY, endZ = getWorldFromScreenPosition(screenX*v[1], screenY*v[2], 2000)
			
			for snapshot = 1, #collectibles do
				if isElement(collectibles[snapshot]) and (getDistanceBetweenPointAndLine3D(collectiblesPositions[snapshot][1], collectiblesPositions[snapshot][2], collectiblesPositions[snapshot][3], startX, startY, startZ, endX, endY, endZ) < MAX_DISTANCE or isElementOnScreen(collectibles[snapshot])) then
					--outputChatBox("Distance: " ..getDistanceBetweenPointAndLine3D(collectiblesPositions[snapshot][1], collectiblesPositions[snapshot][2], collectiblesPositions[snapshot][3], startX, startY, startZ, endX, endY, endZ))
					
					destroyElement(collectibles[snapshot])
					
					setElementData(localPlayer, "score", (getElementData(localPlayer, "score") or 0) + 1)
					text = true
					setTimer(function() text = false end, 6000, 1)
					
					triggerServerEvent("updateSnapshots", localPlayer, snapshot)
					
					local colshapes = getElementsByType("colshape", getResourceDynamicElementRoot(getResourceFromName("race")))
					if #colshapes > 0 then triggerEvent("onClientColShapeHit", colshapes[#colshapes], localPlayer) end
				
					return
				end
			end
		end
		
	end
end )

addEventHandler("onClientRender", root, function()
	if text then
		if getElementData(localPlayer, "score") < 50 then dxDrawBorderedText(2, "SNAPSHOT " ..getElementData(localPlayer, "score").. " OUT OF 50", 0, 0, screenX, screenY*0.7, tocolor (175, 202, 230, 255), screenY/800, screenY/600, "bankgothic", "center", "center", true, false)
		else dxDrawBorderedText(2, "ALL SNAPSHOTS TAKEN!", 0, 0, screenX, screenY*0.7, tocolor (175, 202, 230, 255), screenY/800, screenY/600, "bankgothic", "center", "center", true, false) end
	end
end )

function getDistanceBetweenPointAndLine3D(x, y, z, startX, startY, startZ, endX, endY, endZ)
	local line = Vector3(startX-endX, startY-endY, startZ-endZ)
	local point = Vector3(startX-x, startY-y, startZ-z)
	
	return line:cross(point).length / line.length
end