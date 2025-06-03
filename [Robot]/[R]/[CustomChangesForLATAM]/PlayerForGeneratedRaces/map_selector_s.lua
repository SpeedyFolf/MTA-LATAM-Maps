local DATABASE = dbConnect("sqlite", ":/procedurallyGeneratedRace.db")

races = {}
for i = 1, 9 do
	races[i] = {id = nil, name = nil, rating = nil, vehicle = nil}
end

mapSelected = false
votedPlayers = {}
skipEnabled = false
mapname = nil

function returnRaceName(index)
	if races[index].id == nil then return false end
	
	local mapRating
	if races[index].rating == -1 then mapRating = "N/A"
	else
		local tmp = fromJSON(races[index].rating)
		mapRating = math.floor(tmp[1] * 10) / 10 
	end
	
	return races[index].name.. " " .. "(ID: " ..races[index].id.. " | Rating: " ..mapRating.. " | Vehicle: " ..races[index].vehicle.. ")"
end 

function voteMap()
	-- Select 8 races from database
	dbExec(DATABASE, "CREATE TABLE IF NOT EXISTS maps(id INTEGER, mapname TEXT, friendlyname TEXT, playername TEXT, checkpoints TEXT, vehicle TEXT, race TEXT, environment TEXT, timestamp INTEGER, ratings INTEGER, timesplayed INTEGER)")
	outputResults = dbPoll(dbQuery(DATABASE, "SELECT COUNT(*) as mapscount FROM maps"), -1)
	local mapsFound = tonumber(outputResults[1]["mapscount"])
	
	if mapsFound and mapsFound == 0 then 
		outputChatBox("#FF0000NO MAPS FOUND IN THE DATABASE!", root, 0, 0, 0, true)
		return 
	end
	
	-- Select random 9 races
	local tbl = {}
	for i = 1, mapsFound do
		table.insert(tbl, i)
	end
	
	if mapsFound < 9 then k = mapsFound 
	elseif mapsFound >= 9 then k = 9 end
	
	for i = 1, k do
		local n = math.random(#tbl)
		getRes = dbPoll(dbQuery(DATABASE, "SELECT * FROM maps WHERE id = ?", tbl[n]), -1)
		for b, data in pairs(getRes) do
			local vehicledata = fromJSON(data["vehicle"])
			table.insert(races, i, {
				id = data.id,
				name = data["friendlyname"],
				rating = data["ratings"],
				vehicle = vehicledata["name"]
			})
		end 
		table.remove(tbl, n)
	end
	
	local pollData = {
		title = "Choose the race:",
		percentage = 100,
		timeout = 15,
		allowchange = true
	}
	
	local racesFound = 0
	for i = 1, 9 do
		if returnRaceName(i) then
			table.insert(pollData, i, {returnRaceName(i), "pollFinished", resourceRoot, 50 + i})
			racesFound = racesFound + 1
		end
	end
	
	exports.votemanager:stopPoll {}
	
	if racesFound > 9 then racesFound = 9 end
	if not exports.votemanager:startPoll(pollData) then applyPollResult(math.random(51, 50 + racesFound)) end
end

addEvent("pollFinished", true)
addEventHandler("pollFinished", resourceRoot, function(pollResult)
	if pollResult > 50 and pollResult < 60 then
		result = dbPoll(dbQuery(DATABASE, "SELECT * FROM maps WHERE id = ?", races[pollResult - 50].id), -1)
		
		local raceName = result[1]["friendlyname"]
		vehicle = fromJSON(result[1]["vehicle"])
		race = fromJSON(result[1]["race"])
		environment = fromJSON(result[1]["environment"])
		markers = fromJSON(result[1]["checkpoints"])
		
		race["timestamp"] = result[1]["timestamp"]
		
		if result[1]["ratings"] == -1 then
			race["rating"] = -1
			race["timesRated"] = 0
		else
			local t = fromJSON(result[1]["ratings"])
			race["rating"] = t[1]
			race["timesRated"] = t[2]
		end
		
		mapname = result[1]["mapname"]
		race["mapname"] = result[1]["friendlyname"]
		race["generator"] = result[1]["playername"]
		mapSelected = true
		
		forceRaceEnvironment()
		setTimer(update, 500, 0)
	elseif pollResult == 80 then -- Yes
		markerToSkip = getElementData(votePlayer, "race.checkpoint")
		skipEnabled = true
	end
end )

addEventHandler("onResourceStart", resourceRoot, function(resource) 
	voteMap() 
end )

function rate(playerSource, commandName, arg)
	if not mapSelected then return end
	
	-- Process player rating
	local playerRating = tonumber(arg)
	if playerRating == nil then return outputChatBox("Use: /ratemap [0-10]", playerSource)
	elseif playerRating > 10 or playerRating < 0 then return outputChatBox("Use: /ratemap [0-10]", playerSource) end
	
	if DATABASE then
		dbExec(DATABASE, "CREATE TABLE IF NOT EXISTS mapratings(mapname TEXT, playername TEXT, rating INTEGER)") 
		result = dbPoll(dbQuery(DATABASE, "SELECT * FROM mapratings WHERE playername = ? AND mapname = ?", getPlayerName(playerSource), mapname), -1)
		
		if result and #result > 0 then
			dbExec(DATABASE, "DELETE FROM mapratings WHERE playername = ? AND mapname = ?", getPlayerName(playerSource), mapname)
			dbExec(DATABASE, "INSERT INTO mapratings(mapname, playername, rating) VALUES (?,?,?)", mapname, getPlayerName(playerSource), playerRating)
			outputChatBox("Changed rating this map to " ..getRatingColorAsHex(playerRating).. "" ..playerRating.. "/10", playerSource, 255, 255, 255, true)
		else
			dbExec(DATABASE, "INSERT INTO mapratings(mapname, playername, rating) VALUES (?,?,?)", mapname, getPlayerName(playerSource), playerRating)
			outputChatBox("You've rated this map " ..getRatingColorAsHex(playerRating).. "" ..playerRating.. "/10", playerSource, 255, 255, 255, true)
		end
		
		-- Updating race rating
		local sum, tim = 0, 0
		local req = dbPoll(dbQuery(DATABASE, "SELECT rating FROM mapratings WHERE mapname = ?", mapname), -1)
		for _, data in pairs(req) do
			sum = sum + data["rating"]
			tim = tim + 1
		end  
		
		local actualRating = math.floor((sum / tim) * 10) / 10
		dbExec(DATABASE, "UPDATE maps SET ratings = ? WHERE mapname = ?", toJSON({actualRating, tim}), mapname)
	end
end
addCommandHandler("ratemap", rate)

addEvent("onPlayerFinish", true)
addEventHandler("onPlayerFinish", getRootElement(), function(rank, time)
	if DATABASE then		
		dbExec(DATABASE, "CREATE TABLE IF NOT EXISTS maprecords(mapname TEXT, playername TEXT, score INTEGER)")
		recordsResults = dbPoll(dbQuery(DATABASE, "SELECT * FROM maprecords WHERE playername = ? AND mapname = ?", getPlayerName(source):gsub("#%x%x%x%x%x%x", ""), mapname), -1)		
		
		-- Updating Database
		local oldScore
		if recordsResults and #recordsResults > 0 then
			if time < recordsResults[1]["score"] then
				oldScore = recordsResults[1]["score"]
				dbExec(DATABASE, "UPDATE maprecords SET score = ? WHERE playername = ? AND mapname = ?", time, getPlayerName(source):gsub("#%x%x%x%x%x%x", ""), mapname)
			end
		else dbExec(DATABASE, "INSERT INTO maprecords(mapname, playername, score) VALUES (?,?,?)", mapname, getPlayerName(source):gsub("#%x%x%x%x%x%x", ""), time) end
		
		-- Sort first 10 Records 
		recordsResults = dbPoll(dbQuery(DATABASE, "SELECT * FROM maprecords WHERE mapname = ? ORDER BY score ASC LIMIT 10", mapname), -1)
		
		-- Check for new top time
		for i, recordsData in pairs(recordsResults) do 
			if recordsData["playername"] == getPlayerName(source) and time == recordsData["score"] then
				if oldScore then outputChatBox("#00FF00[" ..race["mapname"].. "] New top time #" ..i.. ": " ..getPlayerName(source).. "#00FF00, " ..convertToRaceTime(time).. " (-" ..convertToRaceTime(oldScore - time).. ")", root, 255, 255, 255, true)
				else outputChatBox("#00FF00[" ..race["mapname"].. "] New top time #" ..i.. ": " ..getPlayerName(source).. "#00FF00, " ..convertToRaceTime(time), root, 255, 255, 255, true) end

				break
			end
		end
	end
end )

-- Event called from client when player want to see stats, event returns data from database
addEvent("getStats", true)
addEventHandler("getStats", getRootElement(), function()
	if DATABASE and mapSelected then		
		dbExec(DATABASE, "CREATE TABLE IF NOT EXISTS maprecords(mapname TEXT, playername TEXT, score INTEGER)")
		recordsResults = dbPoll(dbQuery(DATABASE, "SELECT * FROM maprecords WHERE mapname = ? ORDER BY score ASC LIMIT 11", mapname), -1)		
		triggerClientEvent(source, "receiveStats", source, recordsResults)
	end
end )