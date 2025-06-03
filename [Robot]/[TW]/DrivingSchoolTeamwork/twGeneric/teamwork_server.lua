-- TODO
-- ----
-- ----

-- -- Verona Specific:
-- Im not a big fan of that pipe blocking part of the end course track. Perhaps alter it slightly.
-- ped doesn't die
-- Swap caddy for tug?

-- -- Teamwork Script:
-- DONE - freeze vehicles
-- team had an advantage, compensation message could use a color or somethign
-- Perhaps be a bit more in your face with the announcements still. Same with people quiting/idling.
-- revamp checkpoint thing
-- the first gate only opens when the packer changes back to a caddy (or someone picks up a race pickup.) It should open as soon as players finish. Fix!
-- Teams: Synchronize helper count, not rider count
-- DONE - Super GT still messes up
-- DONE - Collisions still messed up, see Jivel on Discord
-- DONE - Collisions dont work when people change team
-- DONE - Definitely somethign wrong with the collision script at line 29 	setElementData(vehicle, "race.collideothers", 1, false)
-- Sometimes when people change teams, it breaks
-- Collisions are weird when two teammates collide with each other while ghosting with a non-teammate

POINT_COMPENSATION_TIMER_INTERVAL = 2000
POINT_COMPENSATION_LOW_HELPER_INTERVAL = 1000

g_teamCount = -1
g_teams = {}
g_teamData = {}
g_playerData = {}
g_maxAllowedHelpers = -1
g_minRequiredRiders = -1

addEvent("onRaceStateChanging", true)

-- Team assignment at start of map
-- -------------------------------
-- -------------------------------

function start()
	shuffleTeams()
	assignTeams()
	for i,v in pairs(getElementsByType("player")) do
		initPlayer(v)
	end
end
addEventHandler("onMapStarting", root, start) 

function shuffleTeams()
	-- shuffle the team list
	local shuffledTeams = {}
	for i = 8, 1, -1 do
		local pickedTeamIndex = math.random(1,i)
		shuffledTeams[i] = POSSIBLE_TEAMS[pickedTeamIndex]
		table.remove(POSSIBLE_TEAMS, pickedTeamIndex)
	end
	POSSIBLE_TEAMS = shuffledTeams	
	triggerClientEvent(root, "receiveShuffledTeams", resourceRoot, shuffledTeams)
end

function assignTeams()
	-- determine how many teams to create based on player count and some degree of randomness
	local randomInt = math.random(1000)
	if g_teamCount == -1 then
		g_teamCount = determineTeamCount(getPlayerCount())
	end

	-- create teams using the list we just shuffled to determine which themes to create
	for i = 1, g_teamCount, 1 do
		g_teams[i] = createTeam(POSSIBLE_TEAMS[i].name,POSSIBLE_TEAMS[i].r,POSSIBLE_TEAMS[i].g,POSSIBLE_TEAMS[i].b)
		initTeam(g_teams[i], POSSIBLE_TEAMS[i])
	end
		
	-- take each player and shuffle them too
	local players = getElementsByType("player")
	local shuffledPlayers = {}
	for i = #players, 1, -1 do
		local pickedPlayerIndex = math.random(1,i)
		shuffledPlayers[i] = players[pickedPlayerIndex]
		table.remove(players, pickedPlayerIndex)
	end
	
	-- then add them to the teams
	for i,v in pairs(shuffledPlayers) do
		setPlayerTeam(v, g_teams[i % g_teamCount + 1])	
	end
	
	g_maxAllowedHelpers, g_minRequiredRiders = determineMaxHelpersAllowed()
end

function initTeam(team, data)
	g_teamData[team] = {}
	g_teamData[team]["name"] = data.name
	g_teamData[team]["r"] = data.r
	g_teamData[team]["g"] = data.g
	g_teamData[team]["b"] = data.b
	g_teamData[team]["hex"] = data.hex
	g_teamData[team]["compensation"] = 0
	g_teamData[team]["quiters"] = 0
	g_teamData[team]["activeMembers"] = 0
	g_teamData[team]["riderRequirement"] = 0
	g_teamData[team]["raceFinished"] = false
	g_teamData[team]["racersFinished"] = 0
	g_teamData[team]["collectedCheckpoints"] = 0
	g_teamData[team]["finishedRiders"] = 0
	g_teamData[team]["targetCheckpoints"] = 0
	g_teamData[team]["compensationTimer"] = nil
end

function determineTeamCount(playerCount)
	hat = {}
	if (playerCount <= 3) then
		return 1
	end
	local rngNum = math.random(1,1000)
	if rngNum < 1000/playerCount then
		return 1
	end
	-- Some weird formula I brute forced together because I dont know how to mathematic
	-- The idea is to favor team sizes closer to 6 players each, with bigger or smaller teams being less favorable
	-- Additional favor is granted to even teams
	local evenTeamsMultiplier = 3
	local smallTeamMultiplier = 2
	local idealTeamSize = 6
	for teamCount = 2, 8, 1 do
		local playersPerTeam = playerCount / teamCount

		if playersPerTeam < 2 then
			break
		end
		local stakes = playersPerTeam - idealTeamSize
		stakes = math.abs(stakes)
		stakes = math.sqrt(stakes)
		stakes = math.ceil(stakes)
		stakes = 13-stakes	-- 13 is 1 greater than sqrt(128) floored
		stakes = math.max(1, stakes)
		stakes = (stakes * stakes*2) - (stakes * stakes) + stakes -- Some cursed formula I brute forced in Google Sheets. No, I dont know how it works
																  -- It's supposed to amplify large numbers of stakes while leaving low numbers low
		stakes = math.floor(stakes)
		if (playersPerTeam < 10) then
			stakes = stakes * smallTeamMultiplier
		end
		if (0 == playersPerTeam % 1) then
			stakes = stakes * evenTeamsMultiplier
		end
		for stake = 1, stakes, 1 do
			hat[#hat+1]=teamCount
		end
	end
	local drawnStake = math.random(1,#hat)
	return hat[drawnStake]
end

function determineMaxHelpersAllowed()
	local smallestTeamSize = 999
	for i,team in pairs(g_teams) do
		smallestTeamSize = math.min(smallestTeamSize, #getPlayersInTeam(team))
	end
	if smallestTeamSize <= 1 then
		-- we have a team of 1 players, move the player to a different team, or check if the player is the only player
		if (#getElementsByType("player") > 1) then
			outputChatBox("ERROR: A team was generated with 1 player in it. This shouldn't happen.", playerSource, 255, 127, 0)
		end
		return 0, 1
	end
	smallestTeamSize = smallestTeamSize - 1
	-- generate three random numbers, and pick whichever is closest to 55% of players.
	local proposedHelperNum = 999
	local proposedHelperNumDistanceFromCenter = 999
	local p55Mark = smallestTeamSize * 0.55
	for i = 1,2,1 do -- The 2 is some weird randomization thing
		local generatedHelperNum = math.random(1, smallestTeamSize)
		local generatedHelperNumDistanceFromCenter = math.abs(generatedHelperNum - p55Mark)
		if generatedHelperNumDistanceFromCenter < proposedHelperNumDistanceFromCenter then
			proposedHelperNum = generatedHelperNum
			proposedHelperNumDistanceFromCenter = generatedHelperNumDistanceFromCenter
		end
	end

	local obligatoryRiders = 1
	local optionalRiders = (smallestTeamSize - proposedHelperNum)
	local moreRiders = math.random(0, optionalRiders)
	obligatoryRiders = obligatoryRiders + moreRiders
	optionalRiders = optionalRiders - moreRiders

	return proposedHelperNum, obligatoryRiders
end

function initPlayer(player)
	g_playerData[player] = {}
	g_playerData[player]["checkpointsReached"] = 0
	g_playerData[player]["state"] = PLAYER_STATES.maincourse
		-- nonparticipant
		-- running
		-- riderarrived
		-- helpercatchingup
		-- atendgate
		-- advantagecompensated
		-- homestretch
		-- racefinished
	g_playerData[player]["formerState"] = PLAYER_STATES.maincourse
	g_playerData[player]["wanderTime"] = 0
	g_playerData[player]["blip"] = createBlipAttachedTo(player, 0, 1, 184, 196, 204)
end

function evaluatePlayerParticipation()
	-- check for campers, idlers, wanderers, etc
	for i,v in pairs(getElementsByType("player")) do
		local x,y,z = getElementPosition(v)
		if (g_playerData[v].state == PLAYER_STATES.racefinished) then
			-- do nothing
		elseif (g_playerData[v].state ~= PLAYER_STATES.nonparticipant) then
			if (getPlayerIdleTime(v) > 60000) then
				for j,w in pairs(getPlayersInTeam(getPlayerTeam(v))) do
					outputChatBox("Your teammate " .. g_teamData[getPlayerTeam(v)].hex .. getPlayerName(v) .. " #B8C4CCis idle. Adjusting objective.", w, 184, 196, 204, true)
				end
				-- player has gone idle, boot from team
				g_playerData[v].formerState = g_playerData[v].state
				g_playerData[v].state = PLAYER_STATES.nonparticipant
			elseif (z > 30000) then
				-- player has gone into spectate mode, boot from team
				for j,w in pairs(getPlayersInTeam(getPlayerTeam(v))) do
					if (w ~= v) then
						outputChatBox("Your teammate " .. g_teamData[getPlayerTeam(v)].hex .. getPlayerName(v) .. " #B8C4CChas started spectating. Adjusting objective.", w, 184, 196, 204, true)
					end
				end
				g_playerData[v].formerState = g_playerData[v].state
				g_playerData[v].state = PLAYER_STATES.nonparticipant
			elseif (not isElementWithinColShape(v, PLAY_AREA)) then
				g_playerData[v].wanderTime = g_playerData[v].wanderTime + 1
				if (g_playerData[v].wanderTime == 5) then
					outputChatBox("If you go off to wander, you'll be letting your " .. g_teamData[getPlayerTeam(v)].hex .. "team #B8C4CCdown.", v, 184, 196, 204, true)
				end
				if (g_playerData[v].wanderTime >= 15) then
					-- player has gone wandering off, boot from team
					for j,w in pairs(getPlayersInTeam(getPlayerTeam(v))) do
						if (w ~= v) then
							outputChatBox("Your teammate " .. g_teamData[getPlayerTeam(v)].hex .. getPlayerName(v) .. " #B8C4CChas gone off wandering. Adjusting objective.", w, 184, 196, 204, true)
						end
					end
					g_playerData[v].formerState = g_playerData[v].state
					g_playerData[v].state = PLAYER_STATES.nonparticipant
				end
			end
		else 
			if (getPlayerIdleTime(v) < 10000 and z < 10000 and isElementWithinColShape(v, PLAY_AREA)) then
				-- put player back in play
				for j,w in pairs(getPlayersInTeam(getPlayerTeam(v))) do
					outputChatBox(g_teamData[getPlayerTeam(v)].hex .. getPlayerName(v) .. " #B8C4CChas returned. Adjusting objective.", w, 184, 196, 204, true)
				end
				g_playerData[v].state = g_playerData[v].formerState
			end
		end
	end
end

addEventHandler("onColShapeLeave", PLAY_AREA, function(player)
	if (getElementType(player) == "player") then
		g_playerData[player].wanderTime = g_playerData[player].wanderTime + 1
	end
end)

addEventHandler("onColShapeHit", PLAY_AREA, function(player)
	if (getElementType(player) == "player") then
		g_playerData[player].wanderTime = 0
	end
end)

function ValidateTeamLineups()
	evaluatePlayerParticipation()
	-- check for stage completion, in case this slipped by the checkpoint triggers
	for i,v in pairs(g_teams) do
		checkTeamObjective(v)
		teamCheckFinalGate(v)
	end
	for i = 1, g_teamCount, 1 do
		if countPlayersInTeam(g_teams[i]) == 1 then
			AutoBalance(getPlayersInTeam(g_teams[i])[1])
		end
	end
	recalculateTeamObjectives()
end

function AutoBalance(player)
	local lowestTeamSize = 999
	local newTeam = nil
	for i = 1, g_teamCount, 1 do
		local team = g_teams[i]
		local playersInTeam = countPlayersInTeam(team)
		if (playersInTeam > 0 and playersInTeam < lowestTeamSize) then
			newTeam = team
			lowestTeamSize = playersInTeam
		end
	end
	if (not newTeam) then
		return
	end
	local oldTeam = getPlayerTeam(player)
	if (oldTeam == newTeam) then
		return
	end
	outputChatBox(g_teamData[oldTeam].hex .. g_teamData[oldTeam].name .. " #B8C4CChas been disbanded. Its sole member has been assigned to " .. g_teamData[newTeam].hex .. g_teamData[newTeam].name, getRootElement(), 184, 196, 204, true)
	setPlayerTeam(player, newTeam)
	local car = getPedOccupiedVehicle(player)
	local r,g,b = getTeamColor(newTeam)
	setVehicleColor(car,r,g,b,(r+127)/2,(g+127)/2,(b+127)/2)
	attachBlipToPlayer(player,r,g,b)
end

function recalculateTeamObjectives()
	for i,v in pairs(g_teams) do
		local quitPeople = 0
		if (g_teamData[v]) then
			quitPeople = g_teamData[v].quiters
		end
		local teamMembers = getPlayersInTeam(v)
		local activeMemberCount = 0
		local finishedMemberCount = 0
		local collectedCheckpoints = 0
		local formerIdlers = 0
		local bootFormerIdlers = false
		for j,w in pairs(teamMembers) do
			if (g_playerData[w].state ~= PLAYER_STATES.nonparticipant) then
				activeMemberCount = activeMemberCount + 1
			end
			if (
				g_playerData[w].state == PLAYER_STATES.waitingforridersatgate or
				g_playerData[w].state == PLAYER_STATES.waitingforhelpersatgate or
				g_playerData[w].state == PLAYER_STATES.advantagecompensated or
				g_playerData[w].state == PLAYER_STATES.homestretch or
				g_playerData[w].state == PLAYER_STATES.racefinished
			) then
				finishedMemberCount = finishedMemberCount + 1
			end
			collectedCheckpoints = collectedCheckpoints + g_playerData[w].checkpointsReached
			collectedCheckpoints = math.min(collectedCheckpoints, MAIN_COURSE_CHECKPOINTS * g_minRequiredRiders)
		end
		g_teamData[v].activeMembers = activeMemberCount
		g_teamData[v].riderRequirement = math.max(1, activeMemberCount - g_maxAllowedHelpers)
		g_teamData[v].collectedCheckpoints = collectedCheckpoints + g_teamData[v].compensation
		g_teamData[v].finishedRiders = finishedMemberCount
		g_teamData[v].targetCheckpoints = MAIN_COURSE_CHECKPOINTS * g_teamData[v].riderRequirement
	end
	triggerClientEvent(root, "sentTeamInformation", getRootElement(), g_teamData, g_playerData)
end

iprint(math.max(1,2,4,-2))

-- Race progress
-- -------------
-- -------------
function onRaceStateChanging(newState, oldState)
	if (newState == "GridCountdown") then
		triggerClientEvent(root, "raceStateChanged", resourceRoot, newState, oldState)
	elseif (newState == "Running" and oldState == "GridCountdown") then
		setTimer(ValidateTeamLineups, 2000, 0)
		triggerClientEvent(root, "raceStateChanged", resourceRoot, newState, oldState)
		for i, v in pairs(getElementsByType("player")) do
			g_playerData[v].wanderTime = -10
		end
	end
end
addEventHandler("onRaceStateChanging", root, onRaceStateChanging)

function onPlayerFinish(rank, time_)
	recalculateTeamObjectives()
	g_playerData[source].state = PLAYER_STATES.racefinished
	local team = getPlayerTeam(source)
	g_teamData[team].racersFinished = g_teamData[team].racersFinished + 1
	if (not g_teamData[team].raceFinished and g_teamData[team].racersFinished >= g_teamData[team].riderRequirement) then
		g_teamData[team].raceFinished = time_
	end
	recalculateTeamObjectives()
end
addEventHandler("onPlayerFinish", root, onPlayerFinish)

function processCheckpoint(checkpoint, time_)
	recalculateTeamObjectives()
	if ((g_playerData[source].state == PLAYER_STATES.helpercatchingup or g_playerData[source].state == PLAYER_STATES.waitingforhelpersatgate) and checkpoint > MAIN_COURSE_CHECKPOINTS) then
		-- this is a helper for whom the end gate has just opened, and he's now heading to reunite with his riders
		g_playerData[source].state = PLAYER_STATES.waitingforhelpersatgate	
		teamCheckFinalGate(getPlayerTeam(source))
	elseif ((g_playerData[source].state == PLAYER_STATES.maincourse or g_playerData[source].state == PLAYER_STATES.nonparticipant) and checkpoint >= 3 and checkpoint < MAIN_COURSE_CHECKPOINTS) then
		-- a rider in the middle of the course
		g_playerData[source].checkpointsReached = checkpoint
	elseif (g_playerData[source].state == PLAYER_STATES.maincourse or g_playerData[source].state == PLAYER_STATES.nonparticipant) and checkpoint >= MAIN_COURSE_CHECKPOINTS then
		-- a rider that has reached the end of the main course. Check for total team progress.
		g_playerData[source].checkpointsReached = MAIN_COURSE_CHECKPOINTS
		g_playerData[source].state = PLAYER_STATES.waitingforridersatgate
		checkTeamObjective(getPlayerTeam(source))
	end
	recalculateTeamObjectives()
end
addEventHandler("onPlayerReachCheckpoint", root, processCheckpoint)

function checkTeamObjective(team)
	local teamMembers = getPlayersInTeam(team)
	for i,v in pairs(teamMembers) do
		if (
			g_playerData[v].state == PLAYER_STATES.helpercatchingup or
			g_playerData[v].state == PLAYER_STATES.waitingforhelpersatgate or
			g_playerData[v].state == PLAYER_STATES.advantagecompensated or
			g_playerData[v].state == PLAYER_STATES.homestretch or
			g_playerData[v].state == PLAYER_STATES.racefinished
		) then
			-- A player has a different state, indicating that this code has run before. Abort. Anyone who does have these states is a returning idler.
			return
		end
	end
	-- check if the team has met its goal, or if all but one of its participating members have reached the finish (the one being the helper)
	if (g_teamData[team].finishedRiders >= g_teamData[team].riderRequirement) then
		-- team is finished, open helper gate for its members
		for i,v in pairs(teamMembers) do
			if (g_playerData[v].state == PLAYER_STATES.waitingforridersatgate) then
				g_playerData[v].state = PLAYER_STATES.waitingforhelpersatgate
			elseif (g_playerData[v].state == PLAYER_STATES.maincourse) then
				g_playerData[v].state = PLAYER_STATES.helpercatchingup
			end
			triggerClientEvent(v, "openFirstGate", root)	
		end
	end
end


function teamCheckFinalGate(team)
	local teamMembers = getPlayersInTeam(team)
	local membersAtGate = 0
	local activeMemberCount = 0
	for i,v in pairs(teamMembers) do
		if (g_playerData[v].state ~= PLAYER_STATES.nonparticipant) then
			activeMemberCount = activeMemberCount + 1
		end
		if (g_playerData[v].state == PLAYER_STATES.waitingforhelpersatgate) then
			membersAtGate = membersAtGate + 1
		end
	end
	local requiredMembers = math.max(1, math.min(activeMemberCount - 1, g_maxAllowedHelpers + g_teamData[team].riderRequirement))
	if membersAtGate < requiredMembers then
		return
	end

	if (g_teamData[team].collectedCheckpoints < g_teamData[team].targetCheckpoints) then
		-- all players reached the end, but this is less than the goal because the team has too little players
		if (not g_teamData[team].compensationTimer) then
			local difference = g_teamData[team].targetCheckpoints - g_teamData[team].collectedCheckpoints
			for i,v in pairs(teamMembers) do
				g_playerData[v].state = PLAYER_STATES.advantagecompensated
			end
			local pointTimer = POINT_COMPENSATION_TIMER_INTERVAL
			if #teamMembers - 1 < g_maxAllowedHelpers then
				pointTimer = POINT_COMPENSATION_LOW_HELPER_INTERVAL
			end
			g_teamData[team].compensationTimer = setTimer(addPoint, pointTimer, difference, team, 1)
			for i,v in pairs(teamMembers) do
				if ((g_playerData[v].state ~= PLAYER_STATES.nonparticipant and g_playerData[v].state ~= PLAYER_STATES.maincourse) or g_playerData[v].checkpointsReached >= MAIN_COURSE_CHECKPOINTS) then
					-- at this point, idlers who came back after everyone finished will not have the gate opem. 
					-- Do not give them the satisfaction of victory, hence > 0. Exceptions for people that went idle after completing the course.
					setTimer(function()
						g_playerData[v].state = PLAYER_STATES.homestretch
						triggerClientEvent(v, "openSecondGate", getRootElement())	
					end, (difference + 1) * pointTimer, 1)
				end
			end
		end
	else
		-- all players have reached the end, and it's more than the initial stated goal
		for i,v in pairs(teamMembers) do
			if (g_playerData[v].state ~= PLAYER_STATES.nonparticipant or g_playerData[v].checkpointsReached >= MAIN_COURSE_CHECKPOINTS) then
				g_playerData[v].state = PLAYER_STATES.homestretch
				setTimer(function()
					triggerClientEvent(v, "openSecondGate", getRootElement())	
				end, 10000, 1)
			end
		end
	end
end

function addPoint(team)
	g_teamData[team].compensation = g_teamData[team].compensation + 1
	recalculateTeamObjectives()
end

function onPlayerRaceWasted()
	g_playerData[source].wasted = true
end
addEvent("onPlayerRaceWasted", true)
addEventHandler("onPlayerRaceWasted", root, onPlayerRaceWasted)

-- Configure players for team
-- --------------------------
-- --------------------------

function setTeamPlayerAttributes(thePlayer)
	local car = getPedOccupiedVehicle(thePlayer)
	if (not car) then
		return
	end
	local r,g,b = getTeamColor(getPlayerTeam(thePlayer))
	setVehicleColor(car,r,g,b,(r+127)/2,(g+127)/2,(b+127)/2)
	attachBlipToPlayer(source,r,g,b)
 	recalculateTeamObjectives()
end

function onPlayerPickUpRacePickup()
	setTeamPlayerAttributes(source)
end
addEventHandler("onPlayerPickUpRacePickup", root, onPlayerPickUpRacePickup)

function onVehicleEnter(thePlayer)
	if (g_playerData[source]) then
		g_playerData[source].wasted = false
	end
	setTeamPlayerAttributes(thePlayer)
end
addEventHandler("onVehicleEnter", root, onVehicleEnter)	

function attachBlipToPlayer(player, r, g, b)
	if (not g_playerData[player]) then
		return
	end
	if (isElement(g_playerData[player].blip)) then
		destroyElement(g_playerData[player].blip)
	end
	g_playerData[player].blip = createBlipAttachedTo(player, 0, 1, r, g, b)
end

-- Team assignment in marker
-- -------------------------
-- -------------------------

function changeTeamCmd(playerSource, commandName, teamNo)
	if (not isElementWithinMarker(playerSource, getElementByID("_MARKER_TEAM_CONFIG"))) then
		return
	end
	if (not teamNo) then
		outputChatBox("no team number specified", playerSource)
		return
	end
	teamNumber = tonumber(teamNo)
	if (teamNumber and teamNumber > 0 and teamNumber < 9) then
		changePlayerTeam(playerSource, teamNumber)
	else 
		outputChatBox("Invalid team number", playerSource)
	end
end
addCommandHandler("changeteam", changeTeamCmd)

function changePlayerTeam(player, to)
	local toTeam = getTeamFromName(POSSIBLE_TEAMS[to].name)
	local fromTeam = getPlayerTeam(player)
	if (g_playerData[player].checkpointsReached > 0) then
		g_teamData[fromTeam].compensation = g_teamData[fromTeam].compensation + g_playerData[player].checkpointsReached
		g_teamData[fromTeam].quiters = g_teamData[fromTeam].quiters + 1
	end
	g_playerData[player].state = PLAYER_STATES.maincourse
	if (toTeam) then
		for i,v in pairs(getPlayersInTeam(toTeam)) do
			outputChatBox(g_teamData[toTeam].hex .. getPlayerName(player) .. " #B8C4CChas joined your team.", v, 184, 196, 204, true)
		end
		setPlayerTeam(player, toTeam)
	else
		g_teams[to] = createTeam(POSSIBLE_TEAMS[to].name,POSSIBLE_TEAMS[to].r,POSSIBLE_TEAMS[to].g,POSSIBLE_TEAMS[to].b)	
		initTeam(g_teams[to], POSSIBLE_TEAMS[to])
		setPlayerTeam(player, g_teams[to])
	end
	for i,v in pairs(getPlayersInTeam(fromTeam)) do
		outputChatBox(g_teamData[fromTeam].hex .. getPlayerName(player) .. " #B8C4CChas abandoned your team. Adjusting objective.", v, 184, 196, 204, true)
	end
	-- set colors & cols etc
	local car = getPedOccupiedVehicle(player)
	local r,g,b = getTeamColor(getPlayerTeam(player))
	setVehicleColor(car,r,g,b,(r+127)/2,(g+127)/2,(b+127)/2)
	attachBlipToPlayer(player,r,g,b)
	recalculateTeamObjectives()
end

-- handle joins and quits
-- ----------------------
-- ----------------------

function handleQuitter()
	local team = getPlayerTeam(source)
	if (g_playerData[source].checkpointsReached > 0) then
		g_teamData[team].compensation = g_teamData[team].compensation + g_playerData[source].checkpointsReached
		g_teamData[team].quiters = g_teamData[team].quiters + 1
	end
	for i,v in pairs(getPlayersInTeam(team)) do
		outputChatBox("Your teammate " .. g_teamData[team].hex .. getPlayerName(source) .. " #B8C4CChas disconnected. Adjusting objective.", v, 184, 196, 204, true)
	end
end
addEventHandler("onPlayerQuit", root, handleQuitter)

function handleJoiner()
	initPlayer(source)
	local lowestTeam = 0
	local selectedTeam = 0
	for i = 1, g_teamCount, 1 do
		local playersInTeam = countPlayersInTeam(g_teams[i])
		if (playersInTeam < lowestTeam) then
			selectedTeam = i
			lowestTeam = playersInTeam
		end
	end
	if (selectedTeam == 0) then
		-- there are no teams with players, plop player in first
		selectedTeam = 1
	end
	setPlayerTeam(source, g_teams[selectedTeam])
	outputChatBox(getPlayerName(source) .. " #B8C4CChas been assigned to " .. g_teamData[g_teams[selectedTeam]].hex .. g_teamData[g_teams[selectedTeam]].name .. "#B8C4CC.", getRootElement(), 184, 196, 204, true)
end
addEventHandler("onPlayerJoin", getRootElement(), handleJoiner)



-- camera
-- ------
-- ------
-- ------

function cutscene(newState, oldState)
	if (newState == "GridCountdown") then
		for i, v in pairs(getElementsByType("player")) do
			setCameraMatrix(v, CAMERA_POSITION_X, CAMERA_POSITION_Y, CAMERA_POSITION_Z, CAMERA_TARGET_X, CAMERA_TARGET_Y, CAMERA_TARGET_Z)
			setTimer(setCameraTarget, 5000, 1, v, v)
		end
	elseif (newState == "Running" and oldState == "GridCountdown") then
		for i, v in pairs(getElementsByType("player")) do
			setCameraTarget(v, v)
		end
	end
end
addEventHandler("onRaceStateChanging", root, cutscene)
