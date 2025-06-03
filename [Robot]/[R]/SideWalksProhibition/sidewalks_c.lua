local wait

addEventHandler("onClientRender", root, function()
	if getPedOccupiedVehicle(localPlayer) then
		local x1, y1, z1 = getVehicleComponentPosition(getPedOccupiedVehicle(localPlayer), "wheel_rf_dummy", "world")
		local x2, y2, z2 = getVehicleComponentPosition(getPedOccupiedVehicle(localPlayer), "wheel_lf_dummy", "world")
		local x3, y3, z3 = getVehicleComponentPosition(getPedOccupiedVehicle(localPlayer), "wheel_rb_dummy", "world")
		local x4, y4, z4 = getVehicleComponentPosition(getPedOccupiedVehicle(localPlayer), "wheel_lb_dummy", "world")
		
		local hit1, _, _, _, _, _, _, _, material1 = processLineOfSight(x1, y1, z1 + 1, x1, y1, -20, true, false, false, false, false)
		local hit2, _, _, _, _, _, _, _, material2 = processLineOfSight(x2, y2, z2 + 1, x2, y2, -20, true, false, false, false, false)
		local hit3, _, _, _, _, _, _, _, material3 = processLineOfSight(x3, y3, z3 + 1, x3, y3, -20, true, false, false, false, false)
		local hit4, _, _, _, _, _, _, _, material4 = processLineOfSight(x4, y4, z4 + 1, x4, y4, -20, true, false, false, false, false)
		
		if ((hit1 and material1 and material1 == 4) or (hit2 and material2 and material2 == 4) or (hit3 and material3 and material3 == 4) or (hit4 and material4 and material4 == 4)) and not isTimer(wait) then
			local event = math.random(5)
			wait = setTimer(function() end, 3000, 1)
			
			iprint("[Side Walks Prohibition]", event)
			if event == 1 then blowVehicle(getPedOccupiedVehicle(localPlayer))
			elseif event == 2 then 
				setElementVelocity(getPedOccupiedVehicle(localPlayer), 0, 0, 3)
				setElementAngularVelocity(getPedOccupiedVehicle(localPlayer), 0, 10, 0)
			elseif event == 3 then setElementHealth(getPedOccupiedVehicle(localPlayer), 0)
			elseif event == 4 then setElementHealth(localPlayer, 0)
			elseif event == 5 then setElementVelocity(getPedOccupiedVehicle(localPlayer), 0, 0, 10) end
			
			
		end
	end
end )