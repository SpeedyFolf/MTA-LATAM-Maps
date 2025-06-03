addEvent("achievement", true)
addEventHandler("achievement", root, function(achievementID)
	if exports["achievements"] then
		exports.achievements:triggerAchievement(client, achievementID, nil)
	end
end )

