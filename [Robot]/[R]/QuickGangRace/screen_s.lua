setElementData(root, "video", math.random(130))

addEvent("watchedDYOM", true)
addEventHandler("watchedDYOM", getRootElement(), function()
	exports.achievements:triggerAchievement(source, "disco7", nil)
end )