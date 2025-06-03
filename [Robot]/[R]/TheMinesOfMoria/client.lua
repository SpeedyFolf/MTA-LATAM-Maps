function blowOnCollisionWithModel_Handler(hitElement)
	if (source == getPedOccupiedVehicle(localPlayer)) then
		if (isElement(hitElement) and getElementModel(hitElement) == 4182) then
			blowVehicle(source)
		end
	end
end
addEventHandler("onClientVehicleCollision",getRootElement(),blowOnCollisionWithModel_Handler)

function changeDistance()
	for i,object in pairs(getElementsByType("object")) do
		if isElement(object) then
			local elementID = getElementModel(object)
			engineSetModelLODDistance(elementID,500,true)
		end
	end
end
addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),changeDistance)

function text4OnCollisionWithModel_Handler(hitElement)
	if (source == getPedOccupiedVehicle(localPlayer)) then
		if (isElement(hitElement) and getElementModel(hitElement) == 1598) then
			outputChatBox("There are no no Easter Eggs inside here. Go away.",255,0,0,true)
			removeEventHandler("onClientVehicleCollision",getRootElement(),text4OnCollisionWithModel_Handler)
		end
	end
end
addEventHandler("onClientVehicleCollision",getRootElement(),text4OnCollisionWithModel_Handler)

function text5OnCollisionWithModel_Handler(hitElement)
	if (source == getPedOccupiedVehicle(localPlayer)) then
		if (isElement(hitElement) and getElementModel(hitElement) == 1795) then
			outputChatBox("What on Middle-Earth are you looking at?",255,0,0,true)
			removeEventHandler("onClientVehicleCollision",getRootElement(),text5OnCollisionWithModel_Handler)
		end
	end
end
addEventHandler("onClientVehicleCollision",getRootElement(),text5OnCollisionWithModel_Handler)





-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@ # # The Destroyening of the Ring # # @@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

-- Screenplay by Mawfeen (no tm)
-- Coding powered by ChatGPT (tm)

puzzle3Effects = {}

-- Replace bridge here cause frog dis shid
local khazaddum = {}
khazaddum[1] = createObject(9339, 2418.8906, 1099.6504, -78.46183, 0, 0, 90)
khazaddum[2] = createObject(9339, 2414.9092, 1097.2256, -78.46183, 0, 0, 90)
khazaddum[3] = createObject(8185, 2422.8682, 1098.4307, -77.85816, 0, -90, 90)
setObjectScale(khazaddum[3], 0.61)
setElementCollisionsEnabled(khazaddum[3], false) 
khazaddum[4] = createObject(9339, 2418.8555, 1097.9707, -77.91029, 0, 90, 90)
khazaddum[5] = createObject(9339, 2418.8555, 1098.9731, -77.91029, 0, 90, 90)
khazaddum[6] = createObject(9339, 2418.8906, 1099.6504, -79.58958, 0, 0, 90)
khazaddum[7] = createObject(9339, 2414.9092, 1097.2256, -79.65578, 0, 0, 90)

-- Prevent re-triggering
local puzzleTriggers = {
	puzzletrigger1 = false,
	puzzletrigger2 = false,
	puzzletrigger3 = false,
	puzzletrigger4 = false,
	puzzletrigger5 = false,
	puzzletrigger6 = false,
	audioTrigger1 = false,
	audioTrigger2 = false,
	flyTrigger = false,
	lance_latifi_brain_dmg_trigger = false
}

-- Get puzzle trigger elements from the map
local puzzleTrigger1 = getElementByID("puzzletrigger1")
local puzzleTrigger2 = getElementByID("puzzletrigger2")
local puzzleTrigger3 = getElementByID("puzzletrigger3")
local puzzleTrigger4 = getElementByID("puzzletrigger4")
local puzzleTrigger5 = getElementByID("puzzletrigger5")
local puzzleTrigger6 = getElementByID("puzzletrigger6")
local audioTrigger1 = getElementByID("audiotrigger1")
local audioTrigger2 = getElementByID("audiotrigger2")
local flyTrigger = getElementByID("flytrigger")

-- Create colshapes at those positions (for puzzle triggers)
if isElement(puzzleTrigger1) then
	local x, y, z = getElementPosition(puzzleTrigger1)
	local colPuzzle1 = createColSphere(x, y, z, 3.5)
	setElementData(colPuzzle1, "id", "puzzletrigger1")
	puzzleglow1 = createMarker(x, y, z, "corona", 3, 150, 250, 250, 50)
end
if isElement(puzzleTrigger2) then
	local x, y, z = getElementPosition(puzzleTrigger2)
	local colPuzzle2 = createColSphere(x, y, z, 5)
	setElementData(colPuzzle2, "id", "puzzletrigger2")
	puzzleglow2 = createMarker(x, y, z, "corona", 4.5, 150, 250, 250, 65)
end
if isElement(puzzleTrigger3) then
	local x, y, z = getElementPosition(puzzleTrigger3)
	local colPuzzle3 = createColSphere(x, y, z, 3)
	setElementData(colPuzzle3, "id", "puzzletrigger3")
	puzzleglow3 = createObject(3096, x, y, z - 0.85)
	setObjectScale(puzzleglow3, 0)
end
if isElement(puzzleTrigger4) then
	local x, y, z = getElementPosition(puzzleTrigger4)
	local colPuzzle4 = createColSphere(x, y, z - 2, 2.9)
	setElementData(colPuzzle4, "id", "puzzletrigger4")
	puzzleglow4 = createMarker(x, y, z - 2.5, "corona", 4.5, 150, 250, 250, 50)
end
if isElement(puzzleTrigger5) then
	local x, y, z = getElementPosition(puzzleTrigger5)
	local colPuzzle5 = createColSphere(x, y, z - 2, 5)
	setElementData(colPuzzle5, "id", "puzzletrigger5")
	puzzleglow5 = createMarker(x, y, z - 2.3, "corona", 4.5, 150, 250, 250, 50)
end
if isElement(puzzleTrigger6) then
	local x, y, z = getElementPosition(puzzleTrigger6)
	local colPuzzle6 = createColCuboid(x, y, z, 200, 200, 15)
	setElementData(colPuzzle6, "id", "puzzletrigger6")
end
if isElement(audioTrigger1) then
	local x, y, z = getElementPosition(audioTrigger1)
	local colAudio1 = createColSphere(x, y, z, 35)
	setElementData(colAudio1, "id", "audiotrigger1")
	audioglow5 = createMarker(x, y, z, "corona", 10, 150, 250, 250, 25)
end
if isElement(audioTrigger2) then
	local x, y, z = getElementPosition(audioTrigger2)
	local colAudio2 = createColSphere(x, y, z, 3)
	setElementData(colAudio2, "id", "audiotrigger2")
end
if isElement(flyTrigger) then
	local x, y, z = getElementPosition(flyTrigger)
	local colFly = createColSphere(x, y, z, 25)
	setElementData(colFly, "id", "flytrigger")
end

-- Handle player vehicle entering the colshape
function onPuzzleColHit(element, matchingDimension)
	if element == getPedOccupiedVehicle(localPlayer) then
		local triggerID = getElementData(source, "id")

		if triggerID == "puzzletrigger1" and not puzzleTriggers.puzzletrigger1 then
			puzzleTriggers.puzzletrigger1 = true

			outputChatBox("[I] #DEDEDEThe withered markings read...", 0, 255, 0, true)
			outputChatBox("Whispers echo through the mines,", 150, 150, 150, true)
			outputChatBox("Of ancient treasure one might find.", 150, 150, 150, true)
			outputChatBox("Close outside the depths, able carriage collect,", 150, 150, 150, true)
			outputChatBox("And seek guidance from the light.", 150, 150, 150, true)

			if isElement(puzzleglow1) then
				destroyElement(puzzleglow1)
			end
		elseif triggerID == "puzzletrigger2" and not puzzleTriggers.puzzletrigger2 then
			puzzleTriggers.puzzletrigger2 = true

			outputChatBox("[II] #DEDEDEThe withered markings read...", 0, 255, 0, true)
			outputChatBox("Behold, the gates of old,", 150, 150, 150, true)
			outputChatBox("Once stopped all, now holds none,", 150, 150, 150, true)
			outputChatBox("Yet still home to one.", 150, 150, 150, true)
			local vehicle = getPedOccupiedVehicle(localPlayer)
			if isElement(vehicle) and getElementModel(vehicle) ~= 468 then
				setTimer(function()
					outputChatBox("You feel as if you've managed to already miss something...", 222, 222, 222, true) -- In case [I] was skipped
				end, 3000, 1)
			end
			if isElement(puzzleglow2) then
				destroyElement(puzzleglow2)
			end
		elseif triggerID == "puzzletrigger3" and not puzzleTriggers.puzzletrigger3 then
			puzzleTriggers.puzzletrigger3 = true
			triggerServerEvent("showPuzzle3EffectForAll", resourceRoot, localPlayer)
			outputChatBox("[III] #DEDEDEIt's a ring... its engravings glow brightly.", 0, 255, 0, true)
			outputChatBox("''~ BALIN'S TOMB ~''", 230, 220, 160, true)
			setTimer(function()
				outputChatBox("Spúgol:#FFFFFF ARRGHGHGBLLB!!!! my precious... give BACK... NOWE... don't destroy!!!", 101, 189, 210, true)
			end, 1800, 1)
			if isElement(puzzleglow3) then
				destroyElement(puzzleglow3)
			end

		elseif triggerID == "puzzletrigger4" and not puzzleTriggers.puzzletrigger4 then
			puzzleTriggers.puzzletrigger4 = true
			if puzzleTriggers.puzzletrigger3 == false then
				setTimer(resetTrigger4, 5000, 1)
				outputChatBox("The withered epitaph reads...", 222, 222, 222, true) -- Missing the ring
				outputChatBox("HE  E • LIES • BALIN • S  N • OF • FUNDIN", 80, 80, 80, true)
				outputChatBox("THE • DWARF • LO  D •	F • MORIA", 80, 80, 80, true)
				outputChatBox("ONE • TO • RE	MBER • AMONG • ALL", 80, 80, 80, true)
				setTimer(function()
					outputChatBox("You feel as if you've skipped a step before this epitaph will be of use...", 222, 222, 222)
					end, 3000, 1)
				return
			end
			outputChatBox("[IV] #DEDEDEThe epitaph is glowing curiously...", 0, 255, 0, true)
			outputChatBox("HE  #BEBEBEE#787878 • LIES • B#BEBEBEA#787878LIN • #BEBEBES#787878  N • O#505050F • FU#787878NDIN", 80, 80, 80, true)
			outputChatBox("#BEBEBET#505050HE • D#BEBEBEW#505050ARF • LO  #787878D •	F • MO#787878RI#BEBEBEA", 80, 80, 80, true)
			outputChatBox("ONE • #BEBEBET#505050O • RE#787878	MB#BEBEBEER • #787878AMO#505050NG • ALL", 80, 80, 80, true)
			if isElement(puzzleglow4) then
				destroyElement(puzzleglow4)
			end

		elseif triggerID == "puzzletrigger5" then
			local vehicle = getPedOccupiedVehicle(localPlayer)

			-- First activation
			if not puzzleTriggers.puzzletrigger5 then
				puzzleTriggers.puzzletrigger5 = true
			
				if puzzleTriggers.puzzletrigger3 == false then
					setTimer(resetTrigger5, 5000, 1)
					outputChatBox("You feel as if you forgot to bring something crucial with you...", 222, 222, 222, true)
					return
				end
			
				outputChatBox("[V] #DEDEDEThe gravestone reads...", 0, 255, 0, true)
				outputChatBox("''Fly, you fool!''", 150, 150, 150, true)
			
				if isElement(puzzleglow5) then
					destroyElement(puzzleglow5)
				end
			
				if element == vehicle and isElement(vehicle) then
					setTimer(function()
						triggerVehicleChange(501) -- RC Goblin
						setElementPosition(vehicle, 2330, 1520, -6)
						puzzleTriggers.lance_latifi_brain_dmg_trigger = true
					end, 2000, 1)
				end
			
				setWaterLevel(-100, true, true, true)
				local x, y, z = getElementPosition(puzzleTrigger5)
				local height = 59
				local lavapool = createWater(2384, 1367, height, 2806, 1367, height, 2384, 1600, height, 2806, 1600, height)
				setWaveHeight(2)
				setWaterColor(255, 120, 0, 255)
			
			-- Second trigger condition (already set flag)
			elseif puzzleTriggers.lance_latifi_brain_dmg_trigger then
				if isElement(vehicle) and getElementModel(vehicle) ~= 501 then
					outputChatBox("Fool of a Lance!", 250, 50, 50, true)
					setTimer(function()
						outputChatBox("Disconnect yourself next time and rid us of your stupidity!", 250, 50, 50, true)
					end, 2500, 1)
					if element == vehicle then
						triggerVehicleChange(501)
						setElementPosition(vehicle, 2330, 1520, -6)
					end
				end
			end
		
		elseif triggerID == "flytrigger" and not puzzleTriggers.flytrigger then
			puzzleTriggers.flytrigger = true
			outputChatBox("You feel the burden of the ring get heavier as you get closer...", 222, 222, 222 , true)
		
			setHeatHaze(50, 20, 0, 500, 200, 100, 50, 20, true)
		
			local startTime = getTickCount()
			local duration = 30000
		
			local startGradient = {20, 50, 50, 17, 46, 45}
			local endGradient   = {50, 20, 20, 47, 26, 25}
		
			local startFilter = {124, 124, 124, 254, 30, 30, 32, 254}
			local endFilter   = {100, 0, 0, 200, 250, 50, 50, 254}
		
			local function interpolateEffects()
				local now = getTickCount()
				local elapsed = now - startTime
				local progress = math.min(elapsed / duration, 1)
			
				-- Sky gradient
				local r1 = interpolateBetween(startGradient[1], 0, 0, endGradient[1], 0, 0, progress, "Linear")
				local g1 = interpolateBetween(startGradient[2], 0, 0, endGradient[2], 0, 0, progress, "Linear")
				local b1 = interpolateBetween(startGradient[3], 0, 0, endGradient[3], 0, 0, progress, "Linear")
				local r2 = interpolateBetween(startGradient[4], 0, 0, endGradient[4], 0, 0, progress, "Linear")
				local g2 = interpolateBetween(startGradient[5], 0, 0, endGradient[5], 0, 0, progress, "Linear")
				local b2 = interpolateBetween(startGradient[6], 0, 0, endGradient[6], 0, 0, progress, "Linear")
				setSkyGradient(r1, g1, b1, r2, g2, b2)
			
				-- Color filter
				local cf = {}
				for i = 1, 8 do
					cf[i] = interpolateBetween(startFilter[i], 0, 0, endFilter[i], 0, 0, progress, "Linear")
				end
				setColorFilter(unpack(cf))
			
				-- Stop interpolation after done
				if progress >= 1 then
					removeEventHandler("onClientRender", root, interpolateEffects)
				end
			end
		
			-- Start interpolation
			addEventHandler("onClientRender", root, interpolateEffects)


		elseif triggerID == "puzzletrigger6" and puzzleTriggers.puzzletrigger5 and not puzzleTriggers.puzzletrigger6 then
			puzzleTriggers.puzzletrigger6 = true
			setTimer(function()
				outputChatBox("[VI] #FFEF00You have seemingly destroyed some ring!", 0, 255, 0, true)
				triggerServerEvent("removePuzzle3EffectForAll", resourceRoot, localPlayer)
				resetColorFilter()
				resetWaterColor()
				resetSkyGradient()
				setWeather(9)


			-- Achievement trigger only requires step 6
				triggerServerEvent("achievement", localPlayer, "minesOfMoriaPuzzle")
			end, 1500, 1)


			-- Vehicle change + instructions for the thick-skulled
		elseif triggerID == "audiotrigger1" and not puzzleTriggers.audiotrigger1 then
			puzzleTriggers.audiotrigger1 = true	
			setTimer(function()
				local sound = playSound("intothefire.mp3", false)
				setSoundVolume(sound, 0.8)
				outputChatBox("Elrond:#FFFFFF Cast it into the fire!", 230, 255, 200, true)
			end, 2500, 1)
			setTimer(function()
				outputChatBox("Elrond:#FFFFFF Destroy it!", 230, 255, 200, true)
			end, 5100, 1)
			if element == getPedOccupiedVehicle(localPlayer) then
				local vehicle = getPedOccupiedVehicle(localPlayer)
				if isElement(vehicle) then
					triggerVehicleChange(468) -- Sanchez
				end
			end
			if isElement(audioglow2) then
				destroyElement(audioglow2)
			end

			-- If players don't follow the steps, they get slapped by Gandalf himself
		elseif triggerID == "audiotrigger2" and puzzleTriggers.puzzletrigger3 and not puzzleTriggers.audiotrigger2 and not puzzleTriggers.puzzletrigger6 then
			puzzleTriggers.audiotrigger2 = true	
			local bx, by, bz = getElementPosition(khazaddum[4])
			local x, y, z = getElementPosition(localPlayer)
			triggerServerEvent("playSoundForAllNearby", resourceRoot, localPlayer, "pass.mp3")

			outputChatBox("Gandalf:#FFFFFF YOU...", 200, 200, 200, true)
			setTimer(function()
				outputChatBox("Gandalf:#FFFFFF SHALL NOT", 200, 200, 200, true)
			end, 1500, 1)
			setTimer(function()
				outputChatBox("Gandalf:#FFFFFF PASS!", 200, 200, 200, true)
			end, 3000, 1)
			setTimer(function()
				for _, object in ipairs(khazaddum) do
					if isElement(object) then
						destroyElement(object)
					end
				end
				local px, py, pz = getElementPosition(localPlayer)
				createExplosion(px, py, pz, 11, true, -1.0, true)
				createExplosion(bx, by, bz - 3, 10, true, -1.0, true)
				triggerServerEvent("onAudioTrigger2Kill", resourceRoot)
			end, 4800, 1)
			setTimer(function()
				outputChatBox("You feel as if leaving Moria with the ring is not an option...", 222, 222, 222, true)
			end, 7000, 1)
		end
	end
end
addEventHandler("onClientColShapeHit", root, onPuzzleColHit)


-- Ring carry effect
addEvent("showPuzzle3Effect", true)
addEventHandler("showPuzzle3Effect", root, function(triggeringPlayer)
	if not isElement(triggeringPlayer) then
		return
	end
	if puzzle3Effects[triggeringPlayer] then
		return
	end -- Avoid duplicates

	local vehicle = getPedOccupiedVehicle(triggeringPlayer)
	if not isElement(vehicle) then
		return
	end

	local ringGlow = createMarker(0, 0, 0, "corona", 2.5, 255, 250, 222, 25)
	attachElements(ringGlow, vehicle, 0, 0, 0)

	local ringMarker = createMarker(0, 0, 0, "ring", 0.02, 255, 250, 222, 255)
	attachElements(ringMarker, vehicle, 0.2, 0.25, 0.68)

	puzzle3Effects[triggeringPlayer] = {ringGlow, ringMarker}
end)

addEvent("removePuzzle3Effect", true)
addEventHandler("removePuzzle3Effect", root, function(targetPlayer)
	local effects = puzzle3Effects[targetPlayer]
	if effects then
		for _, element in ipairs(effects) do
			if isElement(element) then
				destroyElement(element)
			end
		end
		puzzle3Effects[targetPlayer] = nil
	end
end)

-- Reset triggers if missing ring
function resetTrigger4()
	puzzleTriggers.puzzletrigger4 = false
end
function resetTrigger5()
	puzzleTriggers.puzzletrigger5 = false
end

-- Vehicle change
function triggerVehicleChange(newModel)
	triggerServerEvent("changePlayerVehicleModel", resourceRoot, newModel)
end

-- Audible Gandalf
addEvent("playSound3DForPlayer", true)
addEventHandler("playSound3DForPlayer", resourceRoot, function(soundFile, x, y, z)
	local sound = playSound3D(soundFile, x, y, z, false)
	setSoundVolume(sound, 0.5)
	setSoundMaxDistance(sound, 500)
end)
