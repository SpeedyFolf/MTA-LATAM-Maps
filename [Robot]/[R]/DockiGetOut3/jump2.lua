local jump_time

function jump( key, state )

	if state == "up" and jump_time then -- replace down with up when activating timer

		local times = (getTickCount() - jump_time)/1000

		if times > 2 then times = 2 end

		local vehicle = getPedOccupiedVehicle(localPlayer)

		if (
			isVehicleWheelOnGround( vehicle , 0) == true 
			or
			isVehicleWheelOnGround( vehicle , 1) == true
			or
			isVehicleWheelOnGround( vehicle , 2) == true
			or
			isVehicleWheelOnGround( vehicle , 3) == true
			or
			isVehicleOnGround ( vehicle ) == true
			) then
			playSound ("hop.wav", false)          

			local sx,sy,sz = getElementVelocity ( vehicle )

			--outputChatBox("#59CC00Vehicle Repaired", 255, 255, 255, true)

			setElementVelocity( vehicle ,sx, sy, sz+0.6*times )

		end

		jump_time = nil

	elseif state == "down" then

		jump_time = getTickCount()

	end

end

bindKey ( "vehicle_fire","both", jump)



local charges, charges_text = 3, " \n(3/3) Repair: Secondary Fire"

function jump2()

	local vehicle = getPedOccupiedVehicle(localPlayer)

    if charges > 0 then

		fixVehicle(vehicle)

		charges = charges -1

		charges_text = " \nFixed"

		setTimer( function() charges_text = "\n("..charges.."/3) Repair: Secondary Fire" end, 500, 1)

		--outputChatBox("Vehicle Repaired. Charges left: "..charges)

	end

end

bindKey ( "vehicle_secondary_fire","down", jump2)



addEvent("recharge",true)

addEventHandler("recharge", root,

	function()

		charges = 3

		charges_text = "\n("..charges.."/3) Repair: Secondary Fire"

	end

)



------------

--HelpText--

------------



local rootElement = getRootElement()

local screenWidth, screenHeight = guiGetScreenSize()



function helpText ()


	local x,y,w,h = (screenWidth/2)-200,(screenHeight-80), 400, 20

	local proc = 0

	if jump_time then proc = ((getTickCount() - jump_time)/1000)/2 end

	if proc > 1 then proc = 1; jump( "", "up" ) end



	dxDrawRectangle (x, y, 400, 80, tocolor( 0, 0, 0, 150 ))

	dxDrawText ("Jump: FIRE.\n ", x, y, x+400, y+80, (proc > 0 and getcolor(proc) or tocolor( 255, 255, 255)), 0.7, 'bankgothic', "center", "center", false, false, false )

	dxDrawText (charges_text, x, y, x+400, y+80, (charges_text == " \nFixed" and tocolor( 0, 255, 0 ) or charges == 0 and tocolor( 255, 0, 0 ) or tocolor (255, 255, 255, 255)), 0.7, 'bankgothic', "center", "center", false, false, false )

	

	-- charging jump

	

	y = y - 21

	x = x - 1

	

	dxDrawLine( x-1,y-1, x+w+2, y-1, tocolor(255,255,255))

	dxDrawLine( x-1,y-1, x-1, y+h+2, tocolor(255,255,255))

	dxDrawLine( x-1,y+h+2, x+w+2, y+h+2, tocolor(255,255,255))

	dxDrawLine( x+w+2,y-1, x+w+2, y+h+2, tocolor(255,255,255))

	dxDrawRectangle (x,y , proc*w, h, tocolor( 0, 0, 0, 150 ))

	

	dxDrawText (round(60*(proc*2)), x, y, x+w, y+h, getcolor(proc) , 0.7, 'bankgothic', "center", "center", false, false, false )

end

addEventHandler("onClientRender", rootElement, helpText)



function round(number, decimals, method)

    decimals = decimals or 0

    local factor = 10 ^ decimals

    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor

    else return tonumber(("%."..decimals.."f"):format(number)) end

end

function getcolor(proc)

	proc = proc*10

	local g, r = -5.1*(proc^2) + 25.5*proc + 255, -5.1*(proc^2) + 76.5*proc

	r, g = r > 255 and 255 or r, g > 255 and 255 or g

	-- outputDebugString("mapratings: rating = "..rating.." r = "..r.." g = "..g)

	--return "#"..string.format("%02X", r)..string.format("%02X", g).."00"

	return tocolor(r,g,0)

end