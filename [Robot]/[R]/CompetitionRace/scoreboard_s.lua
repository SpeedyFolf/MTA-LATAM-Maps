local DATABASE = dbConnect("sqlite", ":/dataCollector.db")

addEvent("onPlayerFinish", true)
addEventHandler("onPlayerFinish", getRootElement(), function(rank, time)
	if not DATABASE or rank > 1 or playingAlone or not getPedOccupiedVehicle(source) or not baseVehicle or not competitionVehicle then return end
	dbExec(DATABASE, "CREATE TABLE IF NOT EXISTS Competition(base INTEGER, competition INTEGER, data TEXT, score INTEGER)")
	
	-- Data just counts wins
	local finishedVehicle = getElementModel(getPedOccupiedVehicle(source))
	local recordsResults = dbPoll(dbQuery(DATABASE, "SELECT data, score FROM Competition WHERE base = ? AND competition = ? ORDER BY score ASC", baseVehicle, competitionVehicle), -1)
	if recordsResults and #recordsResults > 0 then
		-- Update the database
		recordsResults[1]["data"] = fromJSON(recordsResults[1]["data"])
		if finishedVehicle == baseVehicle then recordsResults[1]["data"].base = recordsResults[1]["data"].base + 1
		elseif finishedVehicle == competitionVehicle then recordsResults[1]["data"].competition = recordsResults[1]["data"].competition + 1 end 
		
		if recordsResults[1]["score"] > time then recordsResults[1]["score"] = time end
		dbExec(DATABASE, "UPDATE Competition SET data = ?, score = ? WHERE base = ? AND competition = ?", toJSON(recordsResults[1]["data"]), recordsResults[1]["score"], baseVehicle, competitionVehicle)
	else
		-- Insert data to the database
		local data
		if finishedVehicle == baseVehicle then data = {base = 1, competition = 0}
		elseif finishedVehicle == competitionVehicle then data = {base = 0, competition = 1} end
		
		dbExec(DATABASE, "INSERT INTO Competition(base, competition, data, score) VALUES (?,?,?,?)", baseVehicle, competitionVehicle, toJSON(data), time)
	end
end )

-- Event called from client when player want to see stats, event returns data from database
addEvent("getStats", true)
addEventHandler("getStats", getRootElement(), function()
	if not DATABASE then return end
	dbExec(DATABASE, "CREATE TABLE IF NOT EXISTS Competition(base INTEGER, competition INTEGER, data TEXT, score INTEGER)")
	
	local data = dbPoll(dbQuery(DATABASE, "SELECT * FROM Competition ORDER BY score ASC"), -1)
	triggerClientEvent(source, "receiveStats", source, data)
end )
