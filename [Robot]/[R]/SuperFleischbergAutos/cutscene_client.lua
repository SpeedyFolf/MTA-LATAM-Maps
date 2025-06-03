

function introCutscene()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if (vehicle) then
		setElementPosition(vehicle, 135.9, -309.1, 9.2)
	end
	setCameraMatrix ( -213.5, -453.5, 63.5, -118.0, -353.8, 0.5)
	setTimer(function()
		setCameraMatrix ( -4.6, -99.4, 38.0, -55.0, -233.0, 26.0)
		-- g_showTutorial = true
	end, 6000, 1)
	setTimer(function()
		g_tutorialBlurb = "#E1E1E1Deliver all the #FDFEFDvehicles #E1E1E1to the #BAA861FleischBerg© factory#E1E1E1!"
		g_showTutorial = true
	end, 7000, 1)
	setTimer(function()
		setCameraMatrix ( -27.7, -209.6, 10.9, -50.2, -222.3, 6.4)
		g_showTutorial = false
	end, 11000, 1)
	setTimer(function()
		g_tutorialBlurb = "#E1E1E1Vehicles can be delivered by parking them in this marker."
		g_showTutorial = true
	end, 11500, 1)
	setTimer(function()
		setCameraMatrix ( 150.0, -392.0, 55.0, -39.0, -293.0, 32.0)
		g_showTutorial = false
	end, 16000, 1)
	setTimer(function()
		g_tutorialBlurb = "#E1E1E1These cranes will assist you with boats, trains, planes, and trailers."
		g_showTutorial = true
	end, 16500, 1)
	setTimer(function()
		setCameraMatrix ( 170.5, -432.8, 18.0, 100.3, -399.5, 6.8)
		g_showTutorial = false
	end, 22000, 1)
	setTimer(function()
		g_tutorialBlurb = "#E1E1E1Simply park these vehicles anywhere within the cranes' range, \nsuch as inside this #1925B8blue marker."
		g_showTutorial = true
	end, 22500, 1)
	setTimer(function()
		g_showTutorial = false
	end, 28000, 1)
	setTimer(function()
		if (getCameraTarget(localPlayer) ~= localPlayer) then
			setCameraTarget ( localPlayer )
		end
	end, 32000, 1)
end
