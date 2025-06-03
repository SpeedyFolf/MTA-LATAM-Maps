local weedLeft = 0
local weedHarvested = 0
local weedUpdateTimer

addEvent("createWeedFire", true)
addEventHandler("createWeedFire", getRootElement(), function(fires, weed)
	-- Create fires
	for _, fire in pairs(fires) do
		createFire(fire.fireX, fire.fireY, 128.22, 3)
	end
	
	-- Update counter for remaining weed
	weedLeft = weed
end )

addEventHandler("onClientObjectBreak", root, function(attacker)
	if isElement(source) and getElementModel(source) == 3409 and attacker and getElementType(attacker) == "vehicle" and getPedOccupiedVehicle(localPlayer) and attacker == getPedOccupiedVehicle(localPlayer) then
		weedHarvested = weedHarvested + 1
		setElementData(localPlayer, "weedHarvested", weedHarvested)
	end
end )

addEvent("onClientMapStarting", true)
addEventHandler("onClientMapStarting", root, function()
	-- Fog
	setFarClipDistance(60)
	
	-- Weed check timer
	weedUpdateTimer = setTimer(function()	
		local damagedWeed = {}
		for _, v in ipairs(getElementsByType("object")) do
			if getElementModel(v) == 3409 and getElementHealth(v) == 0 then
				table.insert(damagedWeed, getElementData(v, "ID"))
			end
		end
		
		triggerServerEvent("updateBurnedWeed", localPlayer, damagedWeed)
		setCameraDrunkLevel(math.min(255, getCameraDrunkLevel() + 2))
	end, 1000, 0)

	-- Hide the race progress bar, because its useless here
	setTimer(function() exports.race_progress:getCustomDataFromRace({}, {}) end, 500, 1)
end )

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

-- Visuals
addEventHandler("onClientRender", root, function()
	local screenX, screenY = guiGetScreenSize()
	local screenAspect = math.floor((screenX / screenY)*10)/10

	if screenAspect >= 1.7 then -- 16:9 screen ratio
		offsets = {0.8, 0.92}
	else -- 4:3 and others screens
		offsets = {0.72, 0.9}
	end
	
	-- distance
	dxDrawBorderedText(2, "WEED LEFT:", screenX * offsets[1], screenY * 0.25, screenX, screenY, tocolor(172, 203, 241, 255), 1, "bankgothic")
	dxDrawBorderedText(2, tostring(weedLeft), screenX * offsets[2], screenY * 0.25, screenX, screenY, tocolor(172, 203, 241, 255), 1, "bankgothic")
	-- speed
	dxDrawBorderedText(2, "HARVESTED:", screenX * offsets[1], screenY * 0.29, screenX, screenY, tocolor(172, 203, 241, 255), 1, "bankgothic")
	dxDrawBorderedText(2, tostring(weedHarvested), screenX * offsets[2], screenY * 0.29, screenX, screenY, tocolor(172, 203, 241, 255), 1, "bankgothic")
end )

addEvent("finishTheWeed", true)
addEventHandler("finishTheWeed", getRootElement(), function()
	local colshapes = getElementsByType("colshape", getResourceDynamicElementRoot(getResourceFromName("race")))
	if #colshapes > 0 then triggerEvent("onClientColShapeHit", colshapes[#colshapes], getPedOccupiedVehicle(localPlayer)) end
end )