addEvent("achievement", true)
addEventHandler("achievement", root, function(achievementID)
	tryExportedFunctionCall("achievements", "triggerAchievement", client, achievementID, nil)
end )


function tryExportedFunctionCall(resName, funcName, param, param2, param3)
	local res = getResourceFromName(resName)
	local functions = getResourceExportedFunctions(res)
	for _, f in ipairs(functions) do
		if f == funcName then
			return call(res, funcName, param, param2, param3)
		end
	end
	return false
end