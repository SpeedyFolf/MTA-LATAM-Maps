----------------
--   Arrows   --
----------------

local rootElement = getRootElement()
local screenWidth, screenHeight = guiGetScreenSize()

--1
arrowcol01 = createColSphere (639.79998779297, -1670.7998046875, 263.200000762939, 10)
function arrow01 (theElement, matchingDimensions)
	if theElement == getLocalPlayer() then

		addEventHandler("onClientRender", rootElement, createLeftArrow)
		setTimer (function() removeEventHandler ("onClientRender", rootElement, createLeftArrow) end , 2000, 1)

	end
end
addEventHandler ("onClientColShapeHit", arrowcol01, arrow01)

--2
arrowcol02 = createColSphere (537.29998779297, -1511.7001953125, 263.200000762939, 10)
function arrow02 (theElement, matchingDimensions)
	if theElement == getLocalPlayer() then

		addEventHandler("onClientRender", rootElement, createChicaneArrow)
		setTimer (function() removeEventHandler ("onClientRender", rootElement, createChicaneArrow) end , 2000, 1)

	end
end
addEventHandler ("onClientColShapeHit", arrowcol02, arrow02)

--3
arrowcol03 = createColSphere (340.60000610352, -1708, 263.400001525879, 10)
function arrow03 (theElement, matchingDimensions)
	if theElement == getLocalPlayer() then

		addEventHandler("onClientRender", rootElement, createLeftArrow)
		setTimer (function() removeEventHandler ("onClientRender", rootElement, createLeftArrow) end , 2000, 1)

	end
end
addEventHandler ("onClientColShapeHit", arrowcol03, arrow03)

--4
arrowcol04 = createColSphere (335.79998779297, -1825.2001953125, 263.200000762939, 10)
function arrow04 (theElement, matchingDimensions)
	if theElement == getLocalPlayer() then

		addEventHandler("onClientRender", rootElement, createRightArrow)
		setTimer (function() removeEventHandler ("onClientRender", rootElement, createRightArrow) end , 2000, 1)

	end
end
addEventHandler ("onClientColShapeHit", arrowcol04, arrow04)

--5
arrowcol05 = createColSphere (408.5, -1942.7998046875, 262.900001525879, 10)
function arrow05 (theElement, matchingDimensions)
	if theElement == getLocalPlayer() then

		addEventHandler("onClientRender", rootElement, createRightArrow)
		setTimer (function() removeEventHandler ("onClientRender", rootElement, createRightArrow) end , 2000, 1)

	end
end
addEventHandler ("onClientColShapeHit", arrowcol05, arrow05)

--6
arrowcol06 = createColSphere (110.90000152588, -1967.1000976563, 256.299999237061, 10)
function arrow06 (theElement, matchingDimensions)
	if theElement == getLocalPlayer() then

		addEventHandler("onClientRender", rootElement, createRightArrow)
		setTimer (function() removeEventHandler ("onClientRender", rootElement, createRightArrow) end , 2000, 1)

	end
end
addEventHandler ("onClientColShapeHit", arrowcol06, arrow06)

--7
arrowcol07 = createColSphere (46.700000762939, -1737.6000976563, 263.200000762939, 10)
function arrow07 (theElement, matchingDimensions)
	if theElement == getLocalPlayer() then

		addEventHandler("onClientRender", rootElement, createRightArrow)
		setTimer (function() removeEventHandler ("onClientRender", rootElement, createRightArrow) end , 2000, 1)

	end
end
addEventHandler ("onClientColShapeHit", arrowcol07, arrow07)

--8
arrowcol08 = createColSphere (73.599998474121, -1571.6000976563, 262, 10)
function arrow08 (theElement, matchingDimensions)
	if theElement == getLocalPlayer() then

		addEventHandler("onClientRender", rootElement, createRightArrow)
		setTimer (function() removeEventHandler ("onClientRender", rootElement, createRightArrow) end , 2000, 1)

	end
end
addEventHandler ("onClientColShapeHit", arrowcol08, arrow08)

--9
arrowcol09 = createColSphere (173.80000305176, -1498.7998046875, 260.5, 10)
function arrow09 (theElement, matchingDimensions)
	if theElement == getLocalPlayer() then

		addEventHandler("onClientRender", rootElement, createLeftArrow)
		setTimer (function() removeEventHandler ("onClientRender", rootElement, createLeftArrow) end , 2000, 1)

	end
end
addEventHandler ("onClientColShapeHit", arrowcol09, arrow09)


--10
arrowcol10 = createColSphere (239.80000305176, -1123.8999023438, 250.700000762939, 10)
function arrow10 (theElement, matchingDimensions)
	if theElement == getLocalPlayer() then

		addEventHandler("onClientRender", rootElement, createURightArrow)
		setTimer (function() removeEventHandler ("onClientRender", rootElement, createURightArrow) end , 2000, 1)

	end
end
addEventHandler ("onClientColShapeHit", arrowcol10, arrow10)

--11
arrowcol11 = createColSphere (411, -1034.8999023438, 251.299999237061, 10)
function arrow11 (theElement, matchingDimensions)
	if theElement == getLocalPlayer() then

		addEventHandler("onClientRender", rootElement, createULeftArrow)
		setTimer (function() removeEventHandler ("onClientRender", rootElement, createULeftArrow) end , 2000, 1)

	end
end
addEventHandler ("onClientColShapeHit", arrowcol11, arrow11)

--12
arrowcol12 = createColSphere (351.70001220703, -952.5, 254.400001525879, 10)
function arrow12 (theElement, matchingDimensions)
	if theElement == getLocalPlayer() then

		addEventHandler("onClientRender", rootElement, createRightArrow)
		setTimer (function() removeEventHandler ("onClientRender", rootElement, createRightArrow) end , 2000, 1)

	end
end
addEventHandler ("onClientColShapeHit", arrowcol12, arrow12)

--13
arrowcol13 = createColSphere (272.29998779297, -880.3000488281, 255.5, 10)
function arrow13 (theElement, matchingDimensions)
	if theElement == getLocalPlayer() then

		addEventHandler("onClientRender", rootElement, createURightArrow)
		setTimer (function() removeEventHandler ("onClientRender", rootElement, createURightArrow) end , 2000, 1)

	end
end
addEventHandler ("onClientColShapeHit", arrowcol13, arrow13)

--14
arrowcol14 = createColSphere (555.20001220703, -948.6999511719, 261.099998474121, 10)
function arrow14 (theElement, matchingDimensions)
	if theElement == getLocalPlayer() then

		addEventHandler("onClientRender", rootElement, createULeftArrow)
		setTimer (function() removeEventHandler ("onClientRender", rootElement, createULeftArrow) end , 2000, 1)

	end
end
addEventHandler ("onClientColShapeHit", arrowcol14, arrow14)

--15
arrowcol15 = createColSphere (-617.70001220703, -542.1999511719, 263.200000762939, 10)
function arrow15 (theElement, matchingDimensions)
	if theElement == getLocalPlayer() then

		addEventHandler("onClientRender", rootElement, createRightArrow)
		setTimer (function() removeEventHandler ("onClientRender", rootElement, createRightArrow) end , 2000, 1)

	end
end
addEventHandler ("onClientColShapeHit", arrowcol15, arrow15)

--16
arrowcol16 = createColSphere (-1007.700012207, -556.8999023438, 263.200000762939, 10)
function arrow16 (theElement, matchingDimensions)
	if theElement == getLocalPlayer() then

		addEventHandler("onClientRender", rootElement, createLeftArrow)
		setTimer (function() removeEventHandler ("onClientRender", rootElement, createLeftArrow) end , 2000, 1)

	end
end
addEventHandler ("onClientColShapeHit", arrowcol16, arrow16)

--17
arrowcol17 = createColSphere (-1156.4000244141, -593.6000976563, 263, 10)
function arrow17 (theElement, matchingDimensions)
	if theElement == getLocalPlayer() then

		addEventHandler("onClientRender", rootElement, createRightArrow)
		setTimer (function() removeEventHandler ("onClientRender", rootElement, createRightArrow) end , 2000, 1)

	end
end
addEventHandler ("onClientColShapeHit", arrowcol17, arrow17)

--18
arrowcol18 = createColSphere (-1289.4000244141, -669.1999511719, 263.799999237061, 10)
function arrow18 (theElement, matchingDimensions)
	if theElement == getLocalPlayer() then

		addEventHandler("onClientRender", rootElement, createChicaneArrow)
		setTimer (function() removeEventHandler ("onClientRender", rootElement, createChicaneArrow) end , 2000, 1)

	end
end
addEventHandler ("onClientColShapeHit", arrowcol18, arrow18)



		function createLeftArrow ()
    			dxDrawImage ( (screenWidth/2)-64, screenHeight*0.05, 128, 128, 'arrows/left.png')
		end

		function createULeftArrow ()
    			dxDrawImage ( (screenWidth/2)-64, screenHeight*0.05, 128, 128, 'arrows/u_left.png')
		end

		function createRightArrow ()
    			dxDrawImage ( (screenWidth/2)-64, screenHeight*0.05, 128, 128, 'arrows/right.png')
		end

		function createURightArrow ()
    			dxDrawImage ( (screenWidth/2)-64, screenHeight*0.05, 128, 128, 'arrows/u_right.png')
		end

		function createChicaneArrow ()
    			dxDrawImage ( (screenWidth/2)-64, screenHeight*0.05, 128, 128, 'arrows/chicane.png')
		end

--------------------
--  Create Water  --
--------------------
 
function startWater( )
	createWater (0, -1630, 259.5, 90, -1630, 259.5, 0, -1540, 259.5, 90, -1540, 259.5)
	createWater (415, -1072, 249, 492, -1072, 251.6, 415, -1000, 251.1, 492, -1000, 251.6)
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), startWater)

-----------------
--Water Colours--
-----------------

wr = 15		--Red
wg = 124	--Green
wb = 125	--Blue
wa = 180	--Alpha (visibility)

function theWaterColor ( )
	setWaterColor (wr, wg, wb, wa)
end
addEventHandler ("onClientResourceStart", resourceRoot, theWaterColor)

-----------------
-- Unbreakable --
-----------------


	addEventHandler("onClientResourceStart",resourceRoot,
		function ()
			for i,obj in ipairs (getElementsByType("object")) do
				if getElementModel(obj) == 3281 then
					setObjectBreakable (obj, true)
				end
			end
		end
	)