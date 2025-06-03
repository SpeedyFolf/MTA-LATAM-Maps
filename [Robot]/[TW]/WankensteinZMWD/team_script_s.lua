-- set colors as: {RED, GREEN, BLUE}
-- example: {204, 0, 0} instead of nil

local MAX_TEAMS = 2

local TEAM_SETTINGS = {
	{	name = "Red FoXes", 	skin = math.random(312), 	vehicle = 415, 	color = {204, 0, 0}	},
	{	name = "Speed is King", 	skin = math.random(312), 	vehicle = 415, 	color = {0, 255, 0}	},
	{	name = "Destruction Derby All Stars", 	skin = math.random(312), 	vehicle = 415, 	color = {222, 180, 222}	},
	{	name = "Supreme Team of Fuckers", 	skin = math.random(312), 	vehicle = 415, 	color = {0, 255, 255}	},
	{	name = "Golden Mowers", 	skin = math.random(312), 	vehicle = 572, 	color = {150, 123, 35}	},
	{	name = "Holy Warriors", 	skin = math.random(312), 	vehicle = 415, 	color = {80, 178, 0}	},
	{	name = "Sofa King Cool", 	skin = math.random(312), 	vehicle = 415, 	color = {255, 136, 0}	},
	{	name = "Super 8", 	skin = math.random(312), 	vehicle = 415, 	color = {204, 85, 0}	},
	{	name = "HaHaXyu", 	skin = math.random(312), 	vehicle = 415, 	color = {255, 221, 0}	},
	{	name = "Firestarters Of The Land", 	skin = math.random(312), 	vehicle = 415, 	color = {115, 124, 161}	},
	{	name = "Die Kekse", 	skin = math.random(312), 	vehicle = 415, 	color = {255, 51, 0}	},
	{	name = "Gladiators of Darkness", 	skin = math.random(312), 	vehicle = 415, 	color = {162, 229, 222}	},
	{	name = "Serious Gaming", 	skin = math.random(312), 	vehicle = 415, 	color = {105, 105, 105}	},
	{	name = "Sixth Sense", 	skin = math.random(312), 	vehicle = 415, 	color = {175, 249, 159}	},
	{	name = "Road Markings", 	skin = math.random(312), 	vehicle = 415, 	color = {255, 255, 255}	},
	{	name = "meow", 	skin = math.random(312), 	vehicle = 415, 	color = {255, 25, 255}	},
	{	name = "banana", 	skin = math.random(312), 	vehicle = 415, 	color = {255, 255, 0}	},
	{	name = "San Andreas Masters", 	skin = math.random(312), 	vehicle = 415, 	color = {0, 171, 255}	},
	{	name = "Deep Dark Fantasy", 	skin = math.random(312), 	vehicle = 415, 	color = {0, 0, 0}	},
	{	name = "Mysterious X", 	skin = math.random(312), 	vehicle = 415, 	color = {102, 0, 51}	},
	{	name = "Skilled Gamer Alliance", 	skin = math.random(312), 	vehicle = 415, 	color = {0, 255, 255}	}
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
			if getElementModel(v) ~= t.skin and t.skin then
				setElementModel(v, t.skin)
			end

			-- Force team vehicle model
			if getPedOccupiedVehicle(v) then
				setVehicleColor(getPedOccupiedVehicle(v), t.color[1], t.color[2], t.color[3], t.color[1], t.color[2], t.color[3], t.color[1], t.color[2], t.color[3], t.color[1], t.color[2], t.color[3])
				if getElementModel(getPedOccupiedVehicle(v)) ~= t.vehicle and t.vehicle then
					setElementModel(getPedOccupiedVehicle(v), t.vehicle)
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
		local teamsPool = TEAM_SETTINGS

		for i = 1, MAX_TEAMS do
			-- Select random team from the pool
			local selectedTeam = math.random(#teamsPool)

			-- Create team
			local teamColor = teamsPool[selectedTeam].color or {hue2RGB(baseColor + (360 * i / MAX_TEAMS))}
			table.insert(team, i, {
				id = i,
				name = teamsPool[selectedTeam].name,
				team = createTeam(teamsPool[selectedTeam].name, teamColor[1], teamColor[2], teamColor[3]),
				color = teamColor,
				vehicle = teamsPool[selectedTeam].vehicle,
				skin = teamsPool[selectedTeam].skin
			})
			setTeamFriendlyFire(team[i].team, false)

			-- Delete team from the pool
			table.remove(teamsPool, selectedTeam)
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
	local totalTeams = MAX_TEAMS
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
		for _, v in ipairs(getAlivePlayers()) do
			setElementData(v, "race.finished", true)
		end

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
