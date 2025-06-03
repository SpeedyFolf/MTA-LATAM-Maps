addEvent("onPlayerReachCheckpoint")
addEventHandler("onPlayerReachCheckpoint", root,
function (checkpoint)
	local vehicle = getPedOccupiedVehicle(source)
	if checkpoint == 45 then
		setElementVelocity(vehicle, 0, 0, 0)
		setElementPosition(vehicle, 1136, -1586.2, 175)
		setElementFrozen(vehicle, true)
		setTimer( function()
			setElementPosition(vehicle, 1136, -1586.2, 26.2)
			setElementRotation(vehicle, 0, 0, 135)
			setElementVelocity(vehicle, 0, 0, 0)
			setElementFrozen(vehicle, false)
		end, 200, 1)
	end
end
)
