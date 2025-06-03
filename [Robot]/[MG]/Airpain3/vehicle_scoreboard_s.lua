-- Function converts time in milliseconds into time in format MM:SS.MS
function convertToRaceTime(time)
	if time ~= nil then
		local m = math.floor(time / 1000 / 60)
		local s = math.floor((time / 1000) - m*60)
		local ms = math.floor(time - (m*60+s)*1000)
		
		if m < 1 then m = ""
		else m = m.. ":" end
		if s < 10 and m ~= "" then s = "0" ..s end
		if ms < 10 then ms = "00" ..ms
		elseif ms < 100 and ms > 9 then ms = "0" ..ms end
		
		return m.. "" ..s.. "." ..ms
	end
end

addEvent("onPlayerFinish", true)
addEventHandler("onPlayerFinish", getRootElement(), function(rank, time)
	if getPedOccupiedVehicle(source) then
		local vehicleModel = getElementModel(getPedOccupiedVehicle(source))
		local playerName = getPlayerNameNoHex(source)

		executeSQLQuery("CREATE TABLE IF NOT EXISTS Airpain3 (vehicle INTEGER, playername TEXT, score INTEGER)")
		recordsResults = executeSQLQuery("SELECT * FROM Airpain3 WHERE vehicle = ? AND playername = ?", vehicleModel, playerName)
		
		-- Updating Database
		if (recordsResults and #recordsResults > 0) then
			if (time < recordsResults[1]["score"]) then
				oldScore = recordsResults[1]["score"]
				executeSQLQuery("UPDATE Airpain3 SET score = ? WHERE vehicle = ? AND playername = ?", time, vehicleModel, playerName)
			end
		else
			oldScore = 0
			executeSQLQuery("INSERT INTO Airpain3 (vehicle, playername, score) VALUES (?,?,?)", vehicleModel, playerName, time)
		end
		
		-- Sort first 11 Records 
		recordsResults = executeSQLQuery("SELECT * FROM Airpain3 WHERE vehicle = ? ORDER BY score ASC LIMIT 11", vehicleModel)		
		-- Check for new top time
		for i, recordsData in pairs(recordsResults) do 
			if recordsData["playername"] == getPlayerNameNoHex(source) and time == recordsData["score"] then
				if oldScore ~= 0 then
					local diff = oldScore - time
					outputChatBox(
						"#00C61C[#EA282E" ..
						CARS_TABLE[getElementModel(getPedOccupiedVehicle(source))] .. 
						"#00C61C] New top time ##EA282E" ..
						i .. 
						"#00C61C: #EA282E" ..
						getPlayerNameNoHex(source) .. 
						"#00C61C, #EA282E" ..
						convertToRaceTime(time) .. 
						"#00C61C (#EA282E-" .. 
						convertToRaceTime(diff) .. 
						"#00C61C)",
					root, 255, 255, 255, true)
				else
					outputChatBox(
						"#00C61C[#EA282E" ..
						CARS_TABLE[getElementModel(getPedOccupiedVehicle(source))] .. 
						"#00C61C] New top time ##EA282E" ..
						i .. 
						"#00C61C: #EA282E" ..
						getPlayerNameNoHex(source) .. 
						"#00C61C, #EA282E" ..
						convertToRaceTime(time), 
					root, 255, 255, 255, true)
				end

				break
			end
			
			if i == 11 then break end
		end
	end
end )

function getPlayerNameNoHex(player)
	local name = getPlayerName(player)
	name = removeHex(name)
	return name
end

function removeHex (s)
	return s:gsub ("#%x%x%x%x%x%x", "") or false
end

function purgeLeaderboardOfHices()
	executeSQLQuery("CREATE TABLE IF NOT EXISTS Airpain3 (vehicle INTEGER, playername TEXT, score INTEGER)")
	local results = executeSQLQuery("SELECT DISTINCT playername FROM Airpain3")
	if not results or #results < 0 then return end
	for i,v in ipairs(results) do
		local hexlessName = removeHex(v.playername)
		if hexlessName ~= v.playername then
			executeSQLQuery("UPDATE Airpain3 SET playername = ? WHERE playername = ?", hexlessName, v.playername)
		end
	end
end
purgeLeaderboardOfHices()

-- Event called from client when player want to see stats, event returns data from database
addEvent("getStats", true)
addEventHandler("getStats", getRootElement(), function()
	local data = {}
	
	for i = 1, 41 do
		if i == 0 then vehicleModel = 0
		elseif i == 1 then vehicleModel = 514
		elseif i == 2 then vehicleModel = 406
		elseif i == 3 then vehicleModel = 603
		elseif i == 4 then vehicleModel = 434
		elseif i == 5 then vehicleModel = 596
		elseif i == 6 then vehicleModel = 458
		elseif i == 7 then vehicleModel = 575
		elseif i == 8 then vehicleModel = 533
		elseif i == 9 then vehicleModel = 431
		elseif i == 10 then vehicleModel = 475
		elseif i == 11 then vehicleModel = 587
		elseif i == 12 then vehicleModel = 483
		elseif i == 13 then vehicleModel = 530
		elseif i == 14 then vehicleModel = 451
		elseif i == 15 then vehicleModel = 545
		elseif i == 16 then vehicleModel = 554
		elseif i == 17 then vehicleModel = 471
		elseif i == 18 then vehicleModel = 580
		elseif i == 19 then vehicleModel = 411
		elseif i == 20 then vehicleModel = 525
		elseif i == 21 then vehicleModel = 536
		elseif i == 22 then vehicleModel = 500
		elseif i == 23 then vehicleModel = 495
		elseif i == 24 then vehicleModel = 572
		elseif i == 25 then vehicleModel = 480
		elseif i == 26 then vehicleModel = 439
		elseif i == 27 then vehicleModel = 602
		elseif i == 28 then vehicleModel = 568
		elseif i == 29 then vehicleModel = 444
		elseif i == 30 then vehicleModel = 515
		elseif i == 31 then vehicleModel = 576
		elseif i == 32 then vehicleModel = 535
		elseif i == 33 then vehicleModel = 415
		elseif i == 34 then vehicleModel = 542
		elseif i == 35 then vehicleModel = 571
		elseif i == 36 then vehicleModel = 532
		elseif i == 37 then vehicleModel = 486
		elseif i == 38 then vehicleModel = 504
		elseif i == 39 then vehicleModel = 476
		elseif i == 40 then vehicleModel = 549
		elseif i == 41 then vehicleModel = 424
		end
		
		executeSQLQuery("CREATE TABLE IF NOT EXISTS Airpain3 (vehicle INTEGER, playername TEXT, score INTEGER)")
		data[i] = executeSQLQuery("SELECT * FROM Airpain3 WHERE vehicle = ? ORDER BY score ASC LIMIT 11", vehicleModel)
	end
	
	local data2 = executeSQLQuery("SELECT vehicle, playername, MIN(score) AS top_score FROM Airpain3 GROUP BY vehicle ORDER BY top_score")
	triggerClientEvent(source, "receiveStats", source, data, data2)
end )

CARS_TABLE = {
	[514] = "Abba Cab",
	[406] = "Big Dump",
	[603] = "Blood Riviera",
	[434] = "Bugga",
	[596] = "Copcar",
	[458] = "Coupe de Grace",
	[575] = "Cow Poker",
	[533] = "DC Codbra",
	[431] = "Deathcruiser",
	[475] = "Degory'un 2",
	[587] = "Eagle 3",
	[483] = "Flower Power",
	[530] = "Forking Ada",
	[451] = "Hawk 3",
	[545] = "Hellrod",
	[554] = "Hick Pickup",
	[471] = "Jetcar",
	[580] = "Ladybug2",
	[411] = "Lamb O'Genie",
	[525] = "Loggerhead",
	[536] = "Mach 13",
	[500] = "Mad Morris",
	[495] = "Monster Beatle",
	[572] = "Piranha",
	[480] = "Porker 2",
	[439] = "Prop Shafter",
	[602] = "Purple Piledriver",
	[568] = "Razorback",
	[444] = "Screwie 2",
	[515] = "Semi Mk.2",
	[576] = "Slam Sedan",
	[535] = "Street Machine",
	[415] = "Tashita2",
	[542] = "The Bimmer",
	[571] = "The Buzzmobile",
	[532] = "The Harvester",
	[486] = "The Plow Mk.2",
	[504] = "The Red Vet",
	[476] = "The Supastuka",
	[549] = "Thunderbucket",
	[424] = "Vlad3",
}