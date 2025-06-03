local launch = {}

for i = 1, 4 do
	local x, y, z = getElementPosition(getElementByID("LAUNCH_" ..i))
	launch[i] = createColSphere(x, y, z + 1, 2)
end

addEventHandler("onColShapeHit", resourceRoot, function(element)
	if getElementType(element) == "vehicle" and getVehicleOccupant(element) and getElementModel(element) ~= 425 then
		for i, col in ipairs(launch) do
			if source == col then 
				exports.achievements:triggerAchievement(getVehicleOccupant(element), "craneDerbyLaunchPad", nil)
				break
			end
		end
	end
end )

addEventHandler("onElementModelChange", root, function(old, new)
	if getElementType(source) == "vehicle" and getVehicleOccupant(source) and new == 425 then
		exports.achievements:triggerAchievement(getVehicleOccupant(source), "craneDerbyGetHunter", nil)
	end
end )