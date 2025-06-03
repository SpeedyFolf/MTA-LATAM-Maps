local font = dxCreateFont("font.ttf", 30, true, "proof")
local screenX, screenY = guiGetScreenSize()

local property = {
	{pickup = nil, x = -1969.27, 	y = 282.47, 	z = 34.6, 		blip = nil, 	price = 50000, 	camera = {x = -1990.9690, y = 292.2734, z = 35.1049}, 	lookAt = {x = -1990.0530, y = 291.9333, z = 35.3176}, 	type = "house", 	garage = nil},	-- SF showroom
	{pickup = nil, x = -2243.62, 	y = 133.20, 	z = 34.8, 		blip = nil, 	price = 30000, 	camera = {x = -2255.7051, y = 131.9585, z = 38.5998}, 	lookAt = {x = -2254.7161, y = 132.0048, z = 38.4589}, 	type = "house", 	garage = nil},	-- zero RC shop
	{pickup = nil, x = 426.4972, 	y = 2530.68, 	z = 16.1, 		blip = nil, 	price = 80000, 	camera = {x = 445.1280, y = 2540.4360, z = 25.6202}, 	lookAt = {x = 444.1882, y = 2540.1421, z = 25.4462}, 	type = "house", 	garage = 45},	-- Desert Airstrip
	{pickup = nil, x = 316.0696, 	y = -1772.5688, z = 4.1893, 	blip = nil, 	price = 30000, 	camera = {x = 316.0747, y = -1786.7572, z = 5.0712}, 	lookAt = {x = 316.1206, y = -1785.7781, z = 5.2692}, 	type = "house", 	garage = 13}, 	-- beach front malibu house LA
	{pickup = nil, x = 2441.0022, 	y = 695.1089, 	z = 10.6646, 	blip = nil, 	price = 20000, 	camera = {x = 2430.8694, y = 698.3348, z = 12.9763}, 	lookAt = {x = 2431.7886, y = 697.9644, z = 12.8430}, 	type = "house", 	garage = 34}, 	-- Shabbyhouse in Vegas East
	{pickup = nil, x = -366.1849, 	y = 1166.0305, 	z = 19.2422, 	blip = nil, 	price = 30000, 	camera = {x = -362.3164, y = 1152.6638, z = 21.4821}, 	lookAt = {x = -362.6989, y = 1153.5872, z = 21.5142}, 	type = "house", 	garage = 42}, 	-- fort carson old house savehouse near river badlands
	{pickup = nil, x = 1283.8439, 	y = 2528.7029, 	z = 10.3203, 	blip = nil, 	price = 50000, 	camera = {x = 1295.9816, y = 2525.5703, z = 14.1002}, 	lookAt = {x = 1294.9943, y = 2525.7239, z = 14.0597}, 	type = "house", 	garage = 38}, 	-- medium house in nice suburb of venturas
	{pickup = nil, x = 922.3647, 	y = 2011.8984, 	z = 10.7660, 	blip = nil, 	price = 30000, 	camera = {x = 908.9885, y = 2006.1508, z = 17.7914}, 	lookAt = {x = 909.9134, y = 2006.1431, z = 17.4113}, 	type = "house", 	garage = 39}, 	-- shabby house in rundown residential area
	{pickup = nil, x = 2236.9280, 	y = 162.8057, 	z = 26.8462, 	blip = nil, 	price = 35000, 	camera = {x = 2233.1401, y = 152.5748, z = 33.5239}, 	lookAt = {x = 2233.1599, y = 153.5324, z = 33.2366}, 	type = "house", 	garage = 48}, 	-- Small town suburban house with lawn and porch
	{pickup = nil, x = 1402.3174, 	y = 1901.9783, 	z = 10.8449, 	blip = nil, 	price = 30000, 	camera = {x = 1385.5187, y = 1901.3131, z = 14.5901}, 	lookAt = {x = 1386.4720, y = 1901.0758, z = 14.4041}, 	type = "house", 	garage = 37}, 	-- shabby house in rundown residential area
	{pickup = nil, x = 1687.9805, 	y = -2100.6431, z = 13.3343, 	blip = nil, 	price = 10000, 	camera = {x = 1689.1176, y = -2120.1648, z = 18.6369}, 	lookAt = {x = 1689.1876, y = -2119.1870, z = 18.4393}, 	type = "house", 	garage = 5}, 	-- house in ruff hood next to airport
	{pickup = nil, x = -2106.6392, 	y = 900.5537, 	z = 76.2032, 	blip = nil, 	price = 100000, camera = {x = -2098.9670, y = 923.2947, z = 80.2446}, 	lookAt = {x = -2098.9861, y = 922.2994, z = 80.3401}, 	type = "house", 	garage = 25}, 	-- big swanky SF savehouse at the top of lombard street
	{pickup = nil, x = 1331.1855, 	y = -630.4962, 	z = 108.6349, 	blip = nil, 	price = 120000, camera = {x = 1325.9745, y = -598.7552, z = 116.1597}, 	lookAt = {x = 1326.2544, y = -599.7052, z = 116.0219}, 	type = "house", 	garage = 14}, 	-- swanky pad in la hills with pool and lots of big windows
	{pickup = nil, x = -2695.7451, 	y = 818.4718, 	z = 49.4844, 	blip = nil, 	price = 20000, 	camera = {x = -2700.6575, y = 791.4500, z = 70.2223}, 	lookAt = {x = -2700.6614, y = 792.4032, z = 69.9203}, 	type = "house", 	garage = 28}, 	-- small flat near hospital in paradiso
	{pickup = nil, x = -2456.9255, 	y = -131.3292, 	z = 25.5376, 	blip = nil, 	price = 40000, 	camera = {x = -2476.4321, y = -127.2039, z = 26.6779}, 	lookAt = {x = -2475.4575, y = -127.2469, z = 26.8974}, 	type = "house", 	garage = 17}, 	-- large garage in alley behind apartments in Hashbury
	{pickup = nil, x = 892.6662, 	y = -1639.7139, z = 14.4567, 	blip = nil, 	price = 10000, 	camera = {x = 894.7908, y = -1663.9961, z = 20.2020}, 	lookAt = {x = 894.8030, y = -1663.0026, z = 20.0891}, 	type = "house", 	garage = nil}, 	-- Medium apartment near Venice canals
	{pickup = nil, x = 1969.9325, 	y = 1623.2429, 	z = 12.3619, 	blip = nil, 	price = 6000, 	camera = {x = 2036.7603, y = 1623.0739, z = 13.4128}, 	lookAt = {x = 2035.8002, y = 1623.0870, z = 13.6921}, 	type = "hotel", 	garage = nil}, 	-- Pirates In Men’s Pants Casino
	{pickup = nil, x = 2234.9087, 	y = 1285.6981, 	z = 10.3203, 	blip = nil, 	price = 6000, 	camera = {x = 2146.1653, y = 1286.2496, z = 33.6386}, 	lookAt = {x = 2147.1636, y = 1286.2180, z = 33.5943}, 	type = "hotel", 	garage = nil}, 	-- The Camels Toe Casino
	{pickup = nil, x = -2213.8643, 	y = 723.5587, 	z = 48.9140, 	blip = nil, 	price = 20000, 	camera = {x = -2213.1877, y = 744.9976, z = 50.0240}, 	lookAt = {x = -2213.2732, y = 744.0281, z = 50.2540}, 	type = "house", 	garage = nil}, 	-- small chinatown pad
	{pickup = nil, x = -1439.0140, 	y = -1540.5901, z = 101.2579, 	blip = nil, 	price = 100000, camera = {x = -1437.1841, y = -1507.7319, z = 103.8198},lookAt = {x = -1437.0469, y = -1508.7114, z = 103.9666},type = "house", 	garage = nil}, 	-- farm near the truths
	{pickup = nil, x = -2027.8300, 	y = -44.0454, 	z = 38.7692, 	blip = nil, 	price = 20000, 	camera = {x = -2000.4270, y = -64.4142, z = 40.0479}, 	lookAt = {x = -2001.2571, y = -63.8685, z = 40.1625}, 	type = "house", 	garage = nil}, 	-- large pad next to driving school
	{pickup = nil, x = -2419.6768, 	y = 334.1621, 	z = 34.6796, 	blip = nil, 	price = 50000, 	camera = {x = -2379.8542, y = 312.8534, z = 34.2136}, 	lookAt = {x = -2380.6831, y = 313.3110, z = 34.5349}, 	type = "hotel", 	garage = nil}, 	-- vank hoff in the park hotel room
	{pickup = nil, x = -2079.0969, 	y = -2309.8987, z = 30.1172, 	blip = nil, 	price = 20000, 	camera = {x = -2079.0613, y = -2298.0559, z = 35.1500}, lookAt = {x = -2078.8796, y = -2299.0286, z = 35.0066}, type = "house", 	garage = nil}, 	-- just off main Angel Pine town, behind Sawmill
	{pickup = nil, x = -1534.1703, 	y = 2650.3000, 	z = 55.3437, 	blip = nil, 	price = 20000, 	camera = {x = -1545.0934, y = 2663.0557, z = 61.0133}, 	lookAt = {x = -1544.2816, y = 2662.5093, z = 60.8075}, 	type = "house", 	garage = nil}, 	-- In El Quebrados (most northerly town)
	{pickup = nil, x = -1045.7751, 	y = 1552.9763, 	z = 32.7980, 	blip = nil, 	price = 20000, 	camera = {x = -1035.1910, y = 1568.4561, z = 39.7221}, 	lookAt = {x = -1035.9714, y = 1567.8857, z = 39.4659}, 	type = "house", 	garage = nil}, 	-- Las Barrancas (southern town)
	{pickup = nil, x = 793.5623, 	y = -514.4116, 	z = 16.3973, 	blip = nil, 	price = 40000, 	camera = {x = 789.7151, y = -529.9901, z = 20.7400}, 	lookAt = {x = 789.8545, y = -529.0045, z = 20.6445}, 	type = "house", 	garage = 49}, 	-- Small town suburban house with lawn and porch
	{pickup = nil, x = 2103.3459, 	y = -1288.3389, z = 23.8168	, 	blip = nil, 	price = 10000, 	camera = {x = 2114.3787, y = -1299.7422, z = 32.8721}, 	lookAt = {x = 2114.3047, y = -1298.8331, z = 32.4622}, 	type = "house", 	garage = nil}, 	-- compton house
	{pickup = nil, x = 2370.4773, 	y = 2165.4744, 	z = 10.3269, 	blip = nil, 	price = 6000, 	camera = {x = 2342.4958, y = 2140.6616, z = 11.3215},	lookAt = {x = 2343.2434, y = 2141.2720, z = 11.5827}, 	type = "hotel", 	garage = nil}, 	-- casino
	{pickup = nil, x = 2220.6257, 	y = 1837.3475, 	z = 10.3203, 	blip = nil, 	price = 6000, 	camera = {x = 2119.7388, y = 1767.8353, z = 26.2058}, 	lookAt = {x = 2120.5295, y = 1768.4473, z = 26.1978},	type = "hotel", 	garage = nil}, 	-- casino clowns pocket
	{pickup = nil, x = 2819.1255, 	y = 2149.3718, 	z = 10.3203, 	blip = nil, 	price = 10000, 	camera = {x = 2820.3608, y = 2174.8303, z = 19.0746}, 	lookAt = {x = 2820.3840, y = 2173.8342, z = 18.9889}, 	type = "hotel", 	garage = nil}, 	-- vegas flat 29
	{pickup = nil, x = 2483.0237, 	y = -2001.0741, z = 13.0540, 	blip = nil, 	price = 10000, 	camera = {x = 2484.9707, y = -2013.0071, z = 17.5718}, 	lookAt = {x = 2484.9600, y = -2012.0312, z = 17.3533}, 	type = "house", 	garage = nil}, 	-- Scummy compton house
	{pickup = nil, x = 206.8, 		y = -112.1, 	z = 4.3965, 	blip = nil, 	price = 10000, 	camera = {x = 189.8908, y = -107.1989, z = 5.7226}, 	lookAt = {x = 190.8559, y = -107.2361, z = 5.4634}, 	type = "house", 	garage = nil} 	-- North Country
}

local texts = {
	["house"] = "PROPERTY BOUGHT!",
	["hotel"] = "HOTEL SUITE PURCHASED!"
}

local state
local vehicle
local cinematic = false
local propertiesBought = 0

addEventHandler("onClientResourceStart", resourceRoot, function()
	-- Create all properties
	for _, v in ipairs(property) do
		v.pickup = createPickup(v.x, v.y, v.z, 3, 1273)
		v.blip = createBlip(v.x, v.y, v.z, 31)
		setBlipVisibleDistance(v.blip, 350)
		givePlayerMoney(v.price)
	end
	
	setTimer(function()
		if getElementData(localPlayer, "race.checkpoint") and getElementData(localPlayer, "race.checkpoint") < propertiesBought + 1 then
			for i = 1, (propertiesBought + 1 - getElementData(localPlayer, "race.checkpoint")) do
				local colshapes = getElementsByType("colshape", getResourceDynamicElementRoot(getResourceFromName("race")))
				if #colshapes > 0 then triggerEvent("onClientColShapeHit", colshapes[#colshapes], getPedOccupiedVehicle(localPlayer) or localPlayer) end
			end
		end
	end, 5000, 0)
end )

addEventHandler("onClientPlayerVehicleEnter", root, function(newvehicle, seat)
	if source == localPlayer then
		if not vehicle and seat == 0 then vehicle = newvehicle end
		
		if getElementModel(newvehicle) == 492 and (not getElementData(localPlayer, "race.checkpoint") or (getElementData(localPlayer, "race.checkpoint") and getElementData(localPlayer, "race.checkpoint") == 1)) then
			-- Initial spawn
			setElementPosition(newvehicle, 2509.85, -1670.0, 13.10)
			setElementRotation(newvehicle, 0, 0, 8)
		end
	end
end )

addEventHandler("onClientElementModelChange", root, function(old, new)
	if getPedOccupiedVehicle(localPlayer) and source == getPedOccupiedVehicle(localPlayer) and new == 447 then
		local x, y, z = getElementPosition(source)
		setElementPosition(source, x, y, z + 3)
	end
end )

addEventHandler("onClientVehicleStartEnter", root, function(ped, seat, door)
	if ped == localPlayer and vehicle and vehicle ~= source then
		cancelEvent()
	end
end )

addEventHandler("onClientRender", root, function()
	if cinematic then
		setPlayerHudComponentVisible("money", false)
		setPlayerHudComponentVisible("radar", false)
		showChat(false)
		dxDrawRectangle(0, 0, screenX, screenY * 0.09765625, tocolor(0, 0, 0, 255))
		dxDrawRectangle(0, screenY * 0.818359375, screenX, screenY, tocolor(0, 0, 0, 255))
		
		drawBorderedText(texts[cinematic.type], 4.2, screenX * 0.965625, screenY * 0.7177734375, screenX * 0.965625, screenY * 0.7177734375, tocolor(125, 85, 14, 255), 2.4, 2.15, "pricedown", "right", "top")
	else
		showChat(true)
		setPlayerHudComponentVisible("money", true)
		setPlayerHudComponentVisible("radar", true)
	end
		
	local x, y, z = getElementPosition(localPlayer)
	local closestProperty = false
	local closestDistance = 99999
	for i, v in ipairs(property) do
		if isElement(v.pickup) then setBlipVisibleDistance(v.blip, 350) end
		
		-- Tooltip for purchasing the property
		if isElement(v.pickup) and not getPedOccupiedVehicle(localPlayer) and getDistanceBetweenPoints3D(x, y, z, v.x, v.y, v.z) < 1 then
			local fontSize = screenY / 1400
			dxDrawRectangle(screenX / 20, screenX / 8, dxGetTextWidth("Press TAB to purchase\nthe property.", fontSize, font) + 20, dxGetFontHeight(screenY / 600, "pricedown") * 2.05, tocolor(0, 0, 0, 175))
			dxDrawText("Press TAB to purchase\nthe property.", (screenX / 20) + 10, (screenX / 8) + 10, (screenX / 20) + 10, (screenX / 8) + 10, tocolor(155, 155, 155, 255), fontSize, fontSize, font, "left", "top")
			
			state = v
		end
		
		if getDistanceBetweenPoints3D(x, y, z, v.x, v.y, v.z) < closestDistance and isElement(v.pickup) then
			closestDistance = getDistanceBetweenPoints3D(x, y, z, v.x, v.y, v.z)
			closestProperty = v
		end
		
		-- Draw price of the property
		local screenPosX, screenPosY, distance = getScreenFromWorldPosition(v.x, v.y, v.z + 1)
		local VISIBLE_DISTANCE = 20
		if screenPosX and isElement(v.pickup) then dxDrawText("$" ..v.price, screenPosX, screenPosY, screenPosX, screenPosY, tocolor(231, 102, 100, (1 - math.min(VISIBLE_DISTANCE, distance or VISIBLE_DISTANCE) / VISIBLE_DISTANCE) * 255), 2.5, 1.8, "pricedown", "center", "top") end
	end
	
	-- Show closest property on the radar
	if closestProperty then
		setBlipVisibleDistance(closestProperty.blip, 16000)
	end
end )

bindKey("tab", "down", function()
	if state and not getPedOccupiedVehicle(localPlayer) then
		if isElement(state.pickup) then
			-- buy
			setBlipIcon(state.blip, 35)
			setBlipVisibleDistance(state.blip, 200)
			destroyElement(state.pickup)
			toggleAllControls(false, true, false)
			givePlayerMoney(-state.price)
			playSFX("radio", "Beats", 9, false)
			propertiesBought = propertiesBought + 1
			
			-- Garage
			if state.garage then setGarageOpen(state.garage, true) end
			
			cinematic = state
			
			local colshapes = getElementsByType("colshape", getResourceDynamicElementRoot(getResourceFromName("race")))
			if #colshapes > 0 then triggerEvent("onClientColShapeHit", colshapes[#colshapes], localPlayer) end
			
			setCameraMatrix(state.camera.x, state.camera.y, state.camera.z, state.lookAt.x, state.lookAt.y, state.lookAt.z)
			setTimer(function() 
				setCameraTarget(localPlayer) 
				toggleAllControls(true, true, false)
				cinematic = false
			end, 5000, 1)
			
			state = nil
		end
	end
end )

function drawBorderedText(text, borderSize, width, height, width2, height2, color, size, font, horizAlign, vertiAlign, bool1, bool2, bool3, bool4)
	dxDrawText(text, width+borderSize, height, width2+borderSize, height2, tocolor(5, 17, 26, 255), size, font, horizAlign, vertiAlign, bool1, bool2, bool3, bool4)
	dxDrawText(text, width, height+borderSize, width2, height2+borderSize, tocolor(5, 17, 26, 255), size, font, horizAlign, vertiAlign, bool1, bool2, bool3, bool4)
	dxDrawText(text, width, height-borderSize, width2, height2-borderSize, tocolor(5, 17, 26, 255), size, font, horizAlign, vertiAlign, bool1, bool2, bool3, bool4)
	dxDrawText(text, width-borderSize, height, width2-borderSize, height2, tocolor(5, 17, 26, 255), size, font, horizAlign, vertiAlign, bool1, bool2, bool3, bool4)
	dxDrawText(text, width+borderSize, height+borderSize, width2+borderSize, height2+borderSize, tocolor(5, 17, 26, 255), size, font, horizAlign, vertiAlign, bool1, bool2, bool3, bool4)
	dxDrawText(text, width-borderSize, height-borderSize, width2-borderSize, height2-borderSize, tocolor(5, 17, 26, 255), size, font, horizAlign, vertiAlign, bool1, bool2, bool3, bool4)
	dxDrawText(text, width+borderSize, height-borderSize, width2+borderSize, height2-borderSize, tocolor(5, 17, 26, 255), size, font, horizAlign, vertiAlign, bool1, bool2, bool3, bool4)
	dxDrawText(text, width-borderSize, height+borderSize, width2-borderSize, height2+borderSize, tocolor(5, 17, 26, 255), size, font, horizAlign, vertiAlign, bool1, bool2, bool3, bool4)
	dxDrawText(text, width, height, width2, height2, color, size, font, horizAlign, vertiAlign, bool1, bool2, bool3, bool4)
end