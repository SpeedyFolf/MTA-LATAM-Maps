------------------
-- Moving Crane --
------------------

function startmovecrane ()

	crane01 = createObject (1388, -1500, 755, 26.4, 0, 0, 270)

	craneobj01 = createObject (1337, -1460.5, 755, 30.3, 0, 0, 0)
		setElementAlpha (craneobj01, 0)
		attachElements (craneobj01, crane01, 0, 39.5, 3.9, 0, 0, 0)

	craneobj02 = createObject (1337, -1508, 755, 30.3, 0, 0, 0)
		setElementAlpha (craneobj02, 0)
		attachElements (craneobj02, crane01, 0, 8, 3.9, 0, 0, 0)

	craneobj03 = createObject (1381, -1460.5, 755, 20, 0, 0, 0)
		attachElements (craneobj03, crane01, 0, 39.5, -9.9, 0, 0, 0)

	craneobj04 = createObject (2932, -1460.5, 755, 17.5, 0, 0, 0)
		attachElements (craneobj04, crane01, 0, 39.5, -12.4, 0, 0, 0)

	addEventHandler("onClientRender", getRootElement(), createcranewires)

	movecrane01 ()
end
addEventHandler ("onClientResourceStart", resourceRoot, startmovecrane)


	function movecrane01 ()
		moveObject (crane01, 15000, -1500, 755, 26.4, 0, 0, 110)
		setTimer (movecrane02, 16000, 1)
	end

	function movecrane02 ()
		moveObject (crane01, 15000, -1500, 755, 26.4, 0, 0, -110)
		setTimer (movecrane01, 16000, 1)
	end

	function createcranewires ()
		xco01, yco01, zco01 = getElementPosition (craneobj01)
		xco02, yco02, zco02 = getElementPosition (craneobj02)
		xco03, yco03, zco03 = getElementPosition (craneobj03)
		dxDrawLine3D (xco01, yco01, zco01, xco02, yco02, zco02, tocolor (84, 84, 84, 255), 5)
		dxDrawLine3D (xco01, yco01, zco01, xco03, yco03, zco03, tocolor (84, 84, 84, 255), 5)
	end

-------------
-- Barrier --
-------------
	barobj00 = createObject (8172, -2250, 681, 49, 0, 270, 270)
	setElementAlpha (barobj00, 0)
	barobj01 = createObject (13647, -2260.2893066406, 680.77880859375, 46.346900939941, 0, 180, 0)
	barobj02 = createObject (979, -2275.9313964844, 680.83911132813, 46.546901702881, 0, 0, 180)
	barobj03 = createObject (7609, -2271.009765625, 680.61199951172, 46.549999237061, 0, 0, 0)
	barobj04 = createObject (973, -2270.990234375, 680.8115234375, 42.396900177002, 0, 270, 180)
	barobj05 = createObject (978, -2266.0651855469, 680.84387207031, 46.546901702881, 0, 0, 180)
	barobj06 = createObject (7609, -2261.15234375, 680.65222167969, 46.549999237061, 0, 0, 0)
	barobj07 = createObject (973, -2261.1293945313, 680.81298828125, 42.396900177002, 0, 270, 180)
	barobj08 = createObject (979, -2256.1879882813, 680.84197998047, 46.546901702881, 0, 0, 180)
	barobj09 = createObject (7609, -2251.2570800781, 680.66302490234, 46.549999237061, 0, 0, 0)
	barobj10 = createObject (973, -2251.2490234375, 680.81707763672, 42.396900177002, 0, 270, 180)
	barobj11 = createObject (978, -2246.3103027344, 680.84582519531, 46.546901702881, 0, 0, 180)

barriercol01 = createColPolygon (0, 0, -2275, 530, -2275, 535, -2235, 535, -2235, 530)

function barrier01a (theElement, matchingDimensions)
	if theElement == getLocalPlayer() then

		destroyElement (barriercol01)
		moveObject (barobj01, 4000, -2260.2893066406, 680.77880859375, 49.346900939941, 0, 0, 0)
		moveObject (barobj02, 4000, -2275.9313964844, 680.83911132813, 49.546901702881, 0, 0, 0)
		moveObject (barobj03, 4000, -2271.009765625, 680.61199951172, 49.549999237061, 0, 0, 0)
		moveObject (barobj04, 4000, -2270.990234375, 680.8115234375, 45.396900177002, 0, 0, 0)
		moveObject (barobj05, 4000, -2266.0651855469, 680.84387207031, 49.546901702881, 0, 0, 0)
		moveObject (barobj06, 4000, -2261.15234375, 680.65222167969, 49.549999237061, 0, 0, 0)
		moveObject (barobj07, 4000, -2261.1293945313, 680.81298828125, 45.396900177002, 0, 0, 0)
		moveObject (barobj08, 4000, -2256.1879882813, 680.84197998047, 49.546901702881, 0, 0, 0)
		moveObject (barobj09, 4000, -2251.2570800781, 680.66302490234, 49.549999237061, 0, 0, 0)
		moveObject (barobj10, 4000, -2251.2490234375, 680.81707763672, 45.396900177002, 0, 0, 0)
		moveObject (barobj11, 4000, -2246.3103027344, 680.84582519531, 49.546901702881, 0, 0, 0)

		setTimer ( function ()
			destroyElement (barobj00)
			destroyElement (barobj01)
			destroyElement (barobj02)
			destroyElement (barobj03)
			destroyElement (barobj04)
			destroyElement (barobj05)
			destroyElement (barobj06)
			destroyElement (barobj07)
			destroyElement (barobj08)
			destroyElement (barobj09)
			destroyElement (barobj10)
			destroyElement (barobj11)
		end, 20000, 1)
	end
end
addEventHandler("onClientColShapeHit", barriercol01, barrier01a)


----------------
-- Moving Box --
----------------

function startmovebox ()
	boxobj01 = createObject (2052, -1694.8, 188.8, 31.5, 0, 20, 0)
	boxobj02 = createObject (2052, -1694.8, 188.8, 13.5, 0, 0, 0)
		attachElements (boxobj02, boxobj01, 0, 0, -18, 0, 0, 0)
	boxobj03 = createObject (2932, -1694.8, 188.8, 9, 0, 0, 0)
		attachElements (boxobj03, boxobj01, 0, 0, -22.5, 0, 0, 0)

	boxobj04 = createObject (2052, -1696.3, 185.4, 10.3, 0, 0, 0)
	boxobj05 = createObject (2052, -1693.3, 185.4, 10.3, 0, 0, 0)
	boxobj06 = createObject (2052, -1696.3, 192.2, 10.3, 0, 0, 0)
	boxobj07 = createObject (2052, -1693.3, 192.2, 10.3, 0, 0, 0)
		attachElements (boxobj04, boxobj01, -1.5, -3.4, -21.2, 0, 0, 0)
		attachElements (boxobj05, boxobj01, 1.5, -3.4, -21.2, 0, 0, 0)
		attachElements (boxobj06, boxobj01, -1.5, 3.4, -21.2, 0, 0, 0)
		attachElements (boxobj07, boxobj01, 1.5, 3.4, -21.2, 0, 0, 0)

	setElementCollisionsEnabled (boxobj01, false)
	setElementCollisionsEnabled (boxobj02, false)
	setElementCollisionsEnabled (boxobj04, false)
	setElementCollisionsEnabled (boxobj05, false)
	setElementCollisionsEnabled (boxobj06, false)
	setElementCollisionsEnabled (boxobj07, false)

	setElementAlpha (boxobj01, 0)
	setElementAlpha (boxobj02, 0)
	setElementAlpha (boxobj04, 0)
	setElementAlpha (boxobj05, 0)
	setElementAlpha (boxobj06, 0)
	setElementAlpha (boxobj07, 0)

	addEventHandler("onClientRender", getRootElement(), createboxwires)

	movebox01 ()

end
addEventHandler ("onClientResourceStart", resourceRoot, startmovebox)

	function movebox01 ()
		moveObject (boxobj01, 7200, -1694.8, 188.8, 31.5, 0, -40, 0)
		setTimer (movebox02, 7200, 1)
	end

	function movebox02 ()
		moveObject (boxobj01, 7200, -1694.8, 188.8, 31.5, 0, 40, 0)
		setTimer (movebox01, 7200, 1)
	end

	function createboxwires ()
		xbox01, ybox01, zbox01 = getElementPosition (boxobj01)
		xbox02, ybox02, zbox02 = getElementPosition (boxobj02)
		xbox04, ybox04, zbox04 = getElementPosition (boxobj04)
		xbox05, ybox05, zbox05 = getElementPosition (boxobj05)
		xbox06, ybox06, zbox06 = getElementPosition (boxobj06)
		xbox07, ybox07, zbox07 = getElementPosition (boxobj07)
		dxDrawLine3D (xbox01, ybox01, zbox01, xbox02, ybox02, zbox02, tocolor (84, 84, 84, 255), 5)
		dxDrawLine3D (xbox04, ybox04, zbox04, xbox02, ybox02, zbox02, tocolor (84, 84, 84, 255), 5)
		dxDrawLine3D (xbox05, ybox05, zbox05, xbox02, ybox02, zbox02, tocolor (84, 84, 84, 255), 5)
		dxDrawLine3D (xbox06, ybox06, zbox06, xbox02, ybox02, zbox02, tocolor (84, 84, 84, 255), 5)
		dxDrawLine3D (xbox07, ybox07, zbox07, xbox02, ybox02, zbox02, tocolor (84, 84, 84, 255), 5)
	end


-----------
-- Train --
-----------

traincol01 = createColCuboid (-1755, -103.5, 2, 30, 10, 10)
function train01 (theElement, matchingDimensions)
	if theElement == getLocalPlayer() then

		destroyElement (traincol01)
		theVehicle = getPedOccupiedVehicle (theElement)

		train01a = createVehicle (537, -1768, -33.3, 5)
			setTrainDerailable (train01a , false)
			setTrainDirection (train01a, false)
			setVehicleOverrideLights (train01a, 2)
			setVehicleEngineState (train01a, true)
			setElementData (train01a, "race.collideothers", 1)
        		setTimer (setTrainSpeed, 100, 250, train01a, -0.4)

		train01b = createVehicle (569, -1786, -35.5, 6.5)
			setTrainDerailable (train01b , false)
			setTrainDirection (train01b, false)
			setVehicleOverrideLights (train01b, 2)
			setVehicleEngineState (train01b, true)
			setElementData (train01b, "race.collideothers", 1)
        		setTimer (setTrainSpeed, 100, 250, train01b, -0.4)

		train01c = createVehicle (590, -1804, -35.5, 7.5)
			setTrainDerailable (train01c , false)
			setTrainDirection (train01c, false)
			setVehicleOverrideLights (train01c, 2)
			setVehicleEngineState (train01c, true)
			setElementData (train01c, "race.collideothers", 1)
        		setTimer (setTrainSpeed, 100, 250, train01c, -0.4)

		setTimer (destroyElement, 30000, 1, train01a)
		setTimer (destroyElement, 30000, 1, train01b)
		setTimer (destroyElement, 30000, 1, train01c)

	end
end
addEventHandler("onClientColShapeHit", traincol01, train01)

---------------
--Falling Box--
---------------

fbox01 = createObject (2932, -1560, 434.5, 30, 180, 0, 90)

fallingboxcol01 = createColPolygon ( 0, 0, -1611.0849609375, 359.6474609375, -1624.7294921875, 373.77734375, -1623.1669921875, 375.255859375, -1609.533203125, 361.1376953125)

function fallingbox01 (theElement,matchingDimensions)
	if theElement == getLocalPlayer() then

		destroyElement (fallingboxcol01)
		setTimer (moveObject, 100, 1, fbox01, 1000, -1560, 434.5, 7.7, 180, 0, 0)
		setTimer ( function ()
			fbx, fby, fbz = getElementPosition (fbox01)
			fbrx, fbry, fbrz = getElementRotation (fbox01)
    			box02 = createObject (3073, fbx, fby, fbz, fbrx, fbry, fbrz)
    			setTimer (createExplosion, 100, 3, fbx, fby, fbz, 10, true, -1.0, false)
    			destroyElement (fbox01)
		end, 1100, 1)
	end
end
addEventHandler("onClientColShapeHit", fallingboxcol01, fallingbox01)


---------
--Lines--
---------

function createLine ()
	--after the start
	dxDrawLine3D (-2394.89453125, -0.0576171875, 34.8, -2402.48828125, -25.9228515625, 34.8, tocolor (0, 255, 255, 255), 20)
	dxDrawLine3D (-2394.89453125, -0.0576171875, 35.8, -2402.48828125, -25.9228515625, 35.8, tocolor (0, 255, 255, 255), 20)
	dxDrawLine3D (-2394.89453125, -0.0576171875, 36.8, -2402.48828125, -25.9228515625, 36.8, tocolor (0, 255, 255, 255), 20)
	dxDrawLine3D (-2402.9736328125, -27.7392578125, 34.8, -2405.3408203125, -58.599609375, 34.8, tocolor (0, 255, 255, 255), 20)
	dxDrawLine3D (-2402.9736328125, -27.7392578125, 35.8, -2405.3408203125, -58.599609375, 35.8, tocolor (0, 255, 255, 255), 20)
	dxDrawLine3D (-2402.9736328125, -27.7392578125, 36.8, -2405.3408203125, -58.599609375, 36.8, tocolor (0, 255, 255, 255), 20)
	dxDrawLine3D (-2405.3388671875, -60.4794921875, 34.8, -2405.33984375, -80, 34.8, tocolor (0, 255, 255, 255), 20)
	dxDrawLine3D (-2405.3388671875, -60.4794921875, 35.8, -2405.33984375, -80, 35.8, tocolor (0, 255, 255, 255), 20)
	dxDrawLine3D (-2405.3388671875, -60.4794921875, 36.8, -2405.33984375, -80, 36.8, tocolor (0, 255, 255, 255), 20)
	dxDrawLine3D (-2405.33984375, -81.8798828125, 34.8, -2402.48828125, -107.67578125, 34.8, tocolor (0, 255, 255, 255), 20)
	dxDrawLine3D (-2405.33984375, -81.8798828125, 35.8, -2402.48828125, -107.67578125, 35.8, tocolor (0, 255, 255, 255), 20)
	dxDrawLine3D (-2405.33984375, -81.8798828125, 36.8, -2402.48828125, -107.67578125, 36.8, tocolor (0, 255, 255, 255), 20)
	dxDrawLine3D (-2402, -109.4921875, 34.8, -2393.955078125, -135.169921875, 34.8, tocolor (0, 255, 255, 255), 20)
	dxDrawLine3D (-2402, -109.4921875, 35.8, -2393.955078125, -135.169921875, 35.8, tocolor (0, 255, 255, 255), 20)
	dxDrawLine3D (-2402, -109.4921875, 36.8, -2393.955078125, -135.169921875, 36.8, tocolor (0, 255, 255, 255), 20)

	dxDrawLine3D (-2376.984375, -10.3984375, 34.8, -2382.5107421875, -31.275390625, 34.8, tocolor (0, 255, 255, 255), 20)
	dxDrawLine3D (-2376.984375, -10.3984375, 35.8, -2382.5107421875, -31.275390625, 35.8, tocolor (0, 255, 255, 255), 20)
	dxDrawLine3D (-2376.984375, -10.3984375, 36.8, -2382.5107421875, -31.275390625, 36.8, tocolor (0, 255, 255, 255), 20)

	dxDrawLine3D (-2382.998046875, -33.091796875, 34.8, -2384.658203125, -58.5986328125, 34.8, tocolor (0, 255, 255, 255), 20)
	dxDrawLine3D (-2382.998046875, -33.091796875, 35.8, -2384.658203125, -58.5986328125, 35.8, tocolor (0, 255, 255, 255), 20)
	dxDrawLine3D (-2382.998046875, -33.091796875, 36.8, -2384.658203125, -58.5986328125, 36.8, tocolor (0, 255, 255, 255), 20)

	dxDrawLine3D (-2384.658203125, -60.4794921875, 34.8, -2384.6591796875, -80, 34.8, tocolor (0, 255, 255, 255), 20)
	dxDrawLine3D (-2384.658203125, -60.4794921875, 35.8, -2384.6591796875, -80, 35.8, tocolor (0, 255, 255, 255), 20)
	dxDrawLine3D (-2384.658203125, -60.4794921875, 36.8, -2384.6591796875, -80, 36.8, tocolor (0, 255, 255, 255), 20)

	dxDrawLine3D (-2384.6591796875, -81.8798828125, 34.8, -2382.5107421875, -102.322265625, 34.8, tocolor (0, 255, 255, 255), 20)
	dxDrawLine3D (-2384.6591796875, -81.8798828125, 35.8, -2382.5107421875, -102.322265625, 35.8, tocolor (0, 255, 255, 255), 20)
	dxDrawLine3D (-2384.6591796875, -81.8798828125, 36.8, -2382.5107421875, -102.322265625, 36.8, tocolor (0, 255, 255, 255), 20)

	dxDrawLine3D (-2382.0244140625, -104.1396484375, 34.8, -2376.0439453125, -124.828125, 34.8, tocolor (0, 255, 255, 255), 20)
	dxDrawLine3D (-2382.0244140625, -104.1396484375, 35.8, -2376.0439453125, -124.828125, 35.8, tocolor (0, 255, 255, 255), 20)
	dxDrawLine3D (-2382.0244140625, -104.1396484375, 36.8, -2376.0439453125, -124.828125, 36.8, tocolor (0, 255, 255, 255), 20)

	--wires for falling box
	dxDrawLine3D (-1560, 434.5, 30, -1560, 434.5, 40.6, tocolor (84, 84, 84, 255), 5)
	dxDrawLine3D (-1560, 434.5, 40.6, -1560, 379.3, 40.6, tocolor (84, 84, 84, 255), 5)

	--Highway:
	dxDrawLine3D (-1893, 56.9, 38.5, -1895.2, 28.8, 38.5, tocolor (255, 140, 0, 255), 20)
	dxDrawLine3D (-1893, 56.9, 39.5, -1895.2, 28.8, 39.5, tocolor (0, 0, 0, 255), 20)
	dxDrawLine3D (-1893, 56.9, 40.5, -1895.2, 28.8, 40.5, tocolor (255, 140, 0, 255), 20)

	dxDrawLine3D (-1879.6, 56, 38.5, -1881.8, 28, 38.5, tocolor (255, 140, 0, 255), 20)
	dxDrawLine3D (-1879.6, 56, 39.5, -1881.8, 28, 39.5, tocolor (0, 0, 0, 255), 20)
	dxDrawLine3D (-1879.6, 56, 40.5, -1881.8, 28, 40.5, tocolor (255, 140, 0, 255), 20)

	dxDrawLine3D (-1896.3, 12, 38.5, -1897.8, -15.8, 38.5, tocolor (255, 140, 0, 255), 20)
	dxDrawLine3D (-1896.3, 12, 39.5, -1897.8, -15.8, 39.5, tocolor (0, 0, 0, 255), 20)
	dxDrawLine3D (-1896.3, 12, 40.5, -1897.8, -15.8, 40.5, tocolor (255, 140, 0, 255), 20)

	dxDrawLine3D (-1882.9, 11.1, 38.5, -1884.4, -16.5, 38.5, tocolor (255, 140, 0, 255), 20)
	dxDrawLine3D (-1882.9, 11.1, 39.5, -1884.4, -16.5, 39.5, tocolor (0, 0, 0, 255), 20)
	dxDrawLine3D (-1882.9, 11.1, 40.5, -1884.4, -16.5, 40.5, tocolor (255, 140, 0, 255), 20)

	dxDrawLine3D (-1898.7, -32.7, 37.5, -1900.8, -76, 37.5, tocolor (0, 0, 0, 255), 20)
	dxDrawLine3D (-1898.7, -32.7, 38.5, -1900.8, -76, 38.5, tocolor (255, 140, 0, 255), 20)
	dxDrawLine3D (-1898.7, -32.7, 39.5, -1900.8, -76, 39.5, tocolor (0, 0, 0, 255), 20)
	dxDrawLine3D (-1898.7, -32.7, 40.5, -1900.8, -76, 40.5, tocolor (255, 140, 0, 255), 20)

	dxDrawLine3D (-1885.3, -33.4, 37.5, -1887.3, -76.6, 37.5, tocolor (0, 0, 0, 255), 20)
	dxDrawLine3D (-1885.3, -33.4, 38.5, -1887.3, -76.6, 38.5, tocolor (255, 140, 0, 255), 20)
	dxDrawLine3D (-1885.3, -33.4, 39.5, -1887.3, -76.6, 39.5, tocolor (0, 0, 0, 255), 20)
	dxDrawLine3D (-1885.3, -33.4, 40.5, -1887.3, -76.6, 40.5, tocolor (255, 140, 0, 255), 20)

	dxDrawLine3D (-1901.5, -93, 38.5, -1903, -131.2, 38.5, tocolor (255, 140, 0, 255), 20)
	dxDrawLine3D (-1901.5, -93, 39.5, -1903, -131.2, 39.5, tocolor (0, 0, 0, 255), 20)
	dxDrawLine3D (-1901.5, -93, 40.5, -1903, -131.2, 40.5, tocolor (255, 140, 0, 255), 20)

	dxDrawLine3D (-1888.1, -93.6, 37.5, -1889.5, -131.4, 37.5, tocolor (0, 0, 0, 255), 20)
	dxDrawLine3D (-1888.1, -93.6, 38.5, -1889.5, -131.4, 38.5, tocolor (255, 140, 0, 255), 20)
	dxDrawLine3D (-1888.1, -93.6, 39.5, -1889.5, -131.4, 39.5, tocolor (0, 0, 0, 255), 20)
	dxDrawLine3D (-1888.1, -93.6, 40.5, -1889.5, -131.4, 40.5, tocolor (255, 140, 0, 255), 20)

	dxDrawLine3D (-1903.4, -148.1, 38.5, -1903.8, -181.3, 38.5, tocolor (255, 140, 0, 255), 20)
	dxDrawLine3D (-1903.4, -148.1, 39.5, -1903.8, -181.3, 39.5, tocolor (0, 0, 0, 255), 20)
	dxDrawLine3D (-1903.4, -148.1, 40.5, -1903.8, -181.3, 40.5, tocolor (255, 140, 0, 255), 20)

	dxDrawLine3D (-1889.9, -148.4, 38.5, -1890.3, -181.4, 38.5, tocolor (255, 140, 0, 255), 20)
	dxDrawLine3D (-1889.9, -148.4, 39.5, -1890.3, -181.4, 39.5, tocolor (0, 0, 0, 255), 20)
	dxDrawLine3D (-1889.9, -148.4, 40.5, -1890.3, -181.4, 40.5, tocolor (255, 140, 0, 255), 20)
end
addEventHandler("onClientRender", getRootElement(), createLine)


------------
--Bauss :)--
------------

function startbauss ()
	setTimer (function ()
	infernusb = createVehicle (411, -2669.2, 1262.7, 55.2, 0, 0, 45)
		setElementHealth (infernusb, 100)
   		setVehicleEngineState (infernusb ,true)
   		setVehicleOverrideLights (infernusb, 2)
		setVehicleDoorOpenRatio (infernusb, 2, 1)
	bauss = createPed (217, -2671.4, 1262.4, 55.5)
		setElementCollisionsEnabled (bauss, false)
		setElementRotation (bauss, 0, 0, 45)
		setTimer (setPedAnimation, 2000, 1, bauss, "POLICE", "Door_Kick", nil, true, true, true)

	addEventHandler("onClientRender",getRootElement(),
	function()
		bx, by, bz = getElementPosition (bauss)
		px, py, pz = getElementPosition (getLocalPlayer())
		distance = getDistanceBetweenPoints3D (bx, by, bz, px, py, pz)
		if distance <= 150 then
			local sx,sy = getScreenFromWorldPosition (bx, by, bz+0.95, 0.06)
			if not sx then return end
			local scale = 1/(0.3 * (distance / 150))
			dxDrawText ("Bauss", sx, sy - 30, sx, sy - 30, tocolor(255, 127, 36, 200), math.min (0.4*(150/distance)*1.4,4), "default", "center", "bottom", false, false, true, true, true)
		end
	end)
	end, 3000, 1)

end
addEventHandler ("onClientResourceStart", resourceRoot, startbauss)


--------------------
-- Bridge Traffic --
--------------------

trafficcol01 = createColSphere (-2690.5, 1266, 56, 14)

function traffic01 (theElement,matchingDimensions)
	if theElement == getLocalPlayer() then

		theVehicle = getPedOccupiedVehicle (theElement)
		--setElementData (theVehicle, "race.collideothers", 1)

		car01a = createVehicle (554, -2693, 1415, 55.6, 0, 0, 180)
			setVehicleEngineState (car01a, true )
			setVehicleOverrideLights (car01a, 2)
			setElementData (car01a, "race.collideothers", 1)
			setTimer (destroyElement, 20000, 1, car01a)
			setTimer (setElementVelocity, 500, 30, car01a, 0, -0.4, 0)

		car01b = createVehicle (440, -2686.3, 1422, 55.6, 0, 0, 180)
			setVehicleEngineState (car01b, true )
			setVehicleOverrideLights (car01b, 2)
			setElementData (car01b, "race.collideothers", 1)
			setTimer (destroyElement, 20000, 1, car01b)
			setTimer (setElementVelocity, 500, 30, car01b, 0, -0.4, 0)

		car01c = createVehicle (408, -2693, 1425, 56, 0, 0, 180)
			setVehicleEngineState (car01c, true )
			setVehicleOverrideLights (car01c, 2)
			setElementData (car01c, "race.collideothers", 1)
			setTimer (destroyElement, 20000, 1, car01c)
			setTimer (setElementVelocity, 500, 30, car01c, 0, -0.4, 0)

		car01d = createVehicle (402, -2686.3, 1435, 55.6, 0, 0, 180)
			setVehicleEngineState (car01d, true )
			setVehicleOverrideLights (car01d, 2)
			setElementData (car01d, "race.collideothers", 1)
			setTimer (destroyElement, 20000, 1, car01d)
			setTimer (setElementVelocity, 500, 30, car01d, 0, -0.4, 0)

	end
end
addEventHandler("onClientColShapeHit", trafficcol01, traffic01)

trafficcol02 = createColSphere (-2688.9, 1425, 55.1, 14)

function traffic02 (theElement,matchingDimensions)
	if theElement == getLocalPlayer() then

		theVehicle = getPedOccupiedVehicle (theElement)
		setElementData (theVehicle, "race.collideothers", 1)

		car02a = createVehicle (517, -2686.4, 1595, 64, 0, 0, 180)
			setVehicleEngineState (car02a, true )
			setVehicleOverrideLights (car02a, 2)
			setElementData (car02a, "race.collideothers", 1)
			setTimer (destroyElement, 20000, 1, car02a)
			setTimer (setElementVelocity, 500, 30, car02a, 0, -0.4, 0)

		car02b = createVehicle (579, -2692, 1610, 64.6, 0, 0, 180)
			setVehicleEngineState (car02b, true )
			setVehicleOverrideLights (car02b, 2)
			setElementData (car02b, "race.collideothers", 1)
			setTimer (destroyElement, 20000, 1, car02b)
			setTimer (setElementVelocity, 500, 30, car02b, 0, -0.4, 0)

		car02c = createVehicle (580, -2686.4, 1610, 65.3, 0, 0, 180)
			setVehicleEngineState (car02c, true )
			setVehicleOverrideLights (car02c, 2)
			setElementData (car02c, "race.collideothers", 1)
			setTimer (destroyElement, 20000, 1, car02c)
			setTimer (setElementVelocity, 500, 30, car02c, 0, -0.4, 0)

	end
end
addEventHandler("onClientColShapeHit", trafficcol02, traffic02)

trafficcol03 = createColSphere (-2688.9, 1630, 65.2, 14)

function traffic03 (theElement,matchingDimensions)
	if theElement == getLocalPlayer() then

		theVehicle = getPedOccupiedVehicle (theElement)
		setElementData (theVehicle, "race.collideothers", 1)

		car03a = createVehicle (515, -2686.4, 1780, 69.1, 0, 0, 180)
			setVehicleEngineState (car03a, true )
			setVehicleOverrideLights (car03a, 2)
			setElementData (car03a, "race.collideothers", 1)
			setTimer (destroyElement, 20000, 1, car03a)
			setTimer (setElementVelocity, 500, 30, car03a, 0, -0.4, 0)

		car03b = createVehicle (584, -2686.4, 1790, 69.2, 0, 0, 180)
			setVehicleOverrideLights (car03b, 2)
			attachTrailerToVehicle (car03a, car03b)
			setElementData (car03b, "race.collideothers", 1)
			setTimer (destroyElement, 20000, 1, car03b)


	end
end
addEventHandler("onClientColShapeHit", trafficcol03, traffic03)

--[[
trafficcol04 = createColSphere (-2690.5, 1785, 67.7, 14)

function traffic04 (theElement,matchingDimensions)
	if theElement == getLocalPlayer() then

		theVehicle = getPedOccupiedVehicle (theElement)
		setElementData (theVehicle, "race.collideothers", 1)

		car04a = createVehicle (456, -2686.5, 1910, 65.5, 0, 0, 180)
			setVehicleEngineState (car04a, true )
			setVehicleOverrideLights (car04a, 2)
			setElementData (car04a, "race.collideothers", 1)
			setTimer (destroyElement, 20000, 1, car04a)
			setTimer (setElementVelocity, 500, 30, car04a, 0, -0.4, 0)

		car04b = createVehicle (443, -2691.8, 1927, 65.2, 0, 0, 180)
			setVehicleEngineState (car04b, true )
			setVehicleOverrideLights (car04b, 2)
			setElementData (car04b, "race.collideothers", 1)
			setTimer (destroyElement, 20000, 1, car04b)
			setTimer (setElementVelocity, 500, 30, car04b, 0, -0.4, 0)

		car04c = createVehicle (524, -2686.5, 1942, 64.8, 0, 0, 180)
			setVehicleEngineState (car04c, true )
			setVehicleOverrideLights (car04c, 2)
			setElementData (car04c, "race.collideothers", 1)
			setTimer (destroyElement, 20000, 1, car04c)
			setTimer (setElementVelocity, 500, 30, car04c, 0, -0.4, 0)

		car04d = createVehicle (437, -2691.8, 1960, 63, 0, 0, 180)
			setVehicleEngineState (car04d, true )
			setVehicleOverrideLights (car04d, 2)
			setElementData (car04d, "race.collideothers", 1)
			setTimer (destroyElement, 20000, 1, car04d)
			setTimer (setElementVelocity, 500, 30, car04d, 0, -0.4, 0)

	end
end
addEventHandler("onClientColShapeHit", trafficcol04, traffic04)
]]--
-----------------------
--Change LOD distance--
-----------------------

addEventHandler("onClientResourceStart",resourceRoot,
	function()
		engineSetModelLODDistance (3785, 100) --bluelight for arrow shader
		engineSetModelLODDistance (2774, 100) --pillars
		engineSetModelLODDistance (3437, 100) --blue neon thing
		engineSetModelLODDistance (3524, 150) --skull01
		engineSetModelLODDistance (6865, 150) --skull02
	end)


