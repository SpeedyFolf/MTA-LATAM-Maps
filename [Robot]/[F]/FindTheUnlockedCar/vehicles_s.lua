local vehicles = {}
local vehiclePos = {
	{1660.200, 1297.7, 10.6, 0, 0, 0},
	{1679.410, 1297.7, 10.6, 0, 0, 0},
	{1672.980, 1297.7, 10.6, 0, 0, 0},
	{1685.790, 1297.7, 10.6, 0, 0, 0},
	{1666.700, 1297.7, 10.6, 0, 0, 0},
	
	{1660.200, 1306.25, 10.6, 0, 0, 180},
	{1679.410, 1306.25, 10.6, 0, 0, 180},
	{1666.700, 1306.25, 10.6, 0, 0, 180},
	{1685.790, 1306.25, 10.6, 0, 0, 180},
	{1672.980, 1306.25, 10.6, 0, 0, 180}
}

addEventHandler("onResourceStart", resourceRoot, function()
	-- Create cars
	for i = 1, #vehiclePos do
		vehicles[i] = createVehicle(451, vehiclePos[i][1], vehiclePos[i][2], vehiclePos[i][3], vehiclePos[i][4], vehiclePos[i][5], vehiclePos[i][6])
		setVehicleLocked(vehicles[i], true)
		setVehicleColor(vehicles[i], 123, 10, 42, 123, 10, 42)
	end
	
	-- Unlock random one
	setVehicleLocked(vehicles[math.random(#vehicles)], false)
end )