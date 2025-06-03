local TEAM_SETTINGS = {
	{	name = "Alpha", 	skin = math.random(255), 	vehicle = 602, 	color = nil	},
	{	name = "Omega", 	skin = math.random(255), 	vehicle = 603, 	color = nil	},
}

local team = {}
local team_color = {}

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

function forceColors()
	for _, t in pairs(team) do
		for _, v in ipairs(getPlayersInTeam(t.team)) do
			-- Force team skin
			if getElementModel(v) ~= TEAM_SETTINGS[t.id].skin then
				setElementModel(v, TEAM_SETTINGS[t.id].skin)
			end
			
			-- Force team vehicle model
			if getPedOccupiedVehicle(v) then
				setVehicleColor(getPedOccupiedVehicle(v), t.color[1], t.color[2], t.color[3], t.color[1], t.color[2], t.color[3], t.color[1], t.color[2], t.color[3], t.color[1], t.color[2], t.color[3])
				if getElementModel(getPedOccupiedVehicle(v)) ~= TEAM_SETTINGS[t.id].vehicle then
					setElementModel(getPedOccupiedVehicle(v), TEAM_SETTINGS[t.id].vehicle)
				end
			end
		end
	end
end

addEvent("onRaceStateChanging", true)
addEventHandler("onRaceStateChanging", root, function(new, old)
	if new == "PreGridCountdown" then
		-- Create teams
		local baseColor = math.random(360)
		for i, t in pairs(TEAM_SETTINGS) do
			local teamColor = TEAM_SETTINGS[i].color or {hue2RGB(baseColor + (360 * i / #TEAM_SETTINGS))}
			
			table.insert(team, i, {
				id = i,
				name = t.name,
				team = createTeam(t.name, teamColor[1], teamColor[2], teamColor[3]), 
				color = teamColor
			})
			
			setTeamFriendlyFire(team[i].team, false)
		end
		
		-- Randomize order
		local playerTable = getElementsByType("player")
		local shuffledTable = {}
		for i = 1, #playerTable do
			local rng = math.random(#playerTable)
			table.insert(shuffledTable, playerTable[rng])
			table.remove(playerTable, rng)
		end
		
		-- Put players in teams
		local index = 1
		for _, v in ipairs(shuffledTable) do
			setPlayerTeam(v, team[index].team)
			
			index = index + 1
			if index > #team then index = 1 end
		end
		
		setTimer(forceColors, 150, 0)
	elseif old == "PreGridCountdown" and new == "GridCountdown" then
		-- Check for players without the team
		for _, v in ipairs(getAlivePlayers()) do
			if not getPlayerTeam(v) then
				setPlayerTeam(v, team[math.random(#team)].team)
			end
		end
	end
end )

addEventHandler("onPlayerWasted", root, function()
	local totalTeams = #TEAM_SETTINGS
	for _, v in ipairs(team) do
		local currentMembers = 0
		for _, p in ipairs(getPlayersInTeam(v.team)) do
			if not isPedDead(p) then
				currentMembers = currentMembers + 1
			end
		end
		
		if currentMembers == 0 then 
			totalTeams = totalTeams - 1
		end
	end
	
	if totalTeams == 1 then
		-- Finish the map
		for _, v in ipairs(getAlivePlayers()) do setElementData(v, "race.finished", true) end
		
		exports["race"]:endMap()
		
		for _, v in ipairs(team) do
			for _, t in ipairs(getPlayersInTeam(v.team)) do
				if not isPedDead(t) then
					triggerClientEvent(root, "showWinMessage", root, "Team " ..v.name.. " Wins!", tocolor(v.color[1], v.color[2], v.color[3]))
					return
				end
			end
		end
	end
end )