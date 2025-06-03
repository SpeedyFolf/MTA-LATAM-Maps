--setDevelopmentMode(true)

local boatTriggered = false
local boatTurn -- timer
local boatNode = 1
local colshape
local boat, boatPed

function findRotation(x1, y1, x2, y2) 
	local t = -math.deg( math.atan2(x2 - x1, y2 - y1))
	return t < 0 and t + 360 or t
end

local boatNodes = {}
local foundNodes = false
while not foundNodes do
	local node = getElementByID("NODE_" ..(#boatNodes + 1))
	if node then
		local nodeX, nodeY, nodeZ = getElementPosition(node)
		table.insert(boatNodes, {x = nodeX, y = nodeY})
	else
		foundNodes = true
	end
end

addEvent("triggerBoat", true)
addEventHandler("triggerBoat", getRootElement(), function()
	if not boatTriggered then
		boatTriggered = true
		
		-- Create boat
		setTimer(function()
			math.randomseed(getTickCount())
			
			local boatModels = {539, 472, 473, 493, 595, 430, 452, 446}
			local boatModel = boatModels[math.random(#boatModels)]
			boat = createVehicle(boatModel, 725.42999, -1783.97, 0, 0, 0, 180)
			
			setVehicleRotorState(boat, true)
			setVehicleEngineState(boat, true)
			
			-- Create ped
			boatPed = createPed(292, 725.42999, -1783.97, 1, 0)
			warpPedIntoVehicle(boatPed, boat, 0)
			
			-- Drive forward
			setPedAnalogControlState(boatPed, "accelerate", 0.35)
			
			-- Turn
			colshape = createColSphere(boatNodes[boatNode].x, boatNodes[boatNode].y, 0, 20)
		end, (boatModel == 539) and 3000 or 0, 1)
	end
end )

addEventHandler("onClientColShapeHit", root, function(element, dim)
	if element == boat and colshape and source == colshape then
		-- Turn
		boatTurn = setTimer(function(ped)
			if boatNode <= #boatNodes then
				local _, _, boatCourse = getElementRotation(getPedOccupiedVehicle(ped))
				local x, y, z = getElementPosition(getPedOccupiedVehicle(ped))
				local course = findRotation(x, y, boatNodes[boatNode].x, boatNodes[boatNode].y)
				
				if math.abs(boatCourse - course) < 3 then
					-- Course is fine
					setPedAnalogControlState(ped, "vehicle_right", 0)
					setPedAnalogControlState(ped, "vehicle_left", 0)
				else
					if math.abs(boatCourse - course) >= 180 then
						-- correction is too big, check for 0 crossing
						if course - boatCourse >= 180 then
							-- turn right
							setPedAnalogControlState(boatPed, "vehicle_right", 1)
						else
							-- turn left
							setPedAnalogControlState(boatPed, "vehicle_left", 1)
						end
					else
						if boatCourse - course >= 3 then 
							-- turn right 
							setPedAnalogControlState(boatPed, "vehicle_right", 1)
						else
							-- turn left
							setPedAnalogControlState(boatPed, "vehicle_left", 1)
						end
					end
				end
			end
		end, 20, 0, boatPed)
		
		destroyElement(colshape)
		boatNode = boatNode + 1
		if boatNode <= #boatNodes then
			-- Create next node
			colshape = createColSphere(boatNodes[boatNode].x, boatNodes[boatNode].y, 0, 20)
		else
			-- End reached
			iprint("[Beach Run]", "finish")
			setPedAnalogControlState(boatPed, "accelerate", 0)
			killTimer(boatTurn)
		end
	end
end )
