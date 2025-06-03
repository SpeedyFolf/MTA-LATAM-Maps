g_pollActive = false

function startRacePoll()
	exports.votemanager:stopPoll {}
	g_pollActive = true
	poll = exports.votemanager:startPoll {
		--start settings (dictionary part)
		title="Choose the map length:",
		percentage=100,
		timeout=POLL_DURATION_IN_SECONDS,
		allowchange=true,

		--start options (array part)
		[1]={"A Basic Race (1)", "pollFinished" , resourceRoot, 1},		
		[2]={"Double It Up (2)", "pollFinished" , resourceRoot, 2},		
		[3]={"Shortened (5)", "pollFinished" , resourceRoot, 5},		
		[4]={"Full Experience (30)", "pollFinished", resourceRoot, 30},
		-- [4]={"DEBUG MODE (2)", "pollFinished" , resourceRoot, 2},		
	}
	if not poll then
		applyPollResult(1)
	end
end

function applyPollResult(pollResult)
	g_requiredCheckpoints = pollResult

	-- Do some trickery with the map name & the race scoreboard manager so that separate top times are tracked per map length
	local customMapName = getMapName()
	if (pollResult == 1) then
		customMapName = customMapName .. " (A Basic Race)"
	elseif (pollResult == 2) then
		customMapName = customMapName .. " (Double It Up)"
	elseif (pollResult == 5) then
		customMapName = customMapName .. " (Shortened)"
	elseif (pollResult == 30) then
		customMapName = customMapName .. " (Full Experience)"
	else
		customMapName = customMapName .. " (DEBUG MODE)"
	end
	setMapName ( customMapName )
	
	-- THe default top times manager does not respond to the above. So send it an event so it does
	local timesManager = getResourceRootElement( getResourceFromName("race_toptimes"))
	if not (timesManager) then
		timesManager = getResourceRootElement( getResourceFromName("race_toptimes2"))
	end
	local raceResRoot = getResourceRootElement( getResourceFromName( "race" ) )
	local raceInfo = raceResRoot and getElementData( raceResRoot, "info" )
	
	local stuff = {}
	stuff.modename = raceInfo.mapInfo.modename
	stuff.name = customMapName
	stuff.statsKey = nil

	triggerClientEvent ( root, "pollEnded", resourceRoot )
	if raceInfo and timesManager then
		triggerEvent("onMapStarting", timesManager, stuff, stuff, stuff)
		triggerClientEvent("onClientSetMapName", timesManager, customMapName )
	end

	if (pollResult == 1) then
		triggerClientEvent(root, "lastCar", resourceRoot)
	end
end
addEvent("pollFinished", true)
addEventHandler("pollFinished", resourceRoot, applyPollResult)