addEventHandler("onClientExplosion", root, function(x, y, z, t)
	if t == 4 then
		cancelEvent()
	end
end)

function dxDrawBorderedText (outline, text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
	local outline = (scale or 1) * (1.333333333333334 * (outline or 1))
	dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left - outline, top - outline, right - outline, bottom - outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
	dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left + outline, top - outline, right + outline, bottom - outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
	dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left - outline, top + outline, right - outline, bottom + outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
	dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left + outline, top + outline, right + outline, bottom + outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
	dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left - outline, top, right - outline, bottom, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
	dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left + outline, top, right + outline, bottom, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
	dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left, top - outline, right, bottom - outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
	dxDrawText (text:gsub("#%x%x%x%x%x%x", ""), left, top + outline, right, bottom + outline, tocolor (0, 0, 0, 225), scale, font, alignX, alignY, clip, wordBreak, postGUI, false, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
	dxDrawText (text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	setWaterColor(210,180,0,180)
	addEventHandler("onClientRender", root, function()
		local screenWidth, screenHeight = guiGetScreenSize()
		dxDrawBorderedText(0.7,"dodge#E60000COCK#FFFFFF", screenWidth / 2 - 240, screenHeight * 0.025,  screenWidth, screenHeight, tocolor(222, 222, 222, 255), 6, "default-bold", center, top, false, false, false, true)
		dxDrawBorderedText(0.7,"™", screenWidth / 2 + 218, screenHeight * 0.025 + 13,  screenWidth, screenHeight, tocolor(222, 222, 222, 255), 2, "default-bold", center, top, false, false, false, true)
		dxDrawBorderedText(0.3,"______________________________________________________________", screenWidth / 2 - 270, screenHeight * 0.025 + 85,  screenWidth, screenHeight, tocolor(222, 222, 222, 255), 1.2, "default-bold", center, top, false, false, false, true)
		dxDrawBorderedText(0.5,"do not let the COCK touch you", screenWidth / 2 - 195, screenHeight * 0.025 + 110,  screenWidth, screenHeight, tocolor(222, 222, 222, 255), 2, "sans")
	end)
end)

function chickendamage(hitElement)
	if (source == getPedOccupiedVehicle(localPlayer)) then
		if (isElement(hitElement) and getElementModel(hitElement) == 16776) then
			setElementHealth(source, getElementHealth(source) - 25)

			triggerServerEvent("onChickenHit", localPlayer, hitElement)
		end
	end
end
addEventHandler("onClientVehicleCollision",getRootElement(),chickendamage)

function deathsound(killer, weapon, bodypart)
	playSound("buckawk.mp3")
end
addEventHandler("onClientPlayerWasted", localPlayer, deathsound)

addEvent("playChickenSound", true)
addEventHandler("playChickenSound", localPlayer, function(sound)
	if sound == "cockadoodledoo" then
		playSound("cockadoodledoo.mp3")
	elseif sound == "cluck" then
		playSound("cluck.mp3")
	end
end)


SONGNAME = "chickendance.mp3"

function startMusic()
	-- setRadioChannel(0)
	songOn = false
	song = playSound(SONGNAME,true)
	setSoundVolume(song,0)
	outputChatBox("Press M to toggle appropriate music!")
end

function makeRadioStayOff(cancel)
	if (not songOn) then
		return
	end
	setRadioChannel(0)
	if (cancel) then
		cancelEvent()
	end
end

function toggleSong()
	if songOn then
		setSoundVolume(song,0)
		songOn = false
	else
		setSoundVolume(song,0.5)
		songOn = true
		setRadioChannel(0)
	end
end

addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),startMusic)
addEventHandler("onClientPlayerRadioSwitch",getRootElement(),makeRadioStayOff,true)
addEventHandler("onClientPlayerVehicleEnter",getRootElement(),makeRadioStayOff,false)
addCommandHandler("musicmusic",toggleSong)
bindKey("m","down","musicmusic")

function cockOff()
	local x, y, z = getElementPosition(localPlayer)
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if vehicle and z < 97 then 
		setElementHealth(vehicle, getElementHealth(vehicle) - 5000)
	end
end
addEventHandler("onClientRender", getRootElement(), cockOff)
