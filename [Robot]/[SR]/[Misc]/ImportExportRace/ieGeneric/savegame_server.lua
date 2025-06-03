DATABASE = dbConnect("sqlite", SAVEGAME_DATABASE_NAME)

g_oldAutosaveErased = false

g_quitPlayersTargets = {}
g_quitPlayersShuffledCars = {}

function ensureDatabaseExists()
	if DATABASE then
		dbExec(DATABASE, "CREATE TABLE IF NOT EXISTS progressTable (serial TEXT PRIMARY KEY, progress INTEGER, indices TEXT)")
	end
end
ensureDatabaseExists()

function loadGameFromDatabase()
	outputChatBox("Loading game from database...", root, 255, 128, 0)

	if (DATABASE) then
		ensureDatabaseExists()

		local query = dbQuery(DATABASE, "SELECT * FROM progressTable")
		local results = dbPoll(query, -1)

		for _, row in pairs(results) do
			local serial = row["serial"]
			local progress = row["progress"]
			local indices = fromJSON(row["indices"])

			g_quitPlayersTargets[serial] = progress
			g_quitPlayersShuffledCars[serial] = indices

			local player = getPlayerFromSerial(serial)
			if player then
				g_playerTargets[player] = g_quitPlayersTargets[serial]
				g_shuffledIndicesPerPlayer[player] = g_quitPlayersShuffledCars[serial]
			end
		end

		applyPollResult(212, (getMapName() .. " (Full Experience, loaded from save)"))
	end
end

function clearGameFromDatabase()
	if (DATABASE) then
		ensureDatabaseExists()

		dbExec(DATABASE, "DROP TABLE IF EXISTS progressTable")
		iprint("[Import Export] All game progress has been cleared from the database.")
	end
end

function savePlayerToDatabase(player)
	if g_requiredCheckpoints ~= 212 then
		-- Don't save player to the database if it's not the full experience
		return
	end

	if (g_shuffledIndicesPerPlayer[player]) then
		local serial = getPlayerSerial(player)
		local json = toJSON(g_shuffledIndicesPerPlayer[player])

		dbExec(DATABASE,
		       "INSERT INTO progressTable (serial, progress, indices) VALUES (?, ?, ?) ON CONFLICT(serial) DO UPDATE SET progress = excluded.progress, indices = excluded.indices",
		       serial, g_playerTargets[player], json)
	end
end

function autoSave(force)
	force = force == true

	if exports.race:getTimePassed() < 600000 and not force then
		-- Don't save if we're not at least 10 minutes in
		return
	end

	if g_requiredCheckpoints ~= 212 then
		-- Don't save to the database if it's not the full experience
		return
	end

	if (#g_chosenCars == 0 or g_raceFinished) then
		-- Race hasn't started yet or has ended
		return
	end

	if (not g_oldAutosaveErased) then
		clearGameFromDatabase()
		g_oldAutosaveErased = true
	end

	iprint("[Import Export] Autosaving...")
	if (DATABASE) then
		for i, player in ipairs(getElementsByType("player")) do
			savePlayerToDatabase(player)
		end
	end
	iprint("[Import Export] Autosaving complete")
end
setTimer(autoSave, 60000, 0) -- autosave every 1 minutes

function manualSaveGame(playerSource, commandName)
	if isObjectInACLGroup("user." .. getAccountName(getPlayerAccount(playerSource)), aclGetGroup("Admin")) then
		autoSave(true)
	end
end
addCommandHandler("ie_saveGame", manualSaveGame, false, false)

function playerLeaving(quitType)
	if (#g_chosenCars == 0) then
		-- Race hasn't started yet
		return
	end
	if (getElementData(source, "race.finished")) then
		return
	end
	if (g_playerTargets[source] == nil or g_playerTargets[source] < 2) then
		return
	end
	local serial = getPlayerSerial(source)
	g_quitPlayersTargets[serial] = g_playerTargets[source]
	g_quitPlayersShuffledCars[serial] = g_shuffledIndicesPerPlayer[source]

	ensureDatabaseExists()
	savePlayerToDatabase(source)
end
addEventHandler( "onPlayerQuit", root, playerLeaving)

function loadPlayerSavedData(loadedResource)
	local serial = getPlayerSerial(source)
	if serial and g_quitPlayersTargets[serial] then
		g_playerTargets[source] = g_quitPlayersTargets[serial]
		g_shuffledIndicesPerPlayer[source] = g_quitPlayersShuffledCars[serial]

		triggerClientEvent(source, "updateTarget", source, g_playerTargets[source] or 1)
	end
end
addEventHandler("onPlayerResourceStart", root, loadPlayerSavedData)

function loadGame(playerSource, commandName)
	if isObjectInACLGroup("user." .. getAccountName(getPlayerAccount(playerSource)), aclGetGroup("Admin")) then
		if g_raceStarted then
			iprint("[Import Export] Can't load because the game is already ongoing")
			return
		end
		exports.votemanager:stopPoll{}
		loadGameFromDatabase()
	end
end
addCommandHandler("ie_loadGame", loadGame, false, false)