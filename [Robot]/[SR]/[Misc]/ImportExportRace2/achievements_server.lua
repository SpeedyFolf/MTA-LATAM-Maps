addEventHandler("onPlayerDeliverVehicle", root, function(oldTarget, time, vehicleModel, health, reward)
	if getResourceState(getResourceFromName("achievements")) == "running" then
		exports.achievements:triggerAchievement(source, "sssIE10M", nil, reward)
	end
end)