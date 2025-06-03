addEvent("changeBike", true)
addEventHandler("changeBike", getRootElement(), function()
	if not getPedOccupiedVehicle(source) then return end
	
	local bikes = {509, 481, 510}
	setElementModel(getPedOccupiedVehicle(source), bikes[math.random(#bikes)])
end )