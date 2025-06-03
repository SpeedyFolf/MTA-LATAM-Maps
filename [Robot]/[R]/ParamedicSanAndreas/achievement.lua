addEvent(g_PATIENTS_DROPPED_OFF_EVENT, true)
addEventHandler(g_PATIENTS_DROPPED_OFF_EVENT, resourceRoot, function(numPatients, hospitalId)
	for i = 1, numPatients do
		exports.achievements:updateObjective(client, "paramedic1", {})
	end
	exports.achievements:updateObjective(client, "paramedic2", hospitalId)
end)