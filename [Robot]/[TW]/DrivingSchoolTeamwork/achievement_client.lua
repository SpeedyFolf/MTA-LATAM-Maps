g_playerHelpLogs = {}

function checkAchievement()
	local team = getPlayerTeam(localPlayer)
	if not team then return end
	local teamMembers = getPlayersInTeam(team)
	if not teamMembers then return end
	local myV = getPedOccupiedVehicle(localPlayer)
	if not myV or getElementModel(myV) == 583 then
		return
	end
	for i, p in ipairs(teamMembers) do
		if p ~= localPlayer then
			local v = getPedOccupiedVehicle(p)
			if v and getElementModel(v) == 583 then
				local x, y, z = getElementPosition(v)
				-- dxDrawLine3D(x,y,z,x,y,z-1,tocolor(255,0,0))
				local hit, _, _, _, hitElement = processLineOfSight(x,y,z,x,y,z-1,
					false, -- world map items
					true, -- vehicles
					false, -- players
					false, -- objects, must be set true to detect dynamic objects
					false, -- dummies
					false, -- see through stuff
					false, -- ignore some objects for camera
					false, -- shoot through stuff
					v,   -- ignored element
					false,  -- include world model info, this is required to get the model ID
					false, -- car tyres
					false -- material info
				)
				if (hitElement == myV) then
					local vehicle = getElementModel(myV)
					local cp = getElementData(p, "race.checkpoint", true)
					local tag = i .. "_" .. vehicle
					if not ( g_playerHelpLogs[tag] and math.abs(g_playerHelpLogs[tag] - cp) < 2 ) then 
						g_playerHelpLogs[tag] = cp
						triggerServerEvent("achievement", localPlayer, "sssTWHelping")
					end
				end
			end
		end
	end
end
addEventHandler("onClientPreRender", root, checkAchievement)