local redMowers = {}
local blackSuperGTs = {}
local prizes = {}
local secretMowers = {}

-- Colspheres for Red Mowers
for i = 1, 5 do
	local x, y, z = getElementPosition(getElementByID("RED_MOWER_" ..i))
	redMowers[i] = createColSphere(x, y, z, 3.5)
end

-- Colspheres for SuperGTs
for i = 1, 12 do
	local x, y, z = getElementPosition(getElementByID("BLACK_SUPERGT_" ..i))
	blackSuperGTs[i] = createColSphere(x, y, z, 3.5)
end

-- Colspheres for Prizes
for i = 1, 11 do
	local x, y, z = getElementPosition(getElementByID("PRIZE_" ..i))
	prizes[i] = createColSphere(x, y, z, 3.5)
end

-- Colspheres for secret mowers
for i = 1, 12 do
	local x, y, z = getElementPosition(getElementByID("SECRET_" ..i))
	secretMowers[i] = createColSphere(x, y, z, 3.5)
end

-- Colshape for over
local bmx = createColPolygon(0, 0, -2609.79, 2822.74, -2654.9099, 2822.6399, -2655.09009, 2902.63989, -2609.77, 2902.77)
setColPolygonHeight(bmx, 939.78003, 955.53003)

addEventHandler("onColShapeHit", resourceRoot, function(element)
	if getElementType(element) == "vehicle" and getVehicleOccupant(element) then
		-- Check mowers
		for i, col in ipairs(redMowers) do
			if source == col then 
				exports.achievements:updateObjective(getVehicleOccupant(element), "secretMowerAllRedMowers", i) 
				break
			end
		end
		
		-- Check supergts
		for i, col in ipairs(blackSuperGTs) do
			if source == col then 
				exports.achievements:updateObjective(getVehicleOccupant(element), "secretMowerAllBlackSuperGT", i) 
				break
			end
		end
		
		-- Check prizes
		for i, col in ipairs(prizes) do
			if source == col then 
				exports.achievements:updateObjective(getVehicleOccupant(element), "secretMowerAllPrizeCars", i)
				break
			end
		end
		
		-- Check prizes
		for i, col in ipairs(secretMowers) do
			if source == col then 
				exports.achievements:updateObjective(getVehicleOccupant(element), "secretMowerDetective", i)
				break
			end
		end
		
		if source == bmx then exports.achievements:triggerAchievement(getVehicleOccupant(element), "secretMowerOverIt", nil) end
	end
end )
