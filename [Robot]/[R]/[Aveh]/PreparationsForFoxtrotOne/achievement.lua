rect1a = createColRectangle(2069.8, 1620.4, 10, 10)
rect1b = createColRectangle(2064.1, 1651.4, 10, 10)
rect1c = createColRectangle(2059.8, 1610.4, 10, 10)
h1 = 0
ts1 = 0
pass1 = false

rect2 = createColRectangle(2254.0, 1950.0, 40, 2)
pass2 = false

rect3a = createColRectangle(1678.0, 1251.0, 10, 14)
rect3b = createColRectangle(1657.9, 1184.4, 20, 14)
rect3c = createColRectangle(1704.0, 1144.0, 10, 20)
rect3d = createColRectangle(1771.5, 1124.4, 20, 20)
h3 = 0
ts3 = 0
pass3 = false

rect4 = createColRectangle(2060.0, 1496.0, 20, 10)
ts4 = 0
pass4 = false

function onClientColShapeHit( theElement, matchingDimension )
    if ( theElement ~= getPedOccupiedVehicle(localPlayer) ) then
        return
    end
	if (source == rect1a) then
		ts1 = getRealTime().timestamp
		destroyElement(rect1a)
	elseif (source == rect1b) then
		h1 = 1
		local t = getRealTime().timestamp
		if (t - ts1 > 3) then
			pass1 = false
		else
			ts1 = t
		end
		destroyElement(rect1b)
	elseif (source == rect1c) then
		local t = getRealTime().timestamp
		if (t - ts1 > 3) then
			pass1 = false
		else
			if (h1 == 1) then 
				ts1 = 1
				pass1 = true
			end
		end
		destroyElement(rect1c)
	elseif (source == rect2) then
		pass2 = true
		destroyElement(rect2)
	elseif (source == rect3a) then
		ts3 = getRealTime().timestamp
		h3 = 1
		destroyElement(rect3a)
	elseif (source == rect3b) then
		h3 = h3 + 1
		destroyElement(rect3b)
	elseif (source == rect3c) then
		h3 = h3 + 1
		destroyElement(rect3c)
	elseif (source == rect3d) then
		t = getRealTime().timestamp
		if (t - ts3 < 14) then
			if (h3 == 3) then
				pass3 = true
			end
		end
		destroyElement(rect3d)
	elseif (source == rect4) then
		ts4 = getRealTime().timestamp
	end
end
addEventHandler("onClientColShapeHit", resourceRoot, onClientColShapeHit)

function finish4()
	if (source ~= localPlayer) then 
		return
	end
	if (ts4 - getRealTime().timestamp < 5) then
		pass4 = true
	end
	if (pass1 and pass2 and pass3 and pass4) then
		-- winner
		triggerServerEvent("achievement", localPlayer, "sssAveh406Shortcuts")
	end
end
addEvent("onClientPlayerFinish", true)
addEventHandler("onClientPlayerFinish", root, finish4)
