-- Crane itself
local CRANE_BASE, CRANE_BAR, CRANE_MAGNET, CRANE_TIMER

-- Crane decorations
local decorations = {"CRANE_GENOME", "CRANE_CORONA", "CRANE_VEG_3", "CRANE_VEG_2", "CRANE_CAMERA", "CRANE_VEG_1", "CRANE_PIPE", "CRANE_STUFF", "CRANE_AIRCON", "CRANE_ROOF", "CRANE_SAMSITE", "CRANE_CORONA_2", "CRANE_CORONA_3", "CRANE_CABIN", "CRANE_WIRE", "CRANE_REEL_1", "CRANE_REEL_2", "CRANE_REEL_3"}

-- Crane state
local CRANE_ROTATING = false
local CRANE_MAGNETING = false
local CRANE_STATE = "init"

-- Crane settings
local CRANE_MAGNET_VERTICAL_SPEED = 131
local CRANE_MAGNET_HORIZONTAL_SPEED = 181
local CRANE_TURN_SPEED = 220
local HOOK_BOAT_HEIGHT_OFFSET = 1.4
local CRANE_REACH_RADIUS = 100
local REACH_CRANE = createColCircle(3535.7, -2478.9, CRANE_REACH_RADIUS)

-- Crane chasing
local chasingPlayer = false
local lastChasedPlayer = false
local rotDestination = 0
local desiredZ = 0
local destinationLenght = 0
local attachDistance = 3.5
local selectTimer

addEventHandler("onResourceStart", resourceRoot, function()
    CRANE_BASE = getElementByID("_CRANE_POLE")
    CRANE_BAR = getElementByID("_CRANE_BAR")
    CRANE_MAGNET = getElementByID("_CRANE_MAGNET")
	
	finalizeCraneMagnetment()
	
	-- Assemble the crane
	local barX, barY, barZ = getElementPosition(CRANE_BAR)
	local barRX, barRY, barRZ = getElementRotation(CRANE_BAR)
	local magnetX, magnetY, magnetZ = getElementPosition(CRANE_MAGNET)
	
	for _, objectID in pairs(decorations) do
		local object = getElementByID(objectID)
		if object then 
			local x, y, z = getElementPosition(object)
			local rx, ry, rz = getElementRotation(object)
			
			if not rx then rx, ry, rz = 0, 0, 0	end -- Markers
			attachElements(object, CRANE_BAR, 0, getDistanceBetweenPoints2D(barX, barY, x, y), z - barZ, rx - barRX, ry - barRY, rz - barRZ)
		end
	end
end )

addEvent("onRaceStateChanging", true)
addEventHandler("onRaceStateChanging", root, function(newState, oldState)
	if oldState == "GridCountdown" and newState == "Running" then
		-- start the crane
		CRANE_STATE = "assist"
		setTimer(craneTimerTick, 10, 0)
	end
end )

function selectPlayerAndDestination()
	if #getAttachedElements(CRANE_MAGNET) == 1 then return end
	
	-- Select player
	local availablePlayers = {}
	for _, player in ipairs(getAlivePlayers()) do
		if getPedOccupiedVehicle(player) and getElementHealth(getPedOccupiedVehicle(player)) > 250 then
			local x, y, z = getElementPosition(getPedOccupiedVehicle(player))
			local vx, vy, vz = getElementVelocity(getPedOccupiedVehicle(player))
			if z > 64 and z < 102 and vz >= 0 then
				table.insert(availablePlayers, player)
			end
		end
	end
	
	if #availablePlayers > 0 then
		chasingPlayer = availablePlayers[math.random(#availablePlayers)]
		iprint("[Crane Derby] Selected", getPlayerName(chasingPlayer))
	
		-- Select random destination
		rotDestination = math.random(3600) / 10
		desiredZ = math.random(90, 130)
		destinationLenght = math.random(40, 90)
	end
	
	if isTimer(selectTimer) then killTimer(selectTimer) end
	selectTimer = setTimer(selectPlayerAndDestination, 20000, 1)
end

function craneTimerTick()
	if chasingPlayer and getPedOccupiedVehicle(chasingPlayer) then
		if getElementAttachedTo(getPedOccupiedVehicle(chasingPlayer)) then
			-- Vehicle is attached
			if getElementHealth(getPedOccupiedVehicle(chasingPlayer)) < 251 or getElementData(chasingPlayer, "state") == "spectating" then
				-- Player is dying right now
				detachElements(getPedOccupiedVehicle(chasingPlayer))
				chasingPlayer = nil
				iprint("[Crane Derby] Need new target")
			end
		else
			-- Vehicle is not attached
			local x, y, z = getElementPosition(getPedOccupiedVehicle(chasingPlayer))
			if z < 66 or z > 102 then
				-- Vehicle not in range
				chasingPlayer = nil
				iprint("[Crane Derby] Need new target")
			end
		end
	end
	
	if not chasingPlayer or (chasingPlayer and not getPedOccupiedVehicle(chasingPlayer)) or (chasingPlayer and getPedOccupiedVehicle(chasingPlayer) and getElementHealth(getPedOccupiedVehicle(chasingPlayer)) < 251) then
		selectPlayerAndDestination()
		return
	end
	
    -- The crane is currently busy rotating. Wait...
    if CRANE_ROTATING or CRANE_MAGNETING then return end

	local vehicle = getPedOccupiedVehicle(chasingPlayer)
	if CRANE_STATE == "assist" then
        if #getAttachedElements(CRANE_MAGNET) == 1 then
            -- Car is attached to crane. Rotate it etc
			
            local rX, rY, rZ = getElementPosition(CRANE_MAGNET)
            local bU, bV, bW = getElementRotation(CRANE_BAR)
            local bX, bY, bZ = getElementPosition(CRANE_BASE)
            local vX, vY, vZ = getElementPosition(vehicle)
            local vehicleDistanceFromBase = getDistanceBetweenPoints2D(bX, bY, vX, vY)
            local hookHeightDeviation = math.abs(rZ-desiredZ)
			
            local barDirectionDeviation = math.abs(bW-rotDestination)
            if (hookHeightDeviation > 0.1 and barDirectionDeviation > 0.1) then
                -- Move the hook up to the required height
				iprint("[Crane Derby] Raising hook for safe rotation @"..getRealTime().timestamp)
                moveMagnet(desiredZ, -1, 0.25)
            elseif (barDirectionDeviation > 0.1) then
                -- Rotate the crane to its destination
				iprint("[Crane Derby] Rotating crane into position for dropoff @"..getRealTime().timestamp)
                rotateCraneTo(rotDestination, 0.35)
            elseif math.abs(vehicleDistanceFromBase - destinationLenght) > 0.5 then
                -- Move the hook forward or backwards before the drop (crane 1)
				iprint("[Crane Derby] Moving magnet above drop zone @"..getRealTime().timestamp, destinationLenght, vehicleDistanceFromBase)
				moveMagnet(-1, destinationLenght, 0.25)
            else
                -- Detach vehicle at destination
		        detachElements(vehicle)
				lastChasedPlayer = chasingPlayer
				chasingPlayer = nil
                CRANE_STATE = "available"
				setTimer(function() CRANE_STATE = "assist" end, 5000, 1)
            end
        else
			local hX, hY, hZ = getElementPosition(CRANE_MAGNET)
			for _, player in ipairs(getAlivePlayers()) do
				if getPedOccupiedVehicle(player) and getElementHealth(getPedOccupiedVehicle(player)) > 250 then
					local x, y, z = getElementPosition(getPedOccupiedVehicle(player))
					
					local magnetDistance = getDistanceBetweenPoints3D(hX, hY, hZ, x, y, z + HOOK_BOAT_HEIGHT_OFFSET)
					local vx, vy, vz = getElementVelocity(getPedOccupiedVehicle(player))
					if z > 64 and z < 102 and vz >= 0 and magnetDistance < attachDistance then
						chasingPlayer = player
						iprint("[Crane Derby] Magnet engaged")
						
						local hU, hV, hW = getElementRotation(CRANE_MAGNET)
						local vU, vV, vW = getElementRotation(getPedOccupiedVehicle(player))
						
						attachElements(getPedOccupiedVehicle(player), CRANE_MAGNET, 0, 0, -HOOK_BOAT_HEIGHT_OFFSET, vU - hU, vV - hV, vW - hW)
						
						if getElementModel(getPedOccupiedVehicle(chasingPlayer)) == 572 then
							iprint("[Crane Derby] Mower detected")
							destinationLenght = 10
						end
						return
					end
				end
			end
			
			-- Car is not attached to the crane
            local vX, vY, vZ = getElementPosition(vehicle)
    
            local bX, bY, zY = getElementPosition(CRANE_BAR)
            local bU, bV, bW = getElementRotation(CRANE_BAR)
			
            local vehicleAngleFromCrane = findRotation(bX, bY, vX, vY)
            local craneAngleFromVehicle = vehicleAngleFromCrane - bW % 360
			
            -- Check if the crane is pointing at us
            if math.abs(craneAngleFromVehicle) < 0.1 or math.abs(craneAngleFromVehicle) > 359.9 then
                -- The crane is pointing at us. Move hook in.
                local vD = getDistanceBetweenPoints2D(bX, bY, vX, vY)
				iprint("[Crane Derby] Moving hook to boat @"..getRealTime().timestamp)
                moveMagnet(vZ + HOOK_BOAT_HEIGHT_OFFSET, math.min(vD, CRANE_REACH_RADIUS), 0.25)
            else
                -- The crane is not pointing at us, move the bar over the boat
				iprint("[Crane Derby] Rotating to boat @"..getRealTime().timestamp)
				rotateCraneTo(vehicleAngleFromCrane, 0.3)
            end
        end
    end
end

function rotateCraneTo(wDest, speedMultiplier)
	local x, y, z = getElementPosition(CRANE_BAR)
	local u, v, w = getElementRotation(CRANE_BAR)   
	local wDiff = wDest - w
	if wDest - w >= 180 then wDiff = (360 + w - wDest) * (-1) end
	
	local duration = math.abs(wDiff * CRANE_TURN_SPEED) * speedMultiplier

    CRANE_ROTATING = true
	moveObject(CRANE_BAR, duration, x, y, z, 0, 0, wDiff, "InOutQuad")
	
	if duration > 0 then
		CRANE_TIMER = setTimer(function()
			CRANE_ROTATING = false
			CRANE_TIMER = false
		end, duration, 1)
    else
		CRANE_ROTATING = false
		CRANE_TIMER = false
    end
end

-- raise or lower the hook
function moveMagnet(destinationZ, destinationD, speedMultiplier)
    detachElements(CRANE_MAGNET)
	
	local u, v, w = getElementRotation(CRANE_BAR)
	setElementRotation(CRANE_MAGNET, u, v, w)

	local xBase, yBase, zBase = getElementPosition(CRANE_BAR)
	local xMagnet, yMagnet, zMagnet = getElementPosition(CRANE_MAGNET)
	local aBar = findRotation(xBase, yBase, xMagnet, yMagnet) 
	local dMagnet = getDistanceBetweenPoints2D (xBase, yBase, xMagnet, yMagnet)
	
	if destinationD < 0 then destinationD = dMagnet end
	if destinationZ < 0 then destinationZ = zMagnet end	
	
	local xNew, yNew = getPointFromDistanceRotation(xBase, yBase, destinationD, aBar)
	local zDuration = math.abs(zMagnet - destinationZ) * CRANE_MAGNET_VERTICAL_SPEED
	local dDuration = math.abs(dMagnet - destinationD) * CRANE_MAGNET_HORIZONTAL_SPEED
	
	duration = math.max(dDuration, zDuration) * speedMultiplier

	CRANE_MAGNETING = true
    moveObject(CRANE_MAGNET, duration, xNew, yNew, destinationZ, 0, 0, 0, "InOutQuad")
	
	if duration > 0 then CRANE_TIMER = setTimer(finalizeCraneMagnetment, duration, 1)
    else finalizeCraneMagnetment() end
end

-- attach the hook to the bar after moving it
function attachMagnet()
    local barX, barY, barZ = getElementPosition(CRANE_BAR)
    local ropeX, ropeY, ropeZ = getElementPosition(CRANE_MAGNET)
    attachElements(CRANE_MAGNET, CRANE_BAR, 0, getDistanceBetweenPoints2D(barX,barY,ropeX,ropeY), ropeZ-barZ)
end

function finalizeCraneMagnetment()
	iprint("[Crane Derby] Magnet movement of hook complete @"..getRealTime().timestamp)
    attachMagnet()
    CRANE_MAGNETING = false
    CRANE_TIMER = false
end

function findRotation(x1, y1, x2, y2) 
    local t = -math.deg( math.atan2(x2 - x1, y2 - y1))
    return t < 0 and t + 360 or t
end

function getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle);
    local dx = math.cos(a) * dist;
    local dy = math.sin(a) * dist;
    return x-dx, y+dy;
end
