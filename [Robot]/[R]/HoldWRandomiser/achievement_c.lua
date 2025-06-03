function failAchievement(key)
	return function(key)
		triggerServerEvent("didntListenToConsole", localPlayer, key)
	end
end

bindKey("a", "down", failAchievement("a"))
bindKey("d", "down", failAchievement("d"))