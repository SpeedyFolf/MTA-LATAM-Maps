
g_gate1Opened = false
g_gate2Opened = false

g_teamData = nil
g_playerData = nil

g_markerShownText = ""
g_scoreboardShownText = "\n\n\n\n\n\n\nLoading Scoreboard"
g_announcementShownText = ""
g_objectiveShownText = ""

g_winMessage = ""
g_teamsFinished = 0
g_finishedTeams = {}

-- anti blow
-- ---------
-- ---------

addEventHandler("onClientExplosion", root, function(x, y, z, t)
    if t == 4 or t == 7 then
        cancelEvent()
    end
end)

-- gates
-- -----
-- -----

function openFirstGate()
	if (g_gate1Opened) then
		return
	end
	g_gate1Opened = true
	local gate = getElementByID(GATE_HELPER_REUNION)
	local x,y,z = getElementPosition(gate)
	moveObject(gate, 1500, x, y, z, 0, 70, 0)

	collectCheckpoints(MAIN_COURSE_CHECKPOINTS)

	local team = getPlayerTeam(localPlayer)
	g_objectiveShownText = "To win, all " .. g_teamData[team].hex .. g_teamData[team].activeMembers .. " #B8C4CCactive team members must finish the race together. Currently ready: " .. g_teamData[team].hex .. g_teamData[team].finishedRiders
	
end
addEvent("openFirstGate", true)
addEventHandler("openFirstGate", getRootElement(), openFirstGate)

function openSecondGate()
	if (g_gate2Opened) then
		return
	end
	g_gate2Opened = true
	local gate = getElementByID(GATE_FINISH_LINE)
	local x,y,z = getElementPosition(gate)
	moveObject(gate, 1500, x, y, z, 0, 70, 0)
end
addEvent("openSecondGate", true)
addEventHandler("openSecondGate", getRootElement(), openSecondGate)

-- announce stuff
-- --------------
-- --------------

function sentTeamInformation(teamData, playerData)
	g_teamData = teamData
	g_playerData = playerData
	
	local text = ""
	for i,v in pairs(g_teamData) do
		text = text .. 
			v.hex .. 
			v.name .. ": " .. 
			v.collectedCheckpoints .. "/" .. 
			v.targetCheckpoints .. " (" .. 
			v.finishedRiders .. "/" .. 
			v.riderRequirement .. "/" .. 
			v.activeMembers .. ")\n"
	end
	g_scoreboardShownText = text

	for i,team in pairs(g_teamData) do
		local finishTime = team.raceFinished
		if finishTime and (not g_finishedTeams[team.name]) then
			g_teamsFinished = g_teamsFinished + 1
			g_finishedTeams[team.name] = true
			local milliseconds = finishTime % 1000
			local seconds = ((finishTime - milliseconds) % 60000) / 1000
			local minutes = (finishTime - milliseconds - (seconds * 1000)) / 60000
			local timeMessage = string.format("%02d:%02d.%03d", minutes, seconds, milliseconds)
			
			if (g_teamsFinished == 1) then
				g_winMessage = team.hex .. team.name .. " #B8C4CCwin! (" .. timeMessage .. ")\n"
			elseif (g_teamsFinished == 2) then
				g_winMessage = g_winMessage .. team.hex .. team.name .. " #B8C4CCcome 2nd! (" .. timeMessage .. ")\n"
			elseif (g_teamsFinished == 3) then
				g_winMessage = g_winMessage .. team.hex .. team.name .. " #B8C4CCcome 3rd! (" .. timeMessage .. ")\n"
			else
				g_winMessage = g_winMessage .. team.hex .. team.name .. " #B8C4CCcome " .. g_teamsFinished .. "th! (" .. timeMessage .. ")\n"
			end
		end
	end
	g_announcementShownText = g_winMessage
end
addEvent("sentTeamInformation", true)
addEventHandler("sentTeamInformation", getRootElement(), sentTeamInformation)

function raceStateChanged(newState, oldState)
	if (newState == "GridCountdown") then
		if (#getElementsByType("player") == 1) then
			g_announcementShownText = "You are the only player in the server.\nTeamwork can't be done alone."
		else
			local team = g_teamData[getPlayerTeam(localPlayer)]
			g_announcementShownText = "Welcome to the Verona Pier Teamwork!\n\nYour team is: " .. team.hex .. team.name .."\n#B8C4CCYour objective: Have " .. team.hex .. team.riderRequirement .. "#B8C4CC players complete the course.\n\n\n\n\n\nTeam members:\n" .. team.hex
		
			local players = getPlayersInTeam(getPlayerTeam(localPlayer))
			for i,v in pairs(players) do
				g_announcementShownText = g_announcementShownText .. team.hex .. getPlayerName(v) .. "#B8C4CC"
				if (i < #players) then
					g_announcementShownText = g_announcementShownText .. ", "
				end
				if (i % 6 == 0) then
					g_announcementShownText = g_announcementShownText .. "\n"
				end
			end
		
		end
	elseif (newState == "Running" and oldState == "GridCountdown") then
		local team = g_teamData[getPlayerTeam(localPlayer)]
		setTimer(function()
			g_announcementShownText = ""
		end, 3000, 1)
		g_objectiveShownText = "Objective: Have " .. team.hex .. team.riderRequirement .. " #B8C4CCteam members complete the course (out of " .. team.hex .. team.activeMembers .. "#B8C4CC active members). Current: " .. team.hex .. team.finishedRiders
	end
end
addEvent("raceStateChanged", true)
addEventHandler("raceStateChanged", getRootElement(), raceStateChanged)

function receiveShuffledTeams(shuffledTeams)
	POSSIBLE_TEAMS = shuffledTeams
end
addEvent("receiveShuffledTeams", true)
addEventHandler("receiveShuffledTeams", getRootElement(), receiveShuffledTeams)

function onClientPlayerWasted()
	g_announcementShownText = ""
end
addEventHandler("onClientPlayerWasted", localPlayer, onClientPlayerWasted)

-- markers
-- -------
-- -------

function onClientMarkerHit(hitPlayer, matchingDimension)
	if (hitPlayer ~= localPlayer) then
		return
	end
	markerID = getElementID(source)
	x1,y1,z1 = getElementPosition(source)
	x2,y2,z2 = getElementPosition(hitPlayer)
	playerState = g_playerData[hitPlayer].state
	if (getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2) > getMarkerSize(source)*1.5) then
		return
	end
	if (markerID == MARKER_TEAM_CONFIG) then
		promptTeamMenu(source)
	elseif (markerID == MARKER_FIRST_GATE) then
		if (playerState == PLAYER_STATES.maincourse) then
			g_markerShownText = "This gate will open when your team has reached its goal."
		elseif (playerState ~= PLAYER_STATES.nonparticipant and playerState ~= PLAYER_STATES.maincourse) then
			collectCheckpoints(MAIN_COURSE_CHECKPOINTS)
		end
	elseif (markerID == MARKER_SECOND_GATE) then
		if (playerState == PLAYER_STATES.waitingforhelpersatgate) then
			g_markerShownText = "Please wait for the rest of your team."
		end
		if (playerState == PLAYER_STATES.advantagecompensated) then
			g_markerShownText = "Your team had an advantage, please wait for compensation."
		end
	end
end
addEventHandler("onClientMarkerHit", resourceRoot, onClientMarkerHit)

function onClientMarkerLeave(thePlayer, matchingDimension)
	if (thePlayer ~= localPlayer) then
		return
	end
	markerID = getElementID(source)
	if (markerID == MARKER_TEAM_CONFIG) then
		-- nothing yet
	elseif (markerID == MARKER_FIRST_GATE) then
		g_markerShownText = ""
	elseif (markerID == MARKER_SECOND_GATE) then
		g_markerShownText = ""
	end
end
addEventHandler("onClientMarkerLeave", resourceRoot, onClientMarkerLeave)

function promptTeamMenu(player)		-- TODO: Give this a GUI
	local msg = "Use /changeteam # to change to a team. Possible team numbers: "
	for i = 1,7,1 do
		msg = msg .. POSSIBLE_TEAMS[i].hex .. i .. "#B8C4CC, "
	end
	msg = msg .. POSSIBLE_TEAMS[8].hex .. 8 .. "#B8C4CC."
	outputChatBox(msg, 184, 196, 204, true)
end

-- colshapes
-- ---------
-- ---------

function onClientColShapeHit(hitElement, matchingDimension)
	if (hitElement ~= localPlayer) then
		return
	end
	if (g_playerData[hitElement].checkpointsReached >= 3 and g_playerData[hitElement].checkpointsReached < MAIN_COURSE_CHECKPOINTS) then
		g_announcementShownText = "Course abandoned! \nType /kill in chat to return."
		setTimer(function()
			g_announcementShownText = ""
		end, 10000, 1)
	end
end
addEventHandler("onClientColShapeHit", HELPER_AREA, onClientColShapeHit)

-- hud
-- ---
-- ---

function drawHud()
	local width,height = guiGetScreenSize()

	drawBorderedText(g_announcementShownText, 2, width*0.2, height*0.2, width*0.8, height*0.9, tocolor(184, 196, 204,255), 3, "default", "center", "top", false, true, false, true)
	drawBorderedText(g_markerShownText, 2, width*0.2, height*0.5, width*0.8, height*0.9, tocolor(184, 196, 204,255), 3, "default", "center", "top", false, true)
	drawBorderedText(g_scoreboardShownText, 1, width*0.2, height*0.03, width*0.87, height*0.9, tocolor(184, 196, 204,255), 1.5, "default", "right", "top", false, true, false, true)
	drawBorderedText(g_objectiveShownText, 2, width*0.2, height*0.8, width*0.8, height*0.95, tocolor(184, 196, 204, 255), 2, "default", "center", "bottom", false, true, false, true)
end
addEventHandler("onClientRender", root, drawHud)

function drawBorderedText(text, borderSize, width, height, width2, height2, color, size, font, horizAlign, vertiAlign, bool1, bool2, bool3, bool4)
	text2 = string.gsub(text, "#%x%x%x%x%x%x", "")
	dxDrawText(text2, width+borderSize, height, width2+borderSize, height2, tocolor(5, 17, 26, 255), size, font, horizAlign, vertiAlign, bool1, bool2, bool3, bool4)
	dxDrawText(text2, width, height+borderSize, width2, height2+borderSize, tocolor(5, 17, 26, 255), size, font, horizAlign, vertiAlign, bool1, bool2, bool3, bool4)
	dxDrawText(text2, width, height-borderSize, width2, height2-borderSize, tocolor(5, 17, 26, 255), size, font, horizAlign, vertiAlign, bool1, bool2, bool3, bool4)
	dxDrawText(text2, width-borderSize, height, width2-borderSize, height2, tocolor(5, 17, 26, 255), size, font, horizAlign, vertiAlign, bool1, bool2, bool3, bool4)
	dxDrawText(text2, width+borderSize, height+borderSize, width2+borderSize, height2+borderSize, tocolor(5, 17, 26, 255), size, font, horizAlign, vertiAlign, bool1, bool2, bool3, bool4)
	dxDrawText(text2, width-borderSize, height-borderSize, width2-borderSize, height2-borderSize, tocolor(5, 17, 26, 255), size, font, horizAlign, vertiAlign, bool1, bool2, bool3, bool4)
	dxDrawText(text2, width+borderSize, height-borderSize, width2+borderSize, height2-borderSize, tocolor(5, 17, 26, 255), size, font, horizAlign, vertiAlign, bool1, bool2, bool3, bool4)
	dxDrawText(text2, width-borderSize, height+borderSize, width2-borderSize, height2+borderSize, tocolor(5, 17, 26, 255), size, font, horizAlign, vertiAlign, bool1, bool2, bool3, bool4)
	dxDrawText(text, width, height, width2, height2, color, size, font, horizAlign, vertiAlign, bool1, bool2, bool3, bool4)
end


