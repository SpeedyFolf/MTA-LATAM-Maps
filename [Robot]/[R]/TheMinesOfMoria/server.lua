function handling (  )
	for _,veh in pairs(getElementsByType("vehicle")) do
		if getElementModel(veh) == 541 then
			setVehicleHandling(veh,"collisionDamageMultiplier",0.15)
			setVehicleHandling(veh,"tractionMultiplier",0.85)
			setVehicleHandling(veh,"headLight",long)
		end
	end
end
addEventHandler ( "onPlayerVehicleEnter", getRootElement(), handling )


-- DDC OMG generated script, PLACE IT SERVER-SIDE

function omg_script98()
	fallingrock2 = createObject(3929, 1228.1734619141, 1232.3442382812, 45.645729064941, 0, 0, 0)
	omgMovefallingrock2(1)
	fallingrock1 = createObject(3931, 526.01892089844, 2859.5024414062, 109.58410644531, 0, 0, 0)
	omgMovefallingrock1(1)
end

function omgMovefallingrock2(point)
	if point == 1 then
		moveObject(fallingrock2, 1133, 1228.1734619141, 1232.3442382812, -40.174785614014, -30.25372314453, -36.60144042969, -20.51568603516)
		setTimer(omgMovefallingrock2, 1133, 1, 2)
	elseif point == 2 then
		moveObject(fallingrock2, 80, 1227.2962646484, 1234.4743652344, -38.671112060547, -28.56207275391, 106.04125976563, 114.84146118164)
		setTimer(omgMovefallingrock2, 80, 1, 3)
	elseif point == 3 then
		moveObject(fallingrock2, 80, 1226.6697998047, 1237.6070556641, -38.224796295166, 13.14212036133, 7.9912109375, 6.363677978516)
		setTimer(omgMovefallingrock2, 80, 1, 4)
	elseif point == 4 then
		moveObject(fallingrock2, 80, 1225.7926025391, 1239.4866943359, -39.477855682373, 79.429138183594, 26.647247314452, 45.01959228516)
		setTimer(omgMovefallingrock2, 80, 1, 5)
	elseif point == 5 then
		moveObject(fallingrock2, 100, 1223.4117431641, 1241.7421875, -44.239490509033, 23.679901123047, 131.17855834961, -94.257232666019)
		setTimer(omgMovefallingrock2, 100, 1, 6)
	elseif point == 6 then
		moveObject(fallingrock2, 300, 1222.0334472656, 1246.3784179688, -55.657043457031, -48.278594970703, 31.37976074219, 2.817596435547)
		setTimer(omgMovefallingrock2, 300, 1, 7)
	elseif point == 7 then
		moveObject(fallingrock2, 700, 1216.3356933594, 1253.5799560547, -119.56275939941, -69.941894531248, 43.96923828125, 52.216796875002)
		setTimer(omgMovefallingrock2, 700, 1, 8)
	elseif point == 8 then
		moveObject(fallingrock2, 400, 1202.736328125, 1249.5111083984, -154.66296386719, 9.82205200195, 112.72268676758, 144.62274169922)
		setTimer(omgMovefallingrock2, 400+33000, 1, 9)
	elseif point == 9 then
		moveObject(fallingrock2, 1, 1228.1734619141, 1232.3442382812, 45.645729064941, 50.96307373047, -63.328521728516, 108.89105224609)
		setTimer(omgMovefallingrock2, 1+26000, 1, 1)
	end
end

function omgMovefallingrock1(point)
	if point == 1 then
		moveObject(fallingrock1, 2500, 526.01892089844, 2859.5024414062, -26.548955917358, 0, 0, 0)
		setTimer(omgMovefallingrock1, 2500+27000, 1, 2)
	elseif point == 2 then
		moveObject(fallingrock1, 1, 526.01892089844, 2859.5024414062, 109.58410644531, 0, 0, 0)
		setTimer(omgMovefallingrock1, 1, 1, 1)
	end
end

addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), omg_script98) 




-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- @@ # # The Destroyening of the Ring # # @@
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

-- Screenplay by Mawfeen (no tm)
-- Coding powered by ChatGPT (tm)

-- Ring effect
addEvent("showPuzzle3EffectForAll", true)
function showPuzzle3EffectForAll(targetPlayer)
	if not isElement(targetPlayer) then
		return
	end
	triggerClientEvent(root, "showPuzzle3Effect", resourceRoot, targetPlayer)
end
addEventHandler("showPuzzle3EffectForAll", resourceRoot, showPuzzle3EffectForAll)

addEvent("removePuzzle3EffectForAll", true)
function removePuzzle3EffectForAll(targetPlayer)
	if not isElement(targetPlayer) then
		return
	end
	triggerClientEvent(root, "removePuzzle3Effect", resourceRoot, targetPlayer)
end
addEventHandler("removePuzzle3EffectForAll", resourceRoot, removePuzzle3EffectForAll)


-- Vehicle change
addEvent("changePlayerVehicleModel", true)
addEventHandler("changePlayerVehicleModel", resourceRoot, function(newModel)
	local vehicle = getPedOccupiedVehicle(client)
	if isElement(vehicle) then
		setElementModel(vehicle, newModel)
	end
end)

-- Leaving Moria with ring
addEvent("onAudioTrigger2Kill", true)
addEventHandler("onAudioTrigger2Kill", resourceRoot, function()
	local player = client -- the player who triggered the event
	if isElement(player) and getElementType(player) == "player" then
		killPed(player)
	end
end)

addEvent("playSoundForAllNearby", true)
function playSoundForAllNearby(player, soundFile)
	if not isElement(player) then
		return
	end

	local x, y, z = getElementPosition(player)
	local players = getElementsByType("player") -- Get all players

	-- Play the sound for the triggering player as well
	triggerClientEvent(player, "playSound3DForPlayer", resourceRoot, soundFile, x, y, z)

	-- Play the sound for nearby players
	for _, nearbyPlayer in ipairs(players) do
		if nearbyPlayer ~= player and getDistanceBetweenPoints3D(x, y, z, getElementPosition(nearbyPlayer)) <= 500 then
			triggerClientEvent(nearbyPlayer, "playSound3DForPlayer", resourceRoot, soundFile, x, y, z)
		end
	end
end
addEventHandler("playSoundForAllNearby", resourceRoot, playSoundForAllNearby)

-- Achievement support
addEvent("achievement", true)
addEventHandler("achievement", root, function(achievementID)
	if exports["achievements"] then
		exports.achievements:triggerAchievement(client, achievementID, nil)
	end
end )
