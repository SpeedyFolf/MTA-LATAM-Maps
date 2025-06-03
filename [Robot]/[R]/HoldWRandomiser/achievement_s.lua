local achievementCriteriaSatisfied = true
local gameStarted = false

addEvent("onRaceStateChanging")
addEventHandler("onRaceStateChanging", getRootElement(), function(state)
	if state == "Running" then
		gameStarted = true
	end
end)

addEvent("didntListenToConsole", true)
addEventHandler("didntListenToConsole", root, function(key)
	if not gameStarted then return end
	if not achievementCriteriaSatisfied then return end

	if not isElement(source) then return end
	if getElementData(source, "state") ~= "alive" then return end

	achievementCriteriaSatisfied = false

	local name = getPlayerName(source)
	outputChatBox(name .. " has been banned by Console. (REAL)", root, 255, 0, 0, false)
	outputChatBox("#4E5768* #FFFFFF" .. name .. " #4E5768has left the game [Banned]", root, 255, 255, 255, true)
end)

addEvent("onPlayerFinish")
addEventHandler("onPlayerFinish", root, function()
	if not achievementCriteriaSatisfied then return end
	if not isElement(source) then return end

	if getPlayerCount() < 10 then return end

	exports.achievements:triggerAchievement(source, "holdwTeamwork")
end)