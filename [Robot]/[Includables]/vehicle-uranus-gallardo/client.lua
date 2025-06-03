--
--
-- Cuztum modeal
--
--

------------------------------------------------------
-- Variables
------------------------------------------------------
local myTag = "uranus-gallardo"
local bOn = false
local txdFilename = "gallardo.txd"
local dffFilename = "gallardo.dff"
local modelID = 558
local txd = {}
local dff = {}
local autoOffTime = 0

------------------------------------------------------
-- Events
------------------------------------------------------
addEvent( "StartCustomVehicle", false )
addEventHandler("StartCustomVehicle", root,
	function( tag , modelId)
		if tag == myTag then
			if tonumber(modelId) then
				modelID = tonumber(modelId)
			end
			ensureOn()
		end
	end
)


addEvent( "KeepCustomVehicle", false )
addEventHandler("KeepCustomVehicle", root,
	function( tag )
		if tag == myTag then
			resetAutoOffTimer()
		end
	end
)


addEvent( "StopCustomVehicle", false )
addEventHandler("StopCustomVehicle", root,
	function( tag )
		if tag == myTag then
			--ensureOff()
		end
	end
)

addEventHandler("onClientResourceStop", resourceRoot,
	function()
		--ensureOff()
	end
)

------------------------------------------------------
-- Stuff
------------------------------------------------------
function ensureOn()
	if not bOn then
		switchOn()
	end
	resetAutoOffTimer()
end

function resetAutoOffTimer()
	autoOffTime = getTickCount() + 5000
end

function ensureOff()
	if bOn then
		switchOff()
	end
end


function switchOn()
	for i=1,2 do
		txd[i] = engineLoadTXD( txdFilename )
		engineImportTXD( txd[i], modelID )
		dff[i] = engineLoadDFF( dffFilename , modelID )
		engineReplaceModel( dff[i], modelID )

		if not txd[i] or not dff[i] then
			outputConsole( "Problems with " .. myTag )
			break
		end
	end
	bOn = true
end


function switchOff()
	for i=1,2 do
		if txd[i] then
			destroyElement( txd[i] )
			txd[i] = nil
		end
		if dff[i] then
			destroyElement( dff[i] )
			dff[i] = nil
		end
	end
	bOn = false
end


------------------------------------------------------
-- Stuff
------------------------------------------------------
handingDef1 = {
				accCurve = { {0, 0}, {0.5, 0}, {1, 1}, {12.6, 0.0} },
				decCurve = { {0, 0}, {0.5, 0}, {1, 1}, {12.6, 0.0} },
				rzCurve  = { {0, 0}, {0.5, 0}, {1, 1}, {12.6, 0.0} },
				dfCurve  = { {0, 0}, {0.5, 0}, {1, 1}, {12.6, 0.0} },
				accScale = 0.3,
				decScale = 0.2,
				rzScale  = 0.0,
				dfScale  = 0.15,
			}

function applyHanding ( ticks, veh, def )
		local seconds = ticks / 1000

		-- Input
		local inputAccelerate = getPedControlState ( 'accelerate' ) and 1 or getAnalogControlState( 'accelerate' )
		local inputBrake  =  getPedControlState ( 'brake_reverse' ) and 1 or getAnalogControlState( 'brake_reverse' )

		-- Get vehicle state
		local vx, vy, vz = getElementVelocity( veh )
		local rx, ry, rz = getElementAngularVelocity ( veh )
		local speed = getDistanceBetweenPoints3D( 0, 0, 0, vx, vy, vz )
		local matrix = getElementMatrix(veh)
		local fwd = Vector3D:new( matrix[2][1], matrix[2][2], matrix[2][3] )
		local up = Vector3D:new( matrix[3][1], matrix[3][2], matrix[3][3] )
		local upNess = up:Dot( Vector3D:new( 0, 0, 1 ) )
		local onGroundNess = isVehicleOnGround ( veh ) and 1 or 0

		-- Get apply amounts
		local accAlpha = math.evalCurve ( def.accCurve, speed )
		local decAlpha = math.evalCurve ( def.decCurve, speed )
		local rzAlpha = math.evalCurve ( def.rzCurve, speed )
		local dfAlpha = math.evalCurve ( def.dfCurve, speed )

		-- Apply acceleration
		local addmul = def.accScale * seconds * inputAccelerate * accAlpha * onGroundNess
		local toAdd = fwd:Mul( addmul )
		vx = vx + toAdd.x
		vy = vy + toAdd.y
		vz = vz + toAdd.z

		-- Apply braking
		local toMul = 1 - math.min( 1, def.decScale * seconds * inputBrake ) * decAlpha * onGroundNess
		vx = vx * toMul
		vy = vy * toMul
		vz = vz * toMul

		-- Apply spin
		rz = rz + rz * def.rzScale * seconds * inputAccelerate * rzAlpha * onGroundNess
		setElementAngularVelocity ( veh, rx, ry, rz )

		-- Apply down force
		vz = vz - def.dfScale * seconds * dfAlpha

		-- Set vehicle state
		setElementVelocity ( veh, vx, vy, vz )
		setElementAngularVelocity ( veh, rx, ry, rz )


		if showspeed then
			local x,y = 1, 0
			local desc = string.format( "Speed: %2.0f", speed*100 )
			dxDrawText ( desc, x+1, y+1, x+1, y+1, tocolor(0,0,0,255) )
			dxDrawText ( desc, x, y )
		end
end


addEventHandler('onClientPreRender', root,
	function ( ticks )
		if bOn then
			if getTickCount() > autoOffTime then
				ensureOff()
			end
			local veh = getPedOccupiedVehicle( getLocalPlayer() )
			if veh and getElementModel( veh ) == modelID then
				applyHanding ( ticks, veh, handingDef1 )
			end
		end
	end
)
