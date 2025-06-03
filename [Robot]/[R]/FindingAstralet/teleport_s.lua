addEvent("onPlayerReachCheckpoint")
addEventHandler("onPlayerReachCheckpoint", root,
function (checkpoint)
	local vehicle = getPedOccupiedVehicle(source)
	if checkpoint == 61 then
		setElementVelocity(vehicle, 0, 0, 0)
		setElementPosition(vehicle, 1544.2, -1353.4, 500)
		setElementFrozen(vehicle, true)
		setTimer( function()
			setElementPosition(vehicle, 1544.2, -1353.4, 330.4)
			setElementRotation(vehicle, 0, 0, 226)
			setElementVelocity(vehicle, 0, 0, 0)
			setElementFrozen(vehicle, false)
		end, 200, 1)
	end
end
)

addEvent("onPlayerReachCheckpoint")
addEventHandler("onPlayerReachCheckpoint", root,
function (checkpoint)
	local vehicle = getPedOccupiedVehicle(source)
	if checkpoint == 68 then
		setWeather(3)
    end 
end
)

addEvent("onPlayerReachCheckpoint")
addEventHandler("onPlayerReachCheckpoint", root,
function (checkpoint)
	local vehicle = getPedOccupiedVehicle(source)
	if checkpoint == 70 then
		outputChatBox("[meow]#fbaed2Astralet: #E7D9B0meow", root, 255, 255, 255, true)
    end 
end
)