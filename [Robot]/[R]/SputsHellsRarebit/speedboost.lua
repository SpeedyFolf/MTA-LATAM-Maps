addEvent ("onPlayerReachCheckpoint")
addEventHandler ("onPlayerReachCheckpoint", getRootElement(),
	function (cp, time)
		if cp == 1 then
			local vehicle = getPedOccupiedVehicle (source)
			local vx, vy, vz = getElementVelocity (vehicle)
			setElementVelocity (vehicle, vx, 1.7, vz)
			playSoundFrontEnd (source, 18)
		end

                if cp == 16 then
                	local vehicle = getPedOccupiedVehicle (source)
                	local vx, vy, vz = getElementVelocity (vehicle)
                	setElementVelocity (vehicle, vx, -1.8, vz)
                	playSoundFrontEnd (source, 18)
                end

		if cp == 20 then
			local vehicle = getPedOccupiedVehicle (source)
			local vx, vy, vz = getElementVelocity (vehicle)
			setElementVelocity (vehicle, vx * 1.9, vy * 1.9, vz)
			playSoundFrontEnd (source, 18)
		end

		if cp == 27 then
			local vehicle = getPedOccupiedVehicle (source)
			local vx, vy, vz = getElementVelocity (vehicle)
			setElementVelocity (vehicle, vx * 1.9, vy * 1.9, vz)
			playSoundFrontEnd (source, 18)
		end
	end
)