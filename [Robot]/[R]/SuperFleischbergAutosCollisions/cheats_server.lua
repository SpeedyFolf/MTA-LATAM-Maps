------------------------------------------------------ Cheats ------------------------------------------------------
------------------------------------------------------ Cheats ------------------------------------------------------
------------------------------------------------------ Cheats ------------------------------------------------------
------------------------------------------------------ Cheats ------------------------------------------------------
------------------------------------------------------ Cheats ------------------------------------------------------
------------------------------------------------------ Cheats ------------------------------------------------------
------------------------------------------------------ Cheats ------------------------------------------------------
------------------------------------------------------ Cheats ------------------------------------------------------
------------------------------------------------------ Cheats ------------------------------------------------------

CHEATS_ENABLED = false

function cheatSkipCutscene(playerSource, commandName)
	if isObjectInACLGroup("user." .. getAccountName(getPlayerAccount(playerSource)), aclGetGroup ("Admin")) then
		startGame()
	end
end

function cheatResetProgress(playerSource, commandName)
	outputChatBox ( "Resetting Progress", playerSource, 255, 127, 127, true )
	g_shuffledIndicesPerPlayer[playerSource] = {}
	g_quitPlayersTargets[getPlayerSerial(playerSource)] = nil
	g_playerTargets[playerSource] = 1
	shuffleCarsPerPlayer(playerSource)
	triggerClientEvent(playerSource, "updateTarget", playerSource, g_playerTargets[playerSource])
end

function enableCheats(playerSource, commandName)
	if isObjectInACLGroup("user." .. getAccountName(getPlayerAccount(playerSource)), aclGetGroup ("Admin")) then
		CHEATS_ENABLED = true
	end
end

function enableOption(playerSource, commandName, count)
	if isObjectInACLGroup("user." .. getAccountName(getPlayerAccount(playerSource)), aclGetGroup ("Admin")) then
		FORCE_ADD_POLL_OPTION = tonumber(count)
		iprint("[FleischBerg Autos] Adding " .. count)
	end
end

function cheatSkipForPlayer(playerSource, commandName, name)
	if isObjectInACLGroup("user." .. getAccountName(getPlayerAccount(playerSource)), aclGetGroup ("Admin")) then
		local playa = getPlayerFromName ( name )
		if (not playa) then
			iprint("[FleischBerg Autos] no such player")
			return
		end

		local target = g_playerTargets[playa] + 1
		if (target > g_requiredCheckpoints) then
			return
		end
		g_playerTargets[playa] = target
		
		teleportPlayerToVehicle(target, playa)
		triggerClientEvent(playa, "updateTarget", playa, target)
	end
end

function cheatSkipVehicle(playerSource, commandName)
	if (not CHEATS_ENABLED) then return end
	local target = g_playerTargets[playerSource] + 1
	if (target > g_requiredCheckpoints) then
		return
	end
	g_playerTargets[playerSource] = target
	
	teleportPlayerToVehicle(target, playerSource)
	triggerClientEvent(playerSource, "updateTarget", playerSource, target)
end

function cheatFlipVehicle(playerSource, commandName)
	if (not CHEATS_ENABLED) then return end
	vehicle = getPedOccupiedVehicle(playerSource)
	setElementRotation(vehicle, 0, 180, 0)
end

function cheatPrevVehicle(playerSource, commandName)
	if (not CHEATS_ENABLED) then return end
	local target = g_playerTargets[playerSource] - 1
	if (target == 0) then
		return
	end
	g_playerTargets[playerSource] = target
	
	teleportPlayerToVehicle(target, playerSource)
	triggerClientEvent(playerSource, "updateTarget", playerSource, target)
end

function cheatTeleportVehicle(playerSource, commandName)
	if (not CHEATS_ENABLED) then return end
	vehicle = getPedOccupiedVehicle(playerSource)
	setElementPosition(vehicle, 0, 0, 20)
end

function cheatTeleportVehicleOp(playerSource, commandName)
	if (not CHEATS_ENABLED) then return end
	vehicle = getPedOccupiedVehicle(playerSource)
	setElementPosition(vehicle, 5, -241, 20)
end

function cheatTeleportBoat(playerSource, commandName)
	if (not CHEATS_ENABLED) then return end
	vehicle = getPedOccupiedVehicle(playerSource)
	setElementPosition(vehicle, -219, -604, 20)
end

addCommandHandler("ie_skipCutscene", cheatSkipCutscene, false, false)
addCommandHandler("ie_resetProgress", cheatResetProgress, false, false)
addCommandHandler("ie_cheatSkipForPlayer", cheatSkipForPlayer, false, false )
addCommandHandler("ie_enableCheats", enableCheats, false, false )
addCommandHandler("ie_poll", enableOption, false, false )
addCommandHandler("cheatnext", cheatSkipVehicle, false, false)
addCommandHandler("cheatflip", cheatFlipVehicle, false, false)
addCommandHandler("cheatprev", cheatPrevVehicle, false, false)
addCommandHandler("cheattp", cheatTeleportVehicle, false, false)
addCommandHandler("cheattpboat", cheatTeleportBoat, false, false)	
addCommandHandler("cheattpop", cheatTeleportVehicleOp, false, false)