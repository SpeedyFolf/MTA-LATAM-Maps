local mowers = {}
local ringX, ringY, ringZ = 559.40997, -2148.3601, 80.66

function findRotation(x1, y1, x2, y2) 
    local t = -math.deg( math.atan2(x2 - x1, y2 - y1))
    return t < 0 and t + 360 or t
end

addEventHandler("onPlayerVehicleEnter", getRootElement(), function(vehicle, seat, jacked)
	if getElementModel(vehicle) == 516 then
		-- Hide the "race" vehicle
		setElementPosition(vehicle, 0, 0, math.random(0, 9999999))
		setElementFrozen(vehicle, true)
		removePedFromVehicle(source)
		
		-- Spawn player on the ring
		local spawnX, spawnY = math.sin(math.rad(math.random(0, 360))) * 20 + ringX, math.cos(math.rad(math.random(0, 360))) * 20 + ringY
		setElementPosition(source, spawnX, spawnY, 78.12)
		setElementRotation(source, 0, 0, findRotation(spawnX, spawnY, ringX, ringY), "default", true)
		
		local skins = {269, 311, 270, 271, 300, 301}
		setPedSkin(source, skins[math.random(#skins)])
		
		local weapons = {10, 11, 12, 13, 14, 15}
		giveWeapon(source, weapons[math.random(#weapons)], 1, true)
		
		-- Freeze player
		setElementFrozen(source, true)
		setTimer(function(player) 
			toggleAllControls(player, false)
			setPlayerHudComponentVisible(player, "radar", false)
		end, 300, 1, source)
	end
end )

addEvent("onRaceStateChanging", true)
addEventHandler("onRaceStateChanging", root, function(newState, oldState)
	if oldState == "GridCountdown" and newState == "Running" then
		-- Unfreeze players
		for _, player in ipairs(getAlivePlayers()) do
			setElementFrozen(player, false)
			toggleAllControls(player, true)
			setPedFightingStyle(player, 7)
		end
		
		setGlitchEnabled("fastsprint", true)
		
		-- Start the game
		triggerClientEvent(root, "setChangeNoteState", root, true)
		setTimer(spawnMowers, math.random(8, 20) * 1000, 1)
	end
end )

addEventHandler("onResourceStop", resourceRoot, function()
	setGlitchEnabled("fastsprint", false)
end )

function nextRound()
	-- Music
	triggerClientEvent(root, "setChangeNoteState", root, true)
	
	for _, player in ipairs(getAlivePlayers()) do
		if not getPedOccupiedVehicle(player) then
			-- Player not in the mower
			setElementHealth(player, 0)
		else
			-- Player was in the mower
			removePedFromVehicle(player)
			setCameraTarget(player, player)
			
			-- Respawn player in the ring
			local spawnX, spawnY = math.sin(math.rad(math.random(0, 360))) * math.random(10, 35) + ringX, math.cos(math.rad(math.random(0, 360))) * math.random(10, 35) + ringY
			setElementPosition(player, spawnX, spawnY, 78.12)
			setElementRotation(player, 0, 0, findRotation(spawnX, spawnY, ringX, ringY), "default", true)
		end
	end
	
	-- Destroy the mowers
	for _, mower in ipairs(mowers) do
		destroyElement(mower)
	end
	mowers = {}
	
	-- Start the next round
	setTimer(spawnMowers, math.random(8, 20) * 1000, 1)
end

function spawnMowers()
	-- Music
	triggerClientEvent(root, "setChangeNoteState", root, false)
	
	-- Decide how many mowers
	local MAX_MOWERS = #getAlivePlayers() - 1
	for i = 0, MAX_MOWERS - 1 do
		local mowerX, mowerY 
		repeat
			mowerX, mowerY = math.sin(math.rad(math.random(0, 360))) * math.random(50, 330) / 10 + ringX, math.cos(math.rad(math.random(0, 360))) * math.random(50, 330) / 10 + ringY
			local clear = true
			for _, m in ipairs(mowers) do
				local x, y, z = getElementPosition(m)
				if getDistanceBetweenPoints2D(x, y, mowerX, mowerY) < 2 then
					clear = false
					break
				end
			end
		until clear
			
		mowers[i + 1] = createVehicle(572, mowerX, mowerY, 77.76, 0, 0, findRotation(mowerX, mowerY, 559.40997, -2148.3601))
		setVehicleColor(mowers[i + 1], math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255))
	end
	
	setTimer(nextRound, math.random(12, 25) * 1000, 1)
end 