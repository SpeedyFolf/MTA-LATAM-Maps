
---------
--Start--
---------

addEvent("onRaceStateChanging")
addEventHandler("onRaceStateChanging",root,
	function (state)
		if state == "GridCountdown" then
			handleTrafficLightStart ()
		end
	end)


------------------
--Traffic Lights--
------------------

addEventHandler("onResourceStart",resourceRoot,
	function ()
		setTrafficLightState (9)
	end)

function handleTrafficLightStart ()
	setTimer (setTrafficLightState, 3000, 1, 2)
	setTimer (setTrafficLightState, 3500, 1, 9)
	setTimer (setTrafficLightState, 4000, 1, 2)
	setTimer (setTrafficLightState, 4500, 1, 9)
	setTimer (setTrafficLightState, 5000, 1, 2)
	setTimer (setTrafficLightState, 5500, 1, 9)
	setTimer (setTrafficLightState, 6000, 1, 5)
end