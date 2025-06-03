-- Screen stuff
screenX, screenY = guiGetScreenSize() --1600, 1200

DEBUG = false
if DEBUG then
	screenX = 1000
	screenY = 1000
end


-- Records
displayStats = false
statsInited = false
statsPage = 0
statsAlpha = 0
displayedRecords = {}
displayedOverview = {}
for j = 1, 41 do
	displayedOverview[j] = {}
	displayedOverview[j]["playername"] = ""
	displayedOverview[j]["vehicle"] = 0
	displayedOverview[j]["time"] = 0
	displayedRecords[j] = {}
	for i = 1, 11 do
		displayedRecords[j][i] = {}
		displayedRecords[j][i]["playername"] = ""
		displayedRecords[j][i]["time"] = 0
	end
end

-- Function that enables stats and requests data from the database
-- Called from key bind and finish of the race
function showStats()
	triggerServerEvent("getStats", getLocalPlayer())
	
	if statsPage == 0 then
		setStatsPage()
	end

	-- Toggle stats
	displayStats = not displayStats
end

-- Generating text message
local b = 1
local button = {}
for vehicleMouseLookKey, state in pairs(getBoundKeys("radio_user_track_skip")) do
	button[b] = vehicleMouseLookKey
	bindKey(vehicleMouseLookKey, "down", showStats)
	
	b = b + 1 
	if b > 4 then 
		b = 4
		break
	end
end 

b = b - 1
helpText = string.upper(button[1])
if b > 1 then
	for i = 2, b do
		helpText = helpText.. " #E7D9B0or #00FF00" ..string.upper(button[i])
	end
end

-- Function that draws stats on the screen
function drawStats()

end

-- Function that convers time in ms into string in format "MM:SS.MS"
function convertToRaceTime(time)
	if time ~= nil then
		local m = math.floor(time / 1000 / 60)
		local s = math.floor((time / 1000) - m*60)
		local ms = math.floor(time - (m*60+s)*1000)
		
		if m < 1 then m = ""
		else m = m.. ":" end
		if s < 10 then s = "0" ..s end
		if ms < 10 then ms = "00" ..ms
		elseif ms < 100 and ms > 9 then ms = "0" ..ms end
		
		return m.. "" ..s.. "." ..ms
	end
end

-- Onscreen stuff and seed generation
addEventHandler("onClientRender", getRootElement(), function()
	
	if DEBUG then
		dxDrawRectangle(0, 0, screenX, screenY, tocolor(255, 0, 255, 127, 50), true)
	end

	if displayStats then
		-- Fade In
		if statsAlpha < 255 then statsAlpha = statsAlpha + 51
		else statsAlpha = 255 end
	else
		-- Fade out
		if statsAlpha > 0 then statsAlpha = statsAlpha - 51
		else statsAlpha = 0 end
	end
	
	local shownAlpha = statsAlpha
	if statsAlpha > 200 then 
		shownAlpha = 200 
	end

	if not statsInited or not getPedOccupiedVehicle(localPlayer) or statsPage == 0 then return end

	-- Draw vehicle's name
	vehicleName, gtaName = getVehicleNamesFromStatsPage()

	-- More Stats
	dxDrawRectangle(screenY*0.02, screenY*0.02, screenY*0.65, screenY*0.96, tocolor(0, 33, 33, shownAlpha, 50), true)
	dxDrawText("Vehicle Records", screenX*0.024, screenY*0.02, screenX*0.41, screenY, tocolor(234, 40, 46, shownAlpha), screenY*0.0016, screenY*0.0016, "bankgothic", "left", "top", false, false, true)
	-- Draw records for each vehicle
	for i = 1, 41 do
		local indxDisp = i.."."
		local vhclDisp = CARS_TABLE[displayedOverview[i].vehicle]
		local avhcDisp = "("..CARMA2_TABLE[vhclDisp]..")"
		local timeDisp = convertToRaceTime(displayedOverview[i].time)
		local userDisp = "by " .. displayedOverview[i].playername
		-- 			text		X left			Y top						X right			Y bottom	color								font size X			font size Y			font face		align X		align Y	clip	break	postgui
		dxDrawText(	indxDisp, 	0, 				screenY*(0.04+0.0222*i), 	screenY*0.07, 	screenY, 	tocolor(0, 198, 28, statsAlpha), 	screenY*0.0008, 	screenY*0.0008, 	"bankgothic", 	"right", 	"top", 	false, 	false, 	true)
		dxDrawText(	vhclDisp, 	screenY*0.078, 	screenY*(0.04+0.0222*i), 	screenY, 		screenY, 	tocolor(0, 198, 28, statsAlpha), 	screenY*0.0008, 	screenY*0.0008, 	"bankgothic", 	"left", 	"top", 	false, 	false, 	true)
		dxDrawText(	avhcDisp, 	0, 				screenY*(0.055+0.0222*i), 	screenY*0.3, 	screenY, 	tocolor(0, 124, 18, statsAlpha), 	screenY*0.0005, 	screenY*0.0005, 	"bankgothic", 	"right", 	"top", 	false, 	false, 	true)
		dxDrawText(	timeDisp, 	0, 				screenY*(0.04+0.0222*i), 	screenY*0.425, 	screenY, 	tocolor(0, 198, 28, statsAlpha), 	screenY*0.0008, 	screenY*0.0008, 	"bankgothic", 	"right", 	"top", 	false, 	false, 	true)
		dxDrawText(	userDisp, 	screenY*0.433, 	screenY*(0.04+0.0222*i), 	screenY*0.67,	screenY, 	tocolor(0, 198, 28, statsAlpha), 	screenY*0.0008, 	screenY*0.0008, 	"bankgothic", 	"left", 	"top", 	true, 	false, 	true)
	end

	-- Draw Stats
	dxDrawRectangle(			screenY*0.68, 	screenY*0.52, 				screenY*0.45, 	screenY*0.383, tocolor(33, 73, 61, shownAlpha, 50), true)
	local arrowText = "◀ ▶"

	-- 			text			X left			Y top			X right										Y bottom	color								font size X			font size Y			font face		align X		align Y	clip	break	postgui
	dxDrawText("Records for", 	screenY*0.685, 	screenY*0.52, 	screenY, 									screenY, 	tocolor(0, 198, 28, shownAlpha), 	screenY*0.0012, 	screenY*0.0012, 	"bankgothic", 	"left", 	"top", 	false, 	false, 	true)
	dxDrawText(arrowText, 		0,			 	screenY*0.52, 	math.min(screenX*0.995, screenY*1.125), 	screenY, 	tocolor(0, 198, 28, shownAlpha), 	screenY*0.0012, 	screenY*0.0012, 	"bankgothic", 	"right", 	"top", 	false, 	false, 	true)
	dxDrawText(vehicleName, 	screenY*0.685, 	screenY*0.545, 	screenY, 									screenY, 	tocolor(234, 40, 46, shownAlpha), 	screenY*0.0015, 	screenY*0.0015, 	"bankgothic", 	"left", 	"top", 	false, 	false, 	true)
	dxDrawText(gtaName, 		screenY*0.688, 	screenY*0.5823, screenY, 									screenY, 	tocolor(234, 40, 46, shownAlpha), 	screenY*0.0006, 	screenY*0.0006, 	"bankgothic", 	"left", 	"top", 	false, 	false, 	true)
	
	-- Draw records for this vehicle
	for i = 1, 11 do
		local indxDisp = i.."."
		local nameDisp = tostring(displayedRecords[statsPage][i]["playername"]):gsub("#%x%x%x%x%x%x", "")
		local timeDisp = convertToRaceTime(displayedRecords[statsPage][i]["time"])
	-- 				text		X left			Y top						X right										Y bottom	color								font size X			font size Y			font face		align X		align Y	clip	break	postgui
		dxDrawText(	indxDisp, 	0, 				screenY*(0.568+0.028*i), 	screenY*0.727,								screenY, 	tocolor(0, 198, 28, statsAlpha), 	screenY*0.0008, 	screenY*0.0008, 	"bankgothic", 	"right", 	"top", 	false, 	false, 	true)
		dxDrawText(	nameDisp, 	screenY*0.733, 	screenY*(0.568+0.028*i), 	math.min(screenX*0.955, screenY*1.025),	screenY, 	tocolor(0, 198, 28, statsAlpha), 	screenY*0.0008, 	screenY*0.0008, 	"bankgothic", 	"left", 	"top", 	true, 	false, 	true)
		dxDrawText(	timeDisp, 	0, 				screenY*(0.568+0.028*i), 	math.min(screenX*1.055, screenY*1.125), 	screenY, 	tocolor(0, 198, 28, statsAlpha), 	screenY*0.0008, 	screenY*0.0008, 	"bankgothic", 	"right", 	"top", 	false, 	false, 	true)
	end
end )

-- Event called from the server script for receiving stats data
addEvent("receiveStats", true)
addEventHandler("receiveStats", getRootElement(), function(recordsStats, overviewStats)		
	-- Handle Vehicle Records
	for j = 1, 41 do
		for i, recordsData in pairs(recordsStats[j]) do 
			displayedRecords[j][i]["playername"] = recordsData["playername"]
			displayedRecords[j][i]["time"] = recordsData["score"]
		end
		
		if #recordsStats[j] < 11 then
			for i = #recordsStats[j] + 1, 11 do
				displayedRecords[j][i]["playername"] = "-- EMPTY --"
				displayedRecords[j][i]["time"] = 0
			end
		end
	end
	
	-- Handle Overview
	for j = 1, 41 do
		if j <= #overviewStats then
			displayedOverview[j].vehicle = overviewStats[j].vehicle
			displayedOverview[j].playername = overviewStats[j].playername
			displayedOverview[j].time = overviewStats[j].top_score	
		else
			displayedOverview[j].vehicle = 0
			displayedOverview[j].playername = "-- EMPTY --"
			displayedOverview[j].time = 0
		end
	end

	statsInited = true
end )

-- Event used to manage player inputs when stats displayed
addEventHandler("onClientKey", root, function(button, press) 
	if isChatBoxInputActive() then return end
	
	if press and displayStats then
		if button == "arrow_r" then
			if statsPage == 41 then statsPage = 1
			else statsPage = statsPage + 1 end
		elseif button == "arrow_l" then
			if statsPage == 1 then statsPage = 41
			else statsPage = statsPage - 1 end
		end
	end
end )

function getVehicleNamesFromStatsPage()
	local vehicleName = ""
	
	if statsPage == 0 then vehicleName = ""
	elseif statsPage == 1 then vehicleName = "Abba Cab"
	elseif statsPage == 2 then vehicleName = "Big Dump"
	elseif statsPage == 3 then vehicleName = "Blood Riviera"
	elseif statsPage == 4 then vehicleName = "Bugga"
	elseif statsPage == 5 then vehicleName = "Copcar"
	elseif statsPage == 6 then vehicleName = "Coupe de Grace"
	elseif statsPage == 7 then vehicleName = "Cow Poker"
	elseif statsPage == 8 then vehicleName = "DC Codbra"
	elseif statsPage == 9 then vehicleName = "Deathcruiser"
	elseif statsPage == 10 then vehicleName = "Degory'un 2"
	elseif statsPage == 11 then vehicleName = "Eagle 3"
	elseif statsPage == 12 then vehicleName = "Flower Power"
	elseif statsPage == 13 then vehicleName = "Forking Ada"
	elseif statsPage == 14 then vehicleName = "Hawk 3"
	elseif statsPage == 15 then vehicleName = "Hellrod"
	elseif statsPage == 16 then vehicleName = "Hick Pickup"
	elseif statsPage == 17 then vehicleName = "Jetcar"
	elseif statsPage == 18 then vehicleName = "Ladybug2"
	elseif statsPage == 19 then vehicleName = "Lamb O'Genie"
	elseif statsPage == 20 then vehicleName = "Loggerhead"
	elseif statsPage == 21 then vehicleName = "Mach 13"
	elseif statsPage == 22 then vehicleName = "Mad Morris"
	elseif statsPage == 23 then vehicleName = "Monster Beatle"
	elseif statsPage == 24 then vehicleName = "Piranha"
	elseif statsPage == 25 then vehicleName = "Porker 2"
	elseif statsPage == 26 then vehicleName = "Prop Shafter"
	elseif statsPage == 27 then vehicleName = "Purple Piledriver"
	elseif statsPage == 28 then vehicleName = "Razorback"
	elseif statsPage == 29 then vehicleName = "Screwie 2"
	elseif statsPage == 30 then vehicleName = "Semi Mk.2"
	elseif statsPage == 31 then vehicleName = "Slam Sedan"
	elseif statsPage == 32 then vehicleName = "Street Machine"
	elseif statsPage == 33 then vehicleName = "Tashita2"
	elseif statsPage == 34 then vehicleName = "The Bimmer"
	elseif statsPage == 35 then vehicleName = "The Buzzmobile"
	elseif statsPage == 36 then vehicleName = "The Harvester"
	elseif statsPage == 37 then vehicleName = "The Plow Mk.2"
	elseif statsPage == 38 then vehicleName = "The Red Vet"
	elseif statsPage == 39 then vehicleName = "The Supastuka"
	elseif statsPage == 40 then vehicleName = "Thunderbucket"
	elseif statsPage == 41 then vehicleName = "Vlad3"
	end
		
	local gtaName = ""
	if statsPage == 1 then gtaName = getVehicleNameFromModel(514)
	elseif statsPage == 2 then gtaName = getVehicleNameFromModel(406)
	elseif statsPage == 3 then gtaName = getVehicleNameFromModel(603)
	elseif statsPage == 4 then gtaName = getVehicleNameFromModel(434)
	elseif statsPage == 5 then gtaName = getVehicleNameFromModel(596)
	elseif statsPage == 6 then gtaName = getVehicleNameFromModel(458)
	elseif statsPage == 7 then gtaName = getVehicleNameFromModel(575)
	elseif statsPage == 8 then gtaName = getVehicleNameFromModel(533)
	elseif statsPage == 9 then gtaName = getVehicleNameFromModel(431)
	elseif statsPage == 10 then gtaName = getVehicleNameFromModel(475)
	elseif statsPage == 11 then gtaName = getVehicleNameFromModel(587)
	elseif statsPage == 12 then gtaName = getVehicleNameFromModel(483)
	elseif statsPage == 13 then gtaName = getVehicleNameFromModel(530)
	elseif statsPage == 14 then gtaName = getVehicleNameFromModel(451)
	elseif statsPage == 15 then gtaName = getVehicleNameFromModel(545)
	elseif statsPage == 16 then gtaName = getVehicleNameFromModel(554)
	elseif statsPage == 17 then gtaName = getVehicleNameFromModel(471)
	elseif statsPage == 18 then gtaName = getVehicleNameFromModel(580)
	elseif statsPage == 19 then gtaName = getVehicleNameFromModel(411)
	elseif statsPage == 20 then gtaName = getVehicleNameFromModel(525)
	elseif statsPage == 21 then gtaName = getVehicleNameFromModel(536)
	elseif statsPage == 22 then gtaName = getVehicleNameFromModel(500)
	elseif statsPage == 23 then gtaName = getVehicleNameFromModel(495)
	elseif statsPage == 24 then gtaName = getVehicleNameFromModel(572)
	elseif statsPage == 25 then gtaName = getVehicleNameFromModel(480)
	elseif statsPage == 26 then gtaName = getVehicleNameFromModel(439)
	elseif statsPage == 27 then gtaName = getVehicleNameFromModel(602)
	elseif statsPage == 28 then gtaName = getVehicleNameFromModel(568)
	elseif statsPage == 29 then gtaName = getVehicleNameFromModel(444)
	elseif statsPage == 30 then gtaName = getVehicleNameFromModel(515)
	elseif statsPage == 31 then gtaName = getVehicleNameFromModel(576)
	elseif statsPage == 32 then gtaName = getVehicleNameFromModel(535)
	elseif statsPage == 33 then gtaName = getVehicleNameFromModel(415)
	elseif statsPage == 34 then gtaName = getVehicleNameFromModel(542)
	elseif statsPage == 35 then gtaName = getVehicleNameFromModel(571)
	elseif statsPage == 36 then gtaName = getVehicleNameFromModel(532)
	elseif statsPage == 37 then gtaName = getVehicleNameFromModel(486)
	elseif statsPage == 38 then gtaName = getVehicleNameFromModel(504)
	elseif statsPage == 39 then gtaName = getVehicleNameFromModel(476)
	elseif statsPage == 40 then gtaName = getVehicleNameFromModel(549)
	elseif statsPage == 41 then gtaName = getVehicleNameFromModel(424)
	end
	local gtaName = "("..gtaName..")"

	return vehicleName, gtaName
end

function setStatsPage()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if not vehicle then 
		statsPage = 1 
		return
	end
	local vehicleModel = getElementModel(vehicle)
	if vehicleModel == 0 then statsPage = 1
	elseif vehicleModel == 514 then statsPage = 1
	elseif vehicleModel == 406 then statsPage = 2
	elseif vehicleModel == 603 then statsPage = 3
	elseif vehicleModel == 434 then statsPage = 4
	elseif vehicleModel == 596 then statsPage = 5
	elseif vehicleModel == 458 then statsPage = 6
	elseif vehicleModel == 575 then statsPage = 7
	elseif vehicleModel == 533 then statsPage = 8
	elseif vehicleModel == 431 then statsPage = 9
	elseif vehicleModel == 475 then statsPage = 10
	elseif vehicleModel == 587 then statsPage = 11
	elseif vehicleModel == 483 then statsPage = 12
	elseif vehicleModel == 530 then statsPage = 13
	elseif vehicleModel == 451 then statsPage = 14
	elseif vehicleModel == 545 then statsPage = 15
	elseif vehicleModel == 554 then statsPage = 16
	elseif vehicleModel == 471 then statsPage = 17
	elseif vehicleModel == 580 then statsPage = 18
	elseif vehicleModel == 411 then statsPage = 19
	elseif vehicleModel == 525 then statsPage = 20
	elseif vehicleModel == 536 then statsPage = 21
	elseif vehicleModel == 500 then statsPage = 22
	elseif vehicleModel == 495 then statsPage = 23
	elseif vehicleModel == 572 then statsPage = 24
	elseif vehicleModel == 480 then statsPage = 25
	elseif vehicleModel == 439 then statsPage = 26
	elseif vehicleModel == 602 then statsPage = 27
	elseif vehicleModel == 568 then statsPage = 28
	elseif vehicleModel == 444 then statsPage = 29
	elseif vehicleModel == 515 then statsPage = 30
	elseif vehicleModel == 576 then statsPage = 31
	elseif vehicleModel == 535 then statsPage = 32
	elseif vehicleModel == 415 then statsPage = 33
	elseif vehicleModel == 542 then statsPage = 34
	elseif vehicleModel == 571 then statsPage = 35
	elseif vehicleModel == 532 then statsPage = 36
	elseif vehicleModel == 486 then statsPage = 37
	elseif vehicleModel == 504 then statsPage = 38
	elseif vehicleModel == 476 then statsPage = 39
	elseif vehicleModel == 549 then statsPage = 40
	elseif vehicleModel == 424 then statsPage = 41
	else statsPage = 1
	end
end
addEventHandler("spawnFirstDodos", resourceRoot, setStatsPage)

CARS_TABLE = {
	[0] = "-- EMPTY --",
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

CARMA2_TABLE = {
	["-- EMPTY --"] = "",
	["Abba Cab"] = getVehicleNameFromModel(514),
	["Big Dump"] = getVehicleNameFromModel(406),
	["Blood Riviera"] = getVehicleNameFromModel(603),
	["Bugga"] = getVehicleNameFromModel(434),
	["Copcar"] = getVehicleNameFromModel(596),
	["Coupe de Grace"] = getVehicleNameFromModel(458),
	["Cow Poker"] = getVehicleNameFromModel(575),
	["DC Codbra"] = getVehicleNameFromModel(533),
	["Deathcruiser"] = getVehicleNameFromModel(431),
	["Degory'un 2"] = getVehicleNameFromModel(475),
	["Eagle 3"] = getVehicleNameFromModel(587),
	["Flower Power"] = getVehicleNameFromModel(483),
	["Forking Ada"] = getVehicleNameFromModel(530),
	["Hawk 3"] = getVehicleNameFromModel(451),
	["Hellrod"] = getVehicleNameFromModel(545),
	["Hick Pickup"] = getVehicleNameFromModel(554),
	["Jetcar"] = getVehicleNameFromModel(471),
	["Ladybug2"] = getVehicleNameFromModel(580),
	["Lamb O'Genie"] = getVehicleNameFromModel(411),
	["Loggerhead"] = getVehicleNameFromModel(525),
	["Mach 13"] = getVehicleNameFromModel(536),
	["Mad Morris"] = getVehicleNameFromModel(500),
	["Monster Beatle"] = getVehicleNameFromModel(495),
	["Piranha"] = getVehicleNameFromModel(572),
	["Porker 2"] = getVehicleNameFromModel(480),
	["Prop Shafter"] = getVehicleNameFromModel(439),
	["Purple Piledriver"] = getVehicleNameFromModel(602),
	["Razorback"] = getVehicleNameFromModel(568),
	["Screwie 2"] = getVehicleNameFromModel(444),
	["Semi Mk.2"] = getVehicleNameFromModel(515),
	["Slam Sedan"] = getVehicleNameFromModel(576),
	["Street Machine"] = getVehicleNameFromModel(535),
	["Tashita2"] = getVehicleNameFromModel(415),
	["The Bimmer"] = getVehicleNameFromModel(542),
	["The Buzzmobile"] = getVehicleNameFromModel(571),
	["The Harvester"] = getVehicleNameFromModel(532),
	["The Plow Mk.2"] = getVehicleNameFromModel(486),
	["The Red Vet"] = getVehicleNameFromModel(504),
	["The Supastuka"] = getVehicleNameFromModel(476),
	["Thunderbucket"] = getVehicleNameFromModel(549),
	["Vlad3"] = getVehicleNameFromModel(424),
}