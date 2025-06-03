addEvent("cinemaMovieWatched", true)
addEventHandler("cinemaMovieWatched", getRootElement(), function()
	exports.achievements:triggerAchievement(source, "cinemaMovieWatched", nil)
end )