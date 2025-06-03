function evaluateTeamCollisions(vehicle, oldValue, newValue)
	local players = getElementsByType("player")
	for i, p in ipairs(players) do
		if (getPedOccupiedVehicle(p)) then
			local teamMine = getPlayerTeam(localPlayer)
			local teamTheirs = getPlayerTeam(p)
			-- local vehicleMine = getPedOccupiedVehicle(localPlayer)
			local vehicleTheirs = getPedOccupiedVehicle(p)
			if (vehicleTheirs) then
				if (teamMine == teamTheirs) then
					setElementData(vehicleTheirs, "race.collideothers", 1, false)
					setElementAlpha(vehicleTheirs, 255)	
				else
					setElementData(vehicleTheirs, "race.collideothers", 0, false)
					setElementAlpha(vehicleTheirs, 120)
				end
			end
		end
	end
end
addEventHandler("onClientPreRender", root, evaluateTeamCollisions)