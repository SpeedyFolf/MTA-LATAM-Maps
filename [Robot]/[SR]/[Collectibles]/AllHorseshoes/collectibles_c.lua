local collectiblesPositions = {
	{ 1224.0, 2617.0, 11.0 },
	{ 2323.0, 1284.0, 97.0 },
	{ 2035.0, 2305.0, 18.0 },
	{ 2491.0, 2263.0, 15.0 },
	{ 1433.0, 2796.0, 20.0 },
	{ 2071.0, 0712.0, 11.0 },
	{ 2239.0, 1839.0, 18.0 },
	{ 2583.0, 2387.0, 16.0 },
	{ 2864.0, 0857.0, 13.0 },
	{ 2612.0, 2200.0, -1.0 },
	{ 2274.0, 1507.0, 24.0 },
	{ 2184.0, 2529.0, 11.0 },
	{ 1863.0, 2314.0, 15.0 },
	{ 2054.0, 2434.0, 166.0 },
	{ 1603.0, 1435.0, 11.0 },
	{ 1362.92, 1015.24, 11.0 },
	{ 2058.7, 2159.10, 16.0 },
	{ 2003.0, 1672.0, 12.0 },
	{ 2238.0, 1135.0, 49.0 },
	{ 1934.06, 0988.79, 22.0, },
	{ 1768.0, 2847.0, 09.0 },
	{ 1084.0, 1076.0, 11.0 },
	{ 2879.0, 2522.0, 11.0 },
	{ 2371.0, 2009.0, 15.0 },
	{ 1521.0, 1690.0, 10.6 },
	{ 2417.0, 1281.0, 21.0 },
	{ 1376.0, 2304.0, 15.0 },
	{ 1393.0, 1832.0, 12.34 },
	{ 0984.0, 2563.0, 12.0 },
	{ 1767.0, 0601.0, 13.0 },
	{ 2108.0, 1003.0, 46.0 },
	{ 2705.98, 1862.52, 24.41 },
	{ 2493.0, 0922.0, 16.0 },
	{ 1881.0, 2846.0, 11.0 },
	{ 2020.0, 2352.0, 11.0 },
	{ 1680.30, 2226.86, 16.11 },
	{ 1462.0, 0936.0, 10.0 },
	{ 2125.50, 0789.23, 11.45 },
	{ 2586.0, 1902.0, 15.0 },
	{ 0919.0, 2070.0, 11.0 },
	{ 2173.0, 2465.0, 11.0 },
	{ 2031.25, 2207.33, 11.0,  },
	{ 2509.0, 1144.0, 19.0 },
	{ 2215.0, 1968.0, 11.0 },
	{ 2626.0, 2841.0, 11.0 },
	{ 2440.08, 2161.07, 20.0 },
	{ 1582.0, 2401.0, 19.0 },
	{ 2077.0, 1912.0, 14.0 },
	{ 0970.0, 1787.0, 11.0 },
	{ 1526.22, 0751.0, 29.04 }
}

local collectibles = {}
local collectiblesCols = {}
local text

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
		collectibles[i] = createPickup(collectiblesPositions[i][1], collectiblesPositions[i][2], collectiblesPositions[i][3], 3, 954)
		collectiblesCols[i] = createColSphere(collectiblesPositions[i][1], collectiblesPositions[i][2], collectiblesPositions[i][3], 2.5)
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

addEventHandler("onClientColShapeHit", root, function(element, matchingDimension)
	if element and getElementType(element) == "player" and element == localPlayer and matchingDimension then
		for i = 1, #collectibles do
			if isElement(collectiblesCols[i]) and source == collectiblesCols[i] then
				destroyElement(collectiblesCols[i])
				destroyElement(collectibles[i])
				
				setElementData(localPlayer, "score", (getElementData(localPlayer, "score") or 0) + 1)
				text = true
				setTimer(function() text = false end, 6000, 1)
				
				triggerServerEvent("updateHorseshoes", localPlayer, i)
				
				local colshapes = getElementsByType("colshape", getResourceDynamicElementRoot(getResourceFromName("race")))
				if #colshapes > 0 then triggerEvent("onClientColShapeHit", colshapes[#colshapes], localPlayer) end
				
				break
			end
		end
	end
end )

addEventHandler("onClientRender", root, function()
	local screenX, screenY = guiGetScreenSize()
	if text then
		if getElementData(localPlayer, "score") < 50 then dxDrawBorderedText(2, "HORSESHOES " ..getElementData(localPlayer, "score").. " OUT OF 50", 0, 0, screenX, screenY*0.7, tocolor (175, 202, 230, 255), screenY/800, screenY/600, "bankgothic", "center", "center", true, false)
		else dxDrawBorderedText(2, "ALL HORSESHOES FOUND!", 0, 0, screenX, screenY*0.7, tocolor (175, 202, 230, 255), screenY/800, screenY/600, "bankgothic", "center", "center", true, false) end
	end
end )