local availableWeapons = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 46, 43, 44, 45, 17, 39, 16, 18}
local specialWeapons = {41, 42, 37}
local spawnZone = {xMin = 21111, xMax = 21424, yMin = -29386, yMax = -29055}

function findRotation(x1, y1, x2, y2) 
    local t = -math.deg( math.atan2(x2 - x1, y2 - y1))
    return t < 0 and t + 360 or t
end

addEventHandler("onPlayerVehicleEnter", root, function(vehicle, seat, jacked)
	setElementPosition(vehicle, 0, 0, math.random(0, 9999999))
	setElementFrozen(vehicle, true)
	removePedFromVehicle(source)
	
	local x, y = math.random(spawnZone.xMin, spawnZone.xMax) / 10, math.random(spawnZone.yMin, spawnZone.yMax) / 10
	setElementPosition(source, x, y, 200.74001)
	setElementRotation(source, 0, 0, findRotation(x, y, 2125, -2923), "default", true)
	
	setPedStat(source, 21, math.random(0, 1000))
	setPedStat(source, 23, math.random(0, 1000))
	
	setElementFrozen(source, true)
	setTimer(function(player) 
		toggleAllControls(player, false)
		-- Hide Radar
		setPlayerHudComponentVisible(player, "radar", false)
		setPlayerHudComponentVisible(player, "weapon", true)
		setPlayerHudComponentVisible(player, "ammo", true)
	end, 300, 1, source)
end )

addEventHandler("onPickupUse", root, function(player)
	takeAllWeapons(player)
	setTimer(function(player, slot) setPedWeaponSlot(player, slot) end, 1, 1, player, getSlotFromWeapon(getPickupWeapon(source)))
end )

addEvent("onRaceStateChanging", true)
addEventHandler("onRaceStateChanging", root, function(newState, oldState)
	if oldState == "GridCountdown" and newState == "Running" then
		-- Unfreeze players
		for _, player in ipairs(getAlivePlayers()) do
			setElementFrozen(player, false)
			toggleAllControls(player, true)
			
			-- give random weapon
			if math.random(10) == 1 then
				-- Give special weapon
				giveWeapon(player, specialWeapons[math.random(#specialWeapons)], 200, true)
			else
				-- Give one piece
				giveWeapon(player, availableWeapons[math.random(#availableWeapons)], 1, true)
			end
			
			-- Random fighting style
			local styles = {4, 5, 6, 7, 15, 16}
			setPedFightingStyle(player, styles[math.random(#styles)])
		end
		
		-- Weapon spawner
		setTimer(function()
			if math.random(10) == 1 then 
				createPickup(math.random(spawnZone.xMin, spawnZone.xMax) / 10, math.random(spawnZone.yMin, spawnZone.yMax) / 10, 201.34, 2, specialWeapons[math.random(#specialWeapons)], 9999999999999, 300) 
			else
				createPickup(math.random(spawnZone.xMin, spawnZone.xMax) / 10, math.random(spawnZone.yMin, spawnZone.yMax) / 10, 201.34, 2, availableWeapons[math.random(#availableWeapons)], 9999999999999, 1) 
			end
		end, 4000, 0)
	end
end )