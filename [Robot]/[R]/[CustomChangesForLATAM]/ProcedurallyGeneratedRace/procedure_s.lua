--DEBUG = true
local raceCreated = false
local mapStarted = false
local DATABASE = dbConnect("sqlite", ":/procedurallyGeneratedRace.db")
local VOTESAVE_MIN_PLAYERS = 2

-- Nodes
local vehicleNodes = {}
local nodesData = {}

-- Skip marker mechanics
local skipEnabled = false
local voteEnabled = false
local votePlayer = nil
local votedPlayers = {}
local markerToSkip = 60

-- Generator
local oldDistance = 0
--local maxDistance = 0
local raceDistance = 0
local bendsDone = 0
local autoBendsDone = 0
local raceRoute = {}
local routeUsedNodes = {}
local lastPoint = {}
local lastAngle
local settings = {
	["default"] = {
		randomPath = true,
		min_dist_1 = 150,
		min_dist_2 = 400,
		max_checkpoints = 50
	},
	["Plane"] = {
		randomPath = true,
		min_dist_1 = 700,
		min_dist_2 = 1200,
		max_checkpoints = 17
	},
	["Boat"] = {
		randomPath = true,
		min_dist_1 = 150,
		min_dist_2 = 400,
		max_checkpoints = 15
	},
	["Train"] = {
		randomPath = false,
		min_dist_1 = 150,
		min_dist_2 = 400,
		max_checkpoints = 50
	}
}

-- Names
local dictionary = {}

-- Data of generated race
local environment = {}
local vehicle = {}
local race = {}
local markers = {}


-- Data table for cars
local vehiclesXml = Xml:new("vehicles.xml", "vehicles")
local vehicleRadius = {3, 3.2, 3.2, 5.2, 3.2, 3.3, 6.6, 4.8, 5.9, 4.3, 2.8, 3.1, 3.9, 3.3, 3.9, 3, 4.4, 12, 3.3, 3.4, 3.3, 3.5, 3.1, 3.6, 2.4, 9.8, 3.2, 4.4, 3.7, 2.9, 6.5, 6.6, 5.1, 5.5, 2.6, 7.3, 3.1, 6.3, 3.3, 3, 3.2, 2, 3.7, 10.3, 3.8, 3.2, 6.7, 7.5, 1.3, 5.2, 7.1, 3, 5.9, 6, 8.3, 5.3, 5.1, 2, 3.4, 3.2, 8.9, 1.4, 1.3, 1.4, 1.2, 0.9, 3.4, 3.5, 1.3, 7.5, 3.2, 1.4, 4.5, 2.6, 3.3, 3.2, 8.1, 3.3, 3.2, 3.3, 2.9, 1.1, 3.3, 3.4, 9.9, 2.3, 4.6, 7.7, 6.5, 3.3, 3.9, 3.4, 3.4, 6.7, 3.5, 3.2, 2.7, 7.7, 4.1, 3.9, 2.9, 0.9, 3.3, 3.4, 3.3, 3.3, 2.9, 3.6, 4.5, 1.2, 1.1, 15, 6.5, 6.5, 5.5, 5.6, 3.4, 3.5, 3.3, 14.1, 8.6, 1.4, 1.4, 1.4, 5, 3.9, 2.9, 3.2, 3.2, 3.1, 2.6, 2.3, 7.3, 3, 3.3, 3.1, 3.5, 11, 8.2, 2.6, 3.4, 2.7, 3.5, 3.2, 6.7, 2.7, 3.3, 3.2, 12.7, 3.1, 3.3, 3.7, 4, 18.9, 3.5, 2.8, 3.8, 3.8, 2.9, 3, 3, 3.2, 2.9, 9.6, 0.9, 2.7, 3.5, 3.7, 2.7, 9.4, 10.6, 1.6, 1.7, 4.1, 2.4, 3.2, 3.4, 45.7, 6.3, 3.5, 3.3, 1.4, 3.9, 2.5, 8.199999999999999, 3.5, 1.5, 3.2, 5.5, 2.9, 9.6, 7.3, 36.4, 9.3, 0.5, 6.3, 3.2, 3.3, 3.2, 3.5, 3.3, 4.5, 3.1, 3.3, 3.4, 3.2, 2.4, 2.4, 4, 4.1, 1.5, 2.1 }
local vehicleUpgrades = {
	[418] = {{1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1006},  {1020, 1021 }}, 
	[517] = {{1142, 1143, 1144, 1145},  {1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1007, 1017},  {1018, 1019, 1020 }}, 
	[421] = {{1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1018, 1019, 1020, 1021 }}, 
	[422] = {{1007, 1017},  {1019, 1020, 1021 }}, 
	[527] = {{1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1007, 1017},  {1018, 1020, 1021 }}, 
	[489] = {{1004, 1005},  {1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1013, 1024},  {1006},  {1018, 1019, 1020 }}, 
	[490] = {{1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164 }}, 
	[491] = {{1142, 1143, 1144, 1145},  {1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1007, 1017},  {1018, 1019, 1020, 1021 }}, 
	[492] = {{1004, 1005},  {1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1006 }}, 
	[600] = {{1004, 1005},  {1007, 1017},  {1013},  {1006},  {1018, 1020, 1022 }}, 
	[496] = {{1011, 1142, 1143},  {1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1007, 1017},  {1006},  {1019, 1020 }}, 
	[605] = {{1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164 }}, 
	[547] = {{1142, 1143},  {1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1018, 1019, 1020, 1021 }}, 
	[436] = {{1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1007, 1017},  {1013},  {1006},  {1019, 1020, 1021, 1022 }}, 
	[500] = {{1019, 1020, 1021 }}, 
	[603] = {{1142, 1143, 1144, 1145},  {1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1007, 1017},  {1006},  {1018, 1019, 1020 }}, 
	[439] = {{1142, 1143, 1144, 1145},  {1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1007, 1017},  {1013 }}, 
	[599] = {{1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164 }}, 
	[559] = {{1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1069, 1070, 1071, 1072},  {1067, 1068},  {1065, 1066},  {1160, 1173},  {1159, 1161 }}, 
	[505] = {{1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164 }}, 
	[560] = {{1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1026, 1027, 1030, 1031},  {1032, 1033},  {1028, 1029},  {1169, 1170},  {1140, 1141 }}, 
	[565] = {{1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1047, 1048, 1051, 1052},  {1053, 1054},  {1045, 1046},  {1152, 1153},  {1150, 1151 }}, 
	[567] = {{1102, 1133},  {1130, 1131},  {1129, 1132},  {1188, 1189},  {1186, 1187 }}, 
	[561] = {{1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1056, 1057, 1062, 1063},  {1055, 1061},  {1059, 1064},  {1155, 1157},  {1154, 1156 }}, 
	[426] = {{1004, 1005},  {1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1006},  {1019, 1021 }}, 
	[580] = {{1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1007, 1017},  {1006},  {1018, 1020 }}, 
	[575] = {{1042, 1099},  {1043, 1044},  {1174, 1175},  {1176, 1177 }}, 
	[579] = {{1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164 }}, 
	[516] = {{1004},  {1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1007, 1017},  {1018, 1019, 1020, 1021 }}, 
	[518] = {{1142, 1143, 1144, 1145},  {1005},  {1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1007, 1017},  {1013},  {1006},  {1018, 1020 }}, 
	[576] = {{1134, 1137},  {1135, 1136},  {1190, 1191},  {1192, 1193 }}, 
	[585] = {{1142, 1143, 1144, 1145},  {1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1007, 1017},  {1013},  {1006},  {1018, 1019, 1020 }}, 
	[587] = {{1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164 }}, 
	[589] = {{1144, 1145},  {1004, 1005},  {1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1007, 1017},  {1006},  {1018, 1020 }}, 
	[540] = {{1142, 1143, 1144, 1145},  {1004},  {1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1007, 1017},  {1024},  {1006},  {1018, 1019, 1020 }}, 
	[458] = {{1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164 }}, 
	[551] = {{1005},  {1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1006},  {1018, 1019, 1020, 1021 }}, 
	[534] = {{1101, 1106, 1122, 1124},  {1126, 1127},  {1179, 1185},  {1178, 1180},  {1100, 1123, 1125 }}, 
	[536] = {{1107, 1108},  {1103, 1128},  {1104, 1105},  {1181, 1182},  {1183, 1184 }}, 
	[550] = {{1142, 1143, 1144, 1145},  {1004, 1005},  {1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1006},  {1018, 1019, 1020 }}, 
	[400] = {{1013, 1024},  {1018, 1019, 1020, 1021 }}, 
	[401] = {{1142, 1143, 1144},  {1004, 1005},  {1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1007, 1017},  {1013},  {1006},  {1019, 1020 }}, 
	[549] = {{1011, 1012, 1142, 1143, 1144, 1145},  {1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1007, 1017},  {1018, 1019, 1020 }}, 
	[546] = {{1142, 1143, 1144, 1145},  {1004},  {1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1007, 1017},  {1024},  {1006},  {1018, 1019 }}, 
	[404] = {{1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1007, 1017},  {1013},  {1019, 1020, 1021 }}, 
	[405] = {{1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1018, 1019, 1020, 1021 }}, 
	[543] = {{1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164 }}, 
	[542] = {{1144, 1145},  {1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1018, 1019, 1020, 1021 }}, 
	[535] = {{1118, 1119, 1120, 1121},  {1115, 1116},  {1109, 1110},  {1113, 1114},  {1117 }}, 
	[558] = {{1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1090, 1093, 1094, 1095},  {1088, 1091},  {1089, 1092},  {1165, 1166},  {1167, 1168 }}, 
	[410] = {{1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1007, 1017},  {1013, 1024},  {1019, 1020, 1021 }}, 
	[562] = {{1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1036, 1039, 1040, 1041},  {1035, 1038},  {1034, 1037},  {1171, 1172},  {1148, 1149 }}, 
	[529] = {{1011, 1012},  {1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1007, 1017},  {1006},  {1018, 1019, 1020 }}, 
	[420] = {{1004, 1005},  {1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1019, 1021 }}, 
	[477] = {{1007, 1017},  {1006},  {1018, 1019, 1020, 1021 }}, 
	[415] = {{1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164},  {1007, 1017},  {1018, 1019 }}, 
	[478] = {{1012},  {1004, 1005},  {1020, 1021, 1022 } }
}

-- Random CJ clothes
local clothes = {}
for i = 0, 16 do
	local clothesIndex = 0
	clothes[i] = {}
	while(getClothesByTypeIndex(i, clothesIndex)) do
		local clothesTexture, clothesModel = getClothesByTypeIndex(i, clothesIndex)
		table.insert(clothes[i], {clothesTexture, clothesModel})
		clothesIndex = clothesIndex + 1
	end
end

-- Saving maps feature
local savingEnabled = false
local savePlayer = nil
local savedPlayers = {}
local mapSaved = false

-- Trailers lol
local trailers = {}
local trailerTimers = {}
local cartsTimer = {}

function saveMap()
	if not raceCreated or mapSaved then return end 
	savingEnabled = false
	mapSaved = true
	
	local markersConverted = markers
	
	if DATABASE then
		-- Create table
		dbExec(DATABASE, "CREATE TABLE IF NOT EXISTS maps(id INTEGER, mapname TEXT, friendlyname TEXT, playername TEXT, checkpoints TEXT, vehicle TEXT, race TEXT, environment TEXT, timestamp INTEGER, ratings INTEGER, timesplayed INTEGER)")
		
		-- Count how many maps already stored
		outputResults = dbPoll(dbQuery(DATABASE, "SELECT COUNT(*) as mapscount FROM maps"), -1)
		
		-- Save
		dbExec(DATABASE, "INSERT INTO maps(id, mapname, friendlyname, playername, checkpoints, vehicle, race, environment, timestamp, ratings, timesplayed) VALUES (?,?,?,?,?,?,?,?,?,?,?)", tonumber(outputResults[1]["mapscount"]) + 1, race["mapname"]:gsub(" ", "").. "" ..math.random(100000, 999999), race["mapname"], race["generator"], toJSON(markersConverted), toJSON(vehicle), toJSON(race), toJSON(environment), timeGenerated, -1, 0)
	end
	
	outputChatBox("#E7D9B0Saving map: #00FF00" ..race["mapname"].. " #E7D9B0by #00FF00" ..race["generator"], root, 0, 0, 0, true)
	if DEBUG then outputDebugString("Saving: " ..race["mapname"]) end
end

function setUpPlayersVehicle()
	for _, players in pairs(getElementsByType("player")) do
		-- Setup player's skin, clothes and CJ's stats
		if race["pedID"] and getElementModel(players) ~= race["pedID"] then
			if race["pedID"] == 74 or race["pedID"] == 149 or race["pedID"] == 208 or race["pedID"] == 0 then
				-- Skin is CJ
				setElementModel(players, 0)
				race["pedID"] = 0
				
				-- Random Clothes
				removePedClothes(players, 17)
				local hat = 16
				if math.random(2) == 1 then hat = 15 end
				for i = 0, hat do 
					removePedClothes(players, i)
					addPedClothes(players, clothes[i][race["clothes"][i]][1], clothes[i][race["clothes"][i]][2], i)
				end
				
				-- CJ's stats
				setPedStat(players, 21, race["fat"])
				setPedStat(players, 23, race["muscle"])
			else
				-- Set skin
				setElementModel(players, race["pedID"])
			end
		end
		
		-- Setup player's vehicle
		if getPedOccupiedVehicle(players) then
			-- Hydraulics
			if vehicle["hydraulics"] == 1 and getVehicleUpgradeOnSlot(getPedOccupiedVehicle(players), 9) == 0 then
				addVehicleUpgrade(getPedOccupiedVehicle(players), 1087)
			end
			
			setVehiclePaintjob(getPedOccupiedVehicle(players), vehicle["paintjob"])
			setVehicleHeadLightColor(getPedOccupiedVehicle(players), vehicle["lightsColorR"], vehicle["lightsColorG"], vehicle["lightsColorB"])
			if vehicle["wheels"] ~= nil then addVehicleUpgrade(getPedOccupiedVehicle(players), vehicle["wheels"]) end
			
			if getVehicleUpgradeOnSlot(getPedOccupiedVehicle(players), 8) ~= 1008 and vehicle["nitros"] == 3 then
				addVehicleUpgrade(getPedOccupiedVehicle(players), 1008) 
			end
			
			for i = 1, #vehicle["upgrades"] do
				addVehicleUpgrade(getPedOccupiedVehicle(players), vehicle["upgrades"][i])
			end
			
			if vehicle["type"] == "Train" then
				-- Derailability Randomizer
				if vehicle["trainDerailable"] == 0 then setTrainDerailable(getPedOccupiedVehicle(players), false) end 
				
				-- Direction Randomizer
				if vehicle["trainDirection"] == 0 then setTrainDirection(getPedOccupiedVehicle(players), true)
				elseif vehicle["trainDirection"] == 1 then setTrainDirection(getPedOccupiedVehicle(players), false) end
				
				-- Train Carts
				if vehicle["trainCarts"] and trailers[players] == nil and not isTimer(cartsTimer[players]) then
					cartsTimer[players] = setTimer(function()
						-- Create carts
						trailers[players] = {}
						trailerTimers[players] = {}
						
						for t = 1, #vehicle["trainCarts"] do
							trailers[players][t] = createVehicle(vehicle["trainCarts"][t], vehicle["spawnX"], vehicle["spawnY"], vehicle["spawnZ"])
							if vehicle["trainDirection"] == 0 then setTrainDirection(trailers[players][t], true)
							else setTrainDirection(trailers[players][t], false) end
							
							if vehicle["trainDerailable"] == 0 then setTrainDerailable(trailers[players][t], false) end
							
							if t == 1 then trailerTimers[players][t] = setTimer(attachCartsToTrain, 250, 0, getPedOccupiedVehicle(players), trailers[players][t])
							else trailerTimers[players][t] = setTimer(attachCartsToTrain, 250, 0, trailers[players][t-1], trailers[players][t]) end
							
							setVehicleColor(trailers[players][t], math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255))
						end
					end, 300, 1)
				end
			end
			
			if vehicle["trailer"] ~= nil and vehicle["type"] ~= "Train" and mapStarted then
				if trailers[players] == nil then
					local x, y, z = getElementPosition(getPedOccupiedVehicle(players))
					local closeToSomebody = false
					
					for _, ps in ipairs(getElementsByType("player")) do
						if players ~= ps and getPedOccupiedVehicle(ps) then
							local u, w, v = getElementPosition(getPedOccupiedVehicle(ps))
							if getDistanceBetweenPoints3D(x, y, z, u, w, v) < 0.3 then
								closeToSomebody = true
								break
							end
						end
					end
					
					if not closeToSomebody then
						local x, y, z = getElementPosition(getPedOccupiedVehicle(players))
						trailers[players] = createVehicle(vehicle["trailer"], x, y, z, 0, 0, vehicle["trailerRot"])
						trailerTimers[players] = setTimer(attachTrailerToVehicle, 250, 1, getPedOccupiedVehicle(players), trailers[players])
						setElementVelocity(getPedOccupiedVehicle(players), 0, 0, 0)
						if vehicle["wheels"] ~= nil then addVehicleUpgrade(trailers[players], vehicle["wheels"]) end
						setVehicleColor(trailers[players], math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255))
					end
				else
					setElementHealth(trailers[players], 1000)
				end
			end
		end
	end
end

function attachCartsToTrain(train, cart)
	if not train then 
		if isElement(cart) then destroyElement(cart) end
		return
	end
	
	if not isTrainDerailed(train) then
		-- Make sure that cart is not derailed
		setTrainDerailed(cart, false)
		
		-- Attach cart to the train
		attachTrailerToVehicle(train, cart)
		
	-- Otherwise derail all carts
	else setTrainDerailed(cart, true) end
end

function update()
	-- Update player's vehicle
	setUpPlayersVehicle()
				
	-- Send data and skip
	if raceCreated then
		for _, players in ipairs(getElementsByType("player")) do
			if getElementData(players, "gotdata") ~= 1 then
				votedPlayers[players] = false
				triggerClientEvent(players, "recieveMarkers", players, {markers, vehicle, race, environment})
			end
			
			if skipEnabled and getElementData(players, "skipped") ~= 1 then
				triggerClientEvent(players, "setSkip", players, markerToSkip)
			end
		end
	end
end

-- GENERATOR STUFF -- 
function createRace()
	-- Check if race is already generated
	if raceCreated then return end
	
	-- Random Vehicle
	math.randomseed(math.floor(os.time()/getTickCount()*math.random(1, getTickCount())))
	--repeat
		vehicle["model"] = math.random(400, 611)
		vehicle["name"] = tostring(vehiclesXml:getAttribute({tag = "vehicle", attribute = {id = vehicle["model"]}}, "name"))
	--until getVehicleType(vehicle["model"]) == "Plane"
	
	if vehicle["model"] == 539 or vehicle["model"] == 607 or vehicle["model"] == 606 then vehicle["type"] = "Automobile" 
	else vehicle["type"] = getVehicleType(vehicle["model"]) end
	
	if vehicle["type"] == "Trailer" then
		vehicle["trailer"] = vehicle["model"]
		vehicle["trailerRot"] = math.random(0, 360)
		vehicle["trailerName"] = tostring(vehiclesXml:getAttribute({tag = "vehicle", attribute = {id = vehicle["trailer"]}}, "name"))
		
		-- "Trucking" trailers
		if vehicle["trailer"] == 435 or vehicle["trailer"] == 584 or vehicle["trailer"] == 450 or vehicle["trailer"] == 591 then
			local trucks = {403, 515, 514}
			vehicle["model"] = trucks[math.random(#trucks)]
		-- Farm Trailer
		elseif vehicle["trailer"] == 610 then
			vehicle["model"] = 531 -- Tractor
		-- Fucking Stairs
		elseif vehicle["trailer"] == 608 then
			local trucks = {583, 485}
			vehicle["model"] = trucks[math.random(#trucks)]
		-- Weird trailer for Utility Van
		elseif vehicle["trailer"] == 611 then
			vehicle["model"] = 552
		end
		
		vehicle["name"] = tostring(vehiclesXml:getAttribute({tag = "vehicle", attribute = {id = vehicle["model"]}}, "name"))
	end 
	
	-- Car delivery with Towtruck
	if vehicle["model"] == 525 then
		if math.random(2) == 2 then
			vehicle["type"] = "Trailer"
			
			local trailers = {602, 496, 401, 518, 527, 589, 587, 533, 526, 474, 545, 600, 491, 405, 467, 516, 445, 604, 438, 420, 496, 585}
			vehicle["trailer"] = trailers[math.random(#trailers)]
			vehicle["trailerRot"] = math.random(0, 360)
			vehicle["trailerName"] = tostring(vehiclesXml:getAttribute({tag = "vehicle", attribute = {id = vehicle["trailer"]}}, "name"))
		end
	end
	
	vehiclesXml:open()
	maxVelocity = tonumber(vehiclesXml:getAttribute({tag = "vehicle", attribute = {id = vehicle["model"]}}, "maxspeed"))
	vehiclesXml:unload()
	
	defineRace()
	
	-- Checkpoints
	local startingTime = getTickCount()
	while true do
		local state = createCheckpoint()
		if not state then 
			-- Redefine the race if it is shit
			if autoBendsDone > race["bends"] and vehicle["type"] ~= "Train" then defineRace()
			elseif vehicle["type"] ~= "Train" then 	
				-- New comparator reference (a bend made here)
				compX = lastPoint.x
				compY = lastPoint.y
				compZ = lastPoint.z
				--createBlip(compX, compY, compZ, 20)
				
				autoBendsDone = autoBendsDone + 1
				oldDistance = 0
			end
		elseif state == -1 then 
			iprint("[Procedurally Generated Race]", "regenerating race")
			defineRace() 
		end
		
		-- Finish route generation
		if raceDistance >= targetDistance then 
			if DEBUG then createBlip(lastPoint.x, lastPoint.y, lastPoint.z, 28) end -- DEBUG
			break 
		else
			if DEBUG then createBlip(lastPoint.x, lastPoint.y, lastPoint.z, 29) end -- DEBUG
		end
	end
	
	-- Select number of CPs
	race["maxCP"] = math.max(math.min(math.floor(targetDistance / math.random(110, 130)), getSetting("max_checkpoints")), 8)
	
	-- Converts CPs
	raceDistance = getDistanceBetweenPoints3D(vehicle["spawnX"], vehicle["spawnY"], vehicle["spawnZ"], raceRoute[math.floor(#raceRoute / race["maxCP"])].x, raceRoute[math.floor(#raceRoute / race["maxCP"])].y, raceRoute[math.floor(#raceRoute / race["maxCP"])].z)
	for i = 1, race["maxCP"] do
		local index = math.floor(#raceRoute * i / race["maxCP"])
		local nextIndex = math.floor(#raceRoute * math.min(race["maxCP"], i + 1) / race["maxCP"])
		
		-- Distance 
		raceDistance = raceDistance + getDistanceBetweenPoints3D(raceRoute[index].x, raceRoute[index].y, raceRoute[index].z, raceRoute[nextIndex].x, raceRoute[nextIndex].y, raceRoute[nextIndex].z)
		
		if DEBUG then createBlip(raceRoute[index].x, raceRoute[index].y, raceRoute[index].z, 0, 2, 0, 255) end -- DEBUG
		markers[i] = {
			id = i, -- for saved maps
			x = raceRoute[index].x, 
			y = raceRoute[index].y, 
			z = raceRoute[index].z,
			color = race["cpColor"],
			type = race["markerType"],
			size = race["markerSize"]
		}
	end
	
	-- Spawn Rotation
	if vehicle["type"] == "Boat" or vehicle["type"] == "Plane" or vehicle["type"] == "Helicopter" then
		vehicle["spawnRot"] = findRotation(vehicle["spawnX"], vehicle["spawnY"], markers[1].x, markers[1].y)
	else vehicle["spawnRot"] = findRotation(vehicle["spawnX"], vehicle["spawnY"], raceRoute[2].x, raceRoute[2].y) end
	
	-- Race type
	if not race["type"] then race["type"] = "" end -- Default race
	if vehicle["trailer"] and vehicle["type"] ~= "Train" then
		if vehicle["model"] == 525 then race["type"] = "vehicle delivery"
		else race["type"] = "trailer delivery" end
	else
		if vehicle["type"] == "Plane" or vehicle["type"] == "Helicopter" then 
			if vehicle["type"] ~= getVehicleType(vehicle["model"]) then race["type"] = "flying cars"
			else race["type"] = "air" end
		elseif vehicle["type"] == "Boat" then race["type"] = "boat" 
		elseif vehicle["type"] == "Train" then race["type"] = "train" 
		else
			-- Default races
			if race["pedID"] == 294 then race["type"] = "blind" end -- Woozie's blind race
		end
	end
	
	-- Objects, pickups and other things
	postGeneration()

	-- Random Name for the map
	race["mapname"] = generateRaceName()
	
	-- Race generated!
	race["raceDistance"] = math.floor(raceDistance)
	race["timems"] = getTickCount() - startingTime
	race["bends"] = bendsDone.. "." ..autoBendsDone
	race["generator"] = getPlayerName(getRandomPlayer())
	
	raceCreated = true
	savingEnabled = true
	timeGenerated = os.time()
	setTimer(update, 500, 0)
	
	if vehicle["trailer"] ~= nil then
		addEventHandler("onTrailerDetach", getRootElement(), function(truck)
			setTimer(properlyAttachTrailer, 10, 1, truck, source)
		end )
	end
end

function defineRace()
	-- Data Initializing
	local availableWheels = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1025, 1073, 1074, 1075, 1076, 1077, 1078, 1079, 1080, 1081, 1082, 1083, 1084, 1085, 1096, 1097, 1098}
	
	-- Vehicle Type Specific Stuff
	-- Trains
	if vehicle["type"] == "Train" then
		vehicle["trainDirection"] = math.random(0, 1)
		vehicle["trainDerailable"] = math.random(0, 1)
		local specialTrain = math.random(4)
		
		-- Tram
		if vehicle["model"] == 449 and math.random(2) == 1 then
			vehicle["trainCarts"] = {449}
		
		-- Other train carts
		elseif vehicle["model"] == 590 or vehicle["model"] == 569 or vehicle["model"] == 570 then
			vehicle["trainCarts"] = {}
			
			for j = 1, math.random(2) do table.insert(vehicle["trainCarts"], vehicle["model"]) end
			
			vehicle["trailer"] = vehicle["model"]
			vehicle["trailerName"] = vehicle["name"]
			
			-- Streak
			if math.random(2) == 1 then 
				vehicle["model"] = 538 
				vehicle["name"] = "Brown Streak"
			-- Freight 	
			else 
				vehicle["model"] = 537 
				vehicle["name"] = "Freight"
			end 
		
		-- Special trains
		elseif (vehicle["model"] == 538 or vehicle["model"] == 569) and specialTrain == 3 then
			local availableCarts = {590, 569, 570, 449}
			vehicle["trainCarts"] = {}
			
			for j = 1, math.random(2) do
				local cart = math.random(#availableCarts)
				table.insert(vehicle["trainCarts"], availableCarts[cart])
			end
		end
	end
	
	-- Boats
	if vehicle["type"] == "Boat" then
		environment["waveHeight"] = math.random(0, 20) / 10
		environment["waterColorR"] = math.random(0, 255)
		environment["waterColorG"] = math.random(0, 255)
		environment["waterColorB"] = math.random(0, 255)
		environment["waterColorA"] = math.random(100, 255)
	end
	
	-- Planes and Helis
	environment["clipDistance"] = math.random(1000, 2500)
	environment["wind"] = { x = math.random(-10, 10) / 10, y = math.random(-10, 10) / 10, z = math.random(-10, 10) / 10 }
	
	-- Race Start
	local carIDs, boatIDs, trainNodes, raceStartNode = {}, {}, {}, nil
	-- Scan IDs of every area into table
	for _, areaData in pairs(vehicleNodes) do
		for nodeID, nodeData in pairs(areaData) do 
			if nodeData.type == 0 and nodeData.z < 600 then table.insert(carIDs, nodeID)				-- Car nodes
			elseif nodeData.type == 1 then table.insert(boatIDs, nodeID) 			-- Boat nodes
			elseif nodeData.type == 2 then table.insert(trainNodes, nodeID) end		-- Train nodes
		end
	end
	
	-- Select the race type
	if vehicle["type"] == "Boat" then 
		-- Boat Race
		raceStartNode = getNodeByID(boatIDs[math.random(#boatIDs)])
		vehicle["nodelist"] = 1
	elseif vehicle["type"] == "Train" then 
		-- Train Race
		raceStartNode = getNodeByID(trainNodes[math.random(#trainNodes)])
		vehicle["nodelist"] = 2
	elseif vehicle["type"] == "Quad" or vehicle["type"] == "Automobile" or vehicle["type"] == "Monster Truck" or vehicle["type"] == "Bike" then
		if vehicle["model"] == 539 and math.random(2) == 2 and vehicle["type"] ~= "Bike" then
			-- Vortex chance to be a boat
			raceStartNode = getNodeByID(boatIDs[math.random(#boatIDs)])
			vehicle["nodelist"] = 1
		else
			local randomModeChande = math.random(25) -- DEBUG 25 25 25 25 25 25
			if randomModeChande == 3 and vehicle["type"] ~= "Monster Truck" and vehicle["type"] ~= "Bike" then
				-- Chance of boat race on wheels
				raceStartNode = getNodeByID(boatIDs[math.random(#boatIDs)])
				race["type"] = "on-water"
				vehicle["nodelist"] = 1
			elseif randomModeChande == 5 and vehicle["type"] ~= "Bike" then
				-- Flying cars race for "Automobile", "Monster Truck" and "Quad"
				vehicle["type"] = "Plane"
				raceStartNode = getNodeByID(carIDs[math.random(#carIDs)])
				vehicle["nodelist"] = 0
			elseif randomModeChande == 10 then
				-- Jetpack races
				vehicle["type"] = "Automobile"
				raceStartNode = getNodeByID(carIDs[math.random(#carIDs)])
				vehicle["nodelist"] = 0
				race["type"] = "jetpack"
			else
				-- Normal Race
				vehicle["nodelist"] = 0
				raceStartNode = getNodeByID(carIDs[math.random(#carIDs)])
			end
		end
	else
		-- Normal Race
		vehicle["nodelist"] = 0
		raceStartNode = getNodeByID(carIDs[math.random(#carIDs)])
	end

	vehicle["spawnX"] = raceStartNode.x
	vehicle["spawnY"] = raceStartNode.y
	if vehicle["type"] ~= "Train" then vehicle["spawnZ"] = raceStartNode.z + 2
	else vehicle["spawnZ"] = raceStartNode.z end
	
	lastPoint = {x = vehicle["spawnX"], y = vehicle["spawnY"], z = vehicle["spawnZ"]}
	--iprint("[Procedurally Generated Race]", "start", raceStartNode.id)
	
	-- Set Random Vehicle Properties
	vehicle["wheels"] = availableWheels[math.random(#availableWheels)]
	vehicle["hydraulics"] = 0
	vehicle["nitros"] = math.random(3)
	
	-- PaintJobs
	local paintJobs = {
		[483] = {0, 3},       -- camper
		[534] = {0, 1, 2},    -- remington
		[535] = {0, 1, 2},    -- slamvan
		[536] = {0, 1, 2},    -- blade
		[558] = {0, 1, 2},    -- uranus
		[559] = {0, 1, 2},    -- jester
		[560] = {0, 1, 2},    -- sultan
		[561] = {0, 1, 2},    -- stratum
		[562] = {0, 1, 2},    -- elegy
		[565] = {0, 1, 2},    -- flash
		[567] = {0, 1, 2},    -- savanna
		[575] = {0, 1},       -- broadway
		[576] = {0, 1, 2}     -- tornado
	}
	
	if paintJobs[vehicle["model"]] then vehicle["paintjob"] = paintJobs[vehicle["model"]][math.random(#paintJobs[vehicle["model"]])]
	else vehicle["paintjob"] = math.random(3) end
	
	-- Vehicle's Lights Random Color
	vehicle["lightsColorR"], vehicle["lightsColorG"], vehicle["lightsColorB"] = hue2RGB(math.random(0, 360))
	
	-- Vehicles Upgrades
	vehicle["upgrades"] = {}
	if vehicleUpgrades[vehicle["model"]] ~= nil then
		local upgrageList = vehicleUpgrades[vehicle["model"]]
		for slot = 1, #vehicleUpgrades[vehicle["model"]] do 
			if math.random(2) == 1 then
				table.insert(vehicle["upgrades"], upgrageList[slot][math.random(#upgrageList[slot])])
			end
		end
	end

	-- Checkpoints Random Color
	race["cpColor"] = math.random(0, 3600) / 10
	
	-- Misc
	if math.random(3) == 1 then race["pedID"] = 0
	else race["pedID"] = math.random(0, 312) end
	
	-- Random Clothes
	if race["pedID"] == 0 or race["pedID"] == 74 or race["pedID"] == 149 or race["pedID"] == 208 then
		race["clothes"] = {}
		for i = 0, 16 do table.insert(race["clothes"], i, math.random(#clothes[i])) end
		
		race["fat"] = math.max(0, math.random(-500, 1000))
		race["muscle"] = math.max(0, math.random(-500, 1000))
	end

	race["bends"] = math.random(0, 2)
	if vehicle["type"] == "Train" then race["bends"] = 0 end
	
	-- Random Hydraulics
	if vehicle["type"] == "Automobile" then vehicle["hydraulics"] = math.random(0, 2)
	else vehicle["hydraulics"] = 0 end
	
	-- Race lenght
	targetDistance = math.min(6000, math.max(1000, maxVelocity * 22))
	if vehicle["type"] == "Plane" then targetDistance = targetDistance * math.random(22, 34) / 10
	elseif vehicle["type"] == "Train" then targetDistance = targetDistance * math.random(8, 30) / 10 end
	
	-- Checkpoint type
	if vehicle["type"] == "Plane" or vehicle["type"] == "Helicopter" then race["markerType"] = "ring" -- Force ring type on plane races
	else
		-- Generic race
		local types = {"ring", "corona", "checkpoint", "checkpoint", "checkpoint", "checkpoint", "checkpoint"}
		race["markerType"] = types[math.random(#types)]
	end
	
	-- Checkpoint size
	if race["markerType"] == "ring" then race["markerSize"] = vehicleRadius[vehicle["model"]-399] + 6
	else race["markerSize"] = 10 end
	
	if vehicle["type"] == "Train" then race["markerSize"] = 3 end
	
	-- Jetpack mode forced settings
	if race["type"] == "jetpack" then
		race["markerType"] = "ring"
		race["markerSize"] = 5
		targetDistance = math.random(1800, 2500)
		vehicle["name"] = "Jetpack"
	end
	
	-- Environment
	if math.random(50) == 5 then environment["hour"] = math.random(0, 6)
	else environment["hour"] = math.random(6, 22) end
	
	environment["min"] = math.random(59)
	environment["heat"] = math.random(0, 90)
	
	environment["AmbientColor"] = {
		[1] = math.random(0, 70),
		[2] = math.random(0, 70),
		[3] = math.random(0, 70)
	}
	environment["Illumination"] = math.random(0, 2)
	environment["Moon"] = math.random(0, 8)
	
	-- Router settings
	minDistance = math.random(getSetting("min_dist_1"), getSetting("min_dist_2"))  -- The higher the value, the closer CPs to each other (min distance)
	--maxDistance = 69999999900  -- The higher the value, the further CP would be (max distance)
	--iprint("[Procedurally Generated Race]", minDistance)
	
	if vehicle["type"] == "Train" then minDistance = 0 end
	
	raceRoute = {} -- Init race route
	routeUsedNodes = {}
	oldDistance = 0
	raceDistance = 0
	bendsDone = 0
	
	compX = vehicle["spawnX"]
	compY = vehicle["spawnY"]
	compZ = vehicle["spawnZ"]
end

function createCheckpoint()
	-- Select areas to scan
	local area = getAreaID(lastPoint.x, lastPoint.y)
	local zonesToScan = {area}
	local areaRow = math.min(7, math.max(0, math.ceil(area / 7) - 1))
	
	if area ~= 0 and area % 8 ~= 0 then 
		table.insert(zonesToScan, area - 1) -- left
		
		if areaRow ~= 7 then table.insert(zonesToScan, area + 7) end -- top left
		if areaRow ~= 0 then table.insert(zonesToScan, area - 9) end -- bottom left
	end 
	
	if area ~= areaRow * 8 + 7 then 
		table.insert(zonesToScan, area + 1) -- right

		if areaRow ~= 7 then table.insert(zonesToScan, area + 9) end -- top right
		if areaRow ~= 0 then table.insert(zonesToScan, area - 7) end -- bottom right		
	end
	
	if areaRow ~= 7 then table.insert(zonesToScan, area + 8) end -- top
	if areaRow ~= 0 then table.insert(zonesToScan, area - 8) end -- bottom
	
	-- Search points in certain distances from the reference point	
	local goodNodes = {}
	for _, areas in pairs(zonesToScan) do
		for _, v in pairs(vehicleNodes[areas]) do
			if v.type == vehicle["nodelist"] then
				local newDistance = getDistanceBetweenPoints3D(compX, compY, compZ, v.x, v.y, v.z)
				local distance = getDistanceBetweenPoints3D(v.x, v.y, v.z, lastPoint.x, lastPoint.y, lastPoint.z)
				
				if (newDistance - oldDistance) >= minDistance --[[and distance <= maxDistance]] then
					table.insert(goodNodes, v)
				end
			end
		end
	end
	
	if #goodNodes == 0 then return false
	else
		-- Filter nodes by entering angle
		for i = #goodNodes, 1, -1 do
			local angle = findRotation(lastPoint.x, lastPoint.y, goodNodes[i].x, goodNodes[i].y)
			if lastAngle then
				-- last angle exists, compare
				local difference = math.abs(lastAngle - angle)
				
				if difference <= 200 and difference >= 160 then
					--table.remove(goodNodes, i)
				end
			end
		end
		
		-- Selecting points from good nodes list
		math.randomseed(getTickCount()*math.random(69)*420/69*os.clock())
		local selectedNode = math.random(#goodNodes)
		
		-- debug
		local angle = findRotation(lastPoint.x, lastPoint.y, goodNodes[selectedNode].x, goodNodes[selectedNode].y)
		if lastAngle then 
			local difference = math.abs(lastAngle - angle)
			--iprint("[Procedurally Generated Race]", lastAngle, angle, difference)
		end
				
		lastAngle = findRotation(lastPoint.x, lastPoint.y, goodNodes[selectedNode].x, goodNodes[selectedNode].y)
		
		-- Update Generator Parameters
		oldDistance = getDistanceBetweenPoints3D(compX, compY, compZ, goodNodes[selectedNode].x, goodNodes[selectedNode].y, goodNodes[selectedNode].z)
		
		-- Store coords in the race route
		local prevRoutePoint = {x = lastPoint.x, y = lastPoint.y, z = lastPoint.z}
		local calculatedRoute = getPath(goodNodes[selectedNode].x, goodNodes[selectedNode].y, goodNodes[selectedNode].z, lastPoint.x, lastPoint.y, lastPoint.z, getSetting("randomPath"))
		if not calculatedRoute then return -1 end
		
		for _, route in ipairs(calculatedRoute) do
			raceDistance = raceDistance + getDistanceBetweenPoints3D(prevRoutePoint.x, prevRoutePoint.y, prevRoutePoint.z, route.x, route.y, route.z)
			
			prevRoutePoint.x = route.x
			prevRoutePoint.y = route.y
			prevRoutePoint.z = route.z
			
			if raceDistance >= targetDistance then
				-- Target distance reached, termitate generation
				break
			else
				-- Continue to fill the route 
				table.insert(raceRoute, {x = route.x, y = route.y, z = route.z + 2})
				
				-- Maybe do a bend
				if bendsDone ~= race["bends"] then
					local bendPosition = targetDistance * (bendsDone + 1) / (race["bends"] + 1)
					
					-- Check if we in range of making a bend
					if raceDistance >= bendPosition - 10 and raceDistance <= bendPosition + 10 then
						if math.random(5) == 1 then -- 1/5 chance
							compX = goodNodes[selectedNode].x
							compY = goodNodes[selectedNode].y
							compZ = goodNodes[selectedNode].z
							
							--createBlip(compX, compY, compZ, 20)
							oldDistance = 0
							bendsDone = bendsDone + 1
						end
					end
				end
			end
		end
		
		-- Store last cp
		if vehicle["type"] ~= "Train" then lastPoint = {x = raceRoute[#raceRoute].x, y = raceRoute[#raceRoute].y, z = raceRoute[#raceRoute].z}
		else lastPoint = {x = goodNodes[selectedNode].x, y = goodNodes[selectedNode].y, z = goodNodes[selectedNode].z} end
	end
	
	return true
end

function postGeneration()
	-- Pickups
	race["pickups"] = {}
	for i = 1, math.floor(raceDistance / math.random(500, 1200)) + math.random(-2, 2) do
		local location = math.random(2, race["maxCP"] - 1)
		
		local line = Vector2(markers[location].x - markers[location-1].x, markers[location].y - markers[location-1].y)
		local multip = math.random(0, 100) / 100
		local node = findNodePosition((line.x * multip) + markers[location].x, (line.y * multip) + markers[location].y, 0)
		
		table.insert(race["pickups"], {
			type = math.random(2225, 2226), 
			x = node.x + math.random(-3, 3),
			y = node.y + math.random(-3, 3),
			z = node.z + 1.4
		})
	end
	
	-- Random objects test
	race["objects"] = {}
	for i = 1, math.floor(raceDistance / math.random(1200, 2500)) + math.random(-2, 2) do
		-- Select position for the object
		local location = math.random(2, race["maxCP"] - 1)
		local line = Vector2(markers[location].x - markers[location-1].x, markers[location].y - markers[location-1].y)
		local multip = math.random(0, 100) / 100
		local node = findNodePosition((line.x * multip) + markers[location].x, (line.y * multip) + markers[location].y, 0)
		
		-- Place the object from the props list
		local props = { 1244, 1225, 1370, 1676, 1686 }
		local id = math.random(#props)
		for a = 1, math.max(1, math.random(-2, 5)) do
			table.insert(race["objects"], {
				id = props[id],
				collisions = true,
				x = node.x + math.random(-3, 3),
				y = node.y + math.random(-3, 3),
				z = node.z + 0.6, 
				r = math.random(0, 360)
			})
		end
	end
	
	-- Jumps
	if vehicle["type"] ~= "Helicopter" and vehicle["type"] ~= "Plane" and vehicle["type"] ~= "Train" and race["markerType"] ~= "ring" and race["type"] ~= "jetpack" then
		local totalJumps = math.max(math.random(-1, 3), 0)
		if totalJumps > 0 then
			local usedCheckpoints = {}
			race["jumps"] = {}
			
			for jumpIndex = 1, totalJumps do
				-- Select checkpoint where would be a jump
				local checkpoint, routePoint, tries = nil, nil, 0
				local TRIES_THRESHOLD = 10
				repeat
					checkpoint = math.random(2, race["maxCP"])
					routePoint = math.floor(#raceRoute * checkpoint / race["maxCP"])
					
					-- Check if this checkpoint is not used
					local found = false
					for i, v in pairs(usedCheckpoints) do
						if v == checkpoint then 
							found = true
							break
						end
					end
					
					tries = tries + 1
					--if tries > TRIES_THRESHOLD then iprint("[Procedurally Generated Race]", "fuck") end
				until (not found and math.abs(markers[checkpoint].z - markers[checkpoint-1].z) < 2) or tries > TRIES_THRESHOLD
				
				if tries <= TRIES_THRESHOLD then
					
					-- Place the jump
					local jumpObjects = {3080, 1633, 1634, 1655}
					local waterJumpObjects = {1631, 1632, 1655}
					local selectedJump
					
					if vehicle["type"] == "Boat" or race["type"] == "on-water" then selectedJump = waterJumpObjects[math.random(#waterJumpObjects)]
					else selectedJump = jumpObjects[math.random(#jumpObjects)] end
					
					if math.random(2) == 1 then
						-- Jump with ring checkpoint
						race["jumps"][jumpIndex] = {
							id = selectedJump,
							x = markers[checkpoint].x, 
							y = markers[checkpoint].y,
							z = markers[checkpoint].z - 1.1,
							rz = findRotation(raceRoute[math.max(0, routePoint - 1)].x, raceRoute[math.max(0, routePoint - 1)].y, markers[checkpoint].x, markers[checkpoint].y),
						}
					
						-- Correct checkpoint position and set it as "ring"
						local jumpMatrix = Matrix(Vector3(race["jumps"][jumpIndex].x, race["jumps"][jumpIndex].y, race["jumps"][jumpIndex].z), Vector3(0, 0, race["jumps"][jumpIndex].rz))
						
						-- Move checkpoint
						markers[checkpoint].x = markers[checkpoint].x + jumpMatrix:getForward().x * 5.4
						markers[checkpoint].y = markers[checkpoint].y + jumpMatrix:getForward().y * 5.4
						markers[checkpoint].z = markers[checkpoint].z + 4
						markers[checkpoint].type = "ring"
						markers[checkpoint].size = 2.5
						markers[checkpoint].color = markers[checkpoint].color + 180
					else
						-- Jump with a pickup
						local line = Vector2(markers[checkpoint].x - markers[checkpoint-1].x, markers[checkpoint].y - markers[checkpoint-1].y)
						local multip = math.random(20, 80) / 100
						
						-- Define jump position
						local jumpPos
						if race["type"] == "on-water" or vehicle["type"] == "Boat" then
							-- Skip node search for boat and on-water races
							jumpPos = {
								x = (line.x * multip) + markers[checkpoint].x,
								y = (line.y * multip) + markers[checkpoint].y,
								z = markers[checkpoint].z
							}
						else
							local node = findNodePosition((line.x * multip) + markers[checkpoint].x, (line.y * multip) + markers[checkpoint].y, 0)
							jumpPos = {
								x = node.x,
								y = node.y,
								z = node.z + 2
							}
						end
						
						race["jumps"][jumpIndex] = {
							id = selectedJump,
							x = jumpPos.x, 
							y = jumpPos.y,
							z = jumpPos.z - 1.1,
							rz = findRotation(raceRoute[math.max(0, routePoint - 1)].x, raceRoute[math.max(0, routePoint - 1)].y, markers[checkpoint].x, markers[checkpoint].y),
						}
						
						local jumpMatrix = Matrix(Vector3(race["jumps"][jumpIndex].x, race["jumps"][jumpIndex].y, race["jumps"][jumpIndex].z), Vector3(0, 0, race["jumps"][jumpIndex].rz))
						
						table.insert(race["pickups"], {
							type = math.random(2225, 2226), 
							x = jumpPos.x + jumpMatrix:getForward().x * 5.2,
							y = jumpPos.y + jumpMatrix:getForward().y * 5.2,
							z = jumpPos.z + 4
						})
					end
					
					-- Store it, so the script doesn't used it again
					table.insert(usedCheckpoints, checkpoint)
				end
			end
		end
	end
	
	-- Increasing height of cps for air vehicles	
	if vehicle["type"] == "Helicopter" or vehicle["type"] == "Plane" or race["type"] == "jetpack" then
		vehicle["spawnZ"] = vehicle["spawnZ"] + math.random(15, math.max(15, maxVelocity / 2)) -- Initial height of a spawn
		local baseHeight = vehicle["spawnZ"] + math.random(-10, math.max(-10, (maxVelocity / 4)))
		
		for i = 1, race["maxCP"] do
			markers[i].z = markers[i].z + baseHeight + math.random(-15, 5)
		end
		
		for i, v in pairs(race["pickups"]) do
			race["pickups"][i].z = v.z + baseHeight + math.random(-5, 5)
		end
	end
	
	-- Standing plate for jetpack races
	if race["type"] == "jetpack" then
		table.insert(race["objects"], {
			id = 13646,
			collisions = true,
			x = vehicle["spawnX"],
			y = vehicle["spawnY"],
			z = vehicle["spawnZ"] - 1.5, 
			r = 0
		})
	end
	
	-- Boat race specific
	if vehicle["type"] == "Boat" or race["type"] == "on-water" then
		-- Buoys for boat races
		for i = 0, race["maxCP"] do
			local reference, nextReference
			-- Select first point
			if i == 0 then reference = {x = vehicle["spawnX"], y = vehicle["spawnY"]}
			else reference = {x = markers[i].x, y = markers[i].y} end
			
			-- Select second point
			if i == race["maxCP"] then nextReference = {x = markers[i-1].x, y = markers[i-1].y}
			else nextReference = {x = markers[i+1].x, y = markers[i+1].y} end
		
			local matrix = Matrix(Vector3(reference.x, reference.y, -2.5), Vector3(0, 0, findRotation(reference.x, reference.y, nextReference.x, nextReference.y)))
			local leftOffset, rightOffset = matrix:getRight() * vehicleRadius[vehicle["model"]-399] * 2.2, matrix:getRight() * vehicleRadius[vehicle["model"]-399] * (-2.2)
			
			table.insert(race["objects"], {
				id = 1243, 
				collisions = true,
				x = reference.x + leftOffset.x,
				y = reference.y + leftOffset.y,
				z = -2.5
			})
			
			table.insert(race["objects"], {
				id = 1243,
				collisions = true,
				x = reference.x + rightOffset.x,
				y = reference.y + rightOffset.y,
				z = -2.5
			})
		end
		
		-- Tropic bridge protection (c) 
		removeWorldModel(12812, 147.95247, 329.67969, -354.42187, 8.9375)
		removeWorldModel(12852, 172.82428, -26.46875, -554.82031, 2.42188)
		removeWorldModel(17281, 153.04022, -42.50781, -1476.8906, 4.3125)
		removeWorldModel(17002, 36.94622, 52.89063, -1532.0312, 7.74219)
		
		local bridge1 = createObject(12812, 329.67969, -354.42187, 8.9375) 
		local bridge2 = createObject(12852, -26.46875, -554.82031, 2.42188) 
		local bridge3 = createObject(17281, -42.50781, -1476.8906, 4.3125) 
		local bridge4 = createObject(17002, 52.89063, -1532.0312, 7.74219)
		
		setElementCollisionsEnabled(bridge1, false)
		setElementCollisionsEnabled(bridge2, false)
		setElementCollisionsEnabled(bridge3, false)
		setElementCollisionsEnabled(bridge4, false)
	end
	
	-- Start and Finish objects
	if vehicle["type"] ~= "Helicopter" and vehicle["type"] ~= "Plane" and vehicle["type"] ~= "Boat" and race["type"] ~= "jetpack" and race["type"] ~= "on-water" then
		local reference = {x = raceRoute[2].x, y = raceRoute[2].y}
		local forwardMult = 13
		
		-- Start object
		local startMatrix = Matrix(Vector3(0, 0, 0), Vector3(0, 0, findRotation(vehicle["spawnX"], vehicle["spawnY"], reference.x, reference.y)))
		local closestNode = findNodePosition(vehicle["spawnX"] + startMatrix:getForward().x * forwardMult, vehicle["spawnY"] + startMatrix:getForward().y * forwardMult, vehicle["spawnZ"])
		
		table.insert(race["objects"], {
			id = 18275,
			collisions = false,
			x = closestNode.x,
			y = closestNode.y,
			z = closestNode.z + 4.55,
			r = findRotation(vehicle["spawnX"], vehicle["spawnY"], reference.x, reference.y),
			scale = 2
		})
		
		-- Finish object
		local finishMatrix = Matrix(Vector3(0, 0, 0), Vector3(0, 0, findRotation(raceRoute[#raceRoute].x, raceRoute[#raceRoute].y, raceRoute[#raceRoute - 1].x, raceRoute[#raceRoute - 1].y)))
		closestNode = findNodePosition(markers[race["maxCP"]].x + finishMatrix:getForward().x * forwardMult, markers[race["maxCP"]].y + finishMatrix:getForward().y * forwardMult, markers[race["maxCP"]].z)
		
		table.insert(race["objects"], {
			id = 18275,
			collisions = false,
			x = closestNode.x,
			y = closestNode.y,
			z = closestNode.z + 4.55,
			r = findRotation(raceRoute[#raceRoute].x, raceRoute[#raceRoute].y, raceRoute[#raceRoute - 1].x, raceRoute[#raceRoute - 1].y),
			scale = 2
		})
		
		-- Party Lights :3
		local partyMatrix = Matrix(Vector3(closestNode.x, closestNode.y, closestNode.z + 4.55), Vector3(0, 0, findRotation(raceRoute[#raceRoute].x, raceRoute[#raceRoute].y, raceRoute[#raceRoute - 1].x, raceRoute[#raceRoute - 1].y)))
		table.insert(race["objects"], {
			id = 18102,
			x = closestNode.x + partyMatrix:getRight().x * 3.8 - partyMatrix:getForward().x * 2.0,
			y = closestNode.y + partyMatrix:getRight().y * 3.8 - partyMatrix:getForward().y * 2.0,
			z = partyMatrix:getPosition().z + 2.8,
			r = findRotation(raceRoute[#raceRoute].x, raceRoute[#raceRoute].y, raceRoute[#raceRoute - 1].x, raceRoute[#raceRoute - 1].y)
		})
	end
	
	-- Weather selection by the city
	local cityWeathers = {
		["Tierra Robada"] = {13, 14, 15},
		["Bone County"] = {17, 18, 19},
		["Las Venturas"] = {10, 11, 12},
		["San Fierro"] = {5, 6, 7, 8, 9},
		["Red County"] = {13, 14, 15, 16},
		["Whetstone"] = {13, 14, 15, 16},
		["Flint County"] = {13, 14, 15, 16},
		["Los Santos"] = {0, 1, 2, 3, 4},
		["Unknown"] = {19, 20, 21, 22}
	}

	local startZone = getZoneName(vehicle["spawnX"], vehicle["spawnY"], 0, true)
	local finishZone = getZoneName(markers[race["maxCP"]].x, markers[race["maxCP"]].y, markers[race["maxCP"]].z, true)
	environment["weather"] = cityWeathers[startZone][math.random(#cityWeathers[startZone])] or 0
	environment["nextweather"] = cityWeathers[finishZone][math.random(#cityWeathers[finishZone])] or 0
end

-- GENERATOR STUFF END --

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

function startSkipVote(playerSource, commandName)
	if voteEnabled and not skipEnabled and not votedPlayers[playerSource] then
		if not getElementData(playerSource, "race.finished") then
			votePlayer = playerSource
			votedPlayers[playerSource] = true
			local checkpointIsAttainable = false
			
			for _, players in ipairs(getElementsByType("player")) do 
				if getElementData(players, "race.checkpoint") ~= nil and getElementData(players, "race.checkpoint") ~= false and players ~= playerSource then
					if getElementData(players, "race.checkpoint") > getElementData(playerSource, "race.checkpoint") then
						checkpointIsAttainable = true
						break
					end
				end
			end
			
			if not checkpointIsAttainable then
				exports.votemanager:stopPoll {}
				poll = exports.votemanager:startPoll 
				{
					title = getPlayerName(playerSource):gsub("#%x%x%x%x%x%x", "").. " found unattainable checkpoint " ..getElementData(playerSource, "race.checkpoint").. ". Skip it?",
					percentage = 100,
					timeout = 15,
					allowchange = true,

					[1] = {"Yes", "pollFinished" , resourceRoot, 80},
					[2] = {"No", "pollFinished" , resourceRoot, 2},		
				}
				
				if not poll then applyPollResult(2) end
			else
				outputChatBox("Voteskip: that's not an unattainable checkpoint", playerSource)
			end
		end
	else
		if skipEnabled then outputChatBox("Voteskip: marker already skipped", playerSource)
		elseif votedPlayers[playerSource] then outputChatBox("Voteskip: you already voted once", playerSource)
		else outputChatBox("Voteskip: command disabled right now", playerSource) end
	end
end
addCommandHandler("voteskip", startSkipVote)

function startSaveVote(playerSource, commandName)
	if (savingEnabled and not savedPlayers[playerSource] and raceCreated and getPlayerCount() > VOTESAVE_MIN_PLAYERS - 1) or (playerSource == "OVERRIDE" and not mapSaved) then
		savePlayer = playerSource
		savedPlayers[playerSource] = true
		
		exports.votemanager:stopPoll {}
		poll = exports.votemanager:startPoll 
		{
			title = "Save this map?",
			percentage = 100,
			timeout = 15,
			allowchange = true,

			[1] = {"Yes", "pollFinished" , resourceRoot, 69},
			[2] = {"No", "pollFinished" , resourceRoot, 79},		
		}
		
		if not poll then applyPollResult(79) end
	else
		if votedPlayers[playerSource] then outputChatBox("Votesave: you already voted once", playerSource)
		elseif not raceCreated then outputChatBox("Votesave: map isn't generated yet", playerSource) end
	end
end
addCommandHandler("votesave", startSaveVote)

function forceRaceEnvironment()
	-- Fallback
	if not raceCreated then
		setTimer(forceRaceEnvironment, 1000, 1)
		return
	end
	
	-- Set Weather
	setTime(environment["hour"], environment["min"])
	setWeather(environment["weather"])
	setMoonSize(environment["Moon"])
	setHeatHaze(environment["heat"])
	
	-- Set next Weather
	setWeatherBlended(environment["nextweather"])
	
	if vehicle["type"] == "Boat" then
		setWaveHeight(environment["waveHeight"])
		setWaterColor(environment["waterColorR"], environment["waterColorG"], environment["waterColorB"], environment["waterColorA"])
	end
	
	if vehicle["type"] == "Plane" or vehicle["type"] == "Helicopter" then 
		setFarClipDistance(environment["clipDistance"])
		setWindVelocity(environment["wind"].x, environment["wind"].y, environment["wind"].z)
	end
	
	-- Create objects
	if race["objects"] and #race["objects"] > 0 then
		for _, object in pairs(race["objects"]) do
			local obj = createObject(object.id, object.x, object.y, object.z, 0, 0, object.r or 0)
			setElementCollisionsEnabled(obj, object.collisions == true or false)
			setObjectScale(obj, object.scale or 1)
		end
	end
	
	-- Autosaver
	if math.random(35) == 5 then
		setTimer(startSaveVote, math.random(59000, 130000), 1, "OVERRIDE", "votesave")
	end
end 

addEvent("onRaceStateChanging", true)
addEventHandler("onRaceStateChanging", getRootElement(), function(newState, oldState)
	if newState == "PreGridCountdown" then
		forceRaceEnvironment()
	elseif newState == "Running" then
		voteEnabled = true
		mapStarted = true
	elseif newState == "MidMapVote" or newState == "SomeoneWon" or newState == "NextMapVote"
		or newState == "TimesUp" or newState == "EveryoneFinished" or newState == "NextMapSelect" then
		voteEnabled = false
	end
end )

addEventHandler("onResourceStart", resourceRoot, function()
	-- Load Nodes File	
	local file = fileOpen("nodes.json", true)
	local contents = fileRead(file, fileGetSize(file))
	fileClose(file)
	local vehicleNodesTMP = fromJSON(contents)
	
	-- Convert
	for index, data in pairs(vehicleNodesTMP) do
		vehicleNodes[tonumber(index)] = {}
		for nodeIndex, nodeData in pairs(vehicleNodesTMP[index]) do
			local convertedNodeData = {}
			convertedNodeData.id = nodeData.id
			convertedNodeData.type = nodeData.type
			convertedNodeData.x = nodeData.x
			convertedNodeData.y = nodeData.y
			convertedNodeData.z = nodeData.z
			convertedNodeData.neighbours = {}
			
			for nodeDataIndex, nDist in pairs(nodeData.neighbours) do
				convertedNodeData.neighbours[tonumber(nodeDataIndex)] = nDist
			end
			
			vehicleNodes[tonumber(index)][tonumber(nodeIndex)] = convertedNodeData
		end
	end
	
	file = fileOpen("dictionary.json", true)
	local contents = fileRead(file, fileGetSize(file))
	fileClose(file)
	dictionary = fromJSON(contents)
	
	createRace()
end )

addEventHandler("onResourceStop", resourceRoot, function()
	restoreAllWorldModels()
end )

function forceRaceVehicle(player, reason)
	local playersVehicle = getPedOccupiedVehicle(player)
	if not playersVehicle then
		setTimer(forceRaceVehicle, 200, 1, player, reason)
	else
		-- Reset model
		if playersVehicle and getElementModel(playersVehicle) ~= vehicle["model"] then
			setElementModel(playersVehicle, vehicle["model"])
		end
		
		-- Hydraulics fix
		if playersVehicle and vehicle["hydraulics"] == 1 and reason and reason == "enter" then
			removeVehicleUpgrade(playersVehicle, 1087)
		end
	end
end 

-- Reset Player's Vehicle Model
addEvent("resetVehicleModel", true)
addEventHandler("resetVehicleModel", getRootElement(), function(reason)
	if not raceCreated then return end
	forceRaceVehicle(source, reason)
end )

addEvent("procOnPickupHit", true)
addEventHandler("procOnPickupHit", getRootElement(), function(type)
	if source then
		if type == 2225 then addVehicleUpgrade(source, 1010)
		elseif type == 2226 then fixVehicle(source) end
	end
end )

addEvent("onPlayerFinish", true)
addEventHandler("onPlayerFinish", getRootElement(), function(rank, time)
	if not DATABASE then return end
	if isGuestAccount(getPlayerAccount(source)) then return end
	if race["type"] == "" then race["type"] = "default" end
	if race["type"] == "randomizer" or race["type"] == "randomiser" then return end -- Don't save randomizer races
	
	local model, modelName
	if not vehicle["trailer"] then modelName = vehicle["name"]
	else modelName = vehicle["trailerName"] end
	
	if race["type"] == "jetpack" then modelName = "Jetpack" end
	
	-- Query
	dbExec(DATABASE, "CREATE TABLE IF NOT EXISTS vehicleRecords(accountname TEXT, playername TEXT, vehiclename TEXT, racetype TEXT, timestamp INTEGER, score INTEGER)")
	recordsResults = dbPoll(dbQuery(DATABASE, "SELECT score FROM vehicleRecords WHERE accountname = ? AND vehiclename = ? AND racetype = ?", getAccountName(getPlayerAccount(source)), modelName, race["type"]), -1)
	
	-- Updating Database
	local oldScore = 0 -- Used in messages
	if (recordsResults and #recordsResults > 0) then
		if (time < recordsResults[1]["score"]) then
			oldScore = recordsResults[1]["score"]
			dbExec(DATABASE, "UPDATE vehicleRecords SET score = ?, timestamp = ?, playername = ? WHERE accountname = ? AND vehiclename = ? AND racetype = ?", time, os.time(), getPlayerName(source), getAccountName(getPlayerAccount(source)), modelName, race["type"])
		end
	else dbExec(DATABASE, "INSERT INTO vehicleRecords(accountname, playername, vehiclename, racetype, timestamp, score) VALUES (?,?,?,?,?,?)", getAccountName(getPlayerAccount(source)), getPlayerName(source), modelName, race["type"], os.time(), time) end
	
	-- Sort and select player's name, timestamp and score		
	recordsResults = dbPoll(dbQuery(DATABASE, "SELECT accountname, score FROM vehicleRecords WHERE vehiclename = ? AND racetype = ? ORDER BY score ASC LIMIT 11", modelName, race["type"]), -1)
	
	-- Check for new top time (in range 1 - 11)
	local difference = oldScore - time
	for i, recordsData in pairs(recordsResults) do 
		if recordsData["accountname"] == getAccountName(getPlayerAccount(source)) and time == recordsData["score"] then
			if difference > 0 then
				outputChatBox("#00FF00[" ..modelName.. "] New top time #" ..i.. ": " ..getPlayerName(source).. "#00FF00, " ..convertToRaceTime(time).. " (-" ..convertToRaceTime(difference).. ")", root, 255, 255, 255, true)
			else outputChatBox("#00FF00[" ..modelName.. "] New top time #" ..i.. ": " ..getPlayerName(source).. "#00FF00, " ..convertToRaceTime(time), root, 255, 255, 255, true) end
			break
		end
	end
end )

-- Event called from client when player want to see stats, event returns data from database
addEvent("getStats", true)
addEventHandler("getStats", getRootElement(), function()
	if not DATABASE or not raceCreated then return end
	if race["type"] == "" then race["type"] = "default" end
	if race["type"] == "randomizer" or race["type"] == "randomiser" then return end -- Don't load randomizer races data
	
	local model, modelName
	if not vehicle["trailer"] then modelName = vehicle["name"]
	else modelName = vehicle["trailerName"] end
	
	if race["type"] == "jetpack" then modelName = "Jetpack" end
	
	-- Get first 11 records
	dbExec(DATABASE, "CREATE TABLE IF NOT EXISTS vehicleRecords(accountname TEXT, playername TEXT, vehiclename TEXT, racetype TEXT, timestamp INTEGER, score INTEGER)")
	recordsResults = dbPoll(dbQuery(DATABASE, "SELECT score, timestamp, playername FROM vehicleRecords WHERE vehiclename = ? AND racetype = ? ORDER BY score ASC LIMIT 11", modelName, race["type"]), -1)
	
	if not isGuestAccount(getPlayerAccount(source)) then
		-- Get player's record
		local playerRow = dbPoll(dbQuery(DATABASE, "SELECT ROWID FROM vehicleRecords WHERE accountname = ? AND vehiclename = ? AND racetype = ? ORDER BY score ASC", getAccountName(getPlayerAccount(source)), modelName, race["type"]), -1)
		if playerRow and #playerRow > 0 and playerRow[1]["ROWID"] and playerRow[1]["ROWID"] > 11 then 
			table.remove(recordsResults, 11)
			table.insert(recordsResults, 11, playerRow[1])
		end
	end
	
	triggerClientEvent(source, "receiveStats", source, recordsResults)
end )

addEvent("pollFinished", true)
addEventHandler("pollFinished", resourceRoot, function(pollResult)
	if pollResult == 80 then -- Yes
		markerToSkip = getElementData(votePlayer, "race.checkpoint")
		skipEnabled = true
	end
	
	if pollResult == 69 then saveMap() end -- saving yes
end )

addEventHandler("onPlayerVehicleEnter", root, function(vehicle, seat, jacked)
	if race["type"] == "jetpack" and vehicle and not getElementData(source, "race.finished") then
		setElementPosition(vehicle, 0, 0, math.random(35000, 69000))
		setElementFrozen(vehicle, true)
		
		removePedFromVehicle(source)
		setPedWearingJetpack(source, true)
		
		forceJetpack(source)
	end
end )

function forceJetpack(player)
	local checkpoint = getElementData(player, "race.checkpoint")
	if checkpoint then
		checkpoint = checkpoint - 1
		checkpoint = math.min(checkpoint, race["maxCP"])
		if checkpoint == 0 then setElementPosition(player, vehicle["spawnX"], vehicle["spawnY"], vehicle["spawnZ"])
		else setElementPosition(player, markers[checkpoint].x, markers[checkpoint].y, markers[checkpoint].z) end
	else
		setTimer(forceJetpack, 1000, 1, player)
	end
end 

function getAreaID(x, y)
	return math.floor((y + 3000) / 750) * 8 + math.floor((x + 3000) / 750)
end

function getNodeByID(nodeID)
	local areaID = math.floor(nodeID / 65536)
	if areaID <= 63 and areaID >= 0 then
		return vehicleNodes[areaID][nodeID]
	end
end

function findNodePosition(x, y, z)
	local startNode = -1
	local distance = 10000
	local areaID = getAreaID(x, y)
	for j, row in pairs(vehicleNodes[areaID]) do
		local distanceNodes = getDistanceBetweenPoints3D(x, y, z, row.x, row.y, row.z)
		if distance > distanceNodes then
			distance = distanceNodes
			startNode = row
		end
	end
	return startNode
end

function getPath(startX, startY, startZ, goalX, goalY, goalZ, forceRandom)
	local startNode = findNodePosition(startX, startY, startZ)
	local goalNode = findNodePosition(goalX, goalY, goalZ)
	
	local usedNodes = { [startNode.id] = true }
	local currentNodes = {}
	local ways = {}
	
	-- Initialization
	for id, distance in pairs(startNode.neighbours) do
		usedNodes[id] = true
		
		currentNodes[id] = distance
		ways[id] = { startNode.id }
	end
	
	while true do
		local bestNode = false
		local distance = 10000
	
		for currentId, currentDist in pairs(currentNodes) do
			if currentDist < distance or forceRandom then
				bestNode = currentId
				distance = currentDist
			end
			
			if forceRandom and math.random(3) == 1 then break end
		end
		
		if not bestNode then return false end -- Fallback
		
		if goalNode.id == bestNode then
			local zuMalen = bestNode
			local waypoints = {}
			
			while tonumber(zuMalen) do
				table.insert(waypoints, {
					x = getNodeByID(zuMalen).x,
					y = getNodeByID(zuMalen).y,
					z = getNodeByID(zuMalen).z
				})	
				zuMalen = ways[zuMalen]
			end
			
			return waypoints
		end
		
		for neighborID, neighborDist in pairs(getNodeByID(bestNode).neighbours) do
			if not usedNodes[neighborID] then
				ways[neighborID] = bestNode
				currentNodes[neighborID] = distance + neighborDist
				usedNodes[neighborID] = true
			end
		end
		
		currentNodes[bestNode] = nil
	end
end

--[[function getPath(startX, startY, startZ, goalX, goalY, goalZ)
	local startNode = findNodePosition(startX, startY, startZ)
	local goalNode = findNodePosition(goalX, goalY, goalZ)
	
	local usedNodes = {}
	usedNodes[startNode.id] = true
	
	local currentNodes = {}
	local ways = {}
	
	-- Initialization
	for id, distance in pairs(startNode.neighbours) do
		usedNodes[id] = true
		--routeUsedNodes[id] = true
		
		currentNodes[id] = distance
		ways[id] = { startNode.id }
	end
	
	while true do
		local bestNode = -1
		local distance = 10000
	
		for currentId, currentDist in pairs(currentNodes) do
			if currentDist < distance or #currentNodes == 1 then
				bestNode = currentId
				distance = currentDist
			end
		end
		
		if bestNode == -1 then iprint("[Procedurally Generated Race]", "no best node") end
		
		-- Fallback
		if bestNode == -1 then return false end
		if goalNode.id == bestNode then
			-- Last node found
			local zuMalen = bestNode
			local waypoints = {}
			local waypointID = 1
			
			while (tonumber(zuMalen) ~= nil) do
				local wayNode = getNodeByID(zuMalen)
				waypoints[waypointID] = wayNode
				waypointID = waypointID + 1		
				zuMalen = ways[zuMalen]
			end
			
			local wayTable = {}
			for i, wayNode in ipairs(waypoints) do
				wayTable[i] = {x = wayNode.x, y = wayNode.y, z = wayNode.z}
			end
			
			return wayTable
		end
		
		for neighborID, neighborDist in pairs(getNodeByID(bestNode).neighbours) do
			if not usedNodes[neighborID] and not routeUsedNodes[neighborID] then
				ways[neighborID] = bestNode
				currentNodes[neighborID] = distance + neighborDist
				usedNodes[neighborID] = true
				--routeUsedNodes[neighborID] = true
			end
		end
		
		currentNodes[bestNode] = nil
	end
end ]]--

function properlyAttachTrailer(truck, trailer)
	setElementVelocity(truck, 0, 0, 0)
	attachTrailerToVehicle(truck, trailer)
end

function findRotation(x1, y1, x2, y2)
    local t = -math.deg(math.atan2(x2 - x1, y2 - y1))
    return t < 0 and t + 360 or t
end

function hue2RGB(h)
	h = h / 360
	local r, g, b

	local i = math.floor(h * 6);
	local f = h * 6 - i;
	local q = 1 - f;

	i = i % 6

	if i == 0 then r, g, b = 1, f, 0
	elseif i == 1 then r, g, b = q, 1, 0
	elseif i == 2 then r, g, b = 0, 1, f
	elseif i == 3 then r, g, b = 0, q, 1
	elseif i == 4 then r, g, b = f, 0, 1
	elseif i == 5 then r, g, b = 1, 0, q
	end

	return r * 255, g * 255, b * 255
end

function string.first(str)
    return (str:gsub("^%l", string.upper))
end

function generateRaceName(pattern)
	-- Scan all dictionary for words
	local adjs = {}
	local nouns = {}
	local verbs = {}
	local adverbs = {}
	for word, data in pairs(dictionary) do
		if data.type == "adjective" then table.insert(adjs, string.first(word)) end
		if data.type == "noun" then table.insert(nouns, string.first(word)) end
		if data.type == "verb" then table.insert(verbs, string.first(word)) end
		if data.type == "adverb" then table.insert(adverbs, string.first(word)) end
	end
	
	local TOTAL_PATTERNS = 38
	if not pattern then 
		pattern = math.random(TOTAL_PATTERNS)
	end
	
	if pattern == 1 then
		-- Adj noun.
		return adjs[math.random(#adjs)].. " " ..nouns[math.random(#nouns)]
	elseif pattern == 2 then
		-- Random 4-digit number
		return tostring(math.random(1000, 8000))
	elseif pattern == 3 then
		-- Race of the year 2006
		return "Race of The Year " ..math.random(2004, 2040)
	elseif pattern == 4 then
		-- Adverb the noun
		return adverbs[math.random(#adverbs)].. " the " ..nouns[math.random(#nouns)]
	elseif pattern == 5 then
		-- Racing with PlayerName
		return "Racing with " ..getPlayerName(getRandomPlayer()):gsub("#%x%x%x%x%x%x", "")
	elseif pattern == 6 then
		-- Model verb noun
		return vehicle["name"].. " " ..verbs[math.random(#verbs)].. " " ..nouns[math.random(#nouns)]
	elseif pattern == 7 then
		-- The Model Club
		return "The " ..vehicle["name"].. " Club"
	elseif pattern == 8 then
		-- PlayerName's day at the Zone name
		return getPlayerName(getRandomPlayer()):gsub("#%x%x%x%x%x%x", "").. "'s day at the " ..getZoneName(markers[1].x, markers[1].y,  markers[1].z, false)
	elseif pattern == 9 then
		-- Adj vehicleType Race
		return adjs[math.random(#adjs)].. " " ..vehicle["type"].. " Race"
	elseif pattern == 10 then
		-- Model's adj noun (The classic from procedural race)
		return vehicle["name"].. "'s " ..adjs[math.random(#adjs)].. " " ..nouns[math.random(#nouns)]
	elseif pattern == 11 then
		-- Model challenge
		return vehicle["name"].. " Challenge"
	elseif pattern == 12 then
		-- Adj noun of adj noun
		return adjs[math.random(#adjs)].. " " ..nouns[math.random(#nouns)].. " of " ..adjs[math.random(#adjs)].. " " ..nouns[math.random(#nouns)]
	elseif pattern == 13 then
		-- A adj race in the City name
		return "A " ..adjs[math.random(#adjs)].. " Race in " ..getZoneName(markers[math.floor(race["maxCP"] / 2)].x, markers[math.floor(race["maxCP"] / 2)].y,  markers[math.floor(race["maxCP"] / 2)].z, true)
	elseif pattern == 14 then
		-- Verb adverb noun
		return verbs[math.random(#verbs)].. " " ..adverbs[math.random(#adverbs)].. " " ..nouns[math.random(#nouns)]
	elseif pattern == 15 then
		-- 2016 - adj noun
		return math.random(2004, 2030).. " - " ..adjs[math.random(#adjs)].. " " ..nouns[math.random(#nouns)]
	elseif pattern == 16 then
		-- Noun
		return nouns[math.random(#nouns)]
	elseif pattern == 17 then
		-- The Noun
		return "The " ..nouns[math.random(#nouns)]
	elseif pattern == 18 then
		-- Adj noun (LS, SF, LV)
		local zone, city = getZoneName(markers[1].x, markers[1].y,  markers[1].z, true), nil
		if zone == "Los Santos" then city = "LS"
		elseif zone == "San Fierro" then city = "SF"
		elseif zone == "Las Venturas" then city = "LV"
		else city = "OG" end
		
		return adjs[math.random(#adjs)].. " " ..nouns[math.random(#nouns)].. " " ..city
	elseif pattern == 19 then
		-- Model Race
		return vehicle["name"].. " Race"
	elseif pattern == 20 then
		-- Region To Region (city only)
		local startZone = getZoneName(markers[1].x, markers[1].y,  markers[1].z, true)
		local finishZone = getZoneName(markers[race["maxCP"]].x, markers[race["maxCP"]].y,  markers[race["maxCP"]].z, true)
		
		if startZone == finishZone then
			startZone = getZoneName(markers[1].x, markers[1].y,  markers[1].z, false)
			finishZone = getZoneName(markers[race["maxCP"]].x, markers[race["maxCP"]].y,  markers[race["maxCP"]].z, false)
		end
		
		return startZone.. " To " ..finishZone
	elseif pattern == 21 then
		-- Region To Region (every region)
		local startZone = getZoneName(markers[1].x, markers[1].y,  markers[1].z, false)
		local finishZone = getZoneName(markers[race["maxCP"]].x, markers[race["maxCP"]].y,  markers[race["maxCP"]].z, false)
		
		return startZone.. " To " ..finishZone
	elseif pattern == 22 then
		-- 555 We verb
		local n = math.random(9)
		return n.. "" ..n.. "" ..n.. " We " ..verbs[math.random(#verbs)]
	elseif pattern == 23 then
		-- Noun noun (same)
		local no = nouns[math.random(#nouns)]
		return no.. " " ..no
	elseif pattern == 24 then
		-- Adj model Race
		return adjs[math.random(#adjs)].. " " ..vehicle["name"].. " Race"
	elseif pattern == 25 then
		-- End of the noun
		return "End of the " ..nouns[math.random(#nouns)]
	elseif pattern == 26 then
		-- End of the model
		return "End of the " ..vehicle["name"]
	elseif pattern == 27 then
		-- Verb, My noun...
		return verbs[math.random(#verbs)].. ", My " ..nouns[math.random(#nouns)].. "..."
	elseif pattern == 28 then
		-- Verb, My model...
		return verbs[math.random(#verbs)].. ", My " ..vehicle["name"].. "..."
	elseif pattern == 29 then
		-- I verb noun
		return "I " ..verbs[math.random(#verbs)].. " " ..nouns[math.random(#nouns)]
	elseif pattern == 30 then
		-- Noun & Noun Race
		return nouns[math.random(#nouns)].. " & " ..nouns[math.random(#nouns)].. " Race"
	elseif pattern == 31 then
		-- Zone Part 20
		return getZoneName(markers[1].x, markers[1].y,  markers[1].z, false).. " Part " ..math.random(1, 69)
	elseif pattern == 32 then
		-- Racing for the noun
		return "Racing for the " ..nouns[math.random(#nouns)]
	elseif pattern == 33 then
		-- NC202169 - Model
		return "NC" ..math.random(2016, 2039).. "" ..math.random(22, 72).. " - " ..vehicle["name"]
	elseif pattern == 34 then
		-- My adj vehicletype
		return "My " ..adjs[math.random(#adjs)].. " " ..vehicle["type"]
	elseif pattern == 35 then
		-- verb!
		return verbs[math.random(#verbs)].. "!"
	elseif pattern == 36 then
		-- Make a noun - City
		return "Make a " ..nouns[math.random(#nouns)].. " - " ..getZoneName(markers[1].x, markers[1].y,  markers[1].z, true)
	elseif pattern == 37 then
		-- N.O.U.N.
		local noun
		repeat
			noun = nouns[math.random(#nouns)]
		until string.len(noun) > 3 and string.len(noun) < 7
		return noun:gsub("%a", function(s) return string.upper(s).. "." end)
	elseif pattern == 38 then
		-- Getting adverb in model
		return "Getting " ..adverbs[math.random(#adverbs)].. " With " ..vehicle["name"]
	end
end

function getSetting(key)
	if settings[vehicle["type"]] then
		return settings[vehicle["type"]][key]
	else return settings["default"][key] end
end
