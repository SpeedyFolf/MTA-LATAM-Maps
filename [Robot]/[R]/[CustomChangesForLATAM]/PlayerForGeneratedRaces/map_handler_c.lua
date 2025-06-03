local playerState = "not ready"
local DEBUG = false
setDevelopmentMode(DEBUG)
local lines = {}

-- Screen stuff
local screenX, screenY = guiGetScreenSize()
local screenAspect = math.floor((screenX / screenY)*10)/10

-- 16:9 screen ratio
if screenAspect >= 1.7 then 
	-- Stats box
	s_offsets = {0.25, 0.25, 0.5, 0.6} -- X-left, Y-top, width, height for a box
	st_offsets = {0.27, 0.20, 0.63, screenX/1745, screenY/1200} -- X-left, Y1, Y2, textsize
 -- 4:3 and others screens
else 
	-- Stats box
	s_offsets = {0.25, 0.25, 0.5, 0.6} -- X-left, Y-top, width, height for a box
	st_offsets = {0.27, 0.20, 0.63, screenX/1745, screenY/1200} -- X-left, Y1, Y2, textsize
end

-- Race Data
local environment = {}
local vehicle = {}
local race = {}
local clientMarkers = {}
local vehicleRadius = {3, 3.2, 3.2, 5.2, 3.2, 3.3, 6.6, 4.8, 5.9, 4.3, 2.8, 3.1, 3.9, 3.3, 3.9, 3, 4.4, 12, 3.3, 3.4, 3.3, 3.5, 3.1, 3.6, 2.4, 9.800000000000001, 3.2, 4.4, 3.7, 2.9, 6.5, 6.6, 5.1, 5.5, 2.6, 7.3, 3.1, 6.3, 3.3, 3, 3.2, 2, 3.7, 10.3, 3.8, 3.2, 6.7, 7.5, 1.3, 5.2, 7.1, 3, 5.9, 6, 8.300000000000001, 5.3, 5.1, 2, 3.4, 3.2, 8.9, 1.4, 1.3, 1.4, 1.2, 0.9, 3.4, 3.5, 1.3, 7.5, 3.2, 1.4, 4.5, 2.6, 3.3, 3.2, 8.1, 3.3, 3.2, 3.3, 2.9, 1.1, 3.3, 3.4, 9.9, 2.3, 4.6, 7.7, 6.5, 3.3, 3.9, 3.4, 3.4, 6.7, 3.5, 3.2, 2.7, 7.7, 4.1, 3.9, 2.9, 0.9, 3.3, 3.4, 3.3, 3.3, 2.9, 3.6, 4.5, 1.2, 1.1, 15, 6.5, 6.5, 5.5, 5.6, 3.4, 3.5, 3.3, 14.1, 8.6, 1.4, 1.4, 1.4, 5, 3.9, 2.9, 3.2, 3.2, 3.1, 2.6, 2.3, 7.3, 3, 3.3, 3.1, 3.5, 11, 8.199999999999999, 2.6, 3.4, 2.7, 3.5, 3.2, 6.7, 2.7, 3.3, 3.2, 12.7, 3.1, 3.3, 3.7, 4, 18.9, 3.5, 2.8, 3.8, 3.8, 2.9, 3, 3, 3.2, 2.9, 9.6, 0.9, 2.7, 3.5, 3.7, 2.7, 9.4, 10.6, 1.6, 1.7, 4.1, 2.4, 3.2, 3.4, 45.7, 6.3, 3.5, 3.3, 1.4, 3.9, 2.5, 8.199999999999999, 3.5, 1.5, 3.2, 5.5, 2.9, 9.6, 7.3, 36.4, 9.300000000000001, 0.5, 6.3, 3.2, 3.3, 3.2, 3.5, 3.3, 4.5, 3.1, 3.3, 3.4, 3.2, 2.4, 2.4, 4, 4.1, 1.5, 2.1 }

-- Race Elements
local marker = nil
local markerNext = nil
local markerBlip = nil
local markerNextBlip = nil
local markerCol = nil
local specCheckpoints = {}
local pickups = {}
local jumps = {}

-- States 
local dataReceived = false
local inited = false

-- Skips
local skipMarker = 60

-- Tab menu
local mapTexture = dxCreateTexture("map.jpg")
local showTab = false
local showTabInitialTimer

-- Vehicle's Specials
local firetruckPed = {} -- Firetruck LA

-- Skin names
local skinModelNames = { [0] = "CJ", "truth", "maccer", "cdeput", "sfpdm1", "bb", "wfycrp", "male01", "wmycd2", "bfori", "bfost", "vbfycrp", "bfyri", "bfyst", "bmori", "bmost", "bmyap", "bmybu", "bmybe", "bmydj", "bmyri", "bmycr", "bmyst", "wmybmx", "wbdyg1", "wbdyg2", "wmybp", "wmycon", "bmydrug", "wmydrug", "hmydrug", "dwfolc", "dwmolc1", "dwmolc2", "dwmylc1", "hmogar", "wmygol1", "wmygol2", "hfori", "hfost", "hfyri", "hfyst", "suzie", "hmori", "hmost", "hmybe", "hmyri", "hmycr", "hmyst", "omokung", "wmymech", "bmymoun", "wmymoun", "ofori", "ofost", "ofyri", "ofyst", "omori", "omost", "omyri", "omyst", "wmyplt", "wmopj", "bfypro", "hfypro", "vwmyap", "bmypol1", "bmypol2", "wmoprea", "sbfyst", "wmosci", "wmysgrd", "swmyhp1", "swmyhp2", "CJ", "swfopro", "wfystew", "swmotr1", "wmotr1", "bmotr1", "vbmybox", "vwmybox", "vhmyelv", "vbmyelv", "vimyelv", "vwfypro", "vhfyst", "vwfyst1", "wfori", "wfost", "wfyjg", "wfyri", "wfyro", "wfyst", "wmori", "wmost", "wmyjg", "wmylg", "wmyri", "wmyro", "wmycr", "wmyst", "ballas1", "ballas2", "ballas3", "fam1", "fam2", "fam3", "lsv1", "lsv2", "lsv3", "maffa", "maffb", "mafboss", "vla1", "vla2", "vla3", "triada", "triadb", "lvpdm1", "triboss", "dnb1", "dnb2", "dnb3", "vmaff1", "vmaff2", "vmaff3", "vmaff4", "dnmylc", "dnfolc1", "dnfolc2", "dnfylc", "dnmolc1", "dnmolc2", "sbmotr2", "swmotr2", "sbmytr3", "swmotr3", "wfybe", "bfybe", "hfybe", "sofybu", "sbmyst", "sbmycr", "bmycg", "wfycrk", "hmycm", "wmybu", "bfybu", "CJ", "wfybu", "dwfylc1", "wfypro", "wmyconb", "wmybe", "wmypizz", "bmobar", "cwfyhb", "cwmofr", "cwmohb1", "cwmohb2", "cwmyfr", "cwmyhb1", "bmyboun", "wmyboun", "wmomib", "bmymib", "wmybell", "bmochil", "sofyri", "somyst", "vwmybjd", "vwfycrp", "sfr1", "sfr2", "sfr3", "bmybar", "wmybar", "wfysex", "wmyammo", "bmytatt", "vwmycr", "vbmocd", "vbmycr", "vhmycr", "sbmyri", "somyri", "somybu", "swmyst", "wmyva", "copgrl3", "gungrl3", "mecgrl3", "nurgrl3", "crogrl3", "gangrl3", "cwfofr", "cwfohb", "cwfyfr1", "cwfyfr2", "cwmyhb2", "dwfylc2", "dwmylc2", "omykara", "wmykara", "wfyburg", "vwmycd", "vhfypro", "CJ", "omonood", "omoboat", "wfyclot", "vwmotr1", "vwmotr2", "vwfywai", "sbfori", "swfyri", "wmyclot", "sbfost", "sbfyri", "sbmocd", "sbmori", "sbmost", "shmycr", "sofori", "sofost", "sofyst", "somobu", "somori", "somost", "swmotr5", "swfori", "swfost", "swfyst", "swmocd", "swmori", "swmost", "shfypro", "sbfypro", "swmotr4", "swmyri", "smyst", "smyst2", "sfypro", "vbfyst2", "vbfypro", "vhfyst3", "bikera", "bikerb", "bmypimp", "swmycr", "wfylg", "wmyva2", "bmosec", "bikdrug", "wmych", "sbfystr", "swfystr", "heck1", "heck2", "bmycon", "wmycd1", "bmocd", "vwfywa2", "wmoice", "tenpen", "pulaski", "hern", "dwayne", "smoke", "sweet", "ryder", "forelli", "mediatr", "laemt1", "lvemt1", "sfemt1", "lafd1", "lvfd1", "sffd1", "lapd1", "sfpd1", "lvpd1", "csher", "lapdm1", "swat", "fbi", "army", "dsher", "somyap", "rose", "paul", "cesar", "ogloc", "wuzimu", "torino", "jizzy", "maddogg", "cat", "claude", "ryder2", "ryder3", "emmet", "andre", "kendl", "jethro", "zero", "tbone", "sindaco", "janitor", "bbthin", "smokev", "psycho" }

-- Records
local displayStats = false
local statsInited = false
local statsAlpha = 0
local displayedRecords = {}
for i = 1, 11 do
	displayedRecords[i] = {}
	displayedRecords[i]["playername"] = ""
	displayedRecords[i]["time"] = 0
end
local helpText = "F5"

addEventHandler("onClientResourceStart", resourceRoot, function()
	-- Pickups models
	engineImportTXD(engineLoadTXD('models/nitro.txd'), 2225)
	engineReplaceModel(engineLoadDFF('models/nitro.dff'), 2225)
	
	engineImportTXD(engineLoadTXD('models/repair.txd'), 2226)
	engineReplaceModel(engineLoadDFF('models/repair.dff'), 2226)
	
	-- Double draw distance for used models
	local usedModels = {2225, 2226, 1244, 1225, 1370, 1676, 1686, 12812, 12852, 17281, 17002}
	for _, model in pairs(usedModels) do
		engineSetModelLODDistance(model, 80)
	end
end )

-- Function checks spectate mode
function isLocalPlayerSpectating()
	local px, py, pz = getElementPosition(localPlayer)
	if getElementData(localPlayer, "state") == "spectating" or (pz > 1000 and race and race["type"] ~= "jetpack") then return true	
	else return false end
end

-- Recreate markers when player's gone back from spectate mode or died
function resetCheckpoints(reason)
	if DEBUG then iprint("[Player for Generated Races]", "Reset Checkpoints", reason) end
	if dataReceived then
		if isElement(marker) then destroyElement(marker) end
		if isElement(markerBlip) then destroyElement(markerBlip) end
		if isElement(markerCol) then destroyElement(markerCol) end
		if isElement(markerNext) then destroyElement(markerNext) end
		if isElement(markerNextBlip) then destroyElement(markerNextBlip) end
		
		-- Request vehicle model
		triggerServerEvent("resetVehicleModel", localPlayer, reason)
		
		function manageCheckpoints()
			-- Get current race checkpoint
			local checkpoint = getElementData(localPlayer, "race.checkpoint")
			if checkpoint and not getElementData(localPlayer, "race.finished") then
				-- Initial velocity for the planes at first checkpoint
				if checkpoint == 1 and vehicle["type"] == "Plane" then	
					if isTimer(planePushTimer) then killTimer(planePushTimer) end
					planePushTimer = setTimer(function() 
						if not isElementFrozen(getPedOccupiedVehicle(localPlayer)) then
							local matrix = getElementMatrix(getPedOccupiedVehicle(localPlayer))
							setElementVelocity(getPedOccupiedVehicle(localPlayer), matrix[2][1] * 5, matrix[2][2] * 5, matrix[2][3])
							killTimer(planePushTimer)
						end
					end, 50, 0)
				end
				
				if checkpoint == 1 then
					-- First spawn check
					if race["type"] ~= "jetpack" and getPedOccupiedVehicle(localPlayer) then
						setElementPosition(getPedOccupiedVehicle(localPlayer), vehicle["spawnX"], vehicle["spawnY"], vehicle["spawnZ"])
						setElementRotation(getPedOccupiedVehicle(localPlayer), 0.0, 0.0, vehicle["spawnRot"])
					elseif race["type"] == "jetpack" then
						setElementPosition(localPlayer, vehicle["spawnX"], vehicle["spawnY"], vehicle["spawnZ"])
						setElementRotation(localPlayer, 0.0, 0.0, vehicle["spawnRot"])
					end
					
					-- Adjust player's vehicle height to be on a ground
					if vehicle["type"] ~= "Plane" and vehicle["type"] ~= "Helicopter" and race["type"] ~= "jetpack" then
						local raycastFallback = 0
						function adjustZPosition()
							if not getPedOccupiedVehicle(localPlayer) or (getPedOccupiedVehicle(localPlayer) and getElementModel(getPedOccupiedVehicle(localPlayer)) ~= vehicle["model"]) then
								setTimer(adjustZPosition, 200, 1)
							else
								if vehicle["type"] ~= "Train" then
									local hit, hitX, hitY, hitZ = processLineOfSight(vehicle["spawnX"], vehicle["spawnY"], vehicle["spawnZ"] + 2.5, vehicle["spawnX"], vehicle["spawnY"], vehicle["spawnZ"] - 2.5, true, false, false, false, false, false, false, false, nil, true)
									local waterHit, waterX, waterY, waterZ = testLineAgainstWater(vehicle["spawnX"], vehicle["spawnY"], vehicle["spawnZ"] + 1, vehicle["spawnX"], vehicle["spawnY"], vehicle["spawnZ"] - 2)
									
									local newZ, rx = getElementDistanceFromCentreOfMassToBaseOfModel(getPedOccupiedVehicle(localPlayer)), 0
									if getVehicleType(getPedOccupiedVehicle(localPlayer)) == "Monster Truck" then newZ = newZ + 1 end
									
									if hit and hitX and hitY and hitZ then
										-- Store new position
										newZ = newZ + hitZ
										
										-- Calculate rotation (only X axis)
										local vehicleMatrix = Matrix(Vector3(vehicle["spawnX"], vehicle["spawnY"], newZ), Vector3(0, 0, vehicle["spawnRot"]))
										local radius = vehicleRadius[vehicle["model"] - 399]
										local vectorForward = vehicleMatrix:getForward() * radius * 0.8
										local vectorBack = -vehicleMatrix:getForward() * radius * 0.8
										
										local coordsForward = Vector3(vectorForward.x + vehicle["spawnX"], vectorForward.y + vehicle["spawnY"], newZ)
										local coordsBack = Vector3(vectorBack.x + vehicle["spawnX"], vectorBack.y + vehicle["spawnY"], newZ)
										
										local hitForward, _, _, hitFZ = processLineOfSight(coordsForward.x, coordsForward.y, coordsForward.z + 1, coordsForward.x, coordsForward.y, coordsForward.z - 3, true, false, false, false, false, false, false, false, nil, true)
										local hitBack, _, _, hitBZ = processLineOfSight(coordsBack.x, coordsBack.y, coordsBack.z + 1, coordsBack.x, coordsBack.y, coordsBack.z - 3, true, false, false, false, false, false, false, false, nil, true)
										
										if hitForward and hitBack and hitFZ and hitBZ then
											if hitFZ > hitBZ then
												rx = math.abs(math.deg(math.atan2(hitFZ - hitBZ, getDistanceBetweenPoints2D(coordsBack.x, coordsBack.y, coordsForward.x, coordsForward.y))))
											elseif hitBZ > hitFZ then
												rx = 360 - math.abs(math.deg(math.atan2(hitBZ - hitFZ, getDistanceBetweenPoints2D(coordsBack.x, coordsBack.y, coordsForward.x, coordsForward.y))))
											end
										end
									elseif not hit and waterHit then
										-- Water detection
										if race["type"] ~= "on-water" then newZ = waterZ + newZ - 1
										else newZ = waterZ + newZ end
										
										-- Special water race for Automobiles and Quad
										if vehicle["type"] ~= "Boat" then
											setWorldSpecialPropertyEnabled("hovercars", true)
										end
									else
										-- Special case, nothing been hit
										iprint("[Player for Generated Races]", "FUCK FUCK FUCK")
										raycastFallback = raycastFallback + 1
										if raycastFallback > 5 then
											-- Too many times tried to do the raycast
											newZ = vehicle["spawnZ"]
										else
											-- Try raycast again
											setTimer(adjustZPosition, 200, 1)
										end
									end
									
									setElementPosition(getPedOccupiedVehicle(localPlayer), vehicle["spawnX"], vehicle["spawnY"], newZ)
									setElementRotation(getPedOccupiedVehicle(localPlayer), rx, 0, vehicle["spawnRot"])
								else
									-- Train Insane speed bug-fix
									setTrainDerailed(getPedOccupiedVehicle(localPlayer), true)
									setElementVelocity(getPedOccupiedVehicle(localPlayer), 0, 0, 0)
									setTrainSpeed(getPedOccupiedVehicle(localPlayer), 0)
									
									setTimer(function()
										setTrainSpeed(getPedOccupiedVehicle(localPlayer), 0)
										setElementVelocity(getPedOccupiedVehicle(localPlayer), 0, 0, 0)
										setTrainDerailed(getPedOccupiedVehicle(localPlayer), false)
									end, 500, 1)
								end
							end
						end
						
						setTimer(adjustZPosition, 200, 1)
					else
						function forceFlyingCars()
							if not getPedOccupiedVehicle(localPlayer) or (getPedOccupiedVehicle(localPlayer) and getElementModel(getPedOccupiedVehicle(localPlayer)) ~= vehicle["model"]) then
								setTimer(forceFlyingCars, 200, 1)
							else 
								if getVehicleType(getPedOccupiedVehicle(localPlayer)) ~= vehicle["type"] then 
									setWorldSpecialPropertyEnabled("aircars", true) 
								end
							end
						end
						
						forceFlyingCars()
					end
					
					-- Update data in Race Progress Bar
					local checkpointData = {}
					for i = 1, race["maxCP"] do
						table.insert(checkpointData, i, {
							["id"] = i,
							["nextid"] = math.min(i + 1, race["maxCP"]),
							["position"] = {
								clientMarkers[i].x, 
								clientMarkers[i].y, 
								clientMarkers[i].z
							}
						})
					end
					exports.race_progress:getCustomDataFromRace({[1] = {["position"] = {vehicle["spawnX"], vehicle["spawnY"], vehicle["spawnZ"]}}}, checkpointData)
				end
				
				if checkpoint > race["maxCP"] then
					-- Finish the race
					checkpointHandler(60)
				elseif checkpoint == skipMarker and checkpoint <= race["maxCP"] then
					-- Player on checkpoint that should be skipped and he did not finished the race already
					checkpointHandler()
				else
					-- Create checkpoints
					createCheckpoint(checkpoint, "current")
					if checkpoint < race["maxCP"] then createCheckpoint(checkpoint, "next") end
				end
			elseif not checkpoint and not getElementData(localPlayer, "race.finished") then
				-- WTF
				setTimer(manageCheckpoints, 200, 1)
			end
		end 
		
		manageCheckpoints()
		
		-- Update race text
		-- if getElementData(localPlayer, "race.checkpoint") and race["maxCP"] then
			-- exports.race:setCheckpointText(math.min(race["maxCP"], (getElementData(localPlayer, "race.checkpoint") - 1)).. ' / ' .. race["maxCP"])
		-- end
	end
end

function createCheckpoint(checkpoint, c_type)
	if DEBUG then iprint("[Player for Generated Races]", "cp created", checkpoint, c_type) end
	
	for i = 1, #specCheckpoints do 
		if isElement(specCheckpoints[i]) then 
			destroyElement(specCheckpoints[i]) 
		end 
	end
		
	local blips = {
		["Automobile"] = {53, 19, 33},
		["Bike"] = 33,
		["BMX"] = {53, 25, 33},
		["Plane"] = 5,
		["Boat"] = 9,
		["Helicopter"] = {5, 53},
		["Train"] = {25, 33, 42, 53},
		["Trailer"] = {55, 51},
		["Monster Truck"] = {53, 19, 33, 37},
		["Quad"] = {53, 19, 33, 12},
		[486] = 11, -- Dozer
		[407] = 20, -- Firetruck
		[544] = 20, -- Firetruck LA
		[416] = 22, -- Ambulance
		[575] = {53, 19, 33, 23}, -- Broadway
		[448] = 29, -- Pizzaboy
		[427] = {30, 33}, -- Police cars begins
		[596] = {30, 33},
		[598] = {30, 33}, 
		[599] = {30, 33},
		[597] = {30, 33}, -- Police cars ends
		[523] = {30, 33}, -- Police bike
		[441] = {47, 53, 19}, -- RC Bandit
		[464] = {47, 5} -- Red baron
	}
	
	-- Select blip icon for the checkpoint
	local blipIcon, blipIndex = 0, nil
	if checkpoint == race["maxCP"] then
		-- Different CP's blip for final one
		if blips[vehicle["model"]] then blipIndex = vehicle["model"] 
		else blipIndex = vehicle["type"] end
		
		if type(blips[blipIndex]) == "table" then blipIcon = blips[blipIndex][math.random(#blips[blipIndex])]
		else blipIcon = blips[blipIndex] end
	end 

	-- Create next checkpoint
	if c_type == "current" then
		local cpColor = hue2RGB(clientMarkers[checkpoint].color)
		
		marker = createMarker(clientMarkers[checkpoint].x, clientMarkers[checkpoint].y, clientMarkers[checkpoint].z, clientMarkers[checkpoint].type, clientMarkers[checkpoint].size, cpColor.r, cpColor.g, cpColor.b, 200)
		markerBlip = createBlip(clientMarkers[checkpoint].x, clientMarkers[checkpoint].y, clientMarkers[checkpoint].z, blipIcon, 2, cpColor.r, cpColor.g, cpColor.b)
		
		-- Create colshape
		if clientMarkers[checkpoint].type == "ring" or clientMarkers[checkpoint].type == "corona" or clientMarkers[checkpoint].type == "arrow" then
			markerCol = createColSphere(clientMarkers[checkpoint].x, clientMarkers[checkpoint].y, clientMarkers[checkpoint].z, clientMarkers[checkpoint].size + 5)
		elseif clientMarkers[checkpoint].type == "checkpoint" then
			markerCol = createColCircle(clientMarkers[checkpoint].x, clientMarkers[checkpoint].y, clientMarkers[checkpoint].size + 10)
		end

		-- Set target
		if checkpoint ~= race["maxCP"] then 
			setMarkerTarget(marker, clientMarkers[checkpoint+1].x, clientMarkers[checkpoint+1].y, clientMarkers[checkpoint+1].z)
			setMarkerIcon(marker, "arrow")
		else 
			setMarkerTarget(marker, clientMarkers[checkpoint-1].x, clientMarkers[checkpoint-1].y, clientMarkers[checkpoint-1].z) 
			setMarkerIcon(marker, "finish")
		end
	elseif c_type == "next" then
		local cpColor = hue2RGB(clientMarkers[checkpoint+1].color)
		markerNext = createMarker(clientMarkers[checkpoint+1].x, clientMarkers[checkpoint+1].y, clientMarkers[checkpoint+1].z, clientMarkers[checkpoint+1].type, clientMarkers[checkpoint+1].size, cpColor.r, cpColor.g, cpColor.b, 128)
		markerNextBlip = createBlip(clientMarkers[checkpoint+1].x, clientMarkers[checkpoint+1].y, clientMarkers[checkpoint+1].z, blipIcon, 1, cpColor.r, cpColor.g, cpColor.b)
		
		if checkpoint + 2 <= race["maxCP"] and clientMarkers[checkpoint+1].type == "ring" then
			setMarkerTarget(markerNext, clientMarkers[checkpoint+2].x, clientMarkers[checkpoint+2].y, clientMarkers[checkpoint+2].z) 
		end
	end
end

function checkpointHandler(number)
	if not number then number = 1 end
	for i = 1, number do
		local colshapes = getElementsByType("colshape", getResourceDynamicElementRoot(getResourceFromName("race")))
		if (#colshapes == 0) then break end
		triggerEvent("onClientColShapeHit", colshapes[#colshapes], getPedOccupiedVehicle(localPlayer))
	end
end

-- Function that enables stats and requests data from the database
-- Called from key bind and finish of the race
function showStats()
	-- Request data for stats
	triggerServerEvent("getStats", localPlayer)
	
	-- Show stats
	displayStats = not displayStats
end

-- Function that draws stats on the screen
function drawStats()
	if not statsInited then return end
	
	local textShadow, sizeShadow = wordWrap(race["mapname"], screenX*s_offsets[3] * 0.9, st_offsets[5]*4.02)
	local textMain, sizeMain = wordWrap(race["mapname"], screenX*s_offsets[3] * 0.9, st_offsets[5]*4)
	
	local additionalOffset = (st_offsets[5]*4 - sizeMain) * 0.018
			
	dxDrawText(textShadow, screenX * (st_offsets[1] + sizeShadow / 800), screenY * (st_offsets[2] + additionalOffset), screenX, screenY, tocolor(0, 0, 0, statsAlpha), sizeShadow, sizeShadow, "beckett")
	dxDrawText(textMain, screenX * st_offsets[1], screenY * (st_offsets[2] + additionalOffset - sizeMain / 800), screenX * st_offsets[1], screenY, tocolor(175, 202, 230, statsAlpha), sizeMain, sizeMain, "beckett")
	
	local box_height = (screenY*s_offsets[4]) * 0.9
	local textSize = box_height / 75 / (12 / 2)
	local offset = box_height / 12

	-- Draw stats
	for i = 1, 11 do
		local color
		if displayedRecords[i]["playername"]:gsub("#%x%x%x%x%x%x", "") == getPlayerName(localPlayer):gsub("#%x%x%x%x%x%x", "") then
			color = tocolor(0, 200, 200, statsAlpha)
		else
			color = tocolor(175, 202, 230, statsAlpha)
		end
		
		if i == 11 and displayedRecords[11]["id"] ~= nil then
			dxDrawText(displayedRecords[11]["id"].. ".", screenX*st_offsets[1], screenY*(st_offsets[2]+0.07) + offset, screenX*st_offsets[1]*1.105, screenY, color, textSize, textSize, "bankgothic", "right")
		else
			dxDrawText(i.. ".", screenX*st_offsets[1], screenY*(st_offsets[2]+0.07) + offset, screenX*st_offsets[1]*1.105, screenY, color, textSize, textSize, "bankgothic", "right")
		end
		
		dxDrawText(tostring(displayedRecords[i]["playername"]):gsub("#%x%x%x%x%x%x", ""), screenX*(st_offsets[1]*1.12), screenY*(st_offsets[2]+0.07) + offset, screenX*st_offsets[1], screenY, color, textSize, textSize, "bankgothic")
		dxDrawText(convertToRaceTime(displayedRecords[i]["time"]), screenX*(st_offsets[1]+0.03), screenY*(st_offsets[2]+0.07) + offset, screenX*(st_offsets[1]+0.45), screenY, color, textSize, textSize, "bankgothic", "right")
		offset = offset + (box_height / 12)
	end
end

addEvent("setSkip", true)
addEventHandler("setSkip", getRootElement(), function(markerID)
	if getElementData(localPlayer, "race.checkpoint") == markerID then
		local colshapes = getElementsByType("colshape", getResourceDynamicElementRoot(getResourceFromName("race")))
		if #colshapes ~= 0 then
			triggerEvent("onClientColShapeHit", colshapes[#colshapes], getPedOccupiedVehicle(localPlayer))
		end
	end
	
	resetCheckpoints("skip")
	setElementData(localPlayer, "skipped", 1)
	skipMarker = markerID
end )

addEventHandler("onClientPreRender", root, function()
	-- Firetruck LA special
	for _, v in pairs(getElementsByType("vehicle")) do
		if v and getElementModel(v) == 544 then
			-- Vector Magic :3
			local posVector = Vector3(getElementPosition(v))
			local rotVector = Vector3(getElementRotation(v))
			local ladderVector = Vector3(getVehicleComponentRotation(v, "misc_b"))
			rotVector.z = rotVector.z + ladderVector.z
			local vectorBack = Matrix(posVector, rotVector):getForward() * (-7.7)
			
			-- Create Ladder Ped
			if not isElement(firetruckPed[v]) then
				firetruckPed[v] = createPed(math.random(0, 312), posVector.x, posVector.y, posVector.z)
				setElementCollisionsEnabled(firetruckPed[v], false)
				setPedAnimation(firetruckPed[v], "finale", "fin_hang_loop", -1)
			end
			
			-- Set ped's position (offsets doesn't work for some reason)
			setElementPosition(firetruckPed[v], posVector.x + vectorBack.x, posVector.y + vectorBack.y, posVector.z + vectorBack.z + 1.4, false)
			setElementRotation(firetruckPed[v], rotVector.x, rotVector.y, 360 - findRotation(posVector.x, posVector.y, posVector.x + vectorBack.x, posVector.x + vectorBack.y))
		end
	end
	
	-- Blind races
	if race["type"] == "blind" then dxDrawRectangle(0, 0, screenX, screenY, tocolor(0, 0, 0, 255)) end
end )
-- Onscreen stuff and seed generation
addEventHandler("onClientRender", getRootElement(), function()
	-- Player State Checks
	local newPlayerState = "not ready"
	
	if getElementData(localPlayer, "state") then
		newPlayerState = getElementData(localPlayer, "state")
		if isLocalPlayerSpectating() then newPlayerState = "spectating" end
	end
	
	if newPlayerState ~= playerState then -- Player race state changed
		--outputChatBox("new: " ..newPlayerState.. " old: " ..playerState)
		if playerState == "spectating" and newPlayerState == "alive" then resetCheckpoints("state") end
		
		if newPlayerState == "spectating" and dataReceived then
			--for i = 1, race["maxCP"] do
				--specCheckpoints[i] = createMarker(clientMarkers[i].x, clientMarkers[i].y, clientMarkers[i].z, clientMarkers[i].type, clientMarkers[i].size, race["cpColorR"], race["cpColorG"], race["cpColorB"], 200)
			--end
		end
		
		playerState = newPlayerState
		if isLocalPlayerSpectating() then playerState = "spectating" end
	end
	
	if not dataReceived and not checkFirstPosition then
		setElementData(localPlayer, "gotdata", 0)
		
		if not seed then 
			seed = true
			
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
			
			setElementData(localPlayer, "skipped", 0)
			--setTimer(function() outputChatBox("#E7D9B0You can #00FF00skip #E7D9B0unattainable checkpoint by command #00FF00/voteskip", 0, 0, 0, true) end, 90000, 1)
		end
	end
	
	if dataReceived then
		-- Alpha for tab
		if showTab and showTab < 255 and showTab > 0 then
			showTab = showTab - 10
			if showTab <= 0 then showTab = false end
		end
		
		if getKeyState("tab") or showTab then
			setPlayerHudComponentVisible("radar", false)
			
			local alphaCorrected = 200
			local alpha = 255
			if showTab then 
				alphaCorrected = math.max(0, showTab - 55) 
				alpha = math.max(0, showTab)
			end
			
			-- Map
			local centerX, centerY = screenX / 2, screenY / 2
			if screenAspect < 1.7 then centerX = screenX / 2 + screenX*0.12 end
			
			-- Bounds detection
			local maxX, maxY = -6000, -6000
			local minX, minY = 6000, 6000
			
			for i = 1, race["maxCP"] do
				maxX = math.max(clientMarkers[i].x , maxX)
				maxY = math.max(clientMarkers[i].y, maxY)
				
				minX = math.min(clientMarkers[i].x, minX)
				minY = math.min(clientMarkers[i].y, minY)
			end
			
			maxX = math.max(vehicle["spawnX"], maxX)
			maxY = math.max(vehicle["spawnY"], maxY)
			
			minX = math.min(vehicle["spawnX"], minX)
			minY = math.min(vehicle["spawnY"], minY)
			
			-- Keep aspect ratio
			local aspect = (maxX-minX)/(maxY-minY)
			if aspect > 3 then
				local add = (((maxX - minX) / 3) - (maxY-minY)) / 2
				
				if maxY + add > 3000 then minY = minY - add
				else maxY = maxY + add end
				
				if minY - add < -3000 then maxY = maxY + add
				else minY = minY - add end
			elseif aspect < 1 then
				local add = ((maxY-minY) - (maxX-minX)) / 2
				
				maxX = maxX + add
				minX = minX - add
			end
			
			local MAP_SIZE = 1562.5
			
			maxX = math.min(maxX + 100, 3000)
			minX = math.max(minX - 100, -3000)
			maxY = math.min(maxY + 100, 3000)
			minY = math.max(minY - 100, -3000)
	
			local u = MAP_SIZE + minX * (MAP_SIZE/3000)
			local v = MAP_SIZE - maxY * (MAP_SIZE/3000)
			
			local usize = (MAP_SIZE + maxX * (MAP_SIZE/3000)) - u
			local vsize = (MAP_SIZE - minY * (MAP_SIZE/3000)) - v
			
			local image_width = (usize / vsize) * (screenY*0.5 - screenY*0.25)
			local image_height = (screenY*0.5 - screenY*0.25)
			
			local box_width = (screenX*0.98 - screenX*0.7)
			if centerX/2 + image_width > screenX*0.05 + (screenX*0.98 - screenX*0.7) then
				box_width = (centerX/2 + image_width) - (screenX*0.05 + (screenX*0.98 - screenX*0.7)) + box_width + (screenX*0.06 - screenX*0.05)
			end
			
			dxDrawRectangle(screenX*0.05, screenY*0.6, box_width, (screenY*0.5 - screenY*0.2), tocolor(0, 0, 0, alphaCorrected, 50))
			dxDrawImageSection(centerX/2, screenY*0.62, image_width, image_height, u, v, usize, vsize, mapTexture, 0, 0, 0, tocolor(255, 255, 255, alpha))
			
			-- Draw CPs
			local startCP = getElementData(localPlayer, "race.checkpoint")
			if isLocalPlayerSpectating() or getElementData(localPlayer, "race.finished") or not startCP then startCP = 0 end
			for i = startCP, race["maxCP"] do
				local x, y, newX, newY
				local color = hue2RGB(clientMarkers[math.max(i, 1)].color)
				
				if i == 0 then 
					x = (vehicle["spawnX"] - minX) / ((maxX - minX) / image_width)
					y = (vehicle["spawnY"] - maxY) / ((minY - maxY) / image_height)
				else
					x = (clientMarkers[i].x - minX) / ((maxX - minX) / image_width)
					y = (clientMarkers[i].y - maxY) / ((minY - maxY) / image_height)
				end
				
				newX = (clientMarkers[math.min(i + 1, race["maxCP"])].x - minX) / ((maxX - minX) / image_width)
				newY = (clientMarkers[math.min(i + 1, race["maxCP"])].y - maxY) / ((minY - maxY) / image_height)
				
				if newX and newY then
					dxDrawLine(centerX/2 + newX, (screenY*0.62) + newY, centerX/2 + x, (screenY*0.62) + y, tocolor(color.r, color.g, color.b, alpha), 8)
				end
				
				dxDrawCircle(centerX/2 + x, (screenY*0.62) + y, 4, 0, 360, tocolor(color.r, color.g, color.b, alpha))
			end
			
			-- Player pos
			local px, py, pz
			if race["type"] == "jetpack" or not getPedOccupiedVehicle(localPlayer) then px, py, pz = getElementPosition(localPlayer)
			else px, py, pz = getElementPosition(getPedOccupiedVehicle(localPlayer)) end
			
			px = math.min(px, maxX)
			px = math.max(px, minX)
			py = math.min(py, maxY)
			py = math.max(py, minY)
					
			local x = (px - minX) / ((maxX - minX) / image_width)
			local y = (py - maxY) / ((minY - maxY) / image_height)
			
			local checkpoint, color = getElementData(localPlayer, "race.checkpoint"), hue2RGB(clientMarkers[1].color + 180)
			if checkpoint and not getElementData(localPlayer, "race.finished") then color = hue2RGB(clientMarkers[math.min(race["maxCP"], checkpoint)].color + 180) end
			dxDrawCircle(centerX/2 + x, (screenY*0.62) + y, 5, 0, 360, tocolor(color.r, color.g, color.b, alpha))
			
			-- Text data
			local data = {
				"Model: " ..vehicle["name"].. " (" ..vehicle["model"].. ")",
				"Type: " ..vehicle["type"],
				"Moon size: " ..environment["Moon"],
				"Checkpoint type: " ..race["markerType"],
				"Generated by: " ..(race["generator"]:gsub("#%x%x%x%x%x%x", "") or "Server"),
				"Checkpoints: " ..race["maxCP"].. " (" ..(race["raceDistance"] or 6969).. " m.)",
				"Ped: " ..race["pedID"].. " (" ..skinModelNames[race["pedID"]].. ")"
			}
			
			table.insert(data, "Date: " ..os.date(_, tostring(race["timestamp"]):sub(1, 10)))
			
			if vehicle["type"] == "Automobile" or vehicle["type"] == "Monster Truck" or vehicle["type"] == "Quad" and race["type"] ~= "jetpack" then
				local hydraulics = "false"
				if vehicle["hydraulics"] == 1 then hydraulics = "true" end
			
				table.insert(data, "Paintjob: " ..vehicle["paintjob"])
				table.insert(data, "Hydraulics: " ..hydraulics)
				
				if vehicle["nitros"] == 3 then table.insert(data, "Nitro: true") 
				else table.insert(data, "Nitro: false") end
			end
			
			if vehicle["type"] == "Train" then
				if vehicle["trainDerailable"] == 1 then table.insert(data, "Derailable: true")
				else table.insert(data, "Derailable: false") end
				
				if vehicle["trainDirection"] == 1 then table.insert(data, "Clockwise: false")
				else table.insert(data, "Clockwise: true") end
				
				if vehicle["trainCarts"] then table.insert(data, "Carts: " ..#vehicle["trainCarts"]) end
			end
			
			if vehicle["type"] == "Plane" or vehicle["type"] == "Helicopter" then
				table.insert(data, "Clip distance: " ..environment["clipDistance"])
			end
			
			if vehicle["type"] == "Boat" then
				table.insert(data, "Wave height: " ..string.format("%.1f", environment["waveHeight"]))
			end
			
			if vehicle["trailer"] ~= nil and vehicle["type"] ~= "Train" then
				table.insert(data, "Trailer: " ..tostring(vehicle["trailerName"]).. " (" ..tostring(vehicle["trailer"]).. ")")
				if vehicle["nitros"] == 3 then table.insert(data, "Nitro: true") 
				else table.insert(data, "Nitro: false") end
			end
			
			local box_height = (screenY*0.5 - screenY*0.2) * 0.9
			local textSize = box_height / 75 / (6)
			local offset = box_height / 12

			-- Draw data
			for i = 1, #data do		
				dxDrawText(data[i], screenX*0.06, screenY*0.62 + offset, screenX, screenY, tocolor(175, 202, 230, alphaCorrected), textSize, textSize, "bankgothic")
				offset = offset + (box_height / 12)
			end
			
			-- title
			local textShadow, sizeShadow = wordWrap(race["mapname"], box_width * 0.9, st_offsets[5]*2.5)
			local textMain, sizeMain = wordWrap(race["mapname"], box_width * 0.9, st_offsets[5]*2.5)
			
			local additionalOffset = (st_offsets[5]*2.5 - sizeMain) * 0.012
			
			dxDrawText(textShadow, screenX * 0.062, screenY * (0.57 + additionalOffset), screenX, screenY, tocolor(0, 0, 0, alpha), sizeShadow, sizeShadow, "beckett")
			dxDrawText(textMain, screenX * 0.06, screenY * (0.568 + additionalOffset), screenX, screenY, tocolor(175, 202, 230, alpha), sizeMain, sizeMain, "beckett")
		else setPlayerHudComponentVisible("radar", true) end
		
		-- Pickups rotation
		for i, v in pairs(pickups) do
			local x, y, z = getElementRotation(v.object)
			setElementRotation(v.object, x, y, z + 8)
		end
	end
	
	if not dataReceived and not isLocalPlayerSpectating() then
		dxDrawRectangle(0, 0, screenX, screenY, tocolor(0, 0, 0, 255))
		dxDrawText("Select the race", screenX / 2, screenY /2, screenX, screenY, tocolor(255, 255, 255, 255), 2, "default-bold")
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
	
	-- Draw Stats
	if getElementData(localPlayer, "gotdata") == 1 then
		if statsAlpha > 200 then
			dxDrawRectangle(screenX*s_offsets[1], screenY*s_offsets[2], screenX*s_offsets[3], screenY*s_offsets[4], tocolor(0, 0, 0, 200, 50))
		else
			dxDrawRectangle(screenX*s_offsets[1], screenY*s_offsets[2], screenX*s_offsets[3], screenY*s_offsets[4], tocolor(0, 0, 0, statsAlpha, 50))
		end
		drawStats()
	end
	
	-- DEBUG
	for _, line in pairs(lines) do
		dxDrawLine3D(line[1], line[2], line[3], line[4], line[5], line[6])
	end
	
	if isLocalPlayerSpectating() then
		if isElement(marker) then destroyElement(marker) end
		if isElement(markerNext) then destroyElement(markerNext) end
		if isElement(markerBlip) then destroyElement(markerBlip) end
		if isElement(markerNextBlip) then destroyElement(markerNextBlip) end
		if isElement(markerCol) then destroyElement(markerCol) end
		
		return 
	end
	
	if getPedOccupiedVehicle(localPlayer) then
		local x, y, z = getElementRotation(getPedOccupiedVehicle(localPlayer))
		local k, l = getVehicleTurretPosition(getPedOccupiedVehicle(localPlayer))
		
		if getElementModel(getPedOccupiedVehicle(localPlayer)) == 432 then
			setVehicleTurretPosition(getPedOccupiedVehicle(localPlayer), math.rad((getPedCameraRotation(localPlayer)*(-1) - z)-180), l)
		elseif getElementModel(getPedOccupiedVehicle(localPlayer)) == 524 then
			setVehicleAdjustableProperty(getPedOccupiedVehicle(localPlayer), 20000000000)
		else
			setVehicleTurretPosition(getPedOccupiedVehicle(localPlayer), math.rad(getPedCameraRotation(localPlayer)*(-1) - z), l)
		end
	end
end )

addEventHandler("onClientKey", root, function(button, press)
	if press and getPedOccupiedVehicle(localPlayer) and not isElementFrozen(getPedOccupiedVehicle(localPlayer)) and not isChatBoxInputActive() then
		for key, state in pairs(getBoundKeys("enter_exit")) do
			if key == button then
				setElementHealth(localPlayer, 0)
				break
			end
		end
	end
end )

-- No damage from explosions 
addEventHandler("onClientExplosion", root, function(x, y, z, theType)
	if theType == 2 or theType == 3 or theType == 10 and source ~= localPlayer then
		createExplosion(x, y, z, 1)
		cancelEvent()
	end
end )

-- No damage from weapons 
addEventHandler("onClientVehicleDamage", root, function(attacker, weapon)
	if source == getPedOccupiedVehicle(localPlayer) and (weapon == 37 or weapon == 31 or weapon == 38 or weapon == 28) then cancelEvent() end
end )

-- Event called from the server for client to process current race data
addEvent("recieveMarkers", true)
addEventHandler("recieveMarkers", localPlayer, function(data)
	--iprint("[Player for Generated Races]", "GOT DATA", #data)
	if getElementData(localPlayer, "gotdata") == 0 and data and #data > 0 then
		setElementData(localPlayer, "gotdata", 1)
		
		clientMarkers = data[1]
		vehicle = data[2]
		race = data[3]
		environment = data[4]
		dataReceived = true
		
		setWorldProperty("AmbientColor", environment["AmbientColor"][1], environment["AmbientColor"][2], environment["AmbientColor"][3])
		setWorldProperty("Illumination", environment["Illumination"])
		
		if race["type"] ~= "jetpack" and getPedOccupiedVehicle(localPlayer) then
			setElementPosition(getPedOccupiedVehicle(localPlayer), vehicle["spawnX"], vehicle["spawnY"], vehicle["spawnZ"])
			setElementRotation(getPedOccupiedVehicle(localPlayer), 0.0, 0.0, vehicle["spawnRot"])
		end
		
		-- Create pickups
		if race["pickups"] then
			for i, v in pairs(race["pickups"]) do
				table.insert(pickups, i, {
					object = createObject(v.type, v.x, v.y, v.z),
					colshape = createColSphere(v.x, v.y, v.z, 4.5),
					light = createMarker(v.x, v.y, v.z, "corona", 1.4, math.random(255), math.random(255), math.random(20), 70),
					type = v.type
				})
				
				setElementCollisionsEnabled(pickups[i].object, false)
			end
		end
		
		-- Create Jumps
		if race["jumps"] then
			for i, v in pairs(race["jumps"]) do
				table.insert(jumps, i, createObject(v.id, v.x, v.y, v.z, 0, 0, v.rz))
			end
		end
		
		resetCheckpoints("dataReceived")
		
		-- Messages
		local raceCustomText = ""
		if vehicle["trailer"] ~= nil and vehicle["type"] ~= "Train" then raceCustomText = " #E7D9B0with #00FF00" ..vehicle["trailerName"] end
		
		outputChatBox("#E7D9B0Today we are playing #00FF00" ..race["mapname"].. " #E7D9B0by #00FF00" ..race["generator"], 0, 0, 0, true)
		outputChatBox("#E7D9B0It's a#00FF00 " ..(race["type"] or "").. " #E7D9B0race with #00FF00" ..race["maxCP"].. " #E7D9B0checkpoints using #00FF00" ..vehicle["name"].. "" ..raceCustomText.. " #E7D9B0(#00FF00" ..(race["raceDistance"] or 0).. " #E7D9B0m.)", 0, 0, 0, true)
		outputChatBox("#E7D9B0You can get records for this map by pressing #00FF00" ..helpText, 0, 0, 0, true)
		outputChatBox("#E7D9B0Remember to #00FF00rate #E7D9B0saved maps using #00FF00/ratemap [0-10] #E7D9B0command", 0, 0, 0, true)
		
		-- Show Tab menu
		showTab = 255
		showTabInitialTimer = setTimer(function() showTab = 244 end, 6000, 1)
		
		-- Events
		setTimer(function()
			-- No double B glitch for you 
			addEventHandler("onClientVehicleEnter", getRootElement(), function(ped, seat)
				if ped == localPlayer and dataReceived and race then
					resetCheckpoints("enter") 
				end
			end )
		end, 2000, 1)
	end
end )

-- Event called from the server script for receiving stats data
addEvent("receiveStats", true)
addEventHandler("receiveStats", getRootElement(), function(recordsStats)	
	-- Handle Vehicle Records
	for i, recordsData in pairs(recordsStats) do 
		displayedRecords[i]["playername"] = recordsData["playername"]
		displayedRecords[i]["time"] = recordsData["score"]
		
		if i == 11 and recordsData["id"] ~= nil then
			displayedRecords[11]["id"] = recordsData["id"]
		end
	end
	
	if #recordsStats < 11 then
		for i = #recordsStats + 1, 11 do
			displayedRecords[i]["playername"] = "-- EMPTY --"
			displayedRecords[i]["time"] = 0
		end
	end
	
	statsInited = true
end )

-- Checkpoints handler
addEventHandler("onClientColShapeHit", root, function(element, dim)
	-- Increment player's race score
	if element == localPlayer and not isLocalPlayerSpectating() then
		if source == markerCol then
			checkpointHandler()
			resetCheckpoints("hit")
		end
	end
	
	-- Check pickups
	if getPedOccupiedVehicle(localPlayer) and element == getPedOccupiedVehicle(localPlayer) then
		for i, v in pairs(pickups) do
			if source == v.colshape then
				triggerServerEvent("procOnPickupHit", getPedOccupiedVehicle(localPlayer), v.type)
				playSoundFrontEnd(46)
				break
			end
		end
	end
end )

function findRotation(x1, y1, x2, y2)
    local t = -math.deg(math.atan2(x2 - x1, y2 - y1))
    return t < 0 and t + 360 or t
end

function hue2RGB(hue)
	if hue > 360 then hue = hue - 360 end
		
	hue = hue / 360
	local red, green, blue

	local i = math.floor(hue * 6);
	local f = hue * 6 - i;
	local q = 1 - f;

	i = i % 6

	if i == 0 then red, green, blue = 1, f, 0
	elseif i == 1 then red, green, blue = q, 1, 0
	elseif i == 2 then red, green, blue = 0, 1, f
	elseif i == 3 then red, green, blue = 0, q, 1
	elseif i == 4 then red, green, blue = f, 0, 1
	elseif i == 5 then red, green, blue = 1, 0, q
	end

	return { r = red * 255, g = green * 255, b = blue * 255 }
end

function wordWrap(text, maxwidth, size)
	local formattedText
	local textLine
	local linesCount = 1
	
	for i, v in pairs(split(text, " ")) do
		local testLine
		if not textLine then 
			testLine = v 
		else testLine = textLine.. " " ..v  end
		
		if dxGetTextWidth(testLine, size, "beckett", false) > maxwidth then
			if not formattedText then formattedText = textLine.. "\n" 
			else formattedText = formattedText.. "" ..textLine.. "\n" end
			textLine = v
			linesCount = linesCount + 1
		else
			if not textLine then textLine = v
			else textLine = textLine.. " " ..v end
		end
	end
	
	if not formattedText and textLine == nil then formattedText = text
	elseif not formattedText and textLine then formattedText = textLine
	elseif formattedText and textLine then formattedText = formattedText.. "" ..textLine end
	
	if linesCount > 1 then
		return wordWrap(text, maxwidth, size * 0.9)
	end 
	
	return formattedText, size
end
