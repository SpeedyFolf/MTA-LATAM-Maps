-- Screen stuff
local screenX, screenY = guiGetScreenSize()
local s_offsets = {0.25, 0.25, 0.5, 0.6} -- X-left, Y-top, width, height for a box
local st_offsets = {0.27, 0.20, 0.45} -- X-left, Y1, Y2, textsize

-- Records
local displayStats = false
local statsInited = false
local statsAlpha = 0
local statsPage = 0
local displayedRecords = {}

-- Function that enables stats and requests data from the database
-- Called from key bind and finish of the race
function showStats()
	triggerServerEvent("getStats", getLocalPlayer())
	
	-- Toggle stats
	displayStats = not displayStats
end
bindKey("F5", "down", showStats)

-- Function that draws stats on the screen
function drawStats()
	if not statsInited or not getPedOccupiedVehicle(localPlayer) then return end

	-- Draw vehicle's name
	dxDrawText("Competition Race", screenX*(st_offsets[1]+0.005), screenY*(st_offsets[2]-0.01+0.003), screenX, screenY, tocolor(0, 0, 0, statsAlpha), (screenY/1080)*4.02, (screenY/1080)*4.15, "beckett")
	dxDrawText("Competition Race", screenX*st_offsets[1], screenY*(st_offsets[2]-0.01), screenX*st_offsets[1], screenY, tocolor(175, 202, 230, statsAlpha), (screenY/1080)*4, (screenY/1080)*4, "beckett")

	local box_height = screenY*s_offsets[4] * 0.9
	local textSize = box_height / 75 / 13
	local offset = box_height / 34

	-- Draw records
	for i, v in ipairs(displayedRecords) do
		if i >= statsPage * 33 and i < (statsPage + 1) * 33 then
			dxDrawText(i.. ".", screenX*st_offsets[1], screenY*0.27 + offset, screenX*st_offsets[1]*1.105, screenY, tocolor(175, 202, 230, statsAlpha), textSize, textSize, "bankgothic", "right")
			dxDrawText(tostring(v.name), screenX*(st_offsets[1]*1.12), screenY*0.27 + offset, screenX*st_offsets[1], screenY, tocolor(175, 202, 230, statsAlpha), textSize, textSize, "bankgothic")
			dxDrawText(tostring(v.wins), screenX*(st_offsets[1]*2.2), screenY*0.27 + offset, screenX*st_offsets[1], screenY, tocolor(175, 202, 230, statsAlpha), textSize, textSize, "bankgothic")
			dxDrawText(convertToRaceTime(v.score), screenX*(st_offsets[1]+0.04), screenY*0.27 + offset, screenX*(st_offsets[1]+st_offsets[3]), screenY, tocolor(175, 202, 230, statsAlpha), textSize, textSize, "bankgothic", "right")
			
			offset = offset + box_height / 34
		end
	end
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
	if statsAlpha > 200 then dxDrawRectangle(screenX*s_offsets[1], screenY*s_offsets[2], screenX*s_offsets[3], screenY*s_offsets[4], tocolor(0, 0, 0, 200, 50))
	else dxDrawRectangle(screenX*s_offsets[1], screenY*s_offsets[2], screenX*s_offsets[3], screenY*s_offsets[4], tocolor(0, 0, 0, statsAlpha, 50)) end
	drawStats()
end )

-- Event called from the server script for receiving stats data
addEvent("receiveStats", true)
addEventHandler("receiveStats", getRootElement(), function(recordsStats)		
	-- Handle Vehicle Records
	displayedRecords = {}
	for _, d in pairs(recordsStats) do
		d["data"] = fromJSON(d["data"])
		table.insert(displayedRecords, {name = getVehicleNameFromModel(d.base).. " VS " ..getVehicleNameFromModel(d.competition), wins = d["data"].base.. ":" ..d["data"].competition, score = d.score})
	end
	
	statsInited = true
end )

-- Event used to manage player inputs when stats displayed
addEventHandler("onClientKey", root, function(button, press) 
	if isChatBoxInputActive() then return end
	
	if press and displayStats then
		if button == "arrow_r" then
			if statsPage == math.floor(#displayedRecords / 33) then statsPage = 0
			else statsPage = statsPage + 1 end
		elseif button == "arrow_l" then
			if statsPage == 0 then statsPage = math.floor(#displayedRecords / 33)
			else statsPage = statsPage - 1 end
		end
	end
end )