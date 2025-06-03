addEventHandler("onPlayerDeliverVehicle", root, function(oldTarget, time, vehicleModel, health, reward)
	if getResourceState(getResourceFromName("achievements")) == "running" then
		exports.achievements:triggerAchievement(source, "sssIE10M", nil, reward)
		if (health == 1) then
			local expensiveCars = {
				[432] = true, --rhino
				[415] = true, --Cheetah
				[506] = true, --Supergt
				[541] = true, --bullet
				[411] = true, --infernus
				[451] = true, --turismo
			}
			if (expensiveCars[vehicleModel]) then
				exports.achievements:updateObjective(source, "sssFleischExpensiveCars", vehicleModel)
			end
		end
		if (oldTarget + 1 > g_requiredCheckpoints) then
			exports.achievements:updateObjective(client, "sssFleischAllModes", g_requiredCheckpoints)
		end
		exports.achievements:updateObjective(source, "sssFleischAllVehicles", vehicleModel)
		if (vehicleModel == 508) then
			exports.achievements:triggerAchievement(source, "sssFleisch5Journeys", nil)
		end
	end
end)