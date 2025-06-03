-- Finish sequence
local playerWeeds = {}
local finishPointer = 1

-- Timers
local weedStateTimer

-- Weed spawner
local weed = {} -- actual weed objects
local start = {x = -1018.9102, y = -923.47949, z = 128.22}

function raceEnd()
	-- Race end
	-- Count scores of the players
	for _, p in ipairs(getAlivePlayers()) do
		local weedH = getElementData(p, "weedHarvested")
		table.insert(playerWeeds, {player = p, score = weedH or 0})
	end
	
	-- Sort by highest score
	if #playerWeeds > 1 then
		table.sort(playerWeeds, function(a, b)
			if a.score < b.score then return false
			else return true end
		end )
	end
	
	for i, v in ipairs(playerWeeds) do
		iprint("[Save The Weed]", getPlayerName(v.player), v.score)
	end
	
	-- Start the finish sequence
	triggerClientEvent(playerWeeds[1].player, "finishTheWeed", playerWeeds[1].player)
end

addEvent("onPlayerFinish", true)
addEventHandler("onPlayerFinish", getRootElement(), function()
	finishPointer = finishPointer + 1
	if finishPointer <= #playerWeeds then
		triggerClientEvent(playerWeeds[finishPointer].player, "finishTheWeed", playerWeeds[finishPointer].player)
	end
end )

addEvent("onRaceStateChanging", true)
addEventHandler("onRaceStateChanging", getRootElement(), function(new, old)
	if new == "PreGridCountdown" then
		-- Spawn the weed
		local row = 0
		local col = 0
		for i = 1, 875 do
			weed[i] = createObject(3409, start.x - row * 4.8, start.y - col * 5.2, start.z)
			setElementData(weed[i], "ID", i)
			
			if i % 25 == 0 then 
				row = row + 1
				col = 0
			else col = col + 1 end
		end
	elseif old == "GridCountdown" and new == "Running" then
		-- Map starting
		weedStateTimer = setTimer(function()
			local number = 875
			for _, w in ipairs(weed) do
				if getElementHealth(w) == 0 then
					breakObject(w)
					number = number - 1
				end
			end
			
			-- Handle the fires
			local newFires = {
				{fireX = math.random(-11900, -10120) / 10, fireY = math.random(-10520, -9210) / 10},
				{fireX = math.random(-11900, -10120) / 10, fireY = math.random(-10520, -9210) / 10},
				{fireX = math.random(-11900, -10120) / 10, fireY = math.random(-10520, -9210) / 10}
			}
			
			-- Update the clients
			triggerClientEvent(root, "createWeedFire", root, newFires, number)
			
			-- Race is finished!
			if number == 0 then
				killTimer(weedStateTimer)
				raceEnd()
				return
			end
		end, 1000, 0)
	end
end )

-- Data from client
addEvent("updateBurnedWeed", true)
addEventHandler("updateBurnedWeed", getRootElement(), function(damagedWeed)
	for _, v in ipairs(damagedWeed) do
		if getElementHealth(weed[v]) ~= 0 then setElementHealth(weed[v], 0) end
	end
end )
